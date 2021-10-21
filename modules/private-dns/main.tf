#######################################################################
#
#   DNS
#
#   - Create a DNS zone for *.googleapis.com so that it points to
#     the correct internal address.
#   - Create a DNS zone for gcr.io, also pointing to the correct
#     records.
#   - Create a CNAME record for *.googleapis.com to restricted.googleapis.com.
#   - Create an A record for the internal Google APIs addresses to
#     restricted.googleapis.com.
#   - Create a CNAME record aliasing *.gcr.io to gcr.io.
#   - Create an A record for the internal addresses of gcr.io.
#
#######################################################################
variable "dns_artifact_registry_name" { type=string }
variable "dns_container_registry_name" { type=string }
variable "dns_googleapis_name" { type=string }
variable "project" { type=string }
variable "networks" { type=list(string) }


data "google_compute_network" "networks" {
  for_each  = toset(var.networks)
  project   = var.project
  name      = each.value
}


resource "google_dns_managed_zone" "googleapis_com" {
  project     = var.project
  name        = var.dns_googleapis_name
  dns_name    = "googleapis.com."
  description = "Private zone for Google APIs"
  visibility  = "private"

  dynamic "private_visibility_config" {
    for_each = data.google_compute_network.networks

    content {
      networks {
        network_url = private_visibility_config.value.self_link
      }
    }
  }
}


resource "google_dns_managed_zone" "gcr_io" {
  project     = var.project
  name        = var.dns_container_registry_name
  dns_name    = "gcr.io."
  description = "Private zone for Google Container Registry (GCR)"
  visibility  = "private"

  dynamic "private_visibility_config" {
    for_each = data.google_compute_network.networks

    content {
      networks {
        network_url = private_visibility_config.value.self_link
      }
    }
  }
}


resource "google_dns_managed_zone" "pkg_dev" {
  project     = var.project
  name        = var.dns_artifact_registry_name
  dns_name    = "pkg.dev."
  description = "Private zone for Google Artifact Registry"
  visibility  = "private"

  dynamic "private_visibility_config" {
    for_each = data.google_compute_network.networks

    content {
      networks {
        network_url = private_visibility_config.value.self_link
      }
    }
  }
}


resource "google_dns_record_set" "googleapis_com" {
  project       = var.project
  name          = "*.googleapis.com."
  managed_zone  = google_dns_managed_zone.googleapis_com.name
  type          = "CNAME"
  ttl           = 300
  rrdatas       = ["restricted.googleapis.com."]
}


resource "google_dns_record_set" "restricted_googleapis_com" {
  project       = var.project
  name          = "restricted.googleapis.com."
  type          = "A"
  ttl           = 300
  managed_zone  = google_dns_managed_zone.googleapis_com.name
  rrdatas       = [
    "199.36.153.4",
    "199.36.153.5",
    "199.36.153.6",
    "199.36.153.7",
  ]
}


resource "google_dns_record_set" "alias_gcr_io" {
  project       = var.project
  name          = "*.gcr.io."
  managed_zone  = google_dns_managed_zone.gcr_io.name
  type          = "CNAME"
  ttl           = 300
  rrdatas       = ["gcr.io."]
}


resource "google_dns_record_set" "gcr_io" {
  project       = var.project
  name          = "gcr.io."
  type          = "A"
  ttl           = 300
  managed_zone  = google_dns_managed_zone.gcr_io.name
  rrdatas       = [
    "199.36.153.4",
    "199.36.153.5",
    "199.36.153.6",
    "199.36.153.7",
  ]
}



resource "google_dns_record_set" "alias_pkg_dev" {
  project       = var.project
  name          = "*.pkg.dev."
  managed_zone  = google_dns_managed_zone.pkg_dev.name
  type          = "CNAME"
  ttl           = 300
  rrdatas       = ["pkg.dev."]
}


resource "google_dns_record_set" "pkg_dev" {
  project       = var.project
  name          = "pkg.dev."
  type          = "A"
  ttl           = 300
  managed_zone  = google_dns_managed_zone.pkg_dev.name
  rrdatas       = [
    "199.36.153.4",
    "199.36.153.5",
    "199.36.153.6",
    "199.36.153.7",
  ]
}
