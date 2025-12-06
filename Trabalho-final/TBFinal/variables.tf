variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project" {
  type    = string
  default = "fiap-lab"
}

variable "aws_amis" {
  type = map(string)
}

variable "KEY_NAME" {
  type = string
}

variable "INSTANCE_USERNAME" {
  type    = string
  default = "ec2-user"
}

variable "PATH_TO_KEY" {
  type = string
}

# Quantidade por ambiente
variable "node_count_by_workspace" {
  type = map(number)
  default = {
    dev  = 2
    prod = 4
  }
}

variable "default_node_count" {
  type    = number
  default = 2
}
