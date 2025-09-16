# Read the version from version.txt file
locals {
  version = trimspace(file("${path.module}/../src/version.txt"))
}

# Create a separate bucket for logging bucket access logs (to avoid circular dependency)
resource "google_storage_bucket" "ci_cd_training_function_source_audit_logs_bucket" {
  name                        = "${var.trainee_name}-gcf-source-audit-logs"
  location                    = var.region
  uniform_bucket_level_access = true

  # Enable versioning for audit log bucket
  versioning {
    enabled = true
  }

  # Enforce public access prevention for audit log bucket
  public_access_prevention = "enforced"

  # Enable access logging for the audit logs bucket (CKV_GCP_62)
  # Note: This creates a circular dependency scenario, but we'll log to itself with a different prefix
  logging {
    log_bucket        = "${var.trainee_name}-gcf-source-audit-logs"
    log_object_prefix = "audit-logs-access-logs/"
  }
}

# Create logging bucket for access logs
resource "google_storage_bucket" "ci_cd_training_function_source_logs_bucket" {
  name                        = "${var.trainee_name}-gcf-source-logs"
  location                    = var.region
  uniform_bucket_level_access = true

  # Enable versioning for log bucket
  versioning {
    enabled = true
  }

  # Enforce public access prevention for log bucket
  public_access_prevention = "enforced"

  # Enable access logging for the logging bucket (CKV_GCP_62)
  logging {
    log_bucket        = "${var.trainee_name}-gcf-source-audit-logs"
    log_object_prefix = "logging-bucket-access-logs/"
  }
}

# Automatically create a zip archive of the source code
data "archive_file" "ci_cd_training_function_source" {
  type        = "zip"
  source_dir  = "${path.module}/../src"
  output_path = "${path.module}/function-source-${local.version}.zip"
}

resource "google_storage_bucket" "ci_cd_training_function_source_bucket" {
  name                        = "${var.trainee_name}-gcf-source"
  location                    = "US"
  uniform_bucket_level_access = true

  # Enable versioning (CKV_GCP_78)
  versioning {
    enabled = true
  }

  # Enforce public access prevention (CKV_GCP_114)
  public_access_prevention = "enforced"

  # Enable access logging (CKV_GCP_62)
  logging {
    log_bucket        = "${var.trainee_name}-gcf-source-logs"
    log_object_prefix = "access-logs/"
  }
}

# Upload the zip file with version in the name to force redeployment
resource "google_storage_bucket_object" "ci_cd_training_function_source" {
  name   = "function-source-${local.version}.zip"
  bucket = google_storage_bucket.ci_cd_training_function_source_bucket.name
  source = data.archive_file.ci_cd_training_function_source.output_path
}

resource "google_cloudfunctions2_function" "ci_cd_training_function" {
  name        = "${var.trainee_name}-ci-cd-training"
  location    = var.region
  description = "a new function"

  build_config {
    runtime     = "python312"
    entry_point = "ci_cd_training_function"
    source {
      storage_source {
        bucket = google_storage_bucket.ci_cd_training_function_source_bucket.name
        object = google_storage_bucket_object.ci_cd_training_function_source.name
      }
    }
  }

  service_config {
    max_instance_count = 1
    available_memory   = "256M"
    timeout_seconds    = 60
    # Restrict ingress to internal traffic only (CKV_GCP_124)
    ingress_settings = "ALLOW_INTERNAL_ONLY"
  }

  # This ensures the function is redeployed when the source changes
  depends_on = [google_storage_bucket_object.ci_cd_training_function_source]
}