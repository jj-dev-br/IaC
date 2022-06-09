terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 3.27"
        }
    }

    required_version = ">= 0.14.9"
}

provider "aws" {
    profile = "default"
    region = var.var_aws_region
}

resource "aws_instance" "app_server" {
    ami           = "ami-03d5c68bab01f3496"
    instance_type = var.var_instance
    key_name = var.var_key
    tags = {
        Name = "Terraform Ansible Python"
    }
}

resource "aws_key_pair" "chaveSSH" {
    key_name = var.var_key
    public_key = file("${var.var_key}.pub")
}

output "public_ip" {
    value = aws_instance.app_server.public_ip
}