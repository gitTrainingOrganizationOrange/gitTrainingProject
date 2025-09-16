# Terraform CI/CD Training Infrastructure

This directory contains Terraform configuration for the CI/CD training project.

## CI/CD Pipeline

The Terraform CI/CD pipeline includes the following best practices:

### 1. Code Quality Checks
- **Format Check**: Ensures all Terraform files follow standard formatting (`terraform fmt`)
- **Validation**: Validates Terraform configuration syntax (`terraform validate`)

### 2. Security Scanning
- **tfsec**: Static analysis security scanner for Terraform
- **Checkov**: Policy-as-code tool for infrastructure security

### 3. Workflow Stages
1. **terraform-quality**: Runs format, validation, and security checks
2. **terraform-pipeline**: Executes plan/apply based on branch
   - Pull Requests: Runs `terraform plan` and comments results
   - Master branch: Runs `terraform apply` automatically

## Configuration Files

- `.tfsec.yml`: Configuration for tfsec security scanner
- `.checkov.yml`: Configuration for Checkov policy scanner

## Local Development

Before pushing changes:

```bash
# Format your Terraform files
terraform fmt -recursive

# Validate configuration
terraform init -backend=false
terraform validate

# Run security scans locally
tfsec .
checkov -d .
```

## Security Considerations

The pipeline enforces:
- Proper code formatting
- Valid Terraform syntax
- Security best practices via automated scanning
- Review via pull request comments before applying changes
