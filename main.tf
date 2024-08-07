resource "aws_s3_bucket" "awsBucket" {
  bucket = var.bucket
}

resource "aws_s3_bucket_ownership_controls" "name" {
    bucket = aws_s3_bucket.awsBucket.id

    rule {
      object_ownership = "BucketOwnerPreferred"
    }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.awsBucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "example" {
  depends_on = [aws_s3_bucket_ownership_controls.name]

  bucket = aws_s3_bucket.awsBucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_object" "indexhtml" {
  key        = "index.html"
  bucket     = aws_s3_bucket.awsBucket.id
  source     = "index.html"
  acl = "public-read"
  content_type = "text/html"
}

resource "aws_s3_bucket_object" "errorhtml" {
  key        = "error.html"
  bucket     = aws_s3_bucket.awsBucket.id
  source     = "error.html"
  acl = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "picture" {
    bucket = aws_s3_bucket.awsBucket.id
    key = "thor.jpg"
    source = "thor.jpg"
    acl = "public-read"
}

resource "aws_s3_bucket_website_configuration" "mywebsite" {
  bucket = aws_s3_bucket.awsBucket.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }

  depends_on = [ aws_s3_bucket_acl.example ]
}