terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.0"
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
}

# Grupo de segurança

resource "aws_security_group" "this" {
  name = "allow_kubernetes"
  description = "group for allow kubernetes traffic"
  vpc_id = "vpc-07a3b39a3e4228a8b "

  ingress {
    description = "Allow ssh traffic"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description = "Kubernetes API server"
    from_port        = 6443
    to_port          = 6443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description = "etcd server client API"
    from_port        = 2379
    to_port          = 2380
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description = "Kubelet API"
    from_port        = 10250
    to_port          = 10250
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description = "kube-scheduler"
    from_port        = 10259
    to_port          = 10259
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description = "kube-controller-manager"
    from_port        = 10257
    to_port          = 10257
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description = "NodePort Services"
    from_port        = 30000
    to_port          = 32767
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

# instâncias

resource "aws_instance" "master" {
    ami = local.ami-id
    instance_type = local.instance-type
    vpc_security_group_ids = [aws_security_group.this.id]
    key_name = local.acess-key

    ebs_block_device {
      volume_size = local.volume-size
      device_name = "/dev/sda1"
    }

    tags = {
      Name = "k8s"
      type = "master"
    }
}

resource "aws_instance" "worker-01" {

    ami = local.ami-id
    instance_type = local.instance-type
    vpc_security_group_ids = [aws_security_group.this.id]
    key_name = local.acess-key 

    ebs_block_device{
      volume_size = local.volume-size
      device_name = "/dev/sda1"
    }

    tags = {
      Name = "k8s"
      type = "worker"
    }
}

resource "aws_instance" "worker-02" {
  
    ami = local.ami-id
    instance_type = local.instance-type
    vpc_security_group_ids = [aws_security_group.this.id]
    key_name = local.acess-key 

    ebs_block_device{
      volume_size = local.volume-size
      device_name = "/dev/sda1"
    }

    tags = {
      Name = "worker-02"
    }
}

# outputs

output "instance-ip-master" {
  value = aws_instance.master.public_ip
}

output "instance-ip-worker01" {
  value = aws_instance.worker-01.public_ip
}

output "instance-ip-worker02" {
  value = aws_instance.worker-02.public_ip
}
