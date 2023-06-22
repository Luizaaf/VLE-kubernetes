terraform {
  rrequired_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.0"
    }
  }    
}

variable "instaces-names" {

  description = "Names of instances"
  type = list(string)
  default = [ "master", "worker-01", "worker-02" ]

}

provider "aws" {

  region = "us-east-1" # Norte da Virginia

}

resource "aws_instance" "master" {
  
  ami = "ami-053b0d53c279acc90"
  for_each = var.instaces-names
  instance_type = "t2."
  key_name = "labsuser.pem"

  ebs_block_device {

    volume_size = 20

  }
}
