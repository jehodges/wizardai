locals {
  # Decoding the context and config YAML files
  context = yamldecode(file("${path.module}/context.yaml"))
  config  = yamldecode(file("${path.root}/config.yaml"))

  # Extract context based on the current workspace
  context = local.context["context"][terraform.workspace]

  # Extract buckets configuration from config.yaml based on the current workspace
  buckets = local.config["buckets"][terraform.workspace]

  # Additional variables from context.yaml
  account_id            = local.context["account_id"] # unused but retained for future use
  aws_region            = local.context["aws_region"]
  role_arn              = local.context["role_arn"]
  session_name          = local.context["session_name"]
}
