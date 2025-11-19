output "start_lambda_function_arn" {
  description = "ARN of the start instances Lambda function"
  value       = aws_lambda_function.start_instances.arn
}

output "stop_lambda_function_arn" {
  description = "ARN of the stop instances Lambda function"
  value       = aws_lambda_function.stop_instances.arn
}

output "cloudwatch_start_rule_arn" {
  description = "ARN of the CloudWatch rule for starting instances"
  value       = aws_cloudwatch_event_rule.start_instances_rule.arn
}

output "cloudwatch_stop_rule_arn" {
  description = "ARN of the CloudWatch rule for stopping instances"
  value       = aws_cloudwatch_event_rule.stop_instances_rule.arn
}