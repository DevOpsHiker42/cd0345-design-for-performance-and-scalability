output "lambda_arn" {
  description = "The ARN of the greet_lambda function"
  value       = aws_lambda_function.greet_lambda.arn
}
