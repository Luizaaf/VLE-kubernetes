resource "aws_instance" "master" {
    ami = var.ami-id
    instance_type = var.instance-type 
    vpc_security_group_ids = [aws_security_group.this.id]
    key_name = var.acess-key 

    ebs_block_device {
      volume_size = var.volume-size
      device_name = "/dev/sda1"
    }

    tags = {
      Name = "master"
    }
}

resource "aws_instance" "worker-01" {

    ami = var.ami-id 
    instance_type = var.instance-type
    vpc_security_group_ids = [aws_security_group.this.id]
    key_name = var.acess-key 

    ebs_block_device{
      volume_size = var.volume-size
      device_name = "/dev/sda1"
    }

    tags = {
      Name = "worker-01"
    }
}

resource "aws_instance" "worker-02" {
  
    ami = var.ami-id
    instance_type = var.instance-type 
    vpc_security_group_ids = [aws_security_group.this.id]
    key_name = var.acess-key 

    ebs_block_device {
      volume_size = var.volume-size
      device_name = "/dev/sda1"
    }

    tags = {
      Name = "worker-02"
    }
}
