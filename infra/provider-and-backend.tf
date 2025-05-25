terraform {
required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0.0"
    }
 }
}

provider "aws" {
    profile = "2bcloud"                              //Profile to be used
    region = "us-east-1"                                           //Region
}


terraform {
    backend "s3" {
      bucket = "eks-assignment-terraform"                        //S3 bucket to store terraform state (To be created by console)
      key = "terraform.state"
      region = "us-east-1"
      dynamodb_table = "eks-assignment-terraform-locks-table"                     //Dynamo db table for terraform state locking (To be created by console)
      profile = "2bcloud"                           //Profile to be used
    }
 }