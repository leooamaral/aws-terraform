# Terraform and AWS - Provisioning instances, subnets and aws other components using Terraform

## How to use it

- Change the path in `variables.tf` that you want to save your key
- Pass access and secret key in `main.tf` or use another type of connection from Terraform to AWS
- Make sure that Terraform is installed
- Steps to provision:
  1. `terraform init`
  2. `terraform plan`
  3. `terraform validate`
  4. `terraform apply`
- If you want to destroy: `terraform destroy`
