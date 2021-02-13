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

data "aws_iam_policy_document" "policy" {
  statement {
    sid    = ""
    effect = "Allow"

    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }

    actions = ["sts:AssumeRole"]
  }
}

#IAM Role for Lampda
resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = "${data.aws_iam_policy_document.policy.json}"
}

#Resource for Lampda function
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