terraform {
    required_providers {
      aws = {
        source  = "hashicorp/aws"
        version = "~> 5.0"
      }
    }
  
}
provider "aws" {
    region = "ap-south-1"
}

# IAM User
resource "aws_iam_user" "terraform_user" {
  name = "terraform-user"
}

# Create a Login Profile (for Console Access)
resource "aws_iam_user_login_profile" "login_access" {
  user = aws_iam_user.terraform_user.name
  password_reset_required = true #set for force reset password on first login
  
}

# attach policy from aws managed policy
resource "aws_iam_user_policy_attachment" "full_access" {
  user = aws_iam_user.terraform_user.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  
}

output "iam_user" {
  value = aws_iam_user.terraform_user.name
}
