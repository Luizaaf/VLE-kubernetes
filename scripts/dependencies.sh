#!/bin/bash

# instalar python
sudo apt-get update
sudo apt-get install python3 python3-pip -y

# instalar ansible e awscli
pip3 install boto3 botocore ansible awscli 

# instalar terraform [https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli]

sudo apt-get update && sudo apt-get install -y gnupg software-properties-common

wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update
sudo apt install terraform -y

# instalar jq
sudo apt install jq -y
