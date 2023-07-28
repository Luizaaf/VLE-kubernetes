variable "ami-id" {
    default = "ami-053b0d53c279acc90"
    type = string
    description = "This is the id of ami."
}

variable "instance-type" {
    default = "t2.medium"
    type = string
    description = "This is the instance type of the virtual machine."
}

variable "volume-size" {
    default = 20
    type = number
    description = "This is the volume size of the ebs disk."
}

variable "acess-key" {
    default = "vockey"
    type = string
    description = "This is the name of the acess key."
}
