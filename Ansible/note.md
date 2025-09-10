# Note Ansible

## Ansible.cfg
fihier au format `ini`, point central de la config Ansible. FIchier organise comme ceci :
```
[Section]
cle = valeur
```
Le fichier peut etre dans trois localisation, avec en ordre de priorite :

1.  Repertoire courant
2.  Repertoire Home de l'utilisateur
3.  Fichier global du system `/etc/ansible/ansible.cfg`

La variable d'environnement `ANSIBLE_CONFIG` peut aussi etre exporte pour bypass la hierearchie

on peut en genere un complet avec la commande 
```
ansible-config init > ansible.cfg #genere un fichier complet
ansible-config init --disabled > ansible.cfg #genere un fichier avec toute les options commente out.
```

voir le fichier [config d'exemple](./example.cfg)

## Inventaire Statique/Dynamique
Les inventaires Ansible sont essentiels pour cataloguer et gérer les serveurs, les ordinateurs et d’autres équipements informatiques ciblés par les scripts automatisations. [...] Si une nouvelle machine est ajoutée à votre infrastructure, vous devez éditer le fichier **à la main** pour l’y inclure. [Source](https://blog.stephane-robert.info/docs/infra-as-code/gestion-de-configuration/ansible/inventaires-statiques/)

### Inventaire Statique
Fichier dans lequel les hotes sont defini manuellement. Methode facile car aucune dependance externe.

Contenue dans un fichier `INI` ou `YAML`, reference ensuite dans le fichier `ansible.cfg`.

Voire le fichier [inventaire d'exemple](./Inventory/exemple-inventory.yml)

On peut ensuite executer un playbook avec un inventaire specifique :
```
ansible-playbook -i <chemin vers l'inventaire> <chemin vers le playbook>
```

Ou afficher le contenu d'un inventaire :
```
ansible-inventory -i <chemin vers l'inventaire> --list -y 
```

### Variable d'inventaire 
Il est possible de structurer les variables Ansible hors des fichiers d’inventaire, en utilisant les dossiers `group_vars/` et `host_vars/`. Ces répertoires permettent de gérer les paramètres de manière plus claire et modulaire, particulièrement dans les projets Ansible organisés.
Ansible recherche automatiquement ces répertoires à côté du fichier d’inventaire.

Pour appliquer des variables à un groupe entier, créez un fichier YAML dans `group_vars/` portant le nom exact du groupe.

Pour un host specifique, meme chose mais dans le dossier `hosts_vars/`

### Priorité des variables

Ansible applique une hiérarchie stricte entre les sources de variables. Voici les principales (du plus faible au plus fort) :
- role/defaults
- group_vars/ puis host_vars/
- Variables définies dans le playbook (vars)
- Variables enregistrées via set_fact
- Variables passées en ligne de commande (-e)



## Playbook

Fichier YAML detaillant le taff a faire sur la machine distante
```yaml
---
- name: Commentaire du premier play
  hosts: webservers
  tasks:
    - name: Installer Apache
      ansible.builtin.apt:
        name: apache2
        state: present
```
Chaque play est composé de plusieurs éléments clés :

-    name : Un nom descriptif pour le play, qui permet de comprendre son but.
-    hosts : Spécifie les hôtes sur lesquels le play sera exécuté. Cela peut être un groupe d’hôtes défini dans l’inventaire ou un hôte spécifique.
-    tasks : Une liste de tâches à exécuter sur les hôtes spécifiés. Chaque tâche est définie par un nom et un module Ansible à utiliser.

Les modules sont comme des objets en CPP, ils permettent d'interagir sur des aspects du systeme. example de module :

-    Installer ou supprimer des paquets (comme dans l’exemple avec le module apt).
-    Gérer des services (service).
-    Gérer des fichiers ou des répertoires (file).
-    Exécuter des commandes (command, shell) en dernier recours quand les modules n’existent pas.

## Handler
Un Handler est une tache specifique qui ne va se'executer que lorsqu'il est appele par une task termine. on ajoute pour cela la cle `notify: <nom du handler>` a la task. 

Les Handlers s'effectue toujours apres les tasks. ainsi, si un handler est appele par plusieur task, il ne s'exectutera qu'une fois

Un handler peut posseder la cle `listen`, cela permet de grouper plusieur handler entre eux et d'en appeler plusieurs avec un seul `notify`

## Roles
https://www.redhat.com/en/topics/automation/what-is-an-ansible-role#overview

https://galaxy.ansible.com/ui/standalone/roles/geerlingguy/docker/install/