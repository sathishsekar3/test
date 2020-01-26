
### Create VPC , Subnets , IG ###

module "vpc" {
  source             = "terraform-aws-modules/vpc/aws"
  name               = "vpc"
  cidr               = var.cidr_block[terraform.workspace]
  azs                = var.az[terraform.workspace]
  private_subnets    = var.priv_sub[terraform.workspace]
  public_subnets     = var.pub_sub[terraform.workspace]
  enable_nat_gateway = false
  enable_vpn_gateway = false
  public_subnet_tags = {
    Name = "public-subnet"
    VPC = "${terraform.workspace}"
  }
  private_subnet_tags = {
    Name = "private-subnet"
    VPC = "${terraform.workspace}"
  }
  vpc_tags = {
    Name = "${terraform.workspace}"
  }
}


### Create Security Group ###

module "sg" {
  source          = "./modules/sg"
  vpc_id          = "${module.vpc.vpc_id}"
  cidr_blocks     = var.priv_sub[terraform.workspace]
  pub_cidr_blocks = var.pub_sub[terraform.workspace]
}

## Create lambda

module "lambda" {
  source         = "./modules/compute/lambda"
  s3_bucket      = var.lambdas3bucket[terraform.workspace]
  s3_key         = var.lambdas3key[terraform.workspace]
  subnet_id      = "${module.vpc.private_subnets}"
  lambda_sg      = "${module.sg.lambda_sg}"

}

### create rds ###

module "rds" {
  source            =  "./modules/rds"
  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.instance_class[terraform.workspace]
  allocated_storage = var.allocated_storage
  username          = var.username
  db_password       = var.db_password
  sec_rds_sg        = "${module.sg.rds_sg}"
  subnet_id         = "${module.vpc.private_subnets}"
}

### create ElastiCache ###

module "elasticache" {
  source    = "./modules/elasticache"
  nodetype  = var.ec_instancetype[terraform.workspace]
  subnets   = "${module.vpc.private_subnets}"
  sec_ec_sg = "${module.sg.ec_sg}"
}

### create nodejs autoscaling group ###

module "compute" {
  source                 = "./modules/compute/autoscaling"
  name                   = "NodeJS"
  image_id               = var.image_id[terraform.workspace]
  instance_type          = var.instance_type[terraform.workspace]
  availability_zones     = var.az[terraform.workspace]
  desired_capacity       = var.desired_capacity[terraform.workspace]
  max_size               = var.max_size[terraform.workspace]
  min_size               = var.min_size[terraform.workspace]
  vpc_zone_identifier    = "${module.vpc.private_subnets}"
  ssh_pub_key            = var.ssh_pub_key
  vpc_security_group_ids = "${module.sg.ec2_sg}"
}


### ALB ###

module "alb" {
  source     = "./modules/compute/alb"
  lambda_arn = "${module.lambda.arn}"
  port       = var.port
  vpc_id     = "${module.vpc.vpc_id}"
  asg_arn    = "${module.compute.asg_arn}"
  alb_sg     = "${module.sg.alb_sg}"
  pub_sub    = "${module.vpc.public_subnets}"
}
