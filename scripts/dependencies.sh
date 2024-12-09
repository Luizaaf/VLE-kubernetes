#!/bin/bash

sistema=$(cat /etc/os-release | awk -F= '/^ID=/ {print $2}')

if [ $sistema = 'fedora' ]; then
	sudo dnf install python3 python3-pip terraform azure-cli jq -y
	pip3 install boto3 botocore ansible awscli
elif [ $sistema = 'ubuntu' ]; then
	sudo apt-get update
	sudo apt-get install python3 python3-pip terraform jq -y
	pip3 install boto3 botocore ansible awscli
else
	echo "sistema não suportado!"
fi
