variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project" {
  type    = string
  default = "fiap-lab"
}

variable "node_count" {
  type        = number
  description = "Quantidade de instâncias atrás do ELB."
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

variable "ssh_cidr_blocks" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}
