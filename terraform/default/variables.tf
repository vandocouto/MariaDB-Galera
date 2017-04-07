variable "zone" {
	default = "us-east-1"
}

variable "instance" {
	default = "3"
}

variable "size_so" {
        default = "30"
}

variable "size_bd" {
        default = "50"
}

variable "type_disk_so" {
        default = "gp2"
}

variable "type_disk_bd" {
        default = "gp2"
}

variable "type" {
	default = "t2.medium"
}

variable "ami" {
	default = "ami-f4cc1de2"
}

variable "key" {
	default = "Blog-Estudo"
}

variable "vpc" {
	default = "vpc-a4f76ec2"
}

variable "cidr" {
	default = "10.0.0.0/22"
}

variable "security" {
	default = "sg-68600514"
}

variable "subnet" {
	type = "list"
	default = ["subnet-bda4e7e6" , "subnet-ce7cf5f2" , "subnet-ae085c83" , "subnet-2264616b" ]
}

variable "ssh_user_name" {
  	default = "ubuntu"
}

variable "ssh_key_file" {
  	default = "../../chave/Blog-Estudo.pem"
}
