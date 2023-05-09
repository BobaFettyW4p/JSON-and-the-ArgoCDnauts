terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 4.51.0"
        }
    }
    backend "s3" {
        region = "us-east-2"
        key = "prod/terraform.tfstate"
        bucket = "mivancic-argocd-terraform-state"
    }
}

provider "aws" {
    region = "us-east-2"

    default_tags {
        tags = {
            "ManagedBy" = "Terraform"
            Name = "ArgoCD"
        }
    }
}
