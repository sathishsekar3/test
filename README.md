# Solution

**Architecture**


<img width="879" alt="solution" src="https://user-images.githubusercontent.com/16284740/73133175-16190d00-4060-11ea-84a2-c4bdf1aa641f.png">



The architecture uses the following services:

1)	RDS – To create managed mysql database.
2)	ElastiCache – To create managed redis instance.
3)	Lambda Function – nodejs function with IAM role to access RDS and ElastiCache.
4)	Auto Scaling Group – nodeJs ec2 instances with autoscaling policies
5)	Application Load Balancer – Internet-facing LB, configured with two target groups, one target group pointing to Nginx server ec2 ( target type – instance) managed by ASG which serves the static website and another target group  to nodejs Lambda function ( target type – Lambda function ) which serves the requests to /api
6)	Cloudfront – For CDN, create a Web distribution with the ALB as origin.
7)	Route53 – For DNS , create a CNAME record pointing to Cloudfront domain name.

I have created the Terraform code to launch services 1 through 5. 
Instructions to launch Cloudfront with ALB backend isnt available in Terraform documentation, so its better to launch it manually and point the route53 CNAME ( app.com ) to its domain name.

The other solution is present in the file solutions.docx file.

**prerequisite**

1) Update the aws credential and S3 details in tf_backend.tf file.

> Note: Create the backend S3 bucket before Terraform execution

```
provider "aws" {
    profile                 = "< your AWS credential profile name >"
    region                  =  "< region >"
}

terraform {
  required_version = "= 0.12.16"
  backend "s3" {
    bucket = "< Terraform state file backend S3 bucket name >"
    key    = "tfstate"
    region = "< region >"
    profile = "< your AWS credential profile name >"
  }
}
```
2) Create the file terraform.tfvars  and update the variables "db_password" and "ssh_pub_key": 
> Note: db_password -> RDS DB password
        ssh_pub_key -> ec2 instance public key

```
Example:
db_password = "hpdemouk"
ssh_pub_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41"
```

**Terraform workspace can be used to promote the code across environments**

> Note: the existing code supports dev and prod environments

**Execution steps:**

1) Create "dev" workspace
```
terraform workspace new dev
```
2) Switch to "dev" from default workspace 
```
terraform workspace select dev
```
3) Initialize the working directory
```
terraform init
```
4) Execute the plan and apply commands to provision the infrastructure
```
terraform plan 
terraform apply
```
