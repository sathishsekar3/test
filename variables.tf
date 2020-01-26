##### VPC #######

variable "cidr_block" {
  description = "VPC CIDR"

  default = {
    prod = "10.10.0.0/16"
    dev  = "10.20.0.0/16"
  }
}

variable "az" {
  description = "AZ list"

  default = {
    prod = ["ap-southeast-1a","ap-southeast-1b"]
    dev  = ["ap-southeast-1a","ap-southeast-1b"]
  }
}

variable "priv_sub" {
  description = "Private subnet blocks"

  default = {
    prod = ["10.10.3.0/24", "10.10.4.0/24"]
    dev  = ["10.20.3.0/24", "10.20.4.0/24"]
  }
}


variable "pub_sub" {
  description = "Public subnet blocks"

  default = {
    prod = ["10.10.1.0/24", "10.10.2.0/24"]
    dev  = ["10.20.1.0/24", "10.20.2.0/24"]
  }
}

#### Nodejs Lambda function ####

variable "lambdas3bucket" {
  description = "bucket details"

  default = {
    prod = "< Enter s3 bucket which contains the lambda code >"
    dev = "< Enter s3 bucket which contains the lambda code >"
  }
}

variable "lambdas3key" {
  description = "code path in S3 bucket"

  default = {
    prod = "v1.0.0/function.zip"
    dev = "v1.0.0/function.zip"
  }
}

### RDS ###

variable "engine" {
  default = "mysql"
}
variable "engine_version" {
  default = "5.7.19"
}
variable "instance_class" {
  default = {
    prod = "db.t2.micro"
    dev  = "db.t2.micro"
  }
}
variable "allocated_storage" {
  default = 5
}
variable "username" {
   default = "root"

}
variable "db_password" {
  description = "place the DB password in terraform.tfvars file"
}

### ElastiCache - Redis ###

variable "ec_instancetype" {
  default = {
    prod = "cache.t3.micro"
    dev  = "cache.t3.micro"
  }
}

#### Node js compute instances in asg ####

variable "image_id" {
  default = {
    prod = "ami-0d9233e8ce73df7b2"
    dev = "ami-0d9233e8ce73df7b2"
  }
}

variable "instance_type" {
  default = {
    prod = "t3.micro"
    dev = "t3.micro"
  }
}

variable "desired_capacity" {
  default = {
    prod = 1
    dev = 1
  }
}

variable "max_size" {
  default = {
    prod = 1
    dev = 1
  }
}


variable "min_size" {
  default = {
    prod = 1
    dev = 1
  }
}

variable "ssh_pub_key" {
  description = "place the public key in terraform.tfvars file"
}

### ALB ###
variable "port" {
  description = "port for nodejs app"
  default = 6080
}
