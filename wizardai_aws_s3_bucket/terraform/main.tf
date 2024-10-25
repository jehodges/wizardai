module "s3_buckets" {
  source              = "./modules/s3"
  for_each            = local.buckets

  name                = lookup(each.value, "name")
  environment         = lookup(each.value, "environment")
  encryption_type     = lookup(each.value, "encryption_type", "SSE-S3")
  kms_key_id          = lookup(each.value, "kms_key_id", null)
  versioning          = lookup(each.value, "versioning", null)
  public_access_block = lookup(each.value, "public_access_block", true)
}
