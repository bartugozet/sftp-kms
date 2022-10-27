#Define AWS Region
variable "region" {
  description = "Infrastructure region"
  type        = string
  default     = "eu-central-1"
}



#Define IAM User Access Key
variable "access-key" {
  description = "The access-key that belongs to the IAM user"
  type        = string
  sensitive   = true
}
#Define IAM User Secret Key
variable "secret-key" {
  description = "The secret-key that belongs to the IAM user"
  type        = string
  sensitive   = true
}




