output "elastic_beanstalk_application_name" {
    description = "Name of the elastic beanstalk application"
    value = aws_elastic_beanstalk_application.metabase-app.name
}