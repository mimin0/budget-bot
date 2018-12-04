# Budget bot

this is a Telegram bot that can help you manage daily expences

## Prerequisites
 - terraform
 - python
 - aws account
 - telegram account

## Configuration

### AWS account setup

### Terraform setup

NOTE: Terraform’s `aws_api_gateway_deployment` will not deploy a new version of gateway if `stage_name` is not changed. The work arround it to chenge it dynamically via env variables:

#### Option #1

    resource "aws_api_gateway_deployment" "instance" {
        rest_api_id = "${var.rest_api_id}"
        stage_name  = "${var.stage_name}"

    variables {
        deployed_at = "${var.deployed_at}"
        }
    }

    $ export TF_VAR_deployed_at=$(date +%s)
    $ terraform plan

#### Option #2

    export TF_VAR_version=$(git hash-object ./path/to/my/module.tf | awk '{ print substr($1,0,6) }')

### Telegram setup

## First eployment of budget bot

## Rolling out new version of budget bot


## References:
- https://medium.com/coryodaniel/til-forcing-terraform-to-deploy-a-aws-api-gateway-deployment-ed36a9f60c1a
