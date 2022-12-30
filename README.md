# vpn-infra

This repository can be used for provisioning, commissioning, upgrading, and decommissioning VPN infrastructure.

## Prerequisites

  - [Terraform](https://www.terraform.io)

## Quick Start

  1. Change the current directory to either `aws` or `google` subdirectories.
      - Run `make terraform.tfvars` for setting Terraform variables.
      - Run `make config.*.tfbackend` for Terraform backend configurations.
  1. Change directory to `backend` project.
      - Run `make terraform.tfvars init apply`. 
  1. Change directory to `dns` project.
      - Run `make terraform.tfvars init apply`.
  1. Change directory to `server` project.
      - Run `make terraform.tfvars config.s3.tfbackend keys init apply`.
  1. *TBD*

## Client Applications

  - **iOS**
    - [Fair VPN](https://apps.apple.com/us/app/fair-vpn/id1533873488)
  - **Android**
    - [v2rayNG](https://play.google.com/store/apps/details?id=com.v2ray.ang)

## Documentation

### Configurations

The config file is located at `/usr/local/etc/v2ray/config.json`.
The supported format for config files are `json`, `yaml`, and `toml`.

### Server Operations

Here are some basic `v2ray` commands:

```bash
$ v2ray help                 # print command help
$ v2ray version              # print version number
$ v2ray uuid                 # generate a new uuid
$ v2ray test -config=<path>  # validate a config file
```

You can start the v2ray service with `/usr/local/etc/v2ray/config.json` as follows:

```bash
$ systemctl enable v2ray.service
$ systemctl start v2ray.service
```

You can check the v2ray service status and logs using the following commands:

```bash
$ systemctl status v2ray.service
$ journalctl -u v2ray.service
```

## Resources

  - **Project V**
    - [Website](https://www.v2fly.org/en_US)
      - [Installation](https://www.v2fly.org/en_US/guide/install.html)
      - [Novice Guide](https://www.v2fly.org/en_US/guide/start.html)
      - [V5 Configs](https://www.v2fly.org/en_US/v5/config/overview.html)
      - [V4 Configs](https://www.v2fly.org/en_US/config/overview.html)
    - **Repositories**
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
