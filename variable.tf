variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
  default     = "terraform-test-bucket-mum1"
}

variable "access_logging_bucket_name" {
  description = "S3 bucket name for access logging storage"
  type        = string
  default     = "my-access-logging-bucket-name"
}