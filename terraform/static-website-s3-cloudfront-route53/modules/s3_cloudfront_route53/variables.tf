variable "domain" {
    type        = string
    description = "Creates a unique bucket name beginning with the specified prefix."
    default     = null
}

variable "tags" {
    type        = map
    description = "(Optional) A mapping of tags to assign to the bucket."
    default     = null
}

variable "acl" {
    type        = string
    description = "Public/Private"
    default     = "public-read"
}

variable "aws_region" {
    description = "The AWS region to use to create resources."
    default     = null
}

variable "aws_profile" {
    description = "The AWS region to use to create resources."
    default     = null
}

variable "aws_credentials" {
    description = "The AWS region to use to create resources."
    default     = null
}