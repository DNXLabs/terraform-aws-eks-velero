resource "aws_s3_bucket" "velero" {
  bucket = var.bucket_name
  acl    = "private"

  tags = {
    Name = "EKS Velero"
  }
}