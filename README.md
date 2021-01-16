# terraform-aws-eks-velero

[![Lint Status](https://github.com/DNXLabs/terraform-aws-eks-velero/workflows/Lint/badge.svg)](https://github.com/DNXLabs/terraform-aws-eks-velero/actions)
[![LICENSE](https://img.shields.io/github/license/DNXLabs/terraform-aws-eks-velero)](https://github.com/DNXLabs/terraform-aws-eks-velero/blob/master/LICENSE)


Terraform module for deploying Kubernetes [Velero](https://github.com/vmware-tanzu/velero) inside a pre-existing EKS cluster. Velero (formerly Heptio Ark) is an open source tool to safely backup and restore, perform disaster recovery, and migrate Kubernetes cluster resources and persistent volumes.

## Usage

```
module "velero" {
  source = "git::https://github.com/DNXLabs/terraform-aws-eks-velero.git"

  enabled = true

  cluster_name                     = module.eks_cluster.cluster_id
  cluster_identity_oidc_issuer     = module.eks_cluster.cluster_oidc_issuer_url
  cluster_identity_oidc_issuer_arn = module.eks_cluster.oidc_provider_arn
  aws_region                       = data.aws_region.current.name
  bucket_name                      = ""
}
```

#### Step 1: Deploy and customize App on the source cluster

In this example we will be using wordpress, follow the steps below:

- Add the Bitnami chart repository to Helm:

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
```

- Modify your context to reflect the source cluster. Deploy WordPress on the source cluster and make it available at a public load balancer IP address. Replace the PASSWORD placeholder with a password for your WordPress dashboard.
```
helm install wordpress bitnami/wordpress --set service.type=LoadBalancer --set wordpressPassword=PASSWORD
```

- Wait for the deployment to complete and then use the command below to obtain the load balancer IP address:
```bash
kubectl get svc --namespace default wordpress --template "{{ range (index .status.loadBalancer.ingress 0) }}{{.}}
```

#### Step 2: Backup the deployment on the source cluster

Once Velero is running, create a backup of the WordPress deployment:
```bash
velero backup create wpb --selector release=wordpress
```

Execute the command below to view the contents of the backup and confirm that it contains all the required resources:
```bash
velero backup describe wpb  --details
```

At this point, your backup is ready. You can repeat this step every time you wish to have a manual backup, or you can configure a [schedule for automatic backups](https://velero.io/docs/master/how-velero-works/).

#### Step 3: Restore the deployment on the destination cluster

Once your backup is complete and confirmed, you can now turn your attention to restoring it. Note that this may take a few minutes to complete.
```bash
velero restore create --from-backup wpb
```

Wait until the backed-up resources are fully deployed and active. Use the kubectl get pods and kubectl get svc commands to track the status of the pods and service endpoint. Once the deployment has been restored, browse to the load balancer IP address and confirm that you see the same post content as that on the source cluster.

<!--- BEGIN_TF_DOCS --->

<!--- END_TF_DOCS --->

## Authors

Module managed by [DNX Solutions](https://github.com/DNXLabs).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/DNXLabs/terraform-aws-eks-velero/blob/master/LICENSE) for full details.
