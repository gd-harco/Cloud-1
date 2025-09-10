# Variables
VENV_NAME = venv
PYTHON = python3
BASH_CONFIG = openrc.sh

# Couleurs pour l'affichage
GREEN = \033[0;32m
YELLOW = \033[1;33m
NC = \033[0m # No Color


PACKAGES = openstackclient 

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
	pip install --upgrade pyOpenSSL cryptography
	@echo "$(GREEN)Pip mis à jour$(NC)" 
	which pipx 


# Installe les paquets depuis requirements.txt
install:
	@echo "$(YELLOW)Installation du client openstack ...$(NC)"
	pipx install $(PACKAGES) --include-deps
	@echo "$(GREEN)Paquet installé$(NC)"

	@echo "$(YELLOW)Installation d'Ansible' ...$(NC)"
	pipx install ansible --include-deps
	@echo "$(GREEN)Paquet installé$(NC)"

	@echo "$(YELLOW)Installation des collection ansible terraform...$(NC)"
	ansible-galaxy collection install cloud.terraform
	@echo "$(GREEN)Collection installés$(NC)"

	@echo "$(YELLOW)Installation des roles ansible docker...$(NC)"
	ansible-galaxy role install geerlingguy.docker
	@echo "$(GREEN)Collection installés$(NC)"


# Configuration complète
env: pipx install  
	@echo "$(GREEN)===========================================$(NC)"
	@echo "$(GREEN)Configuration de l'environnement terminée !$(NC)"
	@echo "$(GREEN)===========================================$(NC)"

terraform:
	echo $$(echo creds.env | xargs) 
	env $$(cat creds.env | xargs)  make -C application

ansible:
	cd Ansible && ansible-playbook install_docker.yml
