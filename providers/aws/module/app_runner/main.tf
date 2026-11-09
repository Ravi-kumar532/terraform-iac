resource "aws_apprunner_auto_scaling_configuration_version" "this" {

  auto_scaling_configuration_name = "${var.name}-scaling"
  max_concurrency                 = var.max_concurrency
  max_size                        = var.max_instances
  min_size                        = var.min_instances

}
resource "aws_apprunner_service" "this" {

  service_name                   = var.name
  auto_scaling_configuration_arn = aws_apprunner_auto_scaling_configuration_version.this.arn
  source_configuration {
    auto_deployments_enabled = false
    authentication_configuration {
      access_role_arn = var.ecr_access_role_arn
    }
    image_repository {
      image_identifier      = var.image_identifier
      image_repository_type = "ECR"
      image_configuration {
        port                          = var.port
        runtime_environment_variables = var.environment_variables
      }
    }
  }
  instance_configuration {
    cpu               = var.cpu
    memory            = var.memory
    instance_role_arn = var.instance_role_arn
  }
  network_configuration {

    ingress_configuration {
      is_publicly_accessible = var.publicly_accessible
    }
    egress_configuration {
      egress_type = "DEFAULT"
    }
  }
  tags = var.tags

}
