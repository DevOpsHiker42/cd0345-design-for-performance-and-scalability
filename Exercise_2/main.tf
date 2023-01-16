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
  filename      = "lambda.py.zip"
  function_name = var.lambda_function_name
  role          = aws_iam_role.iam_for_lambda.arn

  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs,
    aws_cloudwatch_log_group.greeting_lambda_logs,
  ]

  source_code_hash = filebase64sha256("lambda.py.zip")

  runtime = "python3.9"
  handler       = "lambda.lambda_handler"

  environment {
    variables = {
      greeting = "Howdy"
    }
  }
}

resource "aws_cloudwatch_log_group" "greeting_lambda_logs" {
  name              = "/aws/lambda/${var.lambda_function_name}"
  retention_in_days = 7
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}
