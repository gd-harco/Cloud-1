# Variables
VENV_NAME = venv
PYTHON = python3
REQUIREMENTS_FILE = requirements.txt
BASH_CONFIG = openrc.sh

# Couleurs pour l'affichage
GREEN = \033[0;32m
YELLOW = \033[1;33m
NC = \033[0m # No Color

PACKAGES = openstackclient

.PHONY: all setup install clean help activate

# Cible par défaut
all: env

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
install: $(REQUIREMENTS_FILE)
	@echo "$(YELLOW)Installation des paquets...$(NC)"
	pipx install $(PACKAGES) --include-deps
	echo "$(GREEN)Paquets installés depuis $(REQUIREMENTS_FILE)$(NC)"


# Configuration complète
env: pipx install  
	@echo "$(GREEN)===========================================$(NC)"
	@echo "$(GREEN)Configuration de l'environnement terminée !$(NC)"
	@echo "$(GREEN)===========================================$(NC)"
