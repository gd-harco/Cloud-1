install de terraform cli

terraform init -> commande pour initialiser un working directory terraform
https://developer.hashicorp.com/terraform/cli/commands/init

## install

clone du repository example
```sh
git clone https://github.com/hashicorp-education/learn-terraform-init
```

## terraform init
je fait un init -> il me propose de faire un plan pour regarder les changements qui serait fait

```sh
➜  learn-terraform-init git:(main) terraform init
Initializing the backend...
Initializing modules...
- ec2-instance in modules/aws-ec2-instance
Downloading registry.terraform.io/joatmon08/hello/random 4.0.0 for hello...
- hello in .terraform/modules/hello
Initializing provider plugins...
- Finding hashicorp/random versions matching "3.6.0"...
- Finding hashicorp/aws versions matching "6.2.0"...
- Installing hashicorp/random v3.6.0...
- Installed hashicorp/random v3.6.0 (signed by HashiCorp)
- Installing hashicorp/aws v6.2.0...
- Installed hashicorp/aws v6.2.0 (signed by HashiCorp)
Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

```sh
➜  learn-terraform-init git:(main) ✗ terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are
indicated with the following symbols:
  + create

Terraform planned the following actions, but then encountered a problem:

  # random_pet.instance will be created
  + resource "random_pet" "instance" {
      + id        = (known after apply)
      + length    = 2
      + separator = "-"
    }

  # module.hello.random_pet.number_2 will be created
  + resource "random_pet" "number_2" {
      + id        = (known after apply)
      + keepers   = {
          + "hello" = (known after apply)
        }
      + length    = 2
      + separator = "-"
    }

  # module.hello.random_pet.server will be created
  + resource "random_pet" "server" {
      + id        = (known after apply)
      + keepers   = {
          + "hello"      = "World"
          + "secret_key" = "secret"
        }
      + length    = 2
      + separator = "-"
    }

Plan: 3 to add, 0 to change, 0 to destroy.
╷
│ Error: No valid credential sources found
│ 
│   with provider["registry.terraform.io/hashicorp/aws"],
│   on main.tf line 4, in provider "aws":
│    4: provider "aws" {
│ 
│ Please see https://registry.terraform.io/providers/hashicorp/aws
│ for more information about providing credentials.
│ 
│ Error: failed to refresh cached credentials, no EC2 IMDS role found, operation error ec2imds:
│ GetMetadata, request canceled, context deadline exceeded
│ 
╵
```

Sachant que je n'ai pas mis de creds : c'est plutot normal

terraform init permet donc de lire les fichiers d'un directory et de lancer d'autre commande comme plan qui interagisse avec le provider.

## Recherche de providers
tuto:
 - https://developer.hashicorp.com/terraform/language/providers#providers
recherche
 - https://registry.terraform.io/providers/ovh/ovh/latest
ovh 
 - https://registry.terraform.io/providers/ovh/ovh/latest

### Definition

Le provider au sens de terraform est un plugin pour interagir avec un cloud provider, un saas (System as a service) ou une autre api.
(https://developer.hashicorp.com/terraform/language/providers#providers)

Chaque Cloud Providers ont un set different de type de ressource et de data managees par terraform.

### Se servir du provider ovh en terraform
tuto ovh
https://help.ovhcloud.com/csm/fr-public-cloud-compute-terraform?id=kb_article_view&sysparm_article=KB0050792
apparement il faut une connection horizon

#### Installation du client openstack
ovh est base sur la techno openstack pour son cloud client
installation de openstackclient

##### Creation d'un environement python
```bash
python3 -m venv env
source env/bin/activate
```
##### instalation du client python
```bash
pip install --upgrade pip
pip3 install python-openstackclient
```

A ce stade on peut se servir de openstack

```bash
(env) ➜  Cloud-1 git:(1-init-terraform-project) ✗ openstack
(openstack) exit
```

#### Recuperer une connection

##### Creation d'un user openstack
https://www.ovh.com/manager/#/public-cloud/pci/projects/412f360f6cce465fb1a77fb6fb46adf3/users/onboarding
la creation genere un mot de passe a save sur la session openstack en sourcant openrc.sh

##### utilisation dans openrc.sh
```sh
source openrc.sh
Please enter your OpenStack Password:
```

##### Verification que la connection est bonne
```sh
openstack project list
+----------------------------------+------------------+
| ID                               | Name             |
+----------------------------------+------------------+
| 412f360f6cce465fb1a77fb6fb46adf3 | 1702805673625800 |
+----------------------------------+------------------+
```

#### Inscription d'une cle ssh 
https://help.ovhcloud.com/csm/fr-public-cloud-compute-getting-started?id=kb_article_view&sysparm_article=KB0051011


#### Construction du provider.tf

NB : les fichiers .tf prenne les variables d'environement ce qui permet le passage de creds et de secrets
On va les mettre dans un workspace que l'on init avec terraform
```terraform
terraform workspace new <nom_d_application>
```


##### definition des sources

```terraform
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
```

##### definition des secrets

pour chaque provider il y a des secrets necessaires pour que terraform fasse son office
Pour les trouver cela se trouve dans la doc du provider:
 - Openstack : https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docshttps://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs
```terraform
provider "openstack" {
  user_name   = "admin"
  tenant_name = "admin"
  password    = "pwd"
  auth_url    = "http://myauthurl:5000/v3"
  region      = "RegionOne"
}
```
-> ils sont definit par openrc.sh
 - ovh       : https://registry.terraform.io/providers/ovh/ovh/latest/docs
```terraform
provider "ovh" {
  endpoint      = "ovh-eu"
  client_id     = "xxxxxxxxx"
  client_secret = "yyyyyyyyy"
}
```
-> ils sont a mettre dans l'environement
```sh
export OVH_ENDPOINT=ovh-eu \
    OVH_APPLICATION_KEY=<key> \
    OVH_APPLICATION_SECRET=<secret> \
    OVH_CONSUMER_KEY=<consumer_key> 
```

on peut init a partir de ce moment
```sh
./openrc.sh && export `cat ovh-api.env`
terraform init
```

##### definition de l'instance par openstack

```terraform
# Création d'une ressource de paire de clés SSH
resource "openstack_compute_keypair_v2" "test_keypair" {
  name       = "test_keypair"            # Nom de la clé SSH à utiliser pour la création
  public_key = file("~/.ssh/id_rsa.pub") # Chemin vers votre clé SSH précédemment générée
}

# Création d'une instance
resource "openstack_compute_instance_v2" "test_terraform_instance" {
  name        = "terraform_instance"    # Nom de l'instance
  image_name  = "Debian 10"             # Nom de l'image
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
```

##### application de la ressource
pour apply la ressource on va la plan puis l'apply (le plan va faire la difference, l'apply va appliquer la diff)
```sh
terraform plan && yes yes | terraform apply
```

