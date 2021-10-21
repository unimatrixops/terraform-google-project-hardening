#-------------------------------------------------------------------------------
#
#   GOOGLE CLOUD PROJECT HARDENING
#
#   Hardens a Google Cloud Platform project.
#
#   - Create a DNS zone for googleapis.com for use with private services.
#   - Create DNS zones for Artifact Registry and Container Registry so that
#     they can be used by services that do not have a public IP address
#     e.g. GKE clusters.
#
#-------------------------------------------------------------------------------


module "private-dns" {
  source = "./modules/private-dns"
  dns_artifact_registry_name  = var.dns_artifact_registry_name
  dns_container_registry_name = var.dns_container_registry_name
  dns_googleapis_name         = var.dns_googleapis_name
  networks                    = var.hardened_networks
  project                     = var.project
}
