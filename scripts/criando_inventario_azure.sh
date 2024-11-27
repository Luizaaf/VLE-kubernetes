#!/bin/bash

cd ../infraestrutura/azure

control_plane_ip=$(terraform output -json | jq -r '.["master-ip"].value')
worker1_ip=$(terraform output -json | jq -r '.["workernode1-ip"].value')
worker2_ip=$(terraform output -json | jq -r '.["workernode2-ip"].value')

cd -  

cat > ../ansible/inventory/hosts<< EOL
[control_plane]
$control_plane_ip

[worker_node]
$worker1_ip
$worker2_ip

[all:vars]
ansible_ssh_private_key_file=~/.ssh/azure
ansible_user=ubuntu
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
EOL