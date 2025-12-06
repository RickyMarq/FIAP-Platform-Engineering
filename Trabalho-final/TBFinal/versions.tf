terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0"
    }
  }

  backend "s3" {
    bucket  = "base-config-357919"
    key     = "terraform-count/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true

    workspace_key_prefix = "workspaces"
  }
}
