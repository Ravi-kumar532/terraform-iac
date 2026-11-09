output "application_name" {
  value = aws_elastic_beanstalk_application.this.name
}
output "environment_id" {
  value = aws_elastic_beanstalk_environment.this[var.environment_name].id
}
output "endpoint_url" {
  value = aws_elastic_beanstalk_environment.this[var.environment_name].endpoint_url
}
output "environment_ids" {
  value = {
    for name, environment in aws_elastic_beanstalk_environment.this : name => environment.id
  }
}
output "endpoint_urls" {
  value = {
    for name, environment in aws_elastic_beanstalk_environment.this : name => environment.endpoint_url
  }
}
