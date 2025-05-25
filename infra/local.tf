locals {
  # Define the environment based on the current workspace
  environment = terraform.workspace

  # Define a map of subnet CIDR blocks for different environments
  private_subnet_cidr = {
    "dev"  = ["172.40.1.0/24", "172.40.2.0/24", "172.40.3.0/24"]
    # "qa"= ["10.1.0.0/24", "10.1.1.0/24", "10.1.2.0/24"]
    # "prod" = ["10.2.0.0/24", "10.2.1.0/24", "10.2.2.0/24"]
    
  }
  private_subnet_az = {
    "dev" = ["us-east-1a", "us-east-1b", "us-east-1c"]
    # "qa" = ["us-east-1a", "us-east-1b", "us-east-1c"]
    # "prod" = ["us-east-1a", "us-east-1b", "us-east-1c"]
   
  }
  # Fetch the subnet CIDR blocks based on the current workspace
  selected_private_cidr_blocks = lookup(local.private_subnet_cidr, local.environment, [])
 
  selected_private_az = lookup(local.private_subnet_az, local.environment, [])

  # Combine subnet names and CIDR blocks into a list of maps
  pvt_subnets = [
    for i in range(length(local.selected_private_cidr_blocks)) : {
      subnet_name       = "${local.environment}-private-subnet-${i + 1}"
      cidr_block        = local.selected_private_cidr_blocks[i]
      availability_zone = local.selected_private_az[i]
    }
  ]

# Define a map of subnet CIDR blocks for different environments
  public_subnet_cidr = {
    
   
    "dev"  = ["172.40.4.0/24", "172.40.5.0/24", "172.40.6.0/24"]
    # "qa" = ["10.1.4.0/22", "10.1.8.0/22", "10.1.12.0/22"]
    # "prod" = ["10.2.4.0/22", "10.2.8.0/22", "10.2.12.0/22"]
     
  }
  public_subnet_az = {
    "dev" = ["us-east-1a", "us-east-1b", "us-east-1c"]
    # "qa" = ["us-east-1a", "us-east-1b", "us-east-1c"]
    # "prod" = ["us-east-1a", "us-east-1b", "us-east-1c"]
   
  }
  # Fetch the subnet CIDR blocks based on the current workspace
  selected_public_cidr_blocks = lookup(local.public_subnet_cidr, local.environment, [])
 
  selected_public_az = lookup(local.public_subnet_az, local.environment, [])

  # Combine subnet names and CIDR blocks into a list of maps
  pub_subnets = [
    for i in range(length(local.selected_public_cidr_blocks)) : {
      subnet_name       = "${local.environment}-public-subnet-${i + 1}"
      cidr_block        = local.selected_public_cidr_blocks[i]
      availability_zone = local.selected_public_az[i]
    }
  ]

  pub_subnet_ids = flatten([
    for subnet in module.pub-sub : subnet.id
  ])

  pvt_subnet_ids = flatten([
    for subnet in module.pvt-sub : subnet.id
  ])
}
