data "aws_route53_zone" "zone" {
    name         = var.domain
    private_zone = false
}

resource "aws_route53_record" "root" {
    zone_id = "${data.aws_route53_zone.zone.zone_id}"
    name    = "${var.domain}"
    type    = "A"

    alias {
        name                   = "${aws_cloudfront_distribution.root_cdn.domain_name}"
        zone_id                = "${aws_cloudfront_distribution.root_cdn.hosted_zone_id}"
        evaluate_target_health = false
    }
}

resource "aws_route53_record" "www" {
    zone_id = "${data.aws_route53_zone.zone.zone_id}"
    name    = "www.${var.domain}"
    type    = "A"

    alias {
        name                   = "${aws_cloudfront_distribution.www_cdn.domain_name}"
        zone_id                = "${aws_cloudfront_distribution.www_cdn.hosted_zone_id}"
        evaluate_target_health = false
    }
}

######################################  AWS CERTIFICATE ######################################
resource "aws_acm_certificate" "cert" {
    provider          = aws.us
    domain_name       = "${var.domain}"
    subject_alternative_names = ["*.${var.domain}"]
    validation_method = "DNS"

    lifecycle {
        create_before_destroy = true
    }

    tags = var.tags
}

resource "aws_route53_record" "main" {
    for_each = {
        for i in aws_acm_certificate.cert.domain_validation_options : i.domain_name => {
        name   = i.resource_record_name
        record = i.resource_record_value
        type   = i.resource_record_type
    }
}

    allow_overwrite = true
    name            = each.value.name
    records         = [each.value.record]
    ttl             = 60
    type            = each.value.type
    zone_id         = "${data.aws_route53_zone.zone.zone_id}"
}

resource "aws_acm_certificate_validation" "cert_validation" {
    provider = aws.us
    certificate_arn         = aws_acm_certificate.cert.arn
    validation_record_fqdns = [for record in aws_route53_record.main : record.fqdn]
    timeouts {
        create = "60m"
    }
}