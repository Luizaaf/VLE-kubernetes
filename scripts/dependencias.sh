#!/bin/bash

sistema=$(cat /etc/os-release | awk -F= '/^ID=/ {print $2}' | tr -d '"')

if [ $sistema = 'ubuntu' ]; then
	echo "==> Atualizando repósitorio de pacotes"
	sudo apt-get update >/dev/null 

	echo "==> Instalando python3 e python3-pip"
	sudo apt-get install python3 python3-pip -y >/dev/null 

	echo "==> Instalando unzip, para descompactação de arquivos."
	sudo apt-get install -y unzip >/dev/null 

	echo "==> Instalando Ansible"
	sudo apt-get install ansible -y

	echo "==> Instalando o terraform."
	curl -s https://releases.hashicorp.com/terraform/1.10.4/terraform_1.10.4_linux_amd64.zip -o /tmp/terraform.zip >/dev/null
	unzip -o /tmp/terraform.zip -d /tmp >/dev/null 
	sudo mv /tmp/terraform /usr/local/bin/ >/dev/null 

	echo "==> Instalando jq"
	apt-get install jq -y >/dev/null 

	read -p "Você irá utilizar AWS ou Azure: " provider
	provider_lower=$(echo "$provider" | tr '[:upper:]' '[:lower:]')

	if [ $provider_lower = 'aws' ]; then
		echo "==> Instalando o AWS CLI"
		curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" >/dev/null 
		unzip awscliv2.zip >/dev/null 
		./aws/install >/dev/null 
		echo "Tudo pronto!"
	elif [ $provider_lower = 'azure' ]; then
		echo "==> Instalando Azure CLI"
		curl -sL https://aka.ms/InstallAzureCLIDeb | bash >/dev/null 
		echo "Tudo pronto!"
	else 
		echo "Provedor desconhecido: $provider"
		exit 1
	fi
else
	echo "sistema não suportado!"
fi
