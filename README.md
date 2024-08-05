# AWS Infrastructure with Terraform - Project Guide

This project automates the deployment of a web server infrastructure on AWS using Terraform. It sets up a VPC with public and private subnets, creates security groups, and provisions EC2 instances for a web server and backend server, with automated installation of Nginx on the web server.

## Architecture Structure

```
AWS VPC (10.0.0.0/16)
|
├── Public Subnet (10.0.1.0/24)
│   ├── Internet Gateway
│   ├── NAT Gateway
│   ├── Web Server (EC2 Instance with Nginx)
│   └── Security Group (Public SG)
|
└── Private Subnet (10.0.2.0/24)
    ├── Backend Server (EC2 Instance)
    └── Security Group (Private SG)
|
└── Route Tables
    ├── Public Route Table
    │   ├── 0.0.0.0/0 -> Internet Gateway
    ├── Private Route Table
        ├── 0.0.0.0/0 -> NAT Gateway
```

![image](https://github.com/user-attachments/assets/5cada2fd-2d15-4b59-ab75-accdd1d6ece0)


## Folder Structure

```
terraform-aws-infrastructure/
├── .gitignore
├── .github/
│   └── workflows/
│       └── terraform.yml
├── ec2.tf
├── main.tf
├── outputs.tf
├── provider.tf
├── security_groups.tf
├── variables.tf
├── terraform.tfstate
├── .terraform/
└── .terraform.lock.hcl
```


## Automation with GitHub Actions

This project includes a GitHub Actions workflow that automates the deployment of Terraform whenever changes are pushed to the repository. The workflow is defined in `.github/workflows/terraform.yml` and will automatically run `terraform init`, `terraform validate`, `terraform plan`, and `terraform apply` whenever a push is made to the `main` branch.

## Prerequisites

- An AWS account
- Terraform installed on your local machine
- AWS CLI installed and configured
- SSH key pair for secure access to your EC2 instance

## Key Generation

### Create SSH Keys via CLI

To create SSH keys, use the following commands:

```sh
ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa
```

This command creates a private key (`id_rsa`) and a public key (`id_rsa.pub`) in the `~/.ssh/` directory.

>[!Note]
>When you generate an SSH key pair locally using `ssh-keygen`, it creates a private key (`~/.ssh/id_rsa`) and a public key (`~/.ssh/id_rsa.pub`). However, AWS needs to have a reference to this key pair to allow SSH access to the EC2 instances. The `aws_key_pair` resource uploads your public key to AWS and creates a key pair that AWS can manage.

### Send Keys to the Web Server Machine

To copy your public key to the web server, use the following command:

```sh
scp -i ~/.ssh/id_rsa ~/.ssh/id_rsa.pub ec2-user@<web-server-public-ip>:~/.ssh/
```

Then, SSH into your web server:

```sh
ssh -i ~/.ssh/id_rsa ec2-user@<web-server-public-ip>
```

Set the correct permissions on the public key:

```sh
chmod 400 ~/.ssh/id_rsa.pub
```



## Files Explanation

### `provider.tf`
This file configures the AWS provider and sets up the AWS region and SSH key pair.

### `variables.tf`
Defines the variables used in the configuration, including VPC CIDR block, subnet CIDR blocks, instance type, key name, and AMI ID.

### `main.tf`
Creates the VPC, subnets, internet gateway, NAT gateway, route tables, and associates the subnets with the route tables.

### `security_groups.tf`
Defines the security groups for the public subnet (web server) and private subnet (backend server).

### `ec2.tf`
Creates EC2 instances for the web server and backend server, including the user data script to install Nginx on the web server.

### `outputs.tf`
Outputs the VPC ID, subnet IDs, and the public and private IPs of the EC2 instances.

### `.gitignore`
Specifies files and directories to be ignored by Git.

### `.github/workflows/terraform.yml`
Defines the GitHub Actions workflow for automating Terraform deployment. This workflow runs on every push to the repository and applies the Terraform configuration.

## Running the Project

### Step 1: Clone the repository

```sh
git clone https://github.com/Matanmoshes/terraform-aws-infrastructure.git
```

### Step 2: Configure AWS CLI

Install the AWS CLI (if not already installed):

Follow the installation instructions for your operating system [here](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html).

Configure the AWS CLI:

```sh
aws configure
```

You will be prompted to enter your AWS Access Key ID, Secret Access Key, Default region name, and Default output format. These credentials can be obtained from the AWS Management Console under IAM -> Users -> [Your User] -> Security credentials.

Example Output:

```sh
$ aws configure
AWS Access Key ID [None]: AKIAIOSFODNN7EXAMPLE
AWS Secret Access Key [None]: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
Default region name [None]: us-east-1
Default output format [None]: json
```

### Step 3: Verify AWS CLI Configuration

Verify that your AWS CLI configuration is correct by running:

```sh
aws sts get-caller-identity
```

This command should return details about your AWS account and the IAM user or role you are using.

### Step 4: Generate SSH Key Pair

Generate an SSH key pair if you don't have one:

```sh
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa
```


This command creates a private key (`id_rsa`) and a public key (`id_rsa.pub`) in the `~/.ssh/` directory.

>[!Note]
>When you generate an SSH key pair locally using `ssh-keygen`, it creates a private key (`~/.ssh/id_rsa`) and a public key (`~/.ssh/id_rsa.pub`). However, AWS needs to have a reference to this key pair to allow SSH access to the EC2 instances. The `aws_key_pair` resource uploads your public key to AWS and creates a key pair that AWS can manage.

### Step 5: Initialize Terraform

Run the following command to initialize Terraform:

```sh
terraform init
```

### Step 6: Validate the Configuration

Validate the Terraform configuration files:

```sh
terraform validate
```

### Step 7: Plan the Infrastructure

Generate and review the execution plan:

```sh
terraform plan
```

### Step 8: Apply the Configuration

Apply the configuration to create the resources:

```sh
terraform apply -auto-approve
```

This command will provision the AWS infrastructure as defined in the Terraform configuration files.

### Step 9: Verify the Deployment

Once the resources are created, you can verify the deployment by SSHing into the web server and backend server as described in the Key Generation section.
