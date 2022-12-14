resource "aws_s3_bucket" "rahonasydevops_com" {
  bucket = "rahonasydevops.com"

  force_destroy = true

  tags = {
    Name = "rahonasydevops.com"
  }
}

resource "aws_s3_bucket_website_configuration" "rahonasydevops_com" {
  bucket = aws_s3_bucket.rahonasydevops_com.bucket

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_policy" "allow_access_from_cloudflare" {
  bucket = aws_s3_bucket.rahonasydevops_com.id
  policy = data.aws_iam_policy_document.allow_access_from_cloudflare.json
}

data "aws_iam_policy_document" "allow_access_from_cloudflare" {
  statement {
    sid = "AllowCloudflareAccessOnly"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = var.cloudflare_ip_ranges
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.rahonasydevops_com.arn}/*",
    ]
  }
}