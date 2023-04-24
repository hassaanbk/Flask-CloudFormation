
module "vpc" {
  source = "./vpc"

  vpc_cidr = "10.0.0.0/16"
  private_subnet_cidr_blocks = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]
  public_subnet_cidr_blocks = [
    "10.0.3.0/24",
    "10.0.4.0/24"
  ]
  availability_zones = [
    "us-east-1a",
    "us-east-1b"
  ]
}

module "rds" {
  source = "./rds"

  snapshot_arn   = "arn:aws:rds:us-east-1:156463586173:snapshot:skillsdb-snapshot"
  public_subnets = module.vpc.public_subnets
  vpc_id         = module.vpc.vpc_id
  db_paramters   = module.parameters.db_parameters
}

module "ec2" {
  source = "./ec2"

  vpc_id     = module.vpc.vpc_id
  app_ami_id = "ami-06ee50f8c9e84937f"
}

module "parameters" {
  source = "./parameters"

  parameters = {
    username = "user"
    password = ""
    database = "skillsontario"
    port     = "3306"
  }
}

module "alb" {
  source              = "./alb"
  vpc_id              = module.vpc.vpc_id
  aws_launch_template = module.ec2.aws_launch_template.id
  public_subnets      = module.vpc.public_subnets

  depends_on = [
    module.rds
  ]
}
