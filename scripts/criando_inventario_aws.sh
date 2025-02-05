#!/bin/bash

cd ../infraestrutura/aws

control_plane_ip=$(terraform output -json | jq -r '.instance_ip_master.value[]')
worker_ip=$(terraform output -json | jq -r '.workers_ip.value[]')

cd -  

mkdir -p ../ansible/inventory/

cat > ../ansible/inventory/hosts << EOL
[control_plane]
$control_plane_ip

[worker_node]
$worker_ip

[all:vars]
ansible_ssh_private_key_file=~/.ssh/vle
ansible_user=ubuntu
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
EOL
