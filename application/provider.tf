# Définir les providers et fixer les versions
terraform {
required_version    = ">= 1.13.1"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = ">= 3.3.2"
    }
    ansible = {
      version = "~> 1.3.0"
      source = "ansible/ansible"
    }
    ovh = {
      version = "2.7.0"
      source = "ovh/ovh"
    }
  }
}
