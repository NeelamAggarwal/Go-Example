variable "dynamo_contacts_table_name" {
  description = "dynamodb contacts table name"
  default     = "DevContacts"
  type        = "string"
}

variable "dynamo_min_read_capacity" {
  description = "minimum read capacity for dynamodb tables"
  default     = "1"
  type        = "string"
}

variable "dynamo_min_write_capacity" {
  description = "minimum write capacity for dynamodb tables"
  default     = "1"
  type        = "string"
}

variable "environment" {
  description = "environment where dynamodb tables will be created"
  default     = "development"
  type        = "string"
}