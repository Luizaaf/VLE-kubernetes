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

resource "aws_security_group" "allow_kubernetes" {
  name = "allow_kubernetes"
  description = "group for allow kubernetes traffic"
  vpc_id = "vpc-0c2e74a43dce77033"

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

resource "aws_instance" "master" {
  
  ami = "ami-053b0d53c279acc90"
  instance_type = "t2.medium"
  vpc_security_group_ids = [aws_security_group.allow_kubernetes.id]
  key_name = "vockey"

  ebs_block_device {
    volume_size = 20
    device_name = "/dev/sda1"
  }

  tags = {
    Name = "master"
  }
}

resource "aws_instance" "worker-01" {
  
  ami = "ami-053b0d53c279acc90"
  instance_type = "t2.medium"
  vpc_security_group_ids = [aws_security_group.allow_kubernetes.id]
  key_name = "vockey"

  ebs_block_device{
    volume_size = 20
    device_name = "/dev/sda1"
  }

  tags = {
    Name = "worker-01"
  }
}

resource "aws_instance" "worker-02" {
  
  ami = "ami-053b0d53c279acc90"
  instance_type = "t2.medium"
  vpc_security_group_ids = [aws_security_group.allow_kubernetes.id]
  key_name = "vockey"

  ebs_block_device {
    volume_size = 20
    device_name = "/dev/sda1"
  }

  tags = {
    Name = "worker-02"
  }
}