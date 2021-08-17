variable "public_key_path" {
  description = "Path to the SSH public key to be used for authentication."
  default = "cert/terraform.pub"
}

variable "key_name" {
  description = "Desired name of AWS key pair"
  default = "terraform"
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "ap-northeast-2"
}
