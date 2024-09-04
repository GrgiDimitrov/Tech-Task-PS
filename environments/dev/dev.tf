module "vpc" {
  source = "../../modules/vpc"

  vpc_name           = "Stratos"
  vpc_cidr_block     = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  isolated_subnets   = ["10.0.7.0/24", "10.0.8.0/24", "10.0.9.0/24"]
  availability_zones = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  environment = var.environment

  tags = {
    Project     = "PaySlip"
  }
}



module "rds_aurora_serverless" {
  source = "../../modules/rds_aurora_serverless"

  cluster_identifier      = "dev-aurora-serverless"
  database_name           = "${var.environment}payslip"
  master_username         = "psadmin"
  master_password         = "supersecretpassword"  
  vpc_security_group_ids  =  ["${module.db-sg.security_group_id}"]
  subnet_ids              =  module.vpc.isolated_subnet_ids 
  min_capacity            = 2
  max_capacity            = 8
  auto_pause              = true
  seconds_until_auto_pause = 300
  environment = "${var.environment}"
  
  tags = {
    Environment = "${var.environment}"
    Project     = "PaySlip"
  }
}




#ALB with ECS
module "alb_ecs" {
  source               = "../../modules/alb_ecs_cluster"
  alb_security_group_id = [module.lb-sg-https.security_group_id,module.lb-sg-http.security_group_id]

  alb_name             = "${var.environment}-alb"
  vpc_id               = module.vpc.vpc_id
  subnet_ids           = module.vpc.public_subnet_ids
  ecs_cluster_name     = "${var.environment}-cluster"
  container_port       = 80
  desired_count        = 1
  tags                 = {
    Environment = "dev"
    Project     = "MyProject"
  }
}



# CF with S3
module "cloudfront_s3" {
  source = "../../modules/cloudfront_s3"

  bucket_name = "${var.environment}-hello-world-bucket"
  origin_id   = "${var.environment}-origin"
  vpc_id = module.vpc.vpc_id
  alb_dns_name = module.alb_ecs.alb_dns_name

  tags = {
    Project     = "PaySlip"
    environment = var.environment
  }
}





# Security Groups
module "web-sg" {
  source = "../../modules/security_groups"

  name        = "${var.environment}-sg-web"
  description = "Security group for"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [
    {
      description  = "Allow HTTP traffic"
      from_port    = 80
      to_port      = 80
      protocol     = "tcp"
      cidr_blocks  = ["0.0.0.0/0"]
    },
    {
      description  = "Allow HTTPS traffic"
      from_port    = 443
      to_port      = 443
      protocol     = "tcp"
      cidr_blocks  = ["0.0.0.0/0"]
    }
  ]

  tags = {
    Environment = "${var.environment}"
    Project     = "PaySlip"
  }
}

module "lb-sg-http" {
  source = "../../modules/security_groups"
  name = "${var.environment}-al-http"
  description = "Security group for ALB"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [
    {
      description  = "Allow PostgreSQL traffic"
      from_port    = 80
      to_port      = 80
      protocol     = "tcp"
      cidr_blocks  = ["0.0.0.0/0"]  
    }
  ]

  egress_rules = [
    {
      description  = "Allow all outbound traffic"
      from_port    = 0
      to_port      = 0
      protocol     = "-1"
      cidr_blocks  = ["0.0.0.0/0"]
    }
  ]
  
}

module "lb-sg-https" {
  source = "../../modules/security_groups"
  name = "${var.environment}-al-https"
  description = "Security group for ALB"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [
    {
      description  = "Allow Web Trafic"
      from_port    = 443
      to_port      = 443
      protocol     = "tcp"
      cidr_blocks  = ["0.0.0.0/0"]  
    }
  ]

  egress_rules = [
    {
      description  = "Allow all outbound traffic"
      from_port    = 0
      to_port      = 0
      protocol     = "-1"
      cidr_blocks  = ["0.0.0.0/0"]
    }
  ]
  
}
module "db-sg" {
  source = "../../modules/security_groups"

  name        = "${var.environment}-sg-postgreSQL"
  description = "Security group for PostgreSQL Aurora Serverless"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = [
    {
      description  = "Allow PostgreSQL traffic"
      from_port    = 5432
      to_port      = 5432
      protocol     = "tcp"
      cidr_blocks  = ["0.0.0.0/0"]  
    }
  ]

  egress_rules = [
    {
      description  = "Allow all outbound traffic"
      from_port    = 0
      to_port      = 0
      protocol     = "-1"
      cidr_blocks  = ["0.0.0.0/0"]
    }
  ]

  tags = {
    Environment = "${var.environment}"
    Project     = "PaySlip"
  }
}


##DB Secret

module "secret_rotation_lambda" {
  source = "../../modules/lambda_secret_rotate"

  lambda_name = "${var.environment}-rotate-secrets"
  secret_source_arn = module.db_secrets.secret_arn

  tags = {
    Environment = "${var.environment}"
    Project     = "PaySlip"
  }
}

module "db_secrets" {
  source = "../../modules/secrets_manager"

  secret_name      = "${var.environment}/aurora/master-credentials"
  master_username  = "admin"
  master_password  = "supersecretpassword"
  rotation_lambda_arn = module.secret_rotation_lambda.lambda_function_arn 
  rotation_interval   = 30

  tags = {
    Environment = "${var.environment}"
    Project     = "PaySlip"
  }
}