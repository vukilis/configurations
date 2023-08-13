module "template_files" {
    source = "../template_s3_bucket_objects"

    base_dir = "${path.module}/../../../../website-test/build"
    template_vars = {
        name = "website-test"
    }
}

resource "aws_s3_bucket" "bucket" {
    bucket = "www.${var.domain}"
    acl = var.acl

    policy = <<POLICY
    {
    "Version":"2012-10-17",
    "Statement":[
        {
        "Sid":"PublicReadGetObject",
        "Effect":"Allow",
        "Principal": "*",
        "Action":["s3:GetObject"],
        "Resource":["arn:aws:s3:::www.${var.domain}/*"]
        }
    ]}
    POLICY

    tags = var.tags
}

resource "aws_s3_bucket_website_configuration" "bucket_conf" {
    bucket = "${aws_s3_bucket.bucket.bucket}"

    index_document {
        suffix = "index.html"
    }

    error_document {
        key = "index.html"
    }
}

resource "aws_s3_bucket" "redirect" {
    bucket = var.domain

    policy = <<POLICY
    {
    "Version":"2012-10-17",
    "Statement":[
        {
        "Sid":"PublicReadGetObject",
        "Effect":"Allow",
        "Principal": "*",
        "Action":["s3:GetObject"],
        "Resource":["arn:aws:s3:::${var.domain}/*"]
        }
    ]}
    POLICY

    website {
        redirect_all_requests_to = "https://www.${var.domain}"
    }
}

resource "aws_s3_bucket_object" "static_files" {
    for_each = module.template_files.files
    bucket       = aws_s3_bucket.bucket.id
    key          = each.key
    content_type = each.value.content_type
    source  = each.value.source_path
    content = each.value.content
    etag = each.value.digests.md5
}