resource "keycloak_realm" "meal_planner" {
  realm        = var.realm_name
  enabled      = true
  display_name = var.realm_display_name

  login_with_email_allowed = true
  registration_allowed     = true
  reset_password_allowed   = true
  remember_me              = true
  verify_email             = false
  login_theme              = "keycloak"

  access_token_lifespan                   = "5m"
  access_token_lifespan_for_implicit_flow = "15m"
  sso_session_idle_timeout                = "30m"
  sso_session_max_lifespan                = "10h"
  offline_session_idle_timeout            = "720h"
  access_code_lifespan                    = "1m"
  access_code_lifespan_user_action        = "5m"
  access_code_lifespan_login              = "30m"

  ssl_required = "external"
  # Brute force: configure via UI (provider limitation)
}

resource "keycloak_role" "user" {
  realm_id    = keycloak_realm.meal_planner.id
  name        = "user"
  description = "Standard user role - basic access to meal planning features"
}

resource "keycloak_role" "premium" {
  realm_id    = keycloak_realm.meal_planner.id
  name        = "premium"
  description = "Premium subscription user - access to advanced features and nutrition analysis"
}

resource "keycloak_role" "admin" {
  realm_id    = keycloak_realm.meal_planner.id
  name        = "admin"
  description = "Administrator role - full system access including user management"
}

resource "keycloak_group" "family_plan" {
  realm_id = keycloak_realm.meal_planner.id
  name     = "family-plan"
  attributes = {
    "plan_type"          = "family"
    "max_family_members" = "6"
  }
}

resource "keycloak_group" "individual" {
  realm_id = keycloak_realm.meal_planner.id
  name     = "individual"
  attributes = {
    "plan_type"          = "individual"
    "max_family_members" = "1"
  }
}

resource "keycloak_openid_client_scope" "openid" {
  realm_id               = keycloak_realm.meal_planner.id
  name                   = "openid"
  description            = "OpenID Connect scope"
  include_in_token_scope = false
  consent_screen_text    = "Authenticate using your identity"
}

data "keycloak_openid_client_scope" "profile" {
  realm_id = keycloak_realm.meal_planner.id
  name     = "profile"
}

data "keycloak_openid_client_scope" "email" {
  realm_id = keycloak_realm.meal_planner.id
  name     = "email"
}

data "keycloak_openid_client_scope" "offline_access" {
  realm_id = keycloak_realm.meal_planner.id
  name     = "offline_access"
}

data "keycloak_openid_client_scope" "roles" {
  realm_id = keycloak_realm.meal_planner.id
  name     = "roles"
}

data "keycloak_openid_client_scope" "web_origins" {
  realm_id = keycloak_realm.meal_planner.id
  name     = "web-origins"
}

data "keycloak_openid_client_scope" "acr" {
  realm_id = keycloak_realm.meal_planner.id
  name     = "acr"
}

data "keycloak_openid_client_scope" "phone" {
  realm_id = keycloak_realm.meal_planner.id
  name     = "phone"
}

data "keycloak_openid_client_scope" "address" {
  realm_id = keycloak_realm.meal_planner.id
  name     = "address"
}

data "keycloak_openid_client_scope" "microprofile_jwt" {
  realm_id = keycloak_realm.meal_planner.id
  name     = "microprofile-jwt"
}

data "keycloak_openid_client_scope" "basic" {
  realm_id = keycloak_realm.meal_planner.id
  name     = "basic"
}

data "keycloak_openid_client_scope" "service_account" {
  realm_id = keycloak_realm.meal_planner.id
  name     = "service_account"
}

data "keycloak_openid_client_scope" "organization" {
  realm_id = keycloak_realm.meal_planner.id
  name     = "organization"
}

resource "keycloak_openid_client_scope" "recipes_read" {
  realm_id               = keycloak_realm.meal_planner.id
  name                   = "meal-planner:recipes:read"
  description            = "Read access to recipes"
  include_in_token_scope = true
  consent_screen_text    = "View recipes and your recipe library"
}

resource "keycloak_openid_client_scope" "recipes_write" {
  realm_id               = keycloak_realm.meal_planner.id
  name                   = "meal-planner:recipes:write"
  description            = "Write access to recipes"
  include_in_token_scope = true
  consent_screen_text    = "Create, edit, and delete your recipes"
}

resource "keycloak_openid_client_scope" "plans_read" {
  realm_id               = keycloak_realm.meal_planner.id
  name                   = "meal-planner:plans:read"
  description            = "Read access to meal plans"
  include_in_token_scope = true
  consent_screen_text    = "View your meal plans and schedule"
}

resource "keycloak_openid_client_scope" "plans_write" {
  realm_id               = keycloak_realm.meal_planner.id
  name                   = "meal-planner:plans:write"
  description            = "Write access to meal plans"
  include_in_token_scope = true
  consent_screen_text    = "Create and modify your meal plans"
}

resource "keycloak_openid_client_scope" "shopping_read" {
  realm_id               = keycloak_realm.meal_planner.id
  name                   = "meal-planner:shopping:read"
  description            = "Read access to shopping lists"
  include_in_token_scope = true
  consent_screen_text    = "View your shopping lists"
}

resource "keycloak_openid_client_scope" "shopping_write" {
  realm_id               = keycloak_realm.meal_planner.id
  name                   = "meal-planner:shopping:write"
  description            = "Write access to shopping lists"
  include_in_token_scope = true
  consent_screen_text    = "Manage and modify your shopping lists"
}

resource "keycloak_openid_client_scope" "nutrition_read" {
  realm_id               = keycloak_realm.meal_planner.id
  name                   = "meal-planner:nutrition:read"
  description            = "Read access to nutrition analysis"
  include_in_token_scope = true
  consent_screen_text    = "View nutrition information and meal analysis"
}

resource "keycloak_openid_client_scope" "premium_access" {
  realm_id               = keycloak_realm.meal_planner.id
  name                   = "meal-planner:premium:access"
  description            = "Access to premium features"
  include_in_token_scope = true
  consent_screen_text    = "Access premium meal planning features"
}

resource "keycloak_openid_client_scope" "admin_manage" {
  realm_id               = keycloak_realm.meal_planner.id
  name                   = "meal-planner:admin:manage"
  description            = "Administrative operations"
  include_in_token_scope = true
  consent_screen_text    = "Perform administrative operations (admin only)"
}

resource "keycloak_openid_client" "mcp_server" {
  realm_id    = keycloak_realm.meal_planner.id
  client_id   = var.mcp_client_id
  name        = "Meal Planner MCP"
  enabled     = true
  description = "Conversational meal planning MCP server"

  access_type                  = "CONFIDENTIAL"
  standard_flow_enabled        = true
  implicit_flow_enabled        = false
  direct_access_grants_enabled = false
  service_accounts_enabled     = false
  pkce_code_challenge_method   = "S256"
  consent_required             = true

  valid_redirect_uris = concat(
    [
      "${var.mcp_server_urls.local}/auth/callback",
      "${var.mcp_server_urls.production}/auth/callback",
      "${var.mcp_server_urls.ngrok}/auth/callback",
    ],
    var.additional_redirect_uris
  )

  valid_post_logout_redirect_uris = [
    "${var.mcp_server_urls.local}/*",
    "${var.mcp_server_urls.production}/*",
    "${var.mcp_server_urls.ngrok}/*",
  ]

  web_origins = [
    var.mcp_server_urls.local,
    var.mcp_server_urls.production,
    var.mcp_server_urls.ngrok,
  ]

  backchannel_logout_session_required        = true
  backchannel_logout_revoke_offline_sessions = false
}

resource "keycloak_openid_client_default_scopes" "mcp_default_scopes" {
  realm_id  = keycloak_realm.meal_planner.id
  client_id = keycloak_openid_client.mcp_server.id

  default_scopes = [
    keycloak_openid_client_scope.openid.name,
    data.keycloak_openid_client_scope.profile.name,
    data.keycloak_openid_client_scope.email.name,
    keycloak_openid_client_scope.recipes_read.name,
    keycloak_openid_client_scope.recipes_write.name,
    keycloak_openid_client_scope.plans_read.name,
    keycloak_openid_client_scope.plans_write.name,
    keycloak_openid_client_scope.shopping_read.name,
    keycloak_openid_client_scope.shopping_write.name,
  ]
}

resource "keycloak_openid_client_optional_scopes" "mcp_optional_scopes" {
  realm_id  = keycloak_realm.meal_planner.id
  client_id = keycloak_openid_client.mcp_server.id

  optional_scopes = [
    data.keycloak_openid_client_scope.offline_access.name,
    data.keycloak_openid_client_scope.roles.name,
    data.keycloak_openid_client_scope.web_origins.name,
    data.keycloak_openid_client_scope.acr.name,
    data.keycloak_openid_client_scope.phone.name,
    data.keycloak_openid_client_scope.address.name,
    data.keycloak_openid_client_scope.microprofile_jwt.name,
    data.keycloak_openid_client_scope.basic.name,
    data.keycloak_openid_client_scope.service_account.name,
    data.keycloak_openid_client_scope.organization.name,
    keycloak_openid_client_scope.nutrition_read.name,
    keycloak_openid_client_scope.premium_access.name,
    keycloak_openid_client_scope.admin_manage.name,
  ]
}

resource "keycloak_openid_audience_protocol_mapper" "localhost_audience" {
  realm_id                 = keycloak_realm.meal_planner.id
  client_id                = keycloak_openid_client.mcp_server.id
  name                     = "localhost-audience"
  included_custom_audience = var.mcp_server_urls.local
  add_to_id_token          = false
  add_to_access_token      = true
}

resource "keycloak_openid_audience_protocol_mapper" "production_audience" {
  realm_id                 = keycloak_realm.meal_planner.id
  client_id                = keycloak_openid_client.mcp_server.id
  name                     = "production-audience"
  included_custom_audience = var.mcp_server_urls.production
  add_to_id_token          = false
  add_to_access_token      = true
}

resource "keycloak_openid_audience_protocol_mapper" "ngrok_audience" {
  realm_id                 = keycloak_realm.meal_planner.id
  client_id                = keycloak_openid_client.mcp_server.id
  name                     = "ngrok-audience"
  included_custom_audience = var.mcp_server_urls.ngrok
  add_to_id_token          = false
  add_to_access_token      = true
}

resource "keycloak_openid_user_realm_role_protocol_mapper" "realm_roles" {
  realm_id            = keycloak_realm.meal_planner.id
  client_id           = keycloak_openid_client.mcp_server.id
  name                = "realm-roles-mapper"
  claim_name          = "realm_access.roles"
  multivalued         = true
  add_to_id_token     = true
  add_to_access_token = true
  add_to_userinfo     = true
}

resource "keycloak_openid_group_membership_protocol_mapper" "groups" {
  realm_id            = keycloak_realm.meal_planner.id
  client_id           = keycloak_openid_client.mcp_server.id
  name                = "groups-mapper"
  claim_name          = "groups"
  full_path           = true
  add_to_id_token     = true
  add_to_access_token = true
  add_to_userinfo     = true
}

resource "keycloak_openid_user_attribute_protocol_mapper" "subscription_tier" {
  realm_id            = keycloak_realm.meal_planner.id
  client_id           = keycloak_openid_client.mcp_server.id
  name                = "subscription-tier-mapper"
  user_attribute      = "subscription_tier"
  claim_name          = "subscription_tier"
  add_to_id_token     = true
  add_to_access_token = true
  add_to_userinfo     = true
}

resource "keycloak_openid_user_attribute_protocol_mapper" "dietary_preferences" {
  realm_id            = keycloak_realm.meal_planner.id
  client_id           = keycloak_openid_client.mcp_server.id
  name                = "dietary-preferences-mapper"
  user_attribute      = "dietary_preferences"
  claim_name          = "dietary_preferences"
  claim_value_type    = "JSON"
  multivalued         = true
  add_to_id_token     = false
  add_to_access_token = true
  add_to_userinfo     = true
}

resource "keycloak_openid_user_attribute_protocol_mapper" "max_family_members" {
  realm_id            = keycloak_realm.meal_planner.id
  client_id           = keycloak_openid_client.mcp_server.id
  name                = "max-family-members-mapper"
  user_attribute      = "max_family_members"
  claim_name          = "max_family_members"
  claim_value_type    = "int"
  add_to_id_token     = false
  add_to_access_token = true
  add_to_userinfo     = false
}

resource "keycloak_user" "test_user" {
  count    = var.create_test_user ? 1 : 0
  realm_id = keycloak_realm.meal_planner.id
  username = "testuser"
  enabled  = true

  email          = "test@example.com"
  email_verified = true
  first_name     = "Test"
  last_name      = "User"

  attributes = {
    "subscription_tier"   = "basic"
    "dietary_preferences" = "[\"vegetarian\"]"
    "max_family_members"  = "4"
  }

  initial_password {
    value     = var.test_user_password
    temporary = false
  }
}

resource "keycloak_user_roles" "test_user_roles" {
  count    = var.create_test_user ? 1 : 0
  realm_id = keycloak_realm.meal_planner.id
  user_id  = keycloak_user.test_user[0].id
  role_ids = [keycloak_role.user.id]
}

resource "keycloak_group_memberships" "test_user_groups" {
  count    = var.create_test_user ? 1 : 0
  realm_id = keycloak_realm.meal_planner.id
  group_id = keycloak_group.individual.id
  members  = [keycloak_user.test_user[0].username]
}
