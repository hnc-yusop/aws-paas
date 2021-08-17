terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.53.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_cognito_user_pool" "pool" {
  name = "github_pool"
  username_attributes = [ "email" ]
}

resource "aws_cognito_user_pool_client" "client" {
  name = "client"

  user_pool_id = aws_cognito_user_pool.pool.id

  generate_secret     = false
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows = [ "code", "implicit" ]
  allowed_oauth_scopes = [ "phone", "email", "openid", "profile", "aws.cognito.signin.user.admin" ]
  callback_urls = [ "${var.app_url}" ]
  logout_urls = [ "${var.app_url}" ]
}

resource "aws_cognito_user_pool_domain" "main" {
  domain       = "hancom-okd"
  user_pool_id = aws_cognito_user_pool.pool.id
}
