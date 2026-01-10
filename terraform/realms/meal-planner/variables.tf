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

variable "mcp_local_url" {
  type    = string
  default = "http://localhost:8000"
}

variable "mcp_production_url" {
  type    = string
  default = "https://meal-planner.cumulus-creations.com"
}

variable "additional_redirect_uris" {
  type    = list(string)
  default = []
}

variable "additional_audience_urls" {
  type        = list(string)
  default     = []
  description = "Additional audience URLs for JWT aud claim (e.g., ngrok URLs)"
}

variable "create_test_user" {
  type    = bool
  default = false
}

variable "test_user_password" {
  type      = string
  sensitive = true
  default   = ""
}
