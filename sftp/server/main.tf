# locals {
#   private_ips = ["10.2.5.65", "10.2.6.89", "10.2.9.77"]
# }

# resource "aws_network_interface" "multi-ip" {
#   count       = length(local.private_ips)
#   subnet_id   = var.subnet_ids[count.index]
#   private_ips = local.private_ips[count.index]
# }

# resource "aws_eip" "sftp" {
#   count                     = 3
#   vpc                       = true
#   network_interface         = aws_network_interface.multi-ip[count.index].id
#   associate_with_private_ip = local.private_ips[count.index]
  
# }

# SFTP server resource
resource "aws_transfer_server" "sftp" {
  identity_provider_type = "SERVICE_MANAGED"
  endpoint_type          = "PUBLIC"
  protocols   = ["SFTP"]

  # logging_role = aws_iam_role.sftp-logging.arn

  tags = var.tags
}

# # Security group for the SFTP endpoint
# resource "aws_security_group" "sftp" {
#   name   = "sftp-sg"
#   vpc_id = var.vpc_id
#   ingress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = var.tags
# }

# # Role to allow the SFTP server to log traffic
# resource "aws_iam_role" "sftp-logging" {
#   name = "sftp-logging-role"

#   assume_role_policy = <<EOF
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#         "Effect": "Allow",
#         "Principal": {
#             "Service": "transfer.amazonaws.com"
#         },
#         "Action": "sts:AssumeRole"
#         }
#     ]
# }
# EOF

#   tags = var.tags
# }

# # Policy to allow the SFTP server to log traffic
# resource "aws_iam_role_policy" "sftp-logging" {
#   name = "sftp-logging-policy"
#   role = aws_iam_role.sftp-logging.id

#   policy = <<POLICY
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Sid": "AllowSFTPToWriteToCloudWatch",
#             "Effect": "Allow",
#             "Action": [
#                 "logs:CreateLogStream",
#                 "logs:DescribeLogStreams",
#                 "logs:CreateLogGroup",
#                 "logs:PutLogEvents"
#             ],
#             "Resource": "*"
#         },
#         {
#             "Sid": "AllowCommunicationVPCEndPoint",
#             "Effect": "Allow",
#             "Action": [
#                 "ec2:DescribeVpcEndpoints",
#                 "ec2:ModifyVpcEndpoint"
#             ],
#             "Resource": "*"
#         }
#     ]
# }
# POLICY

# }

# s3 bucket that will house all of the home directories for our users.
resource "aws_s3_bucket" "sftp" {
  bucket = "ew-sftp"
  
  tags = merge(
    {
      "Name" = "ew-sftp"
    },
    var.tags,
  )
  
}

# Enforce SSE encryption on the bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_server_side_encryption" {
  bucket = aws_s3_bucket.sftp.bucket

  rule {
    apply_server_side_encryption_by_default {
      # kms_master_key_id = module.kms_sftp.key_arn
      # sse_algorithm     = "aws:kms"      
      sse_algorithm     = "AES256"
    }
  }
}

# module "kms_sftp" {
#   source = "git::https://gitlab.lukapo.com/terraform/aws/module.kms?ref=1.1.0"

#   enabled                 = true
#   description             = "KMS key for sftp s3 bucket"
#   deletion_window_in_days = 7
#   enable_key_rotation     = true
#   alias                   = "alias/csftp-s3-bucket-kms-key"
#   policy                  = data.aws_iam_policy_document.kms-sftp.json  
#   tags = merge(
#     {
#       "Name" = "ew-sftp-kms"
#     },
#     var.tags,
#   )
# }

# data "aws_iam_policy_document" "kms-sftp" {
#   version = "2012-10-17"
#   statement {
#     sid    = "Enable IAM User Permissions"
#     effect = "Allow"
#     principals {
#       type        = "AWS"
#       identifiers = ["*"]
#     }
#     actions   = ["kms:*"]
#     resources = ["*"]
#   }
#   statement {
#     sid    = "Allow alias creation during setup"
#     effect = "Allow"
#     principals {
#       type        = "AWS"
#       identifiers = ["*"]
#     }
#     actions   = ["kms:CreateAlias"]
#     resources = ["*"]
#   }
# }
