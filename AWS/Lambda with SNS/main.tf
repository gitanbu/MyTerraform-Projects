provider "aws" {
  region = var.aws_region
}

# Archive Provider for source 
provider "archive" {}

data "archive_file" "zip" {
  type        = "zip"
  source_file = "Hello_World.py"
  output_path = "Hello_World.zip"
}

# SNS creation 
resource "aws_sns_topic" "sns_creation" {
  name = "test_topic"
}

# Basic lambda policy

resource "aws_iam_role" "lambda_access_role" {
  name               = "lambda-role"
  assume_role_policy = jsonencode({
  Version = "2012-10-17"
  Statement = [
      {
      "Effect" = "Allow",
      "Principal" = {
        "Service" = "lambda.amazonaws.com"
      },
      "Action" = "sts:AssumeRole"
      }
  ]
})
}

# Policy for SNS publish access
resource "aws_iam_policy" "policy" {
  name = "SNS-publish-access"
  policy = jsonencode({
   Version = "2012-10-17"
   Statement = [
      {
      "Sid"= "SNSPublishpolicy"
      "Effect"= "Allow"
      "Action"= "sns:Publish"
      "Resource"= "arn:aws:sns:*:*:*"
      }
      ]
    })
}

#attaching sns policy to lambda role
resource "aws_iam_role_policy_attachment" "sns-publish-policy-attachment" {
    role = aws_iam_role.lambda_access_role.name
    policy_arn = aws_iam_policy.policy.arn
}

resource "aws_lambda_function" "lambda" {
  function_name = var.nameoffunction
  filename         = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256
  role    = aws_iam_role.lambda_access_role.arn
  handler = "Hello_World.lambda_handler"
  runtime = "python3.8"

  environment {
    variables = {
      sayworld = "Hello"
    }
  }
}

resource "aws_lambda_function_event_invoke_config" "notifing_with_sns"{
    function_name = aws_lambda_function.lambda.function_name
    destination_config {
        on_success {
            destination = aws_sns_topic.sns_creation.arn
        }
        on_failure {
            destination = aws_sns_topic.sns_creation.arn
        }
    }
}


