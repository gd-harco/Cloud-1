# Création d'une ressource de paire de clés SSH
resource "openstack_compute_keypair_v2" "test_keypair" {
  name       = "test_keypair"            # Nom de la clé SSH à utiliser pour la création
  public_key = file("~/.ssh/id_ed25519_ovh.pub") # Chemin vers votre clé SSH précédemment générée
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
