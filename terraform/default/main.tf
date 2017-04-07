provider "aws" {
	region = "${var.zone}"
}

# Security Group MariaDB_Galera
resource "aws_security_group" "MariaDB_Galera" {
  name        = "MariaDBGalera"
  description = "Used in the terraform"
  vpc_id      = "${var.vpc}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = -1
    self        = true
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["${var.cidr}"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Load Balance MariaDB_Galera
resource "aws_elb" "MariaDB_Galera" {
  name            = "MariaDBGalera"
  subnets         = ["${var.subnet}"]
  security_groups = ["${var.security}"]
  // interno load balance (true) externo load balance (false)
  internal        = true

  listener {
    instance_port     = 3306
    instance_protocol = "tcp"
    lb_port           = 3306
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 5
    target              = "TCP:3306"
    interval            = 60
  }

  instances                   = ["${aws_instance.mariadb_galera.*.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 60
  connection_draining         = true
  connection_draining_timeout = 60
}

# Deploy Instance
resource "aws_instance" "mariadb_galera" {
 	count = "${var.instance}"
    subnet_id = "${element(var.subnet, count.index)}"
	instance_type = "${var.type}"
	ami = "${var.ami}"
	key_name = "${var.key}"
  	//security_groups = ["${var.security}"]
    security_groups = ["${aws_security_group.MariaDB_Galera.id}"]
	associate_public_ip_address = true
	root_block_device {
        	volume_size = "${var.size_so}"
        	volume_type = "${var.type_disk_so}"
    	}

    tags {
        Name = "MariaDB_Galera"
    }

    ebs_block_device {
        device_name = "/dev/xvdb"
        volume_type = "${var.type_disk_bd}"
        volume_size = "${var.size_bd}"
        delete_on_termination = true
    }

    user_data = "${file("script.sh")}"
}

output "Private IP" {
	value = "${join(",", aws_instance.mariadb_galera.*.private_ip)}"
 
}

output "Public IP" {
    value = "${join(",", aws_instance.mariadb_galera.*.public_ip)}"

}

output "lb_address" {
      value = "${aws_elb.MariaDB_Galera.dns_name}"
}


