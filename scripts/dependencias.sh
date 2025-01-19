#!/bin/bash

sistema=$(cat /etc/os-release | awk -F= '/^ID=/ {print $2}')

if [ $sistema = 'fedora' ]; then

	echo "Instalando dependências necessárias..."
	sudo dnf install python3 python3-pip azure-cli jq -y > /dev/null 2>&1
	echo "Dependências instaladas com sucesso!"

	echo "Instalando bibliotecas Python..."
	pip3 install boto3 botocore ansible awscli > /dev/null 2>&1
	echo "Bibliotecas Python instaladas com sucesso!"

	echo "Baixando o Terraform..."
	curl -s https://releases.hashicorp.com/terraform/1.10.4/terraform_1.10.4_linux_amd64.zip -o /tmp/terraform.zip
	echo "Descompactando o Terraform..."
	unzip -o /tmp/terraform.zip -d /tmp > /dev/null 2>&1
	echo "Movendo o Terraform para /usr/bin/..."
	sudo mv /tmp/terraform /usr/bin/
	echo "Terraform instalado com sucesso!"

	echo "Tudo pronto! Você está pronto para usar as ferramentas instaladas."

elif [ $sistema = 'ubuntu' ]; then
	sudo apt-get update
	sudo apt-get install python3 python3-pip jq -y
	pip3 install boto3 botocore ansible awscli azure-cli
	curl https://releases.hashicorp.com/terraform/1.10.4/terraform_1.10.4_linux_amd64.zip -o /tmp/terraform.zip
	unzip /tmp/terraform.zip
	mv /tmp/terraform /usr/bin/
else
	echo "sistema não suportado!"
fi
