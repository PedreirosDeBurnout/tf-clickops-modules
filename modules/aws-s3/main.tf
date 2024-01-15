resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name

  tags     = var.tags
  tags_all = var.tags
}
