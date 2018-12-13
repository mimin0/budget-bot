data "archive_file" "budget_bot_lambda" {
  type        = "zip"
  source_dir = "${path.cwd}/budget-bot"
  output_path = "${path.cwd}/budget-bot.zip"
}
resource "aws_lambda_function" "budget_bot" {
  filename         = "${path.cwd}/budget-bot.zip"
  function_name    = "${var.name}"
  description      = "${var.name}"
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
            map("Scope", "lambda_function_to_DB_${var.region}"),
            )}"
}

