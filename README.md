# S3 Bucket Terraform Module

This repository contains a Terraform module to provision and manage S3 buckets dynamically across multiple environments (development, staging, production). The bucket configurations are defined in a central `config.yaml` file, and the module provisions the appropriate buckets based on the current workspace.

## How to Add Buckets in `config.yaml`

To add new buckets for your environments, edit the `config.yaml` file. The structure of `config.yaml` is divided by environments (e.g., `development`, `staging`, `production`). Each environment contains a list of buckets, and for each bucket, you can define specific configuration options.

### Example `config.yaml`

```yaml
buckets:
  development:
    bucket01:
      name: "dev-bucket01"
      encryption_type: "SSE-S3"
      force_destroy: true
  staging:
    bucket02:
      name: "staging-bucket02"
      encryption_type: "SSE-S3"
      force_destroy: true
  production:
    bucket03:
      name: "prod-bucket03"
      encryption_type: "SSE-S3"
      force_destroy: false
      versioning: true
```

### Bucket Options

You can define the following options for each bucket:

- **`name`** (required): The name of the S3 bucket.
- **`encryption_type`** (optional, default: `SSE-S3`): The encryption type for the S3 bucket. Options include:
    - `"SSE-S3"`: Server-side encryption with Amazon S3-managed keys (default).
    - `"SSE-KMS"`: Server-side encryption with AWS KMS-managed keys. If you choose this, you can also provide a `kms_key_id`.
- **`force_destroy`** (optional, default: `false`): Whether to allow the bucket to be deleted even if it contains objects.
- **`versioning`** (optional, default: `null`): Enable versioning on the S3 bucket. Set to `true` to enable versioning, `false` to suspend versioning.
- **`public_access_block`** (optional, default: `true`): Whether to block public access to the bucket. Set to `false` if public access is required.

### Example Additions

To add a new bucket, simply add a new entry under the appropriate environment. For example:

```yaml
buckets:
  development:
    bucket01:
      name: "dev-bucket01"
      encryption_type: "SSE-S3"
      force_destroy: true
    bucket02:
      name: "dev-bucket02"
      encryption_type: "SSE-KMS"
      kms_key_id: "arn:aws:kms:region:account-id:key/key-id"
      force_destroy: false
      versioning: true
      public_access_block: false
```

In this case, `dev-bucket02` will be provisioned with KMS encryption, versioning enabled, and public access allowed.

## How to Apply Changes

Once you've added or modified bucket definitions in `config.yaml`, you can apply the changes by following these steps:

1. **Select the workspace** for the environment you are working in:
   ```bash
   terraform workspace select development
   ```

2. **Initialize Terraform** (if it's your first time working in this directory):
   ```bash
   terraform init
   ```

3. **Plan and apply** the changes:
   ```bash
   terraform plan
   terraform apply
   ```

This will provision or update the S3 buckets as defined in `config.yaml` for the active workspace.

## Design Decisions

Design decisions can be found in the `DESIGN.md` file.