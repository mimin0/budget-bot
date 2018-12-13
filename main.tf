provider "aws" {
  region = "${var.region}"
}

data "aws_caller_identity" "current" {}


module "lambda_bot" {
  source = "terraform/lambda"
  name  = "${var.lambda_name}"
  region = "${var.region}"
}

module "api_gateway_bot" {
  source = "terraform/api_gateway"
  lambda = "${var.lambda_name}"
  account_id = "${data.aws_caller_identity.current.account_id}"
  region = "${var.region}"
  deployed_at = "${var.deployed_at}"
}

module "budget_database" {
  source = "terraform/dynamodb"
}
