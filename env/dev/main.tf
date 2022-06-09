module "aws-dev" {
    source = "../../infra"
    var_instance = "t2.micro"
    var_aws_region = "us-west-2"
    var_key = "IaC-DEV"
    var_security_group = "general-access_dev"
}

output "ip" {
    value = module.aws-dev.public_ip
}