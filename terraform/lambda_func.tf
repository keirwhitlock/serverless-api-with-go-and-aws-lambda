resource "aws_lambda_function" "books" {
  filename      = "main.zip"
  function_name = "books"
  role          = "${aws_iam_role.lambda-books-executor.arn}"
  handler       = "main"

  source_code_hash = "${filebase64sha256("main.zip")}"
  runtime          = "go1.x"
}

resource "aws_iam_role" "lambda-books-executor" {
  name = "lambda-books-executor"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "lambda-books-executor" {
  name = "dynamodb-item-crud-role"
  role = "${aws_iam_role.lambda-books-executor.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "dynamodb:PutItem",
                "dynamodb:GetItem",
                "logs:CreateLogGroup",
                "logs:PutLogEvents",
		"logs:CreateLogStream"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_lambda_permission" "allow_books_apigateway" {
  statement_id  = "AllowExecutionFromBooksAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.books.function_name}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.bookstore.id}/*/*/*"
}
