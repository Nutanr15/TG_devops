resource "aws_s3_bucket" "raw" {
  bucket        = var.raw_bucket_name
  force_destroy = true
}

resource "aws_s3_bucket" "processed" {
  bucket        = var.processed_bucket_name
  force_destroy = true
}
