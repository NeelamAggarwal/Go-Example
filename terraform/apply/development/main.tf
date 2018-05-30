provider "aws" {
  region = "us-east-1"
}

data "aws_iam_policy" "AmazonDynamoDBFullAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

data "aws_iam_policy" "CloudWatchLogsFullAccess" {
  arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

data "aws_iam_policy" "KinesisReadOnlyAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonKinesisReadOnlyAccess"
}


# Pipeline: API gateway to Lambda to  Kinesis
module "apigw-lambda-kinesis" {
  source = "git@github.com:sendgrid-ops/terraform-modules.git//apigw-lambda-kinesis"
  aws_kinesis_stream_name = "KinesisStream1"
  api_description = "MC Contacts API"
  aws_kinesis_shard_count = "1"
  lambda_function_filepath = "../../../deployment.zip"
  api_name = "MC1"
  aws_kinesis_retention_period = "24"
  lambda_function_name = "LambdaFunction1"
  lambda_env_vars = {CONTACTSAPI_LAMBDACOMMAND   = "http_server"}
}


module "lambda" {
  source      =  "git@github.com:sendgrid-ops/terraform-modules.git//lambda"
  filepath = "../../../deployment.zip"
  function_name = "LambdaFunction2"
  env_vars = {CONTACTSAPI_LAMBDACOMMAND    = "kinesis_consumer"}

  # Lambda policy
  attach_policies = ["${data.aws_iam_policy.AmazonDynamoDBFullAccess.arn}", "${data.aws_iam_policy.CloudWatchLogsFullAccess.arn}", "${data.aws_iam_policy.KinesisReadOnlyAccess.arn}"]
}


# Add lambda as trigger to kinesis
resource "aws_lambda_event_source_mapping" "event_source_mapping" {
  batch_size        = 100
  event_source_arn  = "${module.apigw-lambda-kinesis.kinesis_stream_arn}"
  enabled           = true
  function_name     = "${module.lambda.lambda_arn}"
  starting_position = "TRIM_HORIZON"
}


module "dynamo" {
  source = "../../modules/dynamo"
  dynamo_min_write_capacity = "1"
  dynamo_min_read_capacity = "1"
  dynamo_contacts_table_name = "DynamoTable1"
}

