

variable "dns_artifact_registry_name" {
  type=string
  default="artifact-registry"
  description="Specifies the name of the DNS zone for acr.io"
}


variable "dns_container_registry_name" {
  type=string
  default="container-registry"
  description="Specifies the name of the DNS zone for gcr.io"
}


variable "dns_googleapis_name" {
  type=string
  default="google-services"
  description="Specifies the name of the DNS zone for googleapis.com"
}


variable "hardened_networks" {
  type=list(string)
  default=[]
  description="The list of VPC networks to harden for this project."
}


variable "project" {
  type=string
  description="The Google Cloud project to harden."
}
