output "s3_bucket_name" {
    value = aws_s3_bucket.bucket.id
}

output "s3_bucket_region" {
    value = aws_s3_bucket.bucket.region
}

output "cdn_id" {
    value = aws_cloudfront_distribution.www_cdn.id
}

output "website_endpoint" {
    value = aws_cloudfront_distribution.root_cdn.domain_name
}