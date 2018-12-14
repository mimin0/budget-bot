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

#### Create a new Bot

#### Webhook vs Polling

Great! I have the API key now. Next, I have to choose between the two ways to get messages from Telegram.

Webhooks via setWebhook or
Polling via getUpdates
I’m fairly certain that it is easier to set up with getUpdates but polling isn’t always an option and not having real-time updates isn’t as fun IMHO :P So, for this bot, I went with webhooks as I wanted the bot to respond in real-time.

To set up the Webhook all I had to do is to send a curl request to the Telegram Api.

    curl --request POST --url https://api.telegram.org/bot<YOUR_TOKEN>/setWebhook --header 'content-type: application/json' --data '{"url": "<AWS_API_GATEWAY_ENDPOINT>"}'

you should get a response like that:

    {"ok":true,"result":true,"description":"Webhook was set"}

## First deployment of budget bot

## Rolling out new version of budget bot


## References:
- https://medium.com/coryodaniel/til-forcing-terraform-to-deploy-a-aws-api-gateway-deployment-ed36a9f60c1a
- https://dev.to/nqcm/-building-a-telegram-bot-with-aws-api-gateway-and-aws-lambda-27fg
- https://github.com/lesterchan/telegram-bot
- https://hackernoon.com/serverless-telegram-bot-on-aws-lambda-851204d4236c
