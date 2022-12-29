# backend

This project creates a S3 bucket for storing state data files for the rest of Terraform projects.

## Quick Start

```
$ make terraform.tfvars
$ make init apply
```

**KEEP THE `terraform.tfstate` FILE FOR THIS PROJECT.**

## Resources

  - **Terraform**
    - [State](https://developer.hashicorp.com/terraform/language/state)
    - [Backend Configuration](https://developer.hashicorp.com/terraform/language/settings/backends/configuration)
      - [S3 Backend](https://developer.hashicorp.com/terraform/language/settings/backends/s3)
