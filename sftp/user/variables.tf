variable "tags"{
  type = map(any)
  default = {}
}

variable "user_map" {
  type = map(object({
    authorized_keys = string
  }))
  default = {}
}

variable "sftp_server_id" {
  description = "SFTP server ID"
  type        = string
  default     = ""
}

variable "s3_bucket_arn" {
  description = "Bucket ARN"
  type        = string
  default     = ""
}

variable "s3_bucket_name" {
  description = "Bucket name"
  type        = string
  default     = ""
}