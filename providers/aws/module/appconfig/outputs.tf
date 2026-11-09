output "id" {
  value = aws_appconfig_application.this.id
}
output "arn" {
  value = aws_appconfig_application.this.arn
}

output "environment_id" {
  value = aws_appconfig_environment.this.environment_id
}

output "configuration_profile_id" {
  value = aws_appconfig_configuration_profile.this.configuration_profile_id
}

output "deployment_id" {
  value = aws_appconfig_deployment.this.deployment_number
}
