# Find latest Amazon Centos Image
data "aws_ami" "ami" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2*"]
  }
}

# Find my IP address
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}