variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "lambda_function_name" {
  description = "Lambda Function Name"
  type        = string
  default     = "greeting_function"
}
