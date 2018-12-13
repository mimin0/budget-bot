resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "budgetBot"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "recordId"
  range_key      = "operationDate"

  attribute {
    name = "recordId"
    type = "S"
  }

  attribute {
    name = "operationDate"
    type = "S"
  }

  attribute {
    name = "operationSumm"
    type = "N"
  }

  attribute {
    name = "operationCatigory"
    type = "S"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }

  global_secondary_index {
    name               = "operationCatigoryIndex"
    hash_key           = "operationCatigory"
    range_key          = "operationSumm"
    write_capacity     = 5
    read_capacity      = 5
    projection_type    = "ALL"
  }

  tags {
    Name        = "dynamodb-table-1"
    Environment = "production"
  }
}