# List of variables used in creation of this Project

variable "region" {
  type = string
  default = "eu-west-2"
}

variable "project" {
  type = string
  default = "WordPress"
}

variable "env" {
  type = string
  default = "Testing"
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}