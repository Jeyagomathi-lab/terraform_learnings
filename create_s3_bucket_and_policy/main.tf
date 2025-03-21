#bucket creation
resource "aws_s3_bucket" "myBucket" {
    bucket = var.bucket_name
    tags = {
      Name = var.bucket_name
      Environment = "dev"
    }
}

#enable bucket versioning
resource "aws_s3_bucket_versioning" "bucket_version" {
    bucket = aws_s3_bucket.myBucket.id
    versioning_configuration {
      status = "Enabled"
    }
  
}

#enable server side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
    bucket = aws_s3_bucket.myBucket.id
    rule {
      apply_server_side_encryption_by_default {
         sse_algorithm = "AES256"
      }
    }  
}

#upload a file from local to s3
resource "aws_s3_object" "bucket_object" {
    bucket = aws_s3_bucket.myBucket.id
    key = "mys3filecheck.txt"
    source = "testfile.txt"
    etag = filemd5("testfile.txt")
}

#disable bublic access
resource "aws_s3_bucket_public_access_block" "bucket_access" {
bucket = aws_s3_bucket.myBucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#create user
resource "aws_iam_user" "bucket_user" {
  name ="bucket_user-read"
}

#policy to allow to read bucket object
resource "aws_iam_policy" "bucket_read_policy" {
name = "bucket-read-policy"
description = "read bucket object on user level"
policy = jsonencode({
  Version = "2012-10-17"
  Statement = [{
    Effect = "Allow"
    Action = "s3:getObject"
    Resource = "${aws_s3_bucket.myBucket.arn}/*"
  }]
})
}

#attach policy to user
resource "aws_iam_user_policy_attachment" "attach_policy" {
  user = aws_iam_user.bucket_user.id
  policy_arn = aws_iam_policy.bucket_read_policy.arn
  
}

