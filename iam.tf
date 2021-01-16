# Policy
data "aws_iam_policy_document" "kubernetes_velero" {
  count = var.enabled ? 1 : 0

  statement {
    actions = [
      "ec2:DescribeVolumes",
      "ec2:DescribeSnapshots",
      "ec2:CreateTags",
      "ec2:CreateVolume",
      "ec2:CreateSnapshot",
      "ec2:DeleteSnapshot"
    ]
    resources = [
      "*",
    ]
    effect = "Allow"
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:PutObject",
      "s3:AbortMultipartUpload",
      "s3:ListMultipartUploadParts"
    ]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.velero.id}/*"
    ]
    effect = "Allow"
  }

  statement {
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.velero.id}"
    ]
    effect = "Allow"
  }

}

resource "aws_iam_policy" "kubernetes_velero" {
  depends_on  = [var.mod_dependency]
  count       = var.enabled ? 1 : 0
  name        = "${var.cluster_name}-velero"
  path        = "/"
  description = "Policy for velero service"

  policy = data.aws_iam_policy_document.kubernetes_velero[0].json
}

# Role
data "aws_iam_policy_document" "kubernetes_velero_assume" {
  count = var.enabled ? 1 : 0

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.cluster_identity_oidc_issuer_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.cluster_identity_oidc_issuer, "https://", "")}:sub"

      values = [
        "system:serviceaccount:${var.namespace}:${var.service_account_name}",
      ]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role" "kubernetes_velero" {
  count              = var.enabled ? 1 : 0
  name               = "${var.cluster_name}-velero"
  assume_role_policy = data.aws_iam_policy_document.kubernetes_velero_assume[0].json
}

resource "aws_iam_role_policy_attachment" "kubernetes_velero" {
  count      = var.enabled ? 1 : 0
  role       = aws_iam_role.kubernetes_velero[0].name
  policy_arn = aws_iam_policy.kubernetes_velero[0].arn
}