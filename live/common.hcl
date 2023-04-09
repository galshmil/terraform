remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket  = "terradome-states"
    key     = "tests/gal.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

locals {
  provider_vars      = read_terragrunt_config("./providers-list.hcl")
  providers          = local.provider_vars.locals.providers
  regional_vars      = yamldecode(file("${find_in_parent_folders("region.yaml")}"))
}

generate "versions" {
  path      = "required_providers.tf"
  if_exists = "skip"
  contents = <<-EOF
terraform {
  required_version = ">= 1.0.2"

  required_providers {
  %{if contains(local.providers, "aws") || contains(local.providers, "aws_us") || contains(local.providers, "aws_peer")}
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.45.0"
    }
  %{endif}
  }
}
EOF
}

# TODO: Create Cloudflare user for Terradome
generate "provider" {
  path      = "providers.tf"
  if_exists = "skip"
  contents  = <<-EOF
%{if contains(local.providers, "aws")}
provider "aws" {
  region = "${local.regional_vars["aws_region"]}"
  
  default_tags {
    tags = {
      "Terraform"   = true
      "Owner"       = "DevOps"
    }
  }
}
%{endif}
%{if contains(local.providers, "aws_us")}
provider "aws" {
  alias  = "us"
  region = "us-east-1"
}
%{endif}
EOF
}
