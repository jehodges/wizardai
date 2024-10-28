# Design Decisions for the S3 Bucket Module

## Overview

I built this module to make creating and managing S3 buckets easier across different environments. The idea was to have a central place (`config.yaml`) to control everything, so teams can quickly set up infrastructure that follows our standards without a lot of hassle.

## Key Design Decisions

### 1. **Self hosted terraform module**

Instead of consuming an internet hosted terraform module, I have created a self hosted terraform module. For the sake of this exercise it is in the same repo, however in an enterprise setup, this could be hosted in a separate terraform library repository.

**Why I did this**:
- Self-hosted terraform modules:
    - Are more secure as they are not dependent on an external source.
    - Can be versioned and controlled by the organization.
    - Can be customized to the organization's needs.
    - Can be deployed from inside a firewall with no internet access.
- Terraform is not a gnu/gpl licensed software, it's license and access may also be changed by the provider.

**What’s good about it**:
- Template developments and enhancements can be built to suite the organizations needs and update cadence.
- Developers can view the source code and understand the relationship between the module and the infrastructure it provisions.
- Mandated configuration can be baked into the module to enforce organization and regulatory standards.
- IaaC solution will continue to function in the event of a change in the provider's license or access.

### 2. **Centralized Config with `config.yaml`**

Instead of spreading bucket settings all over, I went with a single `config.yaml` file to manage everything. It’s split by environment (development, staging, production), and each one has its own list of buckets.

**Why I did this**:
- It keeps things simple and reduces the chance of mistakes since everything is in one place.
- It helps maintain consistency across environments by using the same structure for each.
- It’s easier to manage multiple environments without needing to copy-paste Terraform code everywhere.

**What’s good about it**:
- It’s easy to add or change buckets for any environment.
- Keeps the infrastructure setup organized and separate from the module’s logic.

### 3. **Seperated Environment configuration with `context.yaml`**

Rather than holding the environment specific configuration in the `config.yaml`, I have created a `context.yaml` file to hold the environment specific configuration. This file is used to determine the environment specific configuration for the bucket.

**Why I did this**:
- This reduces the complexity of the `config.yaml` file and makes it easier to manage the environment specific configuration.
- It helps maintain consistency across environments by using the same structure for each.
- It’s easier to update or add new environment specific configuration without changing the `config.yaml` file.

**What’s good about it**:
- Developers don't need to worry about accidental environment configuration in the `config.yaml` file.
- This file could be held in a seperate repository and could be used as a submodule to manage the environment specific configuration across multiple terraform modules.

### 4. **Workspaces for Environment-Specific Buckets**

I’m using Terraform workspaces to handle different environments (like dev, staging, and prod). The module pulls the right config from `config.yaml` depending on the workspace you're in.

**Why I did this**:
- Workspaces are a clean and simple way to manage different environments without needing to maintain separate Terraform folders.

**What’s good about it**:
- Teams can easily switch between environments by changing the workspace.
- It cuts down on duplicate Terraform configurations.

### 5. **Flexibility with Bucket Options**

I added flexibility to let teams customize settings like encryption, versioning, and public access. You can tweak these per bucket, but there are sensible defaults to make sure we’re always secure.

**Why I did this**:
- Every project is different, so I wanted to give teams options to adjust things like versioning and access without needing to dive too deep into the config.

**What’s good about it**:
- Teams can focus on what they need for their project without worrying about the details of S3 bucket setup.
- Secure defaults like encryption and blocking public access mean we stay compliant by default.

### 6. **Reusable and Modular**

I wanted this module to be something teams could use for different projects, not just a one-off solution. By separating the config from the code, it’s easy to use the same module for multiple projects. Just update `config.yaml` and switch workspaces.

**Why I did this**:
- Reusability means teams don’t have to reinvent the wheel for every project.
- By keeping the module modular, we can update it (like adding features or security improvements) without breaking everything.

**What’s good about it**:
- It speeds up development since there’s less Terraform code to maintain.
- It helps keep everything consistent across projects, which is a big win for compliance.

## How This Helps Teams Move Faster

This setup helps teams provision infrastructure quickly because:

1. **Less Complexity**: Teams don’t have to deal with separate configs for each environment. Workspaces and `config.yaml` handle all the environment-specific stuff.

2. **Built-in Standards**: Things like `SSE-S3` encryption and public access blocking are baked in as defaults, so teams don’t have to worry about security settings.

3. **One Source of Truth**: By using `config.yaml`, everything is centralized. Teams can easily see what’s going on and update settings in one place.

4. **Easier Onboarding**: New team members don’t need to know all the ins and outs of S3 bucket config.

## Future Ideas

Down the road, we could expand this module to include more features like logging, versioning policies, or even cross-region replication. That way, teams could have a fully production-ready setup with just a few changes in `config.yaml`.

Some updates can also be made to integrate this with CI/CD tooling and manage environment config based on branch instead of explicitly in the `config.yaml`. 
