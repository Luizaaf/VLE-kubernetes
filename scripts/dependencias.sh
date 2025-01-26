#!/bin/bash

sistema=$(cat /etc/os-release | awk -F= '/^ID=/ {print $2}')

if [ $sistema = 'ubuntu' ]; then
	echo "Atualizando repósitorio de pacotes"
	sudo apt update

	echo "Instalando python3 e python3-pip"
	apt install python3 python3-pip

	echo "Instalando unzip, para descompactação de arquivos."
	apt install -y unzip

	echo "Instalando o terraform."
	curl -s https://releases.hashicorp.com/terraform/1.10.4/terraform_1.10.4_linux_amd64.zip -o /tmp/terraform.zip
	unzip -o /tmp/terraform.zip -d /tmp
	sudo mv /tmp/terraform /usr/local/bin/

	echo "Instalando jq"
	apt install jq -y
	
	echo "Você irá utilizar AWS ou Azure:"
	read provider
	provider_lower=$(echo "$provider" | tr '[:upper:]' '[:lower:]'

	if [$provider_lower = 'aws']; then
		curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
		unzip awscliv2.zip
		./aws/install
	elif [$provider_lower = 'azure']; then
		curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
	fi
else
	echo "sistema não suportado!"
fi
