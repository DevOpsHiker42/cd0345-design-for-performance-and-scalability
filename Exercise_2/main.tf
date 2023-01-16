provider "aws" {
  # access_key and secret_key values stored as environment variables for security
  region = var.aws_region
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "greet_lambda" {
  filename      = "lambda.py"
  function_name = "greeting_function"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "index.test"

  source_code_hash = filebase64sha256("lambda.py")

  runtime = "python3.9"

  environment {
    variables = {
      greeting = "Howdy"
    }
  }
}
