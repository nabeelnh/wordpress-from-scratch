# Creating the WordPress Instance
resource "aws_instance" "web" {
  ami           = data.aws_ami.ami.id
  instance_type = var.instance_type
  vpc_security_group_ids =  [aws_security_group.allow_http.id]
  key_name  = var.ssh_key
  iam_instance_profile = aws_iam_instance_profile.instance_profile.name

  connection {
    host = self.public_ip
    user    = "ec2-user"
    private_key  = "${file("~/.aws/${var.ssh_key}.pem")}"
  }

  provisioner "file" {
    content     = templatefile("install-wordpress.tftpl", { 
      DBName = "username", 
      DBUser = "username",
      DBPassword = "password",
      DBRootPassword = "password",
      PrivateDNS = aws_instance.database.private_dns
      })
    destination = "/tmp/install-wordpress.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install-wordpress.sh",
      "/tmp/install-wordpress.sh",
    ]
  }

  tags = local.common_tags
}


# Instane Security Group
resource "aws_security_group" "allow_http" {
  name        = "application security group"
  description = "Allow HTTP inbound traffic"

  ingress {
      description      = "HTTP from the public"
      from_port        = 0
      to_port          = 65535
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }

  ingress {
      description      = "SSH from the public"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["${chomp(data.http.myip.body)}/32"]
    }

  egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
    }

  tags = local.common_tags
}