terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
      version = "2.2.0"
    }
    rancher2 = {
      source = "rancher/rancher2"
      version = "1.16.0"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "rancher2" {
  alias = "bootstrap"

  api_url   = format("https://%s", "${var.rancher_uri}")
  insecure  = true
  bootstrap = true
}

provider "rancher2" {
  alias = "admin"

  api_url = rancher2_bootstrap.admin.url
  token_key = rancher2_bootstrap.admin.token
  insecure = true
}

resource "rancher2_bootstrap" "admin" {
  provider = rancher2.bootstrap

  password = "${var.rancher_password}"

  /*
  current_password = "${var.rancher_password}"
  */

  telemetry = true
}
