# IaC
  This repository was created with the objective to learn Terraform, Ansible, EC2 and Django, as well as Infrastructure as Code

##What it does:
  It starts an EC2 instance, installing Python3, VirtualEnv, Django and starting an Django instance at your EC2 ipv4:8000 port.
  I used this repository to learn infrastructure as code. Terraform is used to create the EC2 instance and Ansible is used to change the instance as you will, without needing to restart it

##What do you need:
  To use it, you need to configure an AWS account. Learn how to do it here : https://docs.aws.amazon.com/pt_br/cli/latest/userguide/cli-chap-welcome.html
  You will also need to have Terraform, Ansible and AWS CLI installed. I have utilized an UBUNTU machine.
  You will need a AWS Private Key and you have to configure it by running

    aws configure

##How to run it:

    terraform init
    terraform apply

  Connect to your EC2 instance with the SSH example available on the AWS Console
  Change the IPV4 on hosts.yml to the IPV4 of your instance located on the AWS console.

    ansible-playbook.yml -u ubuntu --private-key [Your private key archive generated on AWS Console] -i hosts.yml
    cd tcc
    python manage.py runserver 0.0.0.0:8000

  In your browser, enter your-ipv4-address:8000
  Now you have an Django instance running inside your EC2 instance and you are ready to start your project.
