output "endpoint" {
    value = aws_transfer_server.sftp.endpoint
}

output "server_id" {
    value = aws_transfer_server.sftp.id
}

output "bucket_name" {
    value = aws_s3_bucket.sftp.id
}

output "bucket_arn" {
    value = aws_s3_bucket.sftp.arn
}