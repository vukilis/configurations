output "s3_bucket_name" {
    value = module.cloudfront.s3_bucket_name
}

output "s3_bucket_region" {
    value = module.cloudfront.s3_bucket_region
}

output "cdn_id" {
    value = module.cloudfront.cdn_id
}

output "website_endpoint" {
    value = module.cloudfront.website_endpoint
}