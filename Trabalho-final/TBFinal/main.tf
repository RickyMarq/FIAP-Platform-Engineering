locals {
  node_count = lookup(var.node_count_by_workspace, terraform.workspace, var.default_node_count)
}

module "nginx" {
  source = "./modules/nginx_count"

  aws_region        = var.aws_region
  project           = var.project
  node_count        = local.node_count
  aws_amis          = var.aws_amis
  KEY_NAME          = var.KEY_NAME
  INSTANCE_USERNAME = var.INSTANCE_USERNAME
  PATH_TO_KEY       = var.PATH_TO_KEY
}
