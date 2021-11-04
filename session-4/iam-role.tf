# This is going to create IAM role but we can’t link this 
# role to AWS instance and for that, we need EC2 instance Profile
resource "aws_iam_role" "iam_role" {
  name = "${var.project}-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = local.common_tags
}

# Create EC2 Instance Profile
resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.project}-profile"
  role = aws_iam_role.iam_role.name
}


# Give full access to S3 bucket
resource "aws_iam_role_policy" "s3_policy" {
  name = "${var.project}-s3-Policy"
  role = aws_iam_role.iam_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

# Give full access to Parameter Store
resource "aws_iam_role_policy" "ssm_policy" {
  name = "${var.project}-s3-SSM"
  role = aws_iam_role.iam_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ssm:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}