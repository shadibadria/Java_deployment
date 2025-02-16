module "networking" {
  source               = "./modules/networking"
  vpc_cidr             = var.vpc_cidr
  vpc_name             = var.vpc_name
  cidr_public_subnet   = var.cidr_public_subnet
  eu_availability_zone = var.eu_availability_zone
  cidr_private_subnet  = var.cidr_private_subnet
}
 
module "security_group" {
  source              = "./modules/security-groups"
  ec2_sg_name         = "SG for EC2 to enable SSH(22), HTTPS(443) and HTTP(80)"
  vpc_id              = module.networking.dev_proj_1_vpc_id
  ec2_jenkins_sg_name = "Allow port 8080 for jenkins"
}

module "master_server_1" {
  source                    = "./modules/servers"
  ami_id                    = var.ec2_ami_id
  instance_type             = "t2.medium"
  tag_name                  = "master"
  public_key                = var.public_key
  subnet_id                 = tolist(module.networking.dev_proj_1_public_subnets)[0]
  sg_for_jenkins            = [module.security_group.sg_ec2_sg_ssh_http_id, module.security_group.sg_ec2_jenkins_port_8080]
  enable_public_ip_address  = true
  user_data_install_jenkins = templatefile("./modules/servers/master_installer.sh", {})
  root_volume_size          = 25  # Setting root volume size to 25GB
  root_volume_type          = "gp2" # Setting volume type to General Purpose SSD
}


module "slave_server_1" {
  source                    = "./modules/servers"
  ami_id                    = var.ec2_ami_id
  instance_type             = "t2.medium"
  tag_name                  = "slave-1"
  public_key                = var.public_key
  subnet_id                 = tolist(module.networking.dev_proj_1_public_subnets)[0]
  sg_for_jenkins            = [module.security_group.sg_ec2_sg_ssh_http_id, module.security_group.sg_ec2_jenkins_port_8080]
  enable_public_ip_address  = true
  user_data_install_jenkins = templatefile("./modules/servers/slave_installer.sh", {})
  root_volume_size          = 25  # Setting root volume size to 25GB
  root_volume_type          = "gp2" # Setting volume type to General Purpose SSD
}
module "slave_server_2" {
  source                    = "./modules/servers"
  ami_id                    = var.ec2_ami_id
  instance_type             = "t2.medium"
  tag_name                  = "slave-2"
  public_key                = var.public_key
  subnet_id                 = tolist(module.networking.dev_proj_1_public_subnets)[0]
  sg_for_jenkins            = [module.security_group.sg_ec2_sg_ssh_http_id, module.security_group.sg_ec2_jenkins_port_8080]
  enable_public_ip_address  = true
  user_data_install_jenkins = templatefile("./modules/servers/slave_installer.sh", {})
  root_volume_size          = 25  # Setting root volume size to 25GB
  root_volume_type          = "gp2" # Setting volume type to General Purpose SSD
}

module "nexus" {
  source                    = "./modules/servers"
  ami_id                    = var.ec2_ami_id
  instance_type             = "t2.medium"
  tag_name                  = "nexus"
  public_key                = var.public_key
  subnet_id                 = tolist(module.networking.dev_proj_1_public_subnets)[0]
  sg_for_jenkins            = [module.security_group.sg_ec2_sg_ssh_http_id, module.security_group.sg_ec2_jenkins_port_8080]
  enable_public_ip_address  = true
  user_data_install_jenkins = templatefile("./modules/servers/nexus.sh", {})
  root_volume_size          = 25  # Setting root volume size to 25GB
  root_volume_type          = "gp2" # Setting volume type to General Purpose SSD
}
module "solarqube" {
  source                    = "./modules/servers"
  ami_id                    = var.ec2_ami_id
  instance_type             = "t2.medium"
  tag_name                  = "solarqube"
  public_key                = var.public_key
  subnet_id                 = tolist(module.networking.dev_proj_1_public_subnets)[0]
  sg_for_jenkins            = [module.security_group.sg_ec2_sg_ssh_http_id, module.security_group.sg_ec2_jenkins_port_8080]
  enable_public_ip_address  = true
  user_data_install_jenkins = templatefile("./modules/servers/sonarqube.sh", {})
  root_volume_size          = 25  # Setting root volume size to 25GB
  root_volume_type          = "gp2" # Setting volume type to General Purpose SSD
}
module "jenkins" {
  source                    = "./modules/servers"
  ami_id                    = "ami-087a0156cb826e921"
  instance_type             = "t2.medium"
  tag_name                  = "jenkins"
  public_key                = var.public_key
  subnet_id                 = tolist(module.networking.dev_proj_1_public_subnets)[0]
  sg_for_jenkins            = [module.security_group.sg_ec2_sg_ssh_http_id, module.security_group.sg_ec2_jenkins_port_8080]
  enable_public_ip_address  = true
  user_data_install_jenkins = templatefile("./modules/servers/jenkins.sh", {})
  root_volume_size          = 25  # Setting root volume size to 25GB
  root_volume_type          = "gp2" # Setting volume type to General Purpose SSD
}

module "monitoring" {
  source                    = "./modules/servers"
  ami_id                    = var.ec2_ami_id
  instance_type             = "t2.medium"
  tag_name                  = "monitoring"
  public_key                = var.public_key
  subnet_id                 = tolist(module.networking.dev_proj_1_public_subnets)[0]
  sg_for_jenkins            = [module.security_group.sg_ec2_sg_ssh_http_id, module.security_group.sg_ec2_jenkins_port_8080]
  enable_public_ip_address  = true
  user_data_install_jenkins = templatefile("./modules/servers/monitoring.sh", {})
  root_volume_size          = 25  # Setting root volume size to 25GB
  root_volume_type          = "gp2" # Setting volume type to General Purpose SSD
}

