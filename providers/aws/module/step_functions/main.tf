resource "aws_sfn_state_machine" "this" {
  name       = var.name
  role_arn   = var.execution_role_arn
  definition = var.definition
  type       = var.type
  logging_configuration {
    log_destination        = var.log_destination
    include_execution_data = false
    level                  = "ERROR"
  }
  encryption_configuration {
    type = "AWS_OWNED_KEY"
  }
  tags = var.tags
}
