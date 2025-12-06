output "elb_dns_name" {
  value = aws_elb.web.dns_name
}

output "instance_names" {
  value = aws_instance.web[*].tags["Name"]
}
