# vpn-infra

This repository can be used for provisioning, commissioning, upgrading, and decommissioning VPN infrastructure.

## Prerequisites

  - [Terraform](https://www.terraform.io)

## Quick Start

  1. Change the current directory to either `aws` or `google` subdirectories.
      - Run the `make terraform.tfvars` command.
      - Edit the generated `terraform.tfvars` file and fill in the variables.
  1. Run `make keys init validate` and ensure there is no error.
  1. Run `make plan` and then `make apply`.
  1. Wait until all resources are deployed.
  1. *TBD*

## Client Applications

  - **iOS**
    - [Fair VPN](https://apps.apple.com/us/app/fair-vpn/id1533873488)
  - **Android**
    - [v2rayNG](https://play.google.com/store/apps/details?id=com.v2ray.ang)

## Resources

  - **Project V**
    - [Website](https://www.v2fly.org/en_US)
    - [Installation](https://www.v2fly.org/en_US/guide/install.html)
    - [Novice Guide](https://www.v2fly.org/en_US/guide/start.html)
    - [Configurations](https://www.v2fly.org/en_US/v5/config/overview.html)
    - [Guide to V2Ray Configuration](https://guide.v2fly.org/en_US)
    - [v2ray-core](https://github.com/v2fly/v2ray-core)
    - [fhs-install-v2ray](https://github.com/v2fly/fhs-install-v2ray)
    - [v2ray-examples](https://github.com/v2fly/v2ray-examples)
  - **AWS**
    - [Regions and Availability Zones](https://aws.amazon.com/about-aws/global-infrastructure/regions_az)
    - [Amazon EC2 On-Demand Pricing](https://aws.amazon.com/ec2/pricing/on-demand)
  - **Google Cloud**
    - [Global Locations](https://cloud.google.com/about/locations)
    - [VM Instance Pricing](https://cloud.google.com/compute/vm-instance-pricing)
  - **DigitalOcean**
    - [Regional Availability Matrix](https://docs.digitalocean.com/products/platform/availability-matrix)
    - [Droplet Pricing](https://www.digitalocean.com/pricing/droplets)
