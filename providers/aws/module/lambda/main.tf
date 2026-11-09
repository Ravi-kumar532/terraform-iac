resource "aws_lambda_function" "this" {
  function_name                  = var.name
  role                           = var.execution_role_arn
  runtime                        = var.runtime
  handler                        = var.handler
  s3_bucket                      = var.package_bucket
  s3_key                         = var.package_key
  timeout                        = var.timeout
  memory_size                    = var.memory_size
  reserved_concurrent_executions = var.reserved_concurrency
  kms_key_arn                    = var.kms_key_arn
  publish                        = true
  environment {
    variables = var.environment_variables
  }
  tags = var.tags
}
