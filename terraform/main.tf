terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"  # Simple - no variables needed
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "ec2-scheduler-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# IAM Policy for Lambda
resource "aws_iam_policy" "lambda_policy" {
  name        = "ec2-scheduler-lambda-policy"
  description = "Policy for EC2 scheduler Lambda functions"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "ec2:DescribeInstances",
        "ec2:StartInstances", 
        "ec2:StopInstances",
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

# Lambda Functions
resource "aws_lambda_function" "start_instances" {
  filename      = "${path.module}/../start_instances.zip"
  function_name = "ec2-start-instances"
  role          = aws_iam_role.lambda_role.arn
  handler       = "start-instance.lambda_handler"
  runtime       = "python3.8"
  timeout       = 300
}

resource "aws_lambda_function" "stop_instances" {
  filename      = "${path.module}/../stop_instances.zip"
  function_name = "ec2-stop-instances"
  role          = aws_iam_role.lambda_role.arn
  handler       = "stop-instance.lambda_handler"
  runtime       = "python3.8"
  timeout       = 300
}

# CloudWatch Events
resource "aws_cloudwatch_event_rule" "start_instances_rule" {
  name                = "start-ec2-instances"
  description         = "Start EC2 instances at 8 AM"
  schedule_expression = "cron(0 8 * * ? *)"  # 8 AM daily
}

resource "aws_cloudwatch_event_rule" "stop_instances_rule" {
  name                = "stop-ec2-instances" 
  description         = "Stop EC2 instances at 8 PM"
  schedule_expression = "cron(0 20 * * ? *)"  # 8 PM daily
}

# Lambda Permissions
resource "aws_lambda_permission" "start_permission" {
  statement_id  = "CloudWatchStart"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.start_instances.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.start_instances_rule.arn
}

resource "aws_lambda_permission" "stop_permission" {
  statement_id  = "CloudWatchStop"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.stop_instances.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.stop_instances_rule.arn
}

# Event Targets
resource "aws_cloudwatch_event_target" "start_target" {
  rule = aws_cloudwatch_event_rule.start_instances_rule.name
  arn  = aws_lambda_function.start_instances.arn
}

resource "aws_cloudwatch_event_target" "stop_target" {
  rule = aws_cloudwatch_event_rule.stop_instances_rule.name
  arn  = aws_lambda_function.stop_instances.arn
}