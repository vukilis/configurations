resource "aws_cloudfront_origin_access_identity" "cdn_identity" {
    comment = "access-identity-www.${var.domain}.s3.amazonaws.com"
}

resource "aws_cloudfront_distribution" "www_cdn" {

    origin {
        domain_name = "${aws_s3_bucket_website_configuration.bucket_conf.website_endpoint}"
        origin_id   = "www.${var.domain}"

        custom_origin_config {
            http_port              = "80"
            https_port             = "443"
            origin_protocol_policy = "http-only"
            origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
        }
    }
    enabled             = true
    is_ipv6_enabled     = true
    default_root_object = "index.html"
    aliases = ["www.${var.domain}"]
    
    restrictions {
        geo_restriction {
        restriction_type = "none"
        }
    }
    
    default_cache_behavior {
        allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
        cached_methods   = ["GET", "HEAD"]
        target_origin_id = "www.${var.domain}"

        forwarded_values {
        query_string = false

        cookies {
            forward = "none"
        }
        }

        viewer_protocol_policy = "redirect-to-https"
        min_ttl                = 0
        default_ttl            = 3600
        max_ttl                = 86400
    }

    tags = var.tags

    viewer_certificate {
        acm_certificate_arn = aws_acm_certificate_validation.cert_validation.certificate_arn
        ssl_support_method = "sni-only"
        minimum_protocol_version = "TLSv1.1_2016"
    }

}

resource "aws_cloudfront_distribution" "root_cdn" {

    origin {
        domain_name = "${aws_s3_bucket.redirect.website_endpoint}"
        origin_id   = "${var.domain}"

        custom_origin_config {
            http_port              = "80"
            https_port             = "443"
            origin_protocol_policy = "http-only"
            origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
        }
    }
    enabled             = true
    is_ipv6_enabled     = true
    default_root_object = "index.html"
    aliases = ["${var.domain}"]
    
    restrictions {
        geo_restriction {
        restriction_type = "none"
        }
    }
    
    default_cache_behavior {
        allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
        cached_methods   = ["GET", "HEAD"]
        target_origin_id = "${var.domain}"

        forwarded_values {
            query_string = false

            cookies {
                forward = "none"
            }
        }

        viewer_protocol_policy = "redirect-to-https"
        min_ttl                = 0
        default_ttl            = 3600
        max_ttl                = 86400
    }

    tags = var.tags

    viewer_certificate {
        acm_certificate_arn = aws_acm_certificate_validation.cert_validation.certificate_arn
        ssl_support_method = "sni-only"
        minimum_protocol_version = "TLSv1.1_2016"
    }
}