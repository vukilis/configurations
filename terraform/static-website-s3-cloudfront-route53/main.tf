terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 4.11.0"                           #terraform official aws version
        }
        acme = {
            source  = "vancluever/acme"
            version = "~> 2.8.0"
        }
    }

    required_version = ">= 0.12.8"                          #terraform version 
}

module "cloudfront" {
    source  = "./modules/s3_cloudfront_route53"

    domain  = "website-test.com"                 #set your domain -> without "www"

    aws_profile = "default"                                 #set your profile
    aws_region = "eu-west-3"                                #set your region
    aws_credentials = "~/.aws/credentials"                  #set your credentials

    tags = {
        environment = "dev"                                 #set name tags
        terraform   = "true"
    }
}