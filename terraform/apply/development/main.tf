provider "aws" {
  region = "us-west-2"
}


resource "aws_kinesis_stream" "test_stream" {
  name             = "terraform-kinesis-test"
  shard_count      = 1

}


