# Création d'une ressource de paire de clés SSH
resource "openstack_compute_keypair_v2" "test_keypair" {
  name       = "test_keypair"            # Nom de la clé SSH à utiliser pour la création
  public_key = file("~/.ssh/id_ed25519.pub") # Chemin vers votre clé SSH précédemment générée
}

# Création d'une instance
resource "openstack_compute_instance_v2" "test_terraform_instance" {
  name        = "terraform_instance"    # Nom de l'instance
  image_name  = "Debian 13"             # Nom de l'image
  flavor_name = "d2-2"                  # Nom du type d'instance
  # Nom de la ressource openstack_compute_keypair_v2 nommée test_keypair
  key_pair    = openstack_compute_keypair_v2.test_keypair.name
  network {
    name      = "Ext-Net" # Ajoute le composant réseau pour atteindre votre instance
  }
    lifecycle {
    # OVHcloud met régulièrement à jour l’image de base d’un OS donné afin que le client ait moins de paquets à mettre à jour après le lancement d’une nouvelle instance
    # Pour éviter que terraform ne rencontre des problèmes avec cela, la commande ignore_changes suivante est requise.
    ignore_changes = [
      image_name
    ]
  }
}

resource "ansible_group" "ovh" {
  name = "ovh"
}

resource "ansible_host" "server1" {
  name = openstack_compute_instance_v2.test_terraform_instance.id
  groups = [ansible_group.ovh.name]
  variables = {
    ansible_host                 = openstack_compute_instance_v2.test_terraform_instance.access_ip_v4
    ansible_user                 = "debian"
    ansible_ssh_private_key_file = "/Users/srt20/Projets/outscale/labs/terraform/lab01/my_key.pem"
  }
}

resource "ovh_domain_zone_record" "ft-server-cloud-1" {
  zone      = "ft-server.fr"
  subdomain = "cloud-1"
  fieldtype = "A"
  ttl       = 300
  target    = openstack_compute_instance_v2.test_terraform_instance.access_ip_v4
} 
