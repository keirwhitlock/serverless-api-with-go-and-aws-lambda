resource "aws_dynamodb_table" "books" {
  name     = "Books"
  hash_key = "ISBN"
  attribute {
    name = "ISBN"
    type = "S"
  }
  read_capacity  = 5
  write_capacity = 5
}

resource "aws_dynamodb_table_item" "testBookOne" {
  table_name = "${aws_dynamodb_table.books.name}"
  hash_key   = "${aws_dynamodb_table.books.hash_key}"

  item = <<ITEM
{
	"ISBN": {"S": "978-1420931693"},
	"Title": {"S": "The Republic"},
	"Author": {"S": "Plato"}
}
ITEM
}

resource "aws_dynamodb_table_item" "testBookTwo" {
  table_name = "${aws_dynamodb_table.books.name}"
  hash_key   = "${aws_dynamodb_table.books.hash_key}"

  item = <<ITEM
{
	"ISBN": {"S": "978-0486298238"},
	"Title": {"S": "Meditations"},
	"Author": {"S": "Marcus Aurelius"}
}
ITEM
}
