terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }    
}

provider "aws" {
  region = "us-east-1" # Norte da Virginia
}

# locals

locals {
  ami-id = "ami-053b0d53c279acc90"
  instance-type = "t2.medium"
  acess-key = "vockey"
  volume-size = 20
  inventory-path = "../ansible/inventory/aws_ec2.yml"
  key-path = "~/Downloads/labsuser.pem"
  playbook-path = "../ansible/playbook.yml"
}

# Grupo de segurança

resource "aws_security_group" "this" {
  name = "allow_kubernetes"
  description = "Group for allow kubernetes traffic"
  vpc_id = "vpc-07a3b39a3e4228a8b"

  ingress {
    description = "Allow ssh traffic"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description = "Allow all internal group traffic"
    from_port = 0
    to_port = 0
    protocol = "-1"
    self = true
  }

  egress {
      description = "Allow all external traffic"
      from_port = 0
      to_port = 0
      protocol = "-1"
  }
}

# instâncias

resource "aws_instance" "master" {
    ami = local.ami-id
    instance_type = local.instance-type
    vpc_security_group_ids = [aws_security_group.this.id]
    key_name = local.acess-key
    count = 1

    ebs_block_device {
      volume_size = local.volume-size
      device_name = "/dev/sda1"
    }

    tags = {
      Name = "k8s"
      type = "master"
    }
}

resource "aws_instance" "workers" {

    ami = local.ami-id
    instance_type = local.instance-type
    vpc_security_group_ids = [aws_security_group.this.id]
    key_name = local.acess-key 
    count = 2

    ebs_block_device{
      volume_size = local.volume-size
      device_name = "/dev/sda1"
    }

    tags = {
      Name = "k8s"
      type = "worker"
    }
}

resource "null_resource" "name" {  
}

# outputs

output "instance-ip-master" {
  value = aws_instance.master[*].public_ip
}

output "Workres-ip" {
  value = aws_instance.workers[*].public_ip
}

