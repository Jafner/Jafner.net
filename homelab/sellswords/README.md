# Sellswords
This directory contains Terraform code and documentation for external service providers. 

### Recovering from lost TF state

- Run [`cf-terraforming_import.sh`](./cloudflare/cf-terraforming_import.sh) to generate two important artifacts per Zone: 
  - List of `cf-terraforming import` commands, one for each record.
  - A `$ZONE.import.tf` configuration file with all imported records.
- When that's done, the state file should have all configured records, but with unreadable names like `terraform_managed_resource_werpwepigfnwgpowb`. 
- Delete the generated `$ZONE.import.tf` files.
- Run a `terraform init && terraform plan` and *read the diff.*
  - The destroyed and created resources should match 1:1, other than perhaps drift of A-records controlled by dynamic DNS. 
  - If any records differ (other than the above), reconcile those differences before proceeding. Add those records (with human-readable names) to the appropriate zone configuration.
- Run `terraform apply`. 