output "elb_dns_name" {
  value = module.nginx.elb_dns_name
}

output "instance_names" {
  value = module.nginx.instance_names
}
