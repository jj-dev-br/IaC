module "aws-prod" {
    source = "../../infra"
    var_instance = "t2.micro"
    var_aws_region = "us-west-2"
    var_key = "IaC-Prod"
    var_security_group = "general_access_prod"
}

output "ip" {
    value = module.aws-prod.public_ip
}