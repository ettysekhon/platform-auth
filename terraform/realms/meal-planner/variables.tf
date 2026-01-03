variable "keycloak_url" {
  type    = string
  default = "https://auth.cumulus-creations.com"
}

variable "keycloak_admin_username" {
  type    = string
  default = "etty"
}

variable "keycloak_admin_password" {
  type      = string
  sensitive = true
}

variable "realm_name" {
  type    = string
  default = "meal-planner"
}

variable "realm_display_name" {
  type    = string
  default = "Meal Planner"
}

variable "mcp_client_id" {
  type    = string
  default = "meal-planner-mcp"
}

variable "mcp_server_urls" {
  type = object({
    local      = string
    production = string
    ngrok      = string
  })
  default = {
    local      = "http://localhost:8000"
    production = "https://meal-planner.cumulus-creations.com"
    ngrok      = "https://75b49b5e66cd.ngrok-free.app"
  }
}

variable "additional_redirect_uris" {
  type = list(string)
  default = [
    "http://localhost:6274/oauth/callback",
    "https://claude.ai/*",
    "https://75b49b5e66cd.ngrok-free.app/*",
  ]
}

variable "create_test_user" {
  type    = bool
  default = true
}

variable "test_user_password" {
  type      = string
  sensitive = true
  default   = "testpass123"
}
