provider "aws" {
    alias      = "us"
    region     = "us-east-1"

    skip_get_ec2_platforms      = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
}

provider "aws" {
    alias = "eu"
    profile = var.aws_profile
    region  = var.aws_region
    shared_credentials_file = var.aws_credentials

    skip_get_ec2_platforms      = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
}