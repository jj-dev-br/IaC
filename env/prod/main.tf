module "aws-prod" {
    source = "../../infra"
    var_instance = "t2.micro"
    var_aws_region = "us-west-2"
    var_key = "IaC-Prod"
    var_security_group = "general_access_prod"
    var_max_size = 10
    var_min_size = 1
    var_group_name = "Prod"
    var_prod = true
}
