resource "aws_s3_bucket" "velero" {
  count = (var.enabled && var.create_bucket) ? 1 : 0

  bucket = var.bucket_name
  acl    = "private"

  tags = {
    Name = "EKS Velero"
  }
}
