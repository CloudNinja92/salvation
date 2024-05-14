terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.27.0"
    }
  }
}

provider "google" {
  # Configuration options
project = "stellar-aurora-413600"
region = "us-west4"
zone = "us-west4-a"
credentials = "stellar-aurora-413600-81017f2c74c3.json"
}

resource "google_storage_bucket" "bucket" {
  name     = "ninja-bucket92"
  location = "US"
  force_destroy = true
  storage_class = "STANDARD"

website {
    main_page_suffix = "index.html"
    not_found_page   = "error.html"
    }   

  uniform_bucket_level_access = false

}


// Uploading and setting public read access for HTML files
resource "google_storage_bucket_object" "upload_html" {
  for_each     = fileset("${path.module}/", "*.html")
  bucket       = google_storage_bucket.bucket.name
  name         = each.value
  source       = "${path.module}/${each.value}"
  content_type = "text/html"
}

// Public ACL for each HTML file
resource "google_storage_object_acl" "html_acl" {
  for_each       = google_storage_bucket_object.upload_html
  bucket         = google_storage_bucket_object.upload_html[each.key].bucket
  object         = google_storage_bucket_object.upload_html[each.key].name
  predefined_acl = "publicRead"
}

// Uploading and setting public read access for image files
resource "google_storage_bucket_object" "upload_images" {
  for_each     = fileset("${path.module}/", "*.jpg")
  bucket       = google_storage_bucket.bucket.name
  name         = each.value
  source       = "${path.module}/${each.value}"
  content_type = "image/jpeg"
}

// Public ACL for each image file
resource "google_storage_object_acl" "image_acl" {
  for_each       = google_storage_bucket_object.upload_images
  bucket         = google_storage_bucket_object.upload_images[each.key].bucket
  object         = google_storage_bucket_object.upload_images[each.key].name
  predefined_acl = "publicRead"
}

resource "google_storage_bucket_object" "picture" {
  name   = "woman_with_coffee"
  source = "/terraform/armageddon hw/Task1/woman_with_coffee.jpg"
  bucket = "ninja-bucket92"
}

output "website_url" {
  value = "https://storage.googleapis.com/${google_storage_bucket.bucket.name}/index.html"
}

