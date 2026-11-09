resource "aws_appconfig_application" "this" {
  name        = var.name
  description = var.description
  tags        = var.tags
}

resource "aws_appconfig_environment" "this" {
  name           = var.environment_name
  application_id = aws_appconfig_application.this.id
  description    = var.environment_description
  tags           = var.tags
}

resource "aws_appconfig_configuration_profile" "this" {
  application_id = aws_appconfig_application.this.id
  name           = var.configuration_profile_name
  location_uri   = "hosted"
  type           = "AWS.Freeform"
  description    = var.description
  tags           = var.tags
}

resource "aws_appconfig_hosted_configuration_version" "this" {
  application_id           = aws_appconfig_application.this.id
  configuration_profile_id = aws_appconfig_configuration_profile.this.configuration_profile_id
  content                  = base64encode(jsonencode(var.configuration))
  content_type             = "application/json"
  description              = var.description
}

resource "aws_appconfig_deployment_strategy" "this" {
  name                           = var.deployment_strategy_name
  deployment_duration_in_minutes = var.deployment_duration_in_minutes
  growth_factor                  = var.deployment_growth_factor
  growth_type                    = "LINEAR"
  final_bake_time_in_minutes     = var.final_bake_time_in_minutes
  replicate_to                   = "NONE"
  tags                           = var.tags
}

resource "aws_appconfig_deployment" "this" {
  application_id           = aws_appconfig_application.this.id
  configuration_profile_id = aws_appconfig_configuration_profile.this.configuration_profile_id
  configuration_version    = aws_appconfig_hosted_configuration_version.this.version_number
  deployment_strategy_id   = aws_appconfig_deployment_strategy.this.id
  environment_id           = aws_appconfig_environment.this.environment_id
  description              = var.description
}
