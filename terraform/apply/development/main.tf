provider "aws" {
  region = "us-west-2"
}


resource "aws_kinesis_stream" "test_stream" {
  name             = "terraform-kinesis-test"
  shard_count      = 1

}


resource "aws_lambda_function" "demo_lambda" {
    function_name = "demo_lambda"
    handler = "demo.handler"
    runtime = "go1.x"
    filename = "demo.zip"
    source_code_hash = "${base64sha256(file("demo.zip"))}"
}


