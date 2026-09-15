# Terraform AWS Web Server

## Description

Terraform configuration that creates a simple AWS web server:

* EC2 instance running Amazon Linux 2
* Security Group allowing HTTP (80) and SSH (22)
* Apache web server installed using `user_data`

## Commands

```bash
terraform init
terraform validate
terraform fmt
terraform plan
terraform apply
terraform output
terraform show
```

To remove the infrastructure:

```bash
terraform destroy
```

## Outputs

```text
instance_id
instance_public_ip
instance_public_dns
website_url
```

The website is available through the `website_url` output after `terraform apply`.
