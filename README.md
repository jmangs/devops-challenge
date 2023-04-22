# OCI DevOps Challenge

## Instructions

To deploy the compute, you will need to update `terraform/variables.tf` with your tenancy, root compartment, and user IDs as well as your
SSH private key path and fingerprint for the provider. Once you've done that, deploying the compute is done as follows:

````
cd terraform/
terraform init
terraform apply
````

Feel free to check the plan output first with `terraform plan` as needed.