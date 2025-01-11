provider "aws" {
    region = "us-west-2"
}

resource "aws_iam_role" "cross_account_role" {
    name = "cross_account_role"
## adding a not
    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Effect = "Allow",
                Principal = {
                    AWS = "arn:aws:iam::123456789012:root" # Replace with the AWS Account ID of the trusted account
                },
                Action = "sts:AssumeRole"
            }
        ]
    })
}

resource "aws_iam_policy" "s3_access_policy" {
    name        = "s3_access_policy"
    description = "Policy to allow access to S3 bucket"

    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Effect = "Allow",
                Action = [
                    "s3:ListBucket",
                    "s3:GetObject"
                ],
                Resource = [
                    "arn:aws:s3:::your-bucket-name",          # Replace with your S3 bucket ARN
                    "arn:aws:s3:::your-bucket-name/*"         # Replace with your S3 bucket ARN
                ]
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
    role       = aws_iam_role.cross_account_role.name
    policy_arn = aws_iam_policy.s3_access_policy.arn
}
resource "aws_s3_bucket" "example_bucket" {
    bucket = "your-bucket-name" # Replace with your desired bucket name
    acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "example_bucket" {
    bucket = aws_s3_bucket.example_bucket.id

    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
}