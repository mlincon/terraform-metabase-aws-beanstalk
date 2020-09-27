output "metabase_endpoint" {
  description = "Application Endpoint"
  value       = aws_elastic_beanstalk_environment.metabase-env.cname
}