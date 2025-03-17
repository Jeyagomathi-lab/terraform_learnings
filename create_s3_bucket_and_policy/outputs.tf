output "bucketName" {
    description = "Bucket name"
    value = aws_s3_bucket.myBucket.id
}
