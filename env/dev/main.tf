module "aws-dev" {
    source = "../../infra"
    var_instance = "t2.micro"
    var_aws_region = "us-west-2"
    var_key = "IaC-DEV"
    var_security_group = "general-access_dev"
    var_max_size = 1
    var_min_size = 0
    var_group_name = "Dev"
    var_prod = false
}
