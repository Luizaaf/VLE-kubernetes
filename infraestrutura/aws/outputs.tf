output "instance-ip-master" {
  value = aws_instance.master.public_ip
}

output "instance-ip-worker01" {
  value = aws_instance.worker-01.public_ip
}

output "instance-ip-worker02" {
  value = aws_instance.worker-02.public_ip
}
