VENV_NAME = venv
PYTHON = python3
# Couleurs pour l'affichage
GREEN = \033[0;32m
YELLOW = \033[1;33m
RED = \033[0;31m
NC = \033[0m # No Color
PACKAGES = openstackclient 

.PHONY: all setup install clean help activate

# Cible par défaut
all: env terraform

# Crée l'environnement virtuel et met à jour pip
pipx: 
	@echo "$(YELLOW)Vérification de pip...$(NC)"
	@pip show pip >/dev/null 2>&1 && echo "$(GREEN)✓ pip déjà installé$(NC)" || (echo "$(YELLOW)Mise à jour de pip...$(NC)" && pip install --upgrade pip && echo "$(GREEN)Pip mis à jour$(NC)")
	@echo "$(YELLOW)Vérification de pipx...$(NC)"
	@command -v pipx >/dev/null 2>&1 && echo "$(GREEN)✓ pipx déjà installé$(NC)" || (echo "$(YELLOW)Installation de pipx$(NC)" && pip install pipx && echo "$(GREEN)pipx installé$(NC)")
	@echo "$(YELLOW)Vérification des dépendances crypto...$(NC)"
	@$(PYTHON) -c "import OpenSSL" 2>/dev/null && echo "$(GREEN)✓ pyOpenSSL déjà installé$(NC)" || (echo "$(YELLOW)Installation de pyOpenSSL...$(NC)" && pip install --upgrade pyOpenSSL cryptography && echo "$(GREEN)Dépendances crypto mises à jour$(NC)")
	@which pipx

# Installe les paquets depuis requirements.txt
install:
	@echo "$(YELLOW)Vérification du client openstack...$(NC)"
	@pipx list 2>/dev/null | grep -q "$(PACKAGES)" && echo "$(GREEN)✓ $(PACKAGES) déjà installé$(NC)" || (echo "$(YELLOW)Installation du client openstack...$(NC)" && pipx install $(PACKAGES) --include-deps && echo "$(GREEN)$(PACKAGES) installé$(NC)")
	@echo "$(YELLOW)Vérification d'Ansible...$(NC)"
	@pipx list 2>/dev/null | grep -q "ansible" && echo "$(GREEN)✓ ansible déjà installé$(NC)" || (echo "$(YELLOW)Installation d'Ansible...$(NC)" && pipx install ansible --include-deps && echo "$(GREEN)ansible installé$(NC)")
	@echo "$(YELLOW)Vérification des collections ansible terraform...$(NC)"
	@ansible-galaxy collection list | grep -q "cloud.terraform" 2>/dev/null && echo "$(GREEN)✓ cloud.terraform déjà installé$(NC)" || (echo "$(YELLOW)Installation des collections ansible terraform...$(NC)" && ansible-galaxy collection install cloud.terraform && echo "$(GREEN)Collection cloud.terraform installée$(NC)")
	@echo "$(YELLOW)Vérification des roles ansible docker...$(NC)"
	@ansible-galaxy role list | grep -q "geerlingguy.docker" 2>/dev/null && echo "$(GREEN)✓ geerlingguy.docker déjà installé$(NC)" || (echo "$(YELLOW)Installation des roles ansible docker...$(NC)" && ansible-galaxy role install geerlingguy.docker && echo "$(GREEN)Role geerlingguy.docker installé$(NC)")

# Configuration complète
env: pipx install  
	@echo "$(GREEN)===========================================$(NC)"
	@echo "$(GREEN)Configuration de l'environnement terminée !$(NC)"
	@echo "$(GREEN)===========================================$(NC)"

# Vérifier l'état des installations
status:
	@echo "$(GREEN)📋 État des installations :$(NC)"
	@echo "Pip :"
	@pip show pip >/dev/null 2>&1 && echo "  $(GREEN)✅ pip$(NC)" || echo "  $(RED)❌ pip$(NC)"
	@echo "Pipx :"
	@command -v pipx >/dev/null 2>&1 && echo "  $(GREEN)✅ pipx$(NC)" || echo "  $(RED)❌ pipx$(NC)"
	@echo "Packages pipx :"
	@pipx list 2>/dev/null | grep -q "$(PACKAGES)" && echo "  $(GREEN)✅ $(PACKAGES)$(NC)" || echo "  $(RED)❌ $(PACKAGES)$(NC)"
	@pipx list 2>/dev/null | grep -q "ansible" && echo "  $(GREEN)✅ ansible$(NC)" || echo "  $(RED)❌ ansible$(NC)"
	@echo "Collections/Roles Ansible :"
	@ansible-galaxy collection list 2>/dev/null | grep -q "cloud.terraform" && echo "  $(GREEN)✅ cloud.terraform$(NC)" || echo "  $(RED)❌ cloud.terraform$(NC)"
	@ansible-galaxy role list 2>/dev/null | grep -q "geerlingguy.docker" && echo "  $(GREEN)✅ geerlingguy.docker$(NC)" || echo "  $(RED)❌ geerlingguy.docker$(NC)"

terraform:
	echo $$(echo creds.env | xargs) 
	env $$(cat creds.env | xargs)  make -C application

# Aide
help:
	@echo "$(GREEN)Commandes disponibles :$(NC)"
	@echo "  make all      - Configuration complète"
	@echo "  make pipx     - Installation/vérification de pipx"
	@echo "  make install  - Installation/vérification des packages"
	@echo "  make env      - Configuration de l'environnement"
	@echo "  make status   - Vérifier l'état des installations"
	@echo "  make terraform- Exécuter terraform"
	@echo "  make ansible  - Exécuter ansible"
	@echo "  make help     - Afficher cette aide"
