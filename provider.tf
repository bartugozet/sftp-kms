# provider "aws" {
#   region  = var.region
#   access_key = var.access-key
#   secret_key = var.secret-key
#   assume_role {
#     role_arn = "${var.provider_env_roles[local.env]}"
#   }
# }

provider "aws" {
  region = var.region
  access_key = var.access-key
  secret_key = var.secret-key
  # assume_role {
  #   role_arn = var.provider_env_roles[local.env]
  # }
  #profile = "eurowag-shared-services"
}
