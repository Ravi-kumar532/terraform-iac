locals {
  environment_names = toset(concat([var.environment_name], var.environment_names))
}

resource "aws_elastic_beanstalk_application" "this" {
  name        = var.name
  description = var.description
  tags        = var.tags
}

resource "aws_elastic_beanstalk_application_version" "this" {
  name        = var.version_label
  application = aws_elastic_beanstalk_application.this.name
  bucket      = var.source_bucket
  key         = var.source_key
  tags        = var.tags
}

resource "aws_elastic_beanstalk_environment" "this" {
  for_each            = local.environment_names
  name                = each.value
  application         = aws_elastic_beanstalk_application.this.name
  solution_stack_name = var.solution_stack_name
  version_label       = aws_elastic_beanstalk_application_version.this.name
  tier                = "WebServer"
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = var.service_role_arn
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = var.instance_profile_name
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = tostring(var.min_instances)
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = tostring(var.max_instances)
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "LoadBalanced"
  }
  setting {
    namespace = "aws:elbv2:loadbalancer"
    name      = "Scheme"
    value     = var.load_balancer_scheme
  }
  setting {
    namespace = "aws:elbv2:listener:default"
    name      = "ListenerEnabled"
    value     = "false"
  }
  setting {
    namespace = "aws:elbv2:listener:443"
    name      = "ListenerEnabled"
    value     = "true"
  }
  setting {
    namespace = "aws:elbv2:listener:443"
    name      = "Protocol"
    value     = "HTTPS"
  }
  setting {
    namespace = "aws:elbv2:listener:443"
    name      = "SSLCertificateArns"
    value     = var.certificate_arn
  }
  tags = var.tags
}
