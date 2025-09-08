# Note Ansible

## Inventaire Statique ou Dynamique
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

