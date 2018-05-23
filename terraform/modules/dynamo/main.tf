resource "aws_dynamodb_table" "contacts-table" {
  name           = "${var.dynamo_contacts_table_name}"
  read_capacity  = "${var.dynamo_min_read_capacity}"
  write_capacity = "${var.dynamo_min_write_capacity}"
  hash_key       = "UserId"
  range_key      = "ContactId"

  attribute {
    name = "UserId"
    type = "N"
  }

  attribute {
    name = "ContactId"
    type = "S"
  }

  attribute {
    name = "PrimaryEmail"
    type = "S"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled = false
  }

  global_secondary_index {
    name               = "ContactByEmail"
    hash_key           = "UserId"
    range_key          = "PrimaryEmail"
    read_capacity      = "${var.dynamo_min_read_capacity}"
    write_capacity     = "${var.dynamo_min_write_capacity}"
    projection_type    = "ALL"
  }

  stream_enabled = "true"
  stream_view_type = "NEW_AND_OLD_IMAGES"

  tags {
    Name        = "MC-Contacts"
    Environment = "${var.environment}"
  }
}