resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "budgetBot"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "recordId"

  attribute {
    name = "recordId"
    type = "S"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }

  tags {
    Name        = "dynamodb-table-1"
    Environment = "production"
  }
}