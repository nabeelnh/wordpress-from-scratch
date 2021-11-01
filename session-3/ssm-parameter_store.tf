resource "aws_ssm_parameter" "cat-string" {
  name        = "/my-cat-app/dbstring"
  description = "Connection string for cat application"
  type        = "String"
  tier        = "Standard"      # limited to 10,000 parameters
  value       = "db.allthecats.com:3306"

  tags = local.common_tags
}

resource "aws_ssm_parameter" "db-user" {
  name        = "/my-cat-app/dbuser"
  description = "Database user"
  type        = "String"
  tier        = "Standard"      # limited to 10,000 parameters
  value       = "bosscats"

  tags = local.common_tags
}

resource "aws_ssm_parameter" "db-password" {
  name        = "/my-cat-app/dbpassword"
  description = "Database password"
  type        = "SecureString"
  tier        = "Standard"      # limited to 10,000 parameters
  value       = "password"

  tags = local.common_tags
}

resource "aws_ssm_parameter" "dog-string" {
  name        = "/my-dog-app/dbstring"
  description = "Connection string for cat application"
  type        = "String"
  tier        = "Standard"      # limited to 10,000 parameters
  value       = "db.ifwereallymusthavedogs.com:3306"

  tags = local.common_tags
}

resource "aws_ssm_parameter" "lizard-string" {
  name        = "/rate-my-lizard/dbstring"
  description = "Connection string for cat application"
  type        = "String"
  tier        = "Standard"      # limited to 10,000 parameters
  value       = "db.thisisprettyrandom.com:3306"

  tags = local.common_tags
}