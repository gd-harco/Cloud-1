# Définir les providers et fixer les versions
terraform {
required_version    = ">= 1.13.1"                    # Prend en compte les versions de terraform à partir de la 0.14.0
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = ">= 3.3.2"
    }

    ovh = {
      source  = "ovh/ovh"
      version = ">= 2.7.0"
    }
  }
}

# Configure le fournisseur OpenStack hébergé par OVHcloud
provider "openstack" {
  auth_url    = "https://auth.cloud.ovh.net/v3/"    # URL d'authentification
  domain_name = "default"                           # Nom de domaine - Toujours à "default" pour OVHcloud
  alias       = "ovh"                               # Un alias
}
