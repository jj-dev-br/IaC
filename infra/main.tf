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

resource "aws_launch_template" "machine" {
    image_id = "ami-03d5c68bab01f3496"
    instance_type = var.var_instance
    key_name = var.var_key
    tags = {
        Name = "Terraform Ansible Python"
    }
    security_group_names = [ var.var_security_group ]
    user_data = var.var_prod ? filebase64("ansible.sh") : ""
}

resource "aws_key_pair" "chaveSSH" {
    key_name = var.var_key
    public_key = file("${var.var_key}.pub")
}


resource "aws_autoscaling_group" "group" {
    availability_zones = [ "${var.var_aws_region}a", "${var.var_aws_region}b" ]
    name = var.var_group_name
    max_size = var.var_max_size
    min_size = var.var_min_size
    launch_template {
        id = aws_launch_template.machine.id
        version = "$Latest"
    }
    target_group_arns = var.var_prod ? [ aws_lb_target_group.targetLoadBalancer[0].arn ] : []
}

resource "aws_default_subnet" "subnet_1" {
    availability_zone = "${var.var_aws_region}a"
}

resource "aws_default_subnet" "subnet_2" {
    availability_zone = "${var.var_aws_region}b"
}

resource "aws_lb" "loadBalancer" {
    internal = false
    subnets = [ aws_default_subnet.subnet_1.id,  aws_default_subnet.subnet_2.id ]
    count = var.var_prod ? 1 : 0
}

resource "aws_default_vpc" "vpc" {

}

resource "aws_lb_target_group" "targetLoadBalancer" {
    name = "targetLoadBalancer"
    port = "8000"
    protocol = "HTTP"
    vpc_id = aws_default_vpc.vpc.id
    count = var.var_prod ? 1 : 0
}

resource "aws_lb_listener" "listenerLoadBalancer" {
    load_balancer_arn = aws_lb.loadBalancer[0].arn
    port = "8000"
    protocol = "HTTP"
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.targetLoadBalancer[0].arn
    }
    count = var.var_prod ? 1 : 0
}

resource "aws_autoscaling_policy" "prod-scale" {
    name = "terraform-scale"
    autoscaling_group_name = var.var_group_name
    policy_type = "TargetTrackingScaling"
    target_tracking_configuration {
        predefined_metric_specification {
            predefined_metric_type = "ASGAverageCPUUtilization"
        }
        target_value = 50.0
    }
    count = var.var_prod ? 1 : 0
}