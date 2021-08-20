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
  name = "${var.user_pool_name}"
  username_attributes = [ "email" ]
}

resource "aws_cognito_user_pool_client" "okd_client" {
  name = "okd-client"

  user_pool_id = aws_cognito_user_pool.pool.id

  supported_identity_providers = [
    "COGNITO",
  ]

  generate_secret     = true
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows = [ "code" ]
  allowed_oauth_scopes = [ "email", "openid", "profile", "aws.cognito.signin.user.admin" ]
  callback_urls = [ "${var.app_client_url}" ]
  logout_urls = [ "${var.app_client_url}" ]
  explicit_auth_flows = [ "ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_USER_SRP_AUTH", "ALLOW_CUSTOM_AUTH" ]
}

resource "aws_cognito_user_pool_domain" "main" {
  domain       = "${var.user_pool_domain}"
  user_pool_id = aws_cognito_user_pool.pool.id
}

output "user_pool_id" {
  description = "User pool ID"
  value       = aws_cognito_user_pool.pool.id
}

output "okd_client_id" {
  description = "OKD client ID"
  value       = aws_cognito_user_pool_client.okd_client.id
}

output "okd_client_secret" {
  description = "OKD client secret"
  value       = nonsensitive(aws_cognito_user_pool_client.okd_client.client_secret)
}

output "cognito_redirect_uri" {
  description = "Cognito redirect uri"
  value       = "https://${var.user_pool_domain}.auth.ap-northeast-2.amazoncognito.com/oauth2/idpresponse"
}

/* extra part
resource "aws_cognito_user_pool_client" "malangmalang_client" {
  name = "malangmalang-client"

  user_pool_id = aws_cognito_user_pool.pool.id

  supported_identity_providers = [
    "COGNITO",
  ]

  generate_secret     = false
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows = [ "code" ]
  allowed_oauth_scopes = [ "email", "openid", "profile", "aws.cognito.signin.user.admin" ]
  callback_urls = [ "${var.app_client_url}" ]
  logout_urls = [ "${var.app_client_url}" ]
}

output "malangmalang_client_id" {
  description = "MalangMalang client ID"
  value       = aws_cognito_user_pool_client.malangmalang_client.id
}

resource "aws_cognito_identity_provider" "malangmalang_provider" {
  user_pool_id  = aws_cognito_user_pool.pool.id
  provider_name = "malangmalang-provider"
  provider_type = "OIDC"

  provider_details = {
    authorize_scopes = "${var.malangmalang_authorize_scopes}"
    client_id        = "${var.malangmalang_client_id}"
    client_secret    = "${var.malangmalang_client_secret}"
    attributes_request_method = "GET"
    oidc_issuer = "${var.malangmalang_issuer}"
  }

  attribute_mapping = {
    name = "name"
    username = "sub"
    preferred_username = "preferred_username"
  }
}
*/
