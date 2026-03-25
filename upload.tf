# Find all .txt and .jpg files in local directory
locals {
  txt_files = tolist(fileset(".", "*.txt"))
  jpg_files = tolist(fileset(".", "*.jpg"))
  all_files = concat(local.txt_files, local.jpg_files)
}

# Upload each file to S3 using aws_s3_object (modern)
resource "aws_s3_object" "files" {
  for_each = { for f in local.all_files : f => f }

  bucket = aws_s3_bucket.test.bucket
  key    = each.value               # Key in S3 (same as filename)
  source = "./${each.value}"        # Local path to file
  acl    = "private"

  # Optional: Automatically set content type based on file extension
#   content_type = lookup({
#     ".txt" = "text/plain",
#     ".jpg" = "image/jpeg"
#   }, substr(each.value, length(each.value) - 4, 4), "binary/octet-stream")
}