# Variables
VENV_NAME = venv
PYTHON = python3
BASH_CONFIG = openrc.sh

# Couleurs pour l'affichage
GREEN = \033[0;32m
YELLOW = \033[1;33m
NC = \033[0m # No Color


PACKAGES = openstackclient

.env=

.PHONY: all setup install clean help activate

# Cible par défaut
all: env terraform docker

# Crée l'environnement virtuel
# Met à jour pip dans l'environnement virtuel

pipx: 
	@echo "$(YELLOW)Mise à jour de pip...$(NC)"
	pip install --upgrade pip
	@echo "$(GREEN)Pip mis à jour$(NC)"
	@echo "$(YELLOW)Installation de pipx$(NC)" 
	pip install pipx 
	@echo "$(GREEN)Pip mis à jour$(NC)" 
	which pipx 


# Installe les paquets depuis requirements.txt
install:
	@echo "$(YELLOW)Installation des paquets...$(NC)"
	pipx install $(PACKAGES) --include-deps
	echo "$(GREEN)Paquets installés depuis $(NC)"


# Configuration complète
env: pipx install  
	@echo "$(GREEN)===========================================$(NC)"
	@echo "$(GREEN)Configuration de l'environnement terminée !$(NC)"
	@echo "$(GREEN)===========================================$(NC)"

terraform:
	echo $$(echo creds.env | xargs) 
	env $$(cat creds.env | xargs)  make -C application

docker:
	ansible-playbook .Ansible/install_docker.yml