# creation of the api entry
resource "aws_api_gateway_rest_api" "budget_bot_api" {
 name = "budget-bot-api-gateway"
 description = "Proxy to handle requests to our API"
}

resource "aws_api_gateway_resource" "budget_bot_resource" {
  rest_api_id = "${aws_api_gateway_rest_api.budget_bot_api.id}"
  parent_id   = "${aws_api_gateway_rest_api.budget_bot_api.root_resource_id}"
  path_part   = "${var.lambda}"
}

# Example: request for GET /hello
resource "aws_api_gateway_method" "request_method" {
  rest_api_id   = "${aws_api_gateway_rest_api.budget_bot_api.id}"
  resource_id   = "${aws_api_gateway_resource.budget_bot_resource.id}"
  http_method   = "GET"
  authorization = "NONE"
}

# Example: GET /hello => POST lambda
resource "aws_api_gateway_integration" "request_method_integration" {
  rest_api_id = "${aws_api_gateway_rest_api.budget_bot_api.id}"
  resource_id = "${aws_api_gateway_resource.budget_bot_resource.id}"
  http_method = "${aws_api_gateway_method.request_method.http_method}"
  type        = "AWS"
  uri         = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.region}:${var.account_id}:function:${var.lambda}/invocations"

  # AWS lambdas can only be invoked with the POST method
  integration_http_method = "POST"
}

# lambda => GET response
resource "aws_api_gateway_method_response" "response_method" {
  rest_api_id = "${aws_api_gateway_rest_api.budget_bot_api.id}"
  resource_id = "${aws_api_gateway_resource.budget_bot_resource.id}"
  http_method = "${aws_api_gateway_integration.request_method_integration.http_method}"
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }
}

# Response for: GET /hello
resource "aws_api_gateway_integration_response" "response_method_integration" {
  rest_api_id = "${aws_api_gateway_rest_api.budget_bot_api.id}"
  resource_id = "${aws_api_gateway_resource.budget_bot_resource.id}"
  http_method = "${aws_api_gateway_method_response.response_method.http_method}"
  status_code = "${aws_api_gateway_method_response.response_method.status_code}"

  response_templates = {
    "application/json" = ""
  }
}

resource "aws_lambda_permission" "allow_api_gateway" {
  function_name = "${var.lambda}"
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${var.account_id}:${aws_api_gateway_rest_api.budget_bot_api.id}/*/${var.method}/${var.lambda}"
}

resource "aws_api_gateway_deployment" "instance" {
  rest_api_id = "${aws_api_gateway_rest_api.budget_bot_api.id}"
  stage_name  = "prod"

  variables {
    deployed_at = "${var.deployed_at}"
  }
}

output "http_method" {
  value = "${aws_api_gateway_integration_response.response_method_integration.http_method}"
}