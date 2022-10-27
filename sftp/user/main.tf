# Define permissions for the user within their home directory

resource "aws_iam_role" "sftp" {
  name = "sftp-user-role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Service": "transfer.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
        }
    ]
}
EOF

  tags = {
    Name       = "sftp-user-role"
  }
}

# Define permissions for the user within their home directory

resource "aws_iam_role_policy" "sftp" {
  name = "sftp-user-policy"
  role = aws_iam_role.sftp.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowListingFolder",
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetBucketLocation"
            ],
            "Resource": "${var.s3_bucket_arn}"
        },
        {
            "Sid": "AllowReadWriteObject",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObjectVersion",
                "s3:DeleteObject",
                "s3:GetObjectVersion"
            ],
            "Resource": "${var.s3_bucket_arn}/*"
        }
    ]
}
POLICY
}

# Create the users in the SFTP service

resource "aws_transfer_user" "user" {
  #for_each       = var.user_map
  for_each = { 
    for idx, user in var.user_map : idx => user 
  }
  server_id      = var.sftp_server_id
  user_name      = each.key
  role           = aws_iam_role.sftp.arn
  home_directory = "/${var.s3_bucket_name}"

  tags = var.tags
}

# Define the SSH keys that will be used for authentication by each of our users
resource "aws_transfer_ssh_key" "user" {
  for_each = { 
    for idx, user in var.user_map : idx => user
  }
  server_id = var.sftp_server_id
  user_name = aws_transfer_user.user[each.key].user_name
  body      = each.value.authorized_keys

}

# Create the user-specific home directory within the SFTP s3 bucket defined above

# resource "aws_s3_object" "data-cz-aevi" {
#   bucket = var.s3_bucket_name
#   acl    = "private"
#   key    = "data_cz_aevi/"
#   source = "/dev/null"
# }

resource "aws_s3_object" "incoming" {
  bucket = var.s3_bucket_name
  acl    = "private"
  key    = "data_cz_aevi/incoming/"
  source = "/dev/null"
}

# resource "aws_s3_object" "outgoing" {
#   bucket = var.s3_bucket_name
#   acl    = "private"
#   key    = "data_cz_aevi/outgoing/"
#   source = "/dev/null"
# }
