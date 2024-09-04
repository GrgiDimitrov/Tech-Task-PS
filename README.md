Terraform Project Structure
# Infrastructure as Code with Terraform

This repository contains Terraform configurations to deploy the infrastructure for Payslips Technical Task. The infrastructure includes an ECS cluster, an RDS PostgreSQL database, a CloudFront distribution with an S3 bucket configured for static hosting
and an Application Load Balancer


This README provides instructions for configuring the infrastructure and details about setuping up the diffrent modules.

## Terraform Project Structure

The Terraform project is structured as follows:


```
.
├── README.md
├── environments
│   ├── dev
│   │   ├── dev.tf
│   │   ├── outputs.tf
│   │   ├── provider.tf
│   │   ├── terraform.tfstate
│   │   ├── terraform.tfstate.backup
│   │   └── variables.tf
│   └── prod
│       ├── main.tf
│       ├── provider.tf
│       └── variables.tf
├── modules
│   ├── alb_ecs_cluster
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── cloudfront_s3
│   │   ├── files
│   │   │   └── index.html
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── lambda_secret_rotate
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── src
│   │   │   ├── rotate_secrets.py
│   │   │   └── rotate_secrets.py.zip
│   │   └── variables.tf
│   ├── rds_aurora_serverless
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── secrets_manager
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── security_groups
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── vpc
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
└── simple-docker-container
    ├── Dockerfile
    └── app.py

15 directories, 36 files
```
## Project Overview

This project aims to manage and deploy AWS infrastructure using Terraform the reposatory providies a scalable, maintainable, and version-controlled aproach to handle infrastructure deployment


```
git clone https://github.com/GrgiDimitrov/Tech-Task-PS.git
```

## Existing Infrastructure

The deployment of all resources will be done in my personal AWS account - Account Number: 181349251474

The project is seprated into two enviroments
- prod
- dev

## Authenticating to AWS
To authenticate into AWS in your terminal run the following command:
```
aws configure sso
```
Follow the steps and Provide the requested infromation
```
"SSO session name":
"SSO URL": 

Allow botoclient

"CLI default client Region": eu-west-1
"CLI default output format": json
"CLI profile name": "dev"
```
in your terminal run
```
export AWS_PROFILE=dev
```
```
cd /environments/dev
```
 edit providers.tf

it should match the name of your profile you specified in the "CLI profile name": "dev"


Example:
```
provider "aws" {
	region = "eu-west-1"
	profile = "dev"
}
```

*Before initilazing terraform please ensure the correct credentials are set in the provider.tf file*


```
pwd
```
*ensure output is environments/dev*

cd into environments/dev and run 

```
terraform init
```
The following output should appear

```
Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```
## Configure ECR and uploading the Docker Image

cd ../../simple-docker-container

```
$aws ecr create-repository --repository-name <repository-name> --region <region>
```
*Replace <repository-name> with your desired repository name and <region> with your desired AWS region (e.g., eu-west-1).*
```
docker buildx build --platform linux/amd64 -t <image-name> .
```
*Replace <image-name> with a name for your Docker image, such as simple-restful-container.*
```
docker tag <image-name>:latest <account-id>.dkr.ecr.<region>.amazonaws.com/<repository-name>:latest
```
## Authenticating to ECR
```
aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <account-id>.dkr.ecr.<region>.amazonaws.com

docker push <account-id>.dkr.ecr.<region>.amazonaws.com/<repository-name>:latest
```

```
cd ../modules/alb_ecs_cluster
vim variables.tf on line 21 and replace with your image uri
```
### After completing the steps above 

cd back into ../enviroments/dev

and run 
```
terraform plan
```
##### This will provision all the necessary infrastructure, allowing you to access the ‘Hello World’ S3 page and the ‘Hello World’ container via the CloudFront distribution.

*cloudfront_distribution_domain_name = "deyzul5x7k36r.cloudfront.net"*
```
deyzul5x7k36r.cloudfront.net
deyzul5x7k36r.cloudfront.net/helloworld
```

## Migrating to Terraform

## Solving the migration problem would be as follows:

I would begin by analyzing the current state of the infrastructure and documenting all resources that would be managed by Terraform. This includes AWS resources such as EC2 Instances, ECS, RDS, S3, CloudFront, IAM roles, etc.

Next, I would identify and document the dependencies between these resources (e.g., ALB > ECS > RDS) and mark any resources that are not in use to avoid unnecessary resource migration.

### Build Terraform Configuration

I would start by translating the existing infrastructure into Terraform, modularizing each component. The `.tf` files for all identified resources would follow similar naming conventions and configurations as in the current setup. I would ensure that resource names, tags, and dependencies match those in the existing environment. Additionally, I would separate configurations for each environment in dev, staging, and prod.

### Traffic Migration Planning


I would plan the migration to ensure no downtime. This would be done by creating a copy of the production and utilizing a BLUE/GREEN enviroment with a Canary approach 

# Terraform Module Documentation
<!-- BEGIN_TF_DOCS -->
## ALB & ECS cluster
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.ecs_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecs_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_service.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_role.ecs_task_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ecs_task_execution_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lb.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_name"></a> [alb\_name](#input\_alb\_name) | The name of the application load balancer. | `string` | n/a | yes |
| <a name="input_alb_security_group_id"></a> [alb\_security\_group\_id](#input\_alb\_security\_group\_id) | List of Security Group IDs to attach to the ALB. | `list(string)` | n/a | yes |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | The port on which the container listens. | `number` | n/a | yes |
| <a name="input_desired_count"></a> [desired\_count](#input\_desired\_count) | The desired number of tasks to run. | `number` | `1` | no |
| <a name="input_docker_image"></a> [docker\_image](#input\_docker\_image) | The Docker image to deploy. | `string` | `"181349251474.dkr.ecr.eu-west-1.amazonaws.com/simple-restful-container"` | no |
| <a name="input_ecs_cluster_name"></a> [ecs\_cluster\_name](#input\_ecs\_cluster\_name) | The name of the ECS cluster. | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs to attach to the ALB. | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to resources. | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC where the ALB will be created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_dns_name"></a> [alb\_dns\_name](#output\_alb\_dns\_name) | The DNS name of the ALB. |
| <a name="output_ecs_cluster_name"></a> [ecs\_cluster\_name](#output\_ecs\_cluster\_name) | The name of the ECS cluster. |
| <a name="output_ecs_service_name"></a> [ecs\_service\_name](#output\_ecs\_service\_name) | The name of the ECS service. |


## Cloudfront & S3
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_distribution.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_origin_access_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_identity) | resource |
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_website_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration) | resource |
| [aws_s3_object.index](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_dns_name"></a> [alb\_dns\_name](#input\_alb\_dns\_name) | The DNS name of the Aplication Load Balancer | `any` | n/a | yes |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | The name of the S3 bucket | `string` | n/a | yes |
| <a name="input_origin_id"></a> [origin\_id](#input\_origin\_id) | The origin ID for the CloudFront distribution | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID where the load balancer and target groups will be deployed | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudfront_distribution_domain_name"></a> [cloudfront\_distribution\_domain\_name](#output\_cloudfront\_distribution\_domain\_name) | The domain name of the CloudFront distribution |
| <a name="output_cloudfront_distribution_id"></a> [cloudfront\_distribution\_id](#output\_cloudfront\_distribution\_id) | The ID of the CloudFront distribution |
| <a name="output_s3_bucket_website_url"></a> [s3\_bucket\_website\_url](#output\_s3\_bucket\_website\_url) | The website URL of the S3 bucket |

## RDS secret rotaion
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.lambda_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.lambda_rotation_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.lambda_secrets_manager_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.lambda_secrets_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.rotate_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.allow_secrets_manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [null_resource.zip_lambda_function](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_lambda_name"></a> [lambda\_name](#input\_lambda\_name) | The name of the Lambda function | `string` | n/a | yes |
| <a name="input_secret_source_arn"></a> [secret\_source\_arn](#input\_secret\_source\_arn) | The arn of the secret | `any` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lambda_function_arn"></a> [lambda\_function\_arn](#output\_lambda\_function\_arn) | The ARN of the Lambda function |
| <a name="output_lambda_function_name"></a> [lambda\_function\_name](#output\_lambda\_function\_name) | The name of the Lambda function |


## RDS aurora

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_db_subnet_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_rds_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auto_pause"></a> [auto\_pause](#input\_auto\_pause) | Whether to enable auto-pause for the Aurora Serverless DB cluster | `bool` | `true` | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | The number of days to retain backups | `number` | `7` | no |
| <a name="input_cluster_identifier"></a> [cluster\_identifier](#input\_cluster\_identifier) | The cluster identifier for the RDS Aurora instance | `string` | n/a | yes |
| <a name="input_database_name"></a> [database\_name](#input\_database\_name) | The name of the default database to create | `string` | `"mydb"` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | If the DB cluster should have deletion protection enabled | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment variable | `string` | n/a | yes |
| <a name="input_master_password"></a> [master\_password](#input\_master\_password) | The master password for the RDS instance | `string` | n/a | yes |
| <a name="input_master_username"></a> [master\_username](#input\_master\_username) | The master username for the RDS instance | `string` | n/a | yes |
| <a name="input_max_capacity"></a> [max\_capacity](#input\_max\_capacity) | The maximum capacity for an Aurora Serverless DB cluster | `number` | `8` | no |
| <a name="input_min_capacity"></a> [min\_capacity](#input\_min\_capacity) | The minimum capacity for an Aurora Serverless DB cluster | `number` | `2` | no |
| <a name="input_preferred_backup_window"></a> [preferred\_backup\_window](#input\_preferred\_backup\_window) | The daily time range during which automated backups are created | `string` | `"01:00-02:00"` | no |
| <a name="input_preferred_maintenance_window"></a> [preferred\_maintenance\_window](#input\_preferred\_maintenance\_window) | The weekly time range during which system maintenance can occur | `string` | `"sun:03:00-sun:04:00"` | no |
| <a name="input_seconds_until_auto_pause"></a> [seconds\_until\_auto\_pause](#input\_seconds\_until\_auto\_pause) | The time, in seconds, before an Aurora Serverless DB cluster auto-pauses | `number` | `300` | no |
| <a name="input_storage_encrypted"></a> [storage\_encrypted](#input\_storage\_encrypted) | Specifies whether the DB cluster is encrypted | `bool` | `true` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs to associate with the RDS cluster | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources | `map(string)` | `{}` | no |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | List of VPC security groups to associate with the RDS cluster | `list(string)` | n/a | yes |

## Outputs

No outputs.


## Secrets Manager

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.rds_secrets_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_secretsmanager_secret.db_master_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_rotation.db_master_credentials_rotation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_rotation) | resource |
| [aws_secretsmanager_secret_version.db_master_credentials_version](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_master_password"></a> [master\_password](#input\_master\_password) | The master password for the database | `string` | n/a | yes |
| <a name="input_master_username"></a> [master\_username](#input\_master\_username) | The master username for the database | `string` | n/a | yes |
| <a name="input_rotation_interval"></a> [rotation\_interval](#input\_rotation\_interval) | The number of days after which to automatically rotate the secret | `number` | `30` | no |
| <a name="input_rotation_lambda_arn"></a> [rotation\_lambda\_arn](#input\_rotation\_lambda\_arn) | The ARN of the Lambda function used for rotating the secret | `string` | n/a | yes |
| <a name="input_secret_name"></a> [secret\_name](#input\_secret\_name) | The name of the secret in Secrets Manager | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_secret_arn"></a> [secret\_arn](#output\_secret\_arn) | The ARN of the secret |
| <a name="output_secret_name"></a> [secret\_name](#output\_secret\_name) | The name of the secret |
| <a name="output_secret_version_id"></a> [secret\_version\_id](#output\_secret\_version\_id) | The ID of the secret version |


## Security-Group

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | The description of the security group | `string` | `"Managed by Terraform"` | no |
| <a name="input_egress_rules"></a> [egress\_rules](#input\_egress\_rules) | List of egress rules | <pre>list(object({<br>    description     = string<br>    from_port       = number<br>    to_port         = number<br>    protocol        = string<br>    cidr_blocks     = optional(list(string), null)<br>    ipv6_cidr_blocks = optional(list(string), null)<br>    security_groups = optional(list(string), null)<br>    self            = optional(bool, null)<br>  }))</pre> | <pre>[<br>  {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "description": "Allow all outbound traffic",<br>    "from_port": 0,<br>    "ipv6_cidr_blocks": null,<br>    "protocol": "-1",<br>    "security_groups": null,<br>    "self": null,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_ingress_rules"></a> [ingress\_rules](#input\_ingress\_rules) | List of ingress rules | <pre>list(object({<br>    description     = string<br>    from_port       = number<br>    to_port         = number<br>    protocol        = string<br>    cidr_blocks     = optional(list(string), null)<br>    ipv6_cidr_blocks = optional(list(string), null)<br>    security_groups = optional(list(string), null)<br>    self            = optional(bool, null)<br>  }))</pre> | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the security group | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the security group | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID where the security group will be created | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | The ID of the security group |
| <a name="output_security_group_name"></a> [security\_group\_name](#output\_security\_group\_name) | The name of the security group |

## VPC

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.isolated](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | List of availability zones to distribute the subnets across | `list(string)` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment variable | `string` | n/a | yes |
| <a name="input_isolated_subnets"></a> [isolated\_subnets](#input\_isolated\_subnets) | List of CIDR blocks for isolated subnets | `list(string)` | n/a | yes |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | List of CIDR blocks for private subnets | `list(string)` | n/a | yes |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | List of CIDR blocks for public subnets | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources | `map(string)` | `{}` | no |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | The CIDR block for the VPC | `string` | n/a | yes |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | The name of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_internet_gateway_id"></a> [internet\_gateway\_id](#output\_internet\_gateway\_id) | The ID of the Internet Gateway |
| <a name="output_isolated_subnet_ids"></a> [isolated\_subnet\_ids](#output\_isolated\_subnet\_ids) | The IDs of the isolated subnets |
| <a name="output_private_subnet_ids"></a> [private\_subnet\_ids](#output\_private\_subnet\_ids) | The IDs of the private subnets |
| <a name="output_public_subnet_ids"></a> [public\_subnet\_ids](#output\_public\_subnet\_ids) | The IDs of the public subnets |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |

<!-- END_TF_DOCS -->