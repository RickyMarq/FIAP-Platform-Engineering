terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0"
    }
  }
}

# Provider pode ficar no root,
# mas também funciona aqui caso você prefira:
provider "aws" {
  region = var.aws_region
}

data "aws_vpc" "vpc" {
  default = true
}

data "aws_subnets" "all" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
}

data "aws_subnet" "public" {
  for_each = toset(data.aws_subnets.all.ids)
  id       = each.value
}

resource "random_shuffle" "random_subnet" {
  input        = [for s in data.aws_subnet.public : s.id]
  result_count = 1
}

# SG do módulo com workspace no nome
resource "aws_security_group" "allow_ssh_http" {
  name        = "nginx-sg-${terraform.workspace}"
  description = "SG nginx ${terraform.workspace}"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_cidr_blocks
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "nginx-sg-${terraform.workspace}"
    Environment = terraform.workspace
  }
}

# ELB com workspace no nome
resource "aws_elb" "web" {
  name = "terraform-example-elb-${terraform.workspace}"

  subnets         = data.aws_subnets.all.ids
  security_groups = [aws_security_group.allow_ssh_http.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 6
  }

  instances = aws_instance.web[*].id

  tags = {
    Name        = "terraform-example-elb-${terraform.workspace}"
    Environment = terraform.workspace
  }
}

resource "aws_instance" "web" {
  count         = var.node_count
  instance_type = "t3.micro"
  ami           = lookup(var.aws_amis, var.aws_region)

  subnet_id              = random_shuffle.random_subnet.result[0]
  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]
  key_name               = var.KEY_NAME

provisioner "file" {
  source      = "${path.module}/script.sh"
  destination = "/tmp/script.sh"
}

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "sudo /tmp/script.sh",
    ]
  }

  connection {
    user        = var.INSTANCE_USERNAME
    private_key = file(var.PATH_TO_KEY)
    host        = self.public_dns
  }

  tags = {
    # Nomes das máquinas com workspace
    Name        = format("nginx-%s-%03d", terraform.workspace, count.index + 1)
    Environment = terraform.workspace
  }
}
