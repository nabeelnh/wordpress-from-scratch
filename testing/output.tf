# Output values are stored here

output "WEB_IP_Address" {
  value = aws_instance.web.public_ip
}
