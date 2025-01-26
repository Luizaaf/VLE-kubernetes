terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.0"
    }
  }    
}

provider "aws" {
  region = "us-east-1" # Norte da Virginia
}

data "aws_vpc" "default" {
  default = true
}

# Locals
locals {
  ami_id           = "ami-0866a3c8686eaeeba"
  instance_type    = "t2.medium"
  access_key       = "vockey"
  volume_size      = 20
  inventory_path   = "../ansible/inventory/aws_ec2.yml"
  key_path         = "~/Downloads/labsuser.pem"
  playbook_path    = "../ansible/playbook.yml"
}

# Grupo de Segurança
resource "aws_security_group" "this" {
  name        = "allow_kubernetes"
  description = "Group for allowing Kubernetes traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description     = "Allow SSH traffic"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description = "Allow all internal group traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    description = "Allow all external traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Instâncias
resource "aws_instance" "master" {
  ami                    = local.ami_id
  instance_type          = local.instance_type
  vpc_security_group_ids = [aws_security_group.this.id]
  key_name               = local.access_key
  count                  = 1

  ebs_block_device {
    volume_size = local.volume_size
    device_name = "/dev/sda1"
  }

  tags = {
    Name = "k8s"
    type = "master"
  }
}

resource "aws_instance" "workers" {
  ami                    = local.ami_id
  instance_type          = local.instance_type
  vpc_security_group_ids = [aws_security_group.this.id]
  key_name               = local.access_key
  count                  = 2

  ebs_block_device {
    volume_size = local.volume_size
    device_name = "/dev/sda1"
  }

  tags = {
    Name = "k8s"
    type = "worker"
  }
}

#resource "null_resource" "name" {  
#}

# Outputs
output "instance_ip_master" {
  value = aws_instance.master[*].public_ip
}

output "workers_ip" {
  value = aws_instance.workers[*].public_ip
}
