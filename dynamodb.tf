resource "aws_dynamodb_table" "mqtt_table" {
  name           = "mqtt_table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "Key"
  range_key      = "Timestamp"

  attribute {
    name = "Key"
    type = "S"
  }

  attribute {
    name = "Timestamp"
    type = "S"
  }
}

resource "aws_dynamodb_table" "error_table" {
  name           = "error_table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "Metric"
  range_key      = "Value"

  attribute {
    name = "Metric"
    type = "S"
  }

  attribute {
    name = "Value"
    type = "N"
  }
}