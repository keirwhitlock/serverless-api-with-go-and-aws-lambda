resource "aws_api_gateway_rest_api" "bookstore" {
  name        = "bookstore"
  description = "https://www.alexedwards.net/blog/serverless-api-with-go-and-aws-lambda"
}

resource "aws_api_gateway_resource" "books" {
  rest_api_id = "${aws_api_gateway_rest_api.bookstore.id}"
  parent_id   = "${aws_api_gateway_rest_api.bookstore.root_resource_id}"
  path_part   = "books"
}

resource "aws_api_gateway_method" "bookAny" {
  rest_api_id   = "${aws_api_gateway_rest_api.bookstore.id}"
  resource_id   = "${aws_api_gateway_resource.books.id}"
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "books" {
  rest_api_id             = "${aws_api_gateway_rest_api.bookstore.id}"
  resource_id             = "${aws_api_gateway_resource.books.id}"
  http_method             = "${aws_api_gateway_method.bookAny.http_method}"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.books.invoke_arn}"
}

resource "aws_api_gateway_deployment" "staging" {
  depends_on  = ["aws_api_gateway_integration.books"]
  rest_api_id = "${aws_api_gateway_rest_api.bookstore.id}"
  stage_name  = "staging"
}
