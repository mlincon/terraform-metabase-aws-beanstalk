output "ebs_service_role" {
  description = "Role ARN"
  value       = aws_iam_role.ebs-service-role.arn
}

output "metabse_db_endpoint" {
  description = "Postgres DB Endpoint"
  value       = aws_db_instance.metabase-postgres-db.endpoint
}

output "metabase_endpoint" {
  description = "Application Endpoint"
  value       = aws_elastic_beanstalk_environment.metabase-env.cname
}