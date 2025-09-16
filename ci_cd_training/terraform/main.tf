# Read the version from version.txt file
locals {
  version = trimspace(file("${path.module}/../src/version.txt"))
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
}

# Upload the zip file with version in the name to force redeployment
resource "google_storage_bucket_object" "ci_cd_training_function_source" {
  name   = "function-source-${local.version}.zip"
  bucket = google_storage_bucket.ci_cd_training_function_source_bucket.name
  source = data.archive_file.ci_cd_training_function_source.output_path
}

resource "google_cloudfunctions2_function" "ci_cd_training_function" {
  name        = "${var.trainee_name}-ci-cd-training-function"
  location    = var.region
  description = "a new function"

  build_config {
    runtime = "python312"
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
  }

  # This ensures the function is redeployed when the source changes
  depends_on = [google_storage_bucket_object.ci_cd_training_function_source]
}