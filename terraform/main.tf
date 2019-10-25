provider "aws" {
	profile = "default"
	region = "eu-west-2"
}

data "aws_caller_identity" "current" {}

variable "region" {
  type = string
  default = "eu-west-2"
}
