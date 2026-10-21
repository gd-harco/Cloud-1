# Cloud-1 — Déploiement automatisé d’une application web

Projet réalisé dans le cadre du cursus **42** pour découvrir le cloud et l’Infrastructure as Code. Il automatise le provisionnement d’une machine virtuelle sur **OVHcloud** (API OpenStack), puis le déploiement d’une application WordPress conteneurisée avec **Terraform**, **Ansible** et **Docker Compose**.

## Ce que démontre ce projet

- **Infrastructure as Code** : création d’une instance cloud, gestion d’une paire de clés SSH et configuration d’un enregistrement DNS avec Terraform.
- **Automatisation de configuration** : inventaire Terraform dynamique et playbooks Ansible pour préparer le serveur et déployer les services.
- **Conteneurisation** : orchestration de WordPress, MySQL et WP-CLI avec Docker Compose et stockage persistant.
- **Réseau et exposition web** : réseau Docker dédié, routage par nom de domaine via Traefik et redirection HTTP vers HTTPS.
- **Automatisation reproductible** : Makefiles pour enchaîner l’initialisation, le plan Terraform et les étapes de déploiement.
- **Gestion des environnements** : utilisation de variables d’environnement pour les identifiants cloud et les paramètres de l’application.

Ces compétences sont directement mobilisables sur des missions junior en **cloud**, **DevOps**, **administration système** et **automatisation d’infrastructure**.

## Architecture

```text
Poste d’administration
  ├── Terraform ──> Instance Debian sur OVHcloud / OpenStack
  │                  ├── Enregistrement DNS OVH
  │                  └── Inventaire Ansible dynamique
  └── Ansible ───> Docker
                     ├── Traefik (reverse proxy, ports 80/443)
                     └── WordPress + WP-CLI ──> MySQL
                          Volumes persistants sur l’instance
```

Le proxy route les requêtes vers WordPress selon le nom d’hôte. Les données WordPress et MySQL sont conservées dans des volumes liés à des répertoires de l’instance.

## Technologies

| Domaine | Outils |
| --- | --- |
| Cloud et infrastructure | OVHcloud, OpenStack, Terraform |
| Configuration et automatisation | Ansible, inventaire Terraform, Make |
| Conteneurs | Docker, Docker Compose |
| Réseau web | Traefik, DNS, TLS |
| Application | WordPress, MySQL, WP-CLI |

## Prérequis

- Un compte OVHcloud avec accès aux API **OpenStack** et **OVH** et les droits nécessaires pour créer une instance et modifier une zone DNS.
- Terraform CLI (version minimale déclarée dans `application/provider.tf`).
- Python, `pipx`, le client OpenStack et Ansible.
- Les collections Ansible `cloud.terraform`, `community.docker` et `community.crypto`, ainsi que le rôle `geerlingguy.docker`.
- Une paire de clés SSH utilisable pour se connecter à l’instance.
- Un nom de domaine et une zone DNS que vous êtes autorisé à gérer.

Depuis la racine du dépôt, `make env` installe ou vérifie une partie des outils et dépendances Ansible prévus par le Makefile. Installez également les collections `community.docker` et `community.crypto` si elles ne sont pas déjà présentes.

## Configuration

1. Créez le fichier local de variables cloud à partir du modèle :

   ```sh
   cp creds.env.template creds.env
   ```

   Renseignez les identifiants OpenStack et OVH correspondant à votre compte. `creds.env` est ignoré par Git : ne le publiez pas et ne transmettez pas vos clés API.

2. Dans `application/instance.tf`, adaptez les chemins de la clé SSH publique et de la clé privée Ansible à votre machine. Le fichier contient actuellement un chemin local codé en dur pour la clé privée ; utilisez le chemin absolu de votre propre clé. Vérifiez également l’image, la région, la taille de l’instance, le nom de la zone DNS et le sous-domaine selon votre environnement.

3. Créez le fichier de configuration WordPress local :

   ```sh
   cp application/webapp/.env.dummy application/webapp/.env
   ```

   Remplacez toutes les valeurs d’exemple, en particulier les mots de passe WordPress et MySQL, et vérifiez l’URL ainsi que le nom de domaine. Ne réutilisez pas des identifiants d’exemple pour un déploiement accessible sur Internet.

## Déploiement et suppression

Depuis la racine du dépôt :

```sh
make terraform
```

Cette commande lance Terraform, puis les playbooks Ansible qui installent Docker, déploient Traefik et démarrent l’application. Examinez le plan Terraform et les ressources ciblées avant de confirmer toute création ou modification.

Pour supprimer les ressources gérées par Terraform :

```sh
make destroy
```

La suppression de l’instance peut entraîner la perte des données qui y sont stockées. Sauvegardez-les au préalable si nécessaire.

## Sécurité et limites

- Le certificat TLS généré par le playbook est **auto-signé** : les navigateurs afficheront un avertissement. Ce déploiement est un exercice pédagogique, pas une configuration prête pour la production.
- Les clés API, mots de passe et clés privées doivent rester hors du dépôt. Les fichiers `creds.env` et `application/webapp/.env` sont des fichiers locaux sensibles.
- Les ressources et chemins présents dans la configuration sont spécifiques à l’environnement d’origine et doivent être adaptés avant utilisation.
- Les images Docker ne constituent pas, à elles seules, une stratégie de mise à jour ou de durcissement de production.
