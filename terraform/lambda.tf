data "archive_file" "budget_bot_lambda" {
  type        = "zip"
  source_file = "${path.cwd}/budget-bot/budget-bot.py"
  output_path = "${path.cwd}/budget-bot.zip"
}
resource "aws_lambda_function" "budget_bot" {
  filename         = "${path.cwd}/budget-bot.zip"
  function_name    = "${var.prefix}budget-bot${var.suffix}"
  description      = "${var.prefix}budget-bot${var.suffix}"
  timeout          = 300
  runtime          = "python${var.python_version}"
  role             = "${aws_iam_role.role.arn}"
  handler          = "budget-bot.lambda_handler"
  source_code_hash = "${data.archive_file.budget_bot_lambda.output_base64sha256}"

  environment {
    variables = {
      TELEGRAM_TOKEN  = ""
      DB_TABLE = ""
    }
  }

  tags = "${merge(
            var.tags,
            map("Scope", "${var.prefix}lambda_function_to_elasticsearch${var.suffix}"),
            )}"
}

