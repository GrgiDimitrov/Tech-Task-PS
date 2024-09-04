# IAM Role for Lambda
resource "aws_iam_role" "lambda_rotation_role" {
  name = "rds-secret-rotation-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "lambda_secrets_policy" {
  role       = aws_iam_role.lambda_rotation_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_secrets_manager_policy" {
  role       = aws_iam_role.lambda_rotation_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}


# Local-exec provisioner to zip the Lambda function code
resource "null_resource" "zip_lambda_function" {
  provisioner "local-exec" {
    command = "zip -j ${path.module}/src/rotate_secrets.py.zip ${path.module}/src/rotate_secrets.py"
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}

# Define the Lambda function
resource "aws_lambda_function" "rotate_secrets" {
  function_name = "rotate-secrets-function"
  handler       = "rotate_secrets.lambda_handler"
  runtime       = "python3.8"

  role = aws_iam_role.lambda_rotation_role.arn

  filename         = "${path.module}/src/rotate_secrets.py.zip"
  
  # Source_code_hash from the ZIP file
  source_code_hash = filebase64sha256("${path.module}/src/rotate_secrets.py.zip")

  environment {
    variables = {
      LOG_LEVEL = "INFO"
    }
  }

  tags = var.tags

  depends_on = [null_resource.zip_lambda_function]
}





# Create a CloudWatch Log Group for the Lambda function
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.rotate_secrets.function_name}"
  retention_in_days = 14

  tags = var.tags
}



resource "aws_lambda_permission" "allow_secrets_manager" {
  statement_id  = "AllowSecretsManagerInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.rotate_secrets.function_name
  principal     = "secretsmanager.amazonaws.com"
  source_arn    = var.secret_source_arn
}