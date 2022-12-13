# https://developer.hashicorp.com/terraform/language/values/locals
locals {
  # https://en.wikipedia.org/wiki/Classful_network
  # https://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing
  network_cidrs = {
    af-south-1     = "10.10.0.0/16"
    ap-east-1      = "10.11.0.0/16"
    ap-northeast-1 = "10.12.0.0/16"
    ap-northeast-2 = "10.13.0.0/16"
    ap-northeast-3 = "10.14.0.0/16"
    ap-south-1     = "10.15.0.0/16"
    ap-south-2     = "10.16.0.0/16"
    ap-southeast-1 = "10.17.0.0/16"
    ap-southeast-2 = "10.18.0.0/16"
    ap-southeast-3 = "10.19.0.0/16"
    ca-central-1   = "10.20.0.0/16"
    eu-central-1   = "10.21.0.0/16"
    eu-central-2   = "10.22.0.0/16"
    eu-north-1     = "10.23.0.0/16"
    eu-south-1     = "10.24.0.0/16"
    eu-south-2     = "10.25.0.0/16"
    eu-west-1      = "10.26.0.0/16"
    eu-west-2      = "10.27.0.0/16"
    eu-west-3      = "10.28.0.0/16"
    me-central-1   = "10.29.0.0/16"
    me-south-1     = "10.30.0.0/16"
    sa-east-1      = "10.31.0.0/16"
    us-east-1      = "10.32.0.0/16"
    us-east-2      = "10.33.0.0/16"
    us-west-1      = "10.34.0.0/16"
    us-west-2      = "10.35.0.0/16"
  }
}
