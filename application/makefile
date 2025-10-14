all: apply

apply: plan
	terraform apply
	ansible-inventory --list
	ansible-playbook install_docker.yml
	ansible-playbook setup_proxy.yml
	ansible-playbook copy_webapp.yml

plan: workspace
	terraform plan

workspace: init
	terraform workspace new inceptioning_mars || exit 0

init:
	terraform init

destroy:
	terraform destroy
