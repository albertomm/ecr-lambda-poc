terraform {
  required_version = "~> 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  alias   = "account_a"
  region  = var.region
  profile = var.account_a_profile
}

provider "aws" {
  alias   = "account_b"
  region  = var.region
  profile = var.account_b_profile
}

data "aws_caller_identity" "account_a" {
  provider = aws.account_a
}

data "aws_caller_identity" "account_b" {
  provider = aws.account_b
}

module "account_a" {
  source = "./account_a"

  account_b_id = data.aws_caller_identity.account_b.account_id
  updater_role_arn = module.account_b.updater_role_arn

  providers = {
    aws = aws.account_a
  }
}

module "account_b" {
  source = "./account_b"

  account_a_id = data.aws_caller_identity.account_a.account_id
  image_url    = "${module.account_a.repository_url}:initial"

  providers = {
    aws = aws.account_b
  }
}

module "pipeline" {
  source = "./pipeline"

  updater_role_arn = module.account_b.updater_role_arn

  providers = {
    aws = aws.account_a
  }

  depends_on = [
    module.account_a,
    module.account_b,
   ]
}

output "account_a" {
  value = module.account_a
}

output "account_b" {
  value = module.account_b
}

output "pipeline" {
  value = module.pipeline
}
