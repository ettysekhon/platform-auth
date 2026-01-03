terraform {
  required_version = ">= 1.14.0"

  required_providers {
    keycloak = {
      source  = "keycloak/keycloak"
      version = ">= 5.6.0"
    }
  }

  backend "gcs" {
    bucket = "tf-state-simple-gcp-data-pipeline"
    prefix = "keycloak/meal-planner"
  }
}

provider "keycloak" {
  client_id = "admin-cli"
  username  = var.keycloak_admin_username
  password  = var.keycloak_admin_password
  url       = var.keycloak_url
}
