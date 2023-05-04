terraform {
  required_providers {
    vault = {
      source = "registry.terraform.io/hashicorp/vault"
      # renovate: datasource=github-releases depName=hashicorp/terraform-provider-vault versioning=loose extractVersion=^v?(?<version>.*)$
      version = "3.15.2"
    }
  }
}
