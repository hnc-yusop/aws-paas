variable "user_pool_domain" {
  description = "Amazon Cognito domain : Prefixed domain names can only contain lower-case letters, numbers, and hyphens"
}

variable "user_pool_name" {
  description = "Your user pool a descriptive name so you can easily identify it in the future"
}

variable "app_client_url" {
  description = "A callback url indicates where the user is to be redirected after a successful sign-in. ex) https://oauth-openshift.apps.{cluster_name}.{base_domain}/oauth2callback/Cognito"
}

variable "malangmalang_authorize_scopes" {
  description = "Scopes define which user attribues you want to access with your app."
  default = "openid read:user user:email"
}

/* extra part
variable "malangmalang_client_id" {
  description = "MalangMalang client ID"
}

variable "malangmalang_client_secret" {
  description = "MalangMalang client secret"
}

variable "malangmalang_issuer" {
  description = "malangmalang issuer"
}
*/
