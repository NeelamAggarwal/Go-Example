output "dynamodb_contacts_table_arn" {
  description = "ARN for the DynamoDB Contacts table"
  value       = "${aws_dynamodb_table.contacts-table.arn}"
}