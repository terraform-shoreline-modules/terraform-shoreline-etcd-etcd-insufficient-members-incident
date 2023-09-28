terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "etcd_insufficient_members_incident" {
  source    = "./modules/etcd_insufficient_members_incident"

  providers = {
    shoreline = shoreline
  }
}