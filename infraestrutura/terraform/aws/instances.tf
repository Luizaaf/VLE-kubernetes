resource "aws_instance" "master" {
  
  ami = "ami-053b0d53c279acc90"
  instance_type = "t2.medium"
  vpc_security_group_ids = [aws_security_group.this.id]
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
  vpc_security_group_ids = [aws_security_group.this.id]
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
  vpc_security_group_ids = [aws_security_group.this.id]
  key_name = "vockey"

  ebs_block_device {
    volume_size = 20
    device_name = "/dev/sda1"
  }

  tags = {
    Name = "worker-02"
  }
}