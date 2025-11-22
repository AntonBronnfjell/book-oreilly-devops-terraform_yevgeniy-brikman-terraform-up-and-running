terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.99.1"
    }
  }

  backend "s3" {
    bucket = "terraform-up-and-running-state-792290882875"
    key    = "sandbox/03/isolation-via-workspaces/workspace/terraform.tfstate"
    region = "us-east-2"
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt = true
    profile = "default"
    use_lockfile = true
  }
}