
# Terraform Boiler-plate Code For ECS With EC2

This repo helps to setup & create new environments & their CI-CDs using terraform.















## AWS Resources to be created using console before setting up terraform

- S3 bucket for terraform state
- S3 bucket for terraform tfvars
- Dynamodb table for state locking(Use "LockID" for partition key)
- ssh key pair for autoscaling group & bastion-host & any other ec2s
- Codestarconnection of repo with aws
- Create ECR Repo for keeping public base images(in Dockerfile of application to be deployed) if any & push those images using cli (to prevent 429:to many requests error)
- Certificate in acm
- AWS Secrets(For RDS,etc.) if any

## -----------------------Local Setup for terraform--------------------

Clone the project

```bash
  git clone https://bitbucket.org/simformteam/aws-terraform-ecs-boilerplate
```

Go to the infra directory

```bash
  cd infra
```


Go to the provider-and-backend.tf file & edit following values
-
- profile
- bucket (S3 bucket for state that we created using console)
- region
- dynamodb_table(dynamodb table that we created using console)

Create terraform workspace using following command
-

Note: Keep same name for terraform workspace & environment to be created
-

```bash

  terraform workspace new <WORKSPACE_NAME>
  
```

Go to variables.tf
-
- Add env name in default{} of "provider_env_roles" variable

Go to local.tf file
-
Add private_subnet_cidr,private_subnet_az,public_subnet_cidr & public_subnet_cidr for new env in local.tf

Create .tfvars
-
Create new tfvars(for eg terraform.dev.tfvars) file for env that needs to be created & take reference of example.tfvars template.

Terraform commands
-
```bash
  cd infra
  terraform init
  terraform plan --var-file=terraform.dev.tfvars
  terraform apply --var-file=terraform.dev.tfvars
```


------------------------CI-CD setup for terraform------------------
-
Create IAM Role (terraform-pipeline-role) with admin access using console for CI-CD of Terraform
-

Consider following files for CI-CD setup in main directory for terraform

 - aws-secret-from-role.sh
 - buildspec-develop-plan.yml
 - buildspec-develop-apply.yml

Go to aws-secret-from-role.sh file
- 
Replace PROFILE_NAME ,AWS_REGION, role-arn of terraform-pipeline-role (that we created using console)

Go to buildspec-develop-plan.yml & buildspec-develop-apply.yml files
-
Replace S3_BUCKET_NAME(S3 bucket for tfvars that we created using console) ,S3_FILE_KEY(Name of .tfvars (for e.g terraform.dev.tfvars))

Push the code to the SCM
-
Do not push tfvars files in the SCM.

Uploading .tfvars buckets
-
Upload all tfvars files in tfvars S3 bucket that we created using console

Create CI-CD for terraform using console
-
