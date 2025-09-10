all: apply

apply: plan
	terraform apply

plan: workspace
	terraform plan

workspace: init
	terraform workspace new inceptioning_mars || exit 0

init:
	terraform init

