output "db_endpoint" {
  value = aws_db_instance.postgres.endpoint
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_ids" {
  value = aws_subnet.public[*].id
}