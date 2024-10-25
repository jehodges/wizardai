variable "name" {
  description = "Name of the bucket"
  type        = string
}

variable "environment" {
  description = "Environment for the bucket (e.g., development, staging, production)"
  type        = string
}

variable "encryption_type" {
  description = "Type of encryption (SSE-S3 or SSE-KMS)"
  type        = string
  default     = "SSE-S3"

  validation {
    condition     = contains(["SSE-S3", "SSE-KMS"], var.encryption_type)
    error_message = "The encryption_type must be either SSE-S3 or SSE-KMS."
  }
}

variable "kms_key_id" {
  description = "The KMS Key ID to use for SSE-KMS encryption. Required if encryption_type is SSE-KMS."
  type        = string
  default     = null

  validation {
    condition     = var.encryption_type != "SSE-KMS" || var.kms_key_id != null
    error_message = "A KMS Key ID must be provided if encryption_type is SSE-KMS."
  }
}

variable "force_destroy" {
  description = "Whether to allow the bucket to be destroyed even if it contains objects"
  type        = bool
  default     = false
}

variable "versioning" {
  description = "Set versioning to true for 'Enabled', false for 'Suspended', or null to not configure versioning"
  type        = bool
  default     = null
}

variable "bucket_name_prefix" {
  description = "Prefix to add to the bucket name"
  type        = string
  default     = ""
}

variable "public_access_block" {
  description = "Whether to enable public access block configuration"
  type        = bool
  default     = true
}