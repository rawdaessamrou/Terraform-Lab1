# Terraform Lab 1 — AWS VPC with Bastion & App Server

A Terraform lab that provisions a secure AWS environment with a public/private subnet architecture, a bastion host for SSH access, and a private application server.

## Architecture

```
Internet → Internet Gateway → Public Subnet → Bastion Host (EC2)
                                                    │ SSH
                                              Private Subnet → App Server (EC2, port 3000)
```

## Files

| File | Description |
|------|-------------|
| `provider.tf` | AWS provider config (us-east-1, hashicorp/aws ~> 5.0) |
| `network.tf` | VPC, public/private subnets, internet gateway, route tables |
| `Compute.tf` | Security groups and EC2 instances (bastion + app server) |

## Usage

```bash
terraform init
terraform plan
terraform apply
terraform destroy  # when done
```

## Prerequisites

- Terraform >= 1.0
- AWS account with IAM permissions and credentials configured

## Notes

- Bastion host allows SSH from `0.0.0.0/0` — restrict to your IP in production.
- App server is VPC-internal only (ports 22 & 3000).
- No SSH key pair is set — add `key_name` to EC2 resources before use.
