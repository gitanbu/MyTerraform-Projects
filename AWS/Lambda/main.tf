# Specify the AWS region
provider "aws" {
  region = "${var.aws_region}"
}

# Archive Provider for source 
provider "archive" {}

data "archive_file" "zip" {
  type        = "zip"
  source_file = "Hello_World.py"
  output_path = "Hello_World.zip"
}

#POLICY TO CREATE & POST LAMBDA LOG AND SNS TOPIC
data "aws_iam_policy_document" "policy" {
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "log group access",
      "Effect": "Allow",
      "Action": ["logs:CreateLogGroup"],
      "Resource": "arn:aws:logs:us-west-2:<ACCOUNT NUMBER>:*"
    },
    {
      "Sid": "post log",
      "Effect": "Allow",
      "Action": ["logs:CreateLogStream","logs:PutLogEvents"],
      "Resource": "arn:aws:logs:us-west-2:<ACCOUNT NUMBER>:log-group:/aws/lambda/<FUNCTION NAME>:*"
    },
    {
      "Sid": "SNS Publish policy",
      "Effect": "Allow",
      "Action": ["sns:Publish","sns:CreateTopic","sns:DeleteTopic"],
      "Resource": ["arn:aws:sns:*:*:*"]
    }
  ]
}

#IAM Role for Lambda
resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = "${data.aws_iam_policy_document.policy.json}"
}

#Resource for Lambda function
resource "aws_lambda_function" "lambda" {
  function_name = var.nameoffunction
  filename         = "${data.archive_file.zip.output_path}"
  source_code_hash = "${data.archive_file.zip.output_base64sha256}"
  role    = "${aws_iam_role.iam_for_lambda.arn}"
  handler = "Hello_World.lambda_handler"
  runtime = var.versionofpython

  environment {
    variables = {
      sayworld = "Hello"
    }
  }
}

#SNS TOPIC DETAILS TO PUBLISH AFTER LAMBDA EXECUTION
resource "aws_lambda_function_event_invoke_config" "notifing_with_sns"{
    "function_name" = aws_lambda_function.lambda.function_name
    destination_config {
        on_success {
            "destination" = "<SNS TOPIC ARN>"
        }
        on_failure {
            "destination" = "<SNS TOPIC ARN>"
        }
    }
}
