variable "enabled" {
  type        = bool
  default     = true
  description = "Variable indicating whether deployment is enabled."
}

variable "cluster_name" {
  type        = string
  description = "The name of the cluster"
}

variable "aws_region" {
  type        = string
  description = "AWS region where secrets are stored."
}

variable "cluster_identity_oidc_issuer" {
  type        = string
  description = "The OIDC Identity issuer for the cluster."
}

variable "cluster_identity_oidc_issuer_arn" {
  type        = string
  description = "The OIDC Identity issuer ARN for the cluster that can be used to associate IAM roles with a service account."
}

variable "service_account_name" {
  type        = string
  default     = "velero"
  description = "Velero service account name"
}

variable "create_bucket" {
  type        = bool
  default     = true
  description = "Create bucket to store or get the backups."
}

variable "bucket_name" {
  type        = string
  description = "Bucket name to store the backups."
}

variable "volume_snapshot_name" {
  type        = string
  default     = "velero-snapshot"
  description = "Variable indicating the snapshot name."
}

variable "helm_chart_name" {
  type        = string
  default     = "velero"
  description = "Velero Helm chart name to be installed"
}

variable "helm_chart_release_name" {
  type        = string
  default     = "velero"
  description = "Helm release name"
}

variable "helm_chart_version" {
  type        = string
  default     = "2.20.0"
  description = "Velero Helm chart version."
}

variable "helm_chart_repo" {
  type        = string
  default     = "https://vmware-tanzu.github.io/helm-charts"
  description = "Velero repository name."
}

variable "create_namespace" {
  type        = bool
  default     = true
  description = "Whether to create Kubernetes namespace with name defined by `namespace`."
}

variable "namespace" {
  type        = string
  default     = "velero"
  description = "Kubernetes namespace to deploy Velero Helm chart."
}

variable "mod_dependency" {
  default     = null
  description = "Dependence variable binds all AWS resources allocated by this module, dependent modules reference this variable."
}

variable "settings" {
  default     = {}
  description = "Additional settings which will be passed to the Helm chart values."
}