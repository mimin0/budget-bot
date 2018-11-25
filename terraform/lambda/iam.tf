data "template_file" "policy" {
  template = "${file("${path.cwd}/terraform/lambda/files/budget_bot_policy.json")}"
}

resource "aws_iam_policy" "policy" {
  name        = "iamp-budget-bot-lambda"
  path        = "/"
  description = "Policy for budget-bot Lambda function"
  policy      = "${data.template_file.policy.rendered}"
}

resource "aws_iam_role" "role" {
  name = "iamr-budget-bot-lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  role       = "${aws_iam_role.role.name}"
  policy_arn = "${aws_iam_policy.policy.arn}"
}
