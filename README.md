# Cloud-1

Deploiement automatise d'Inception sur une instance de Cloud-Provider

## Installation

### Terraform CLI
L'installation de terraform cli: 
 - https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli


### Ansible
#### Distro Debian-based

[source](https://blog.stephane-robert.info/docs/infra-as-code/gestion-de-configuration/ansible/#comment-installer-ansible)

Installation via `pipx` conseille

Installer pip :
```
$ sudo apt update
$ sudo apt install pipx
$ pipx ensurepath
$ sudo pipx ensurepath --global # optional to allow pipx actions with --global argument 
```

Installation d'Ansible via pipx :

```
$ pipx install --include-deps ansible
``` 

Test de l'instalation : 
```
$ ansible all -i "localhost," -c local -m shell -a 'echo Salut B0B'
```

Sortie attendu :
```
localhost | success | rc=0 >>
salut B0B
```
