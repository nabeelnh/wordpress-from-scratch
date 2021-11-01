# Output values are stored here

output "instance-ip" {
  value = aws_instance.web.public_ip
}