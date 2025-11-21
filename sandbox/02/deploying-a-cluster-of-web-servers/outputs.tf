output "public_ip" {
  description = "The public IP address of the web server"
  value       = data.aws_subnets.default.ids
}

output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value = aws_lb.example.dns_name
}