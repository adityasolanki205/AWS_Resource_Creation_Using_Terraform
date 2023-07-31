# AWS Resource Creation Using Terraform

This is a repository for **learning and implementation** of deployment of AWS resources using terraform. In this repository we will learn to create EC2 instance, S3 bucket and lambda function creation on AWS using terraform. The complete process is divided into 4 parts:

1. **Terraform cli installation**
2. **AWS CLI installation**
3. **Writing the code the create resources**
4. **Implementation of terraform code**


## Motivation
For the last few years, I have been part of a great learning curve wherein I have upskilled to move into a Machine Learning and Cloud Computing. This project was practice project for all the learnings I have had. This is one of the many more to come. 
 
## Services used

<b>Built with</b>
- [Terraform](https://www.terraform.io/)
- [EC2](https://aws.amazon.com/ec2/)
- [Amazon S3](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html)
- [AWS Lambda](https://aws.amazon.com/lambda/)
- [GitHub](https://docs.github.com/en)


## Repo Cloning

```bash
    git clone https://github.com/adityasolanki205/AWS_Resource_Creation_Using_Terraform.git
```


## Implementation

Below are the steps to setup the enviroment and run the models:

### Step 0 - AWS Free tier account creation

- **AWS Account**: We will be using Free tier version of AWS for our demonstration. If you wish to create a new account please click [here](https://portal.aws.amazon.com/billing/signup?refid=em_127222&redirect_url=https%3A%2F%2Faws.amazon.com%2Fregistration-confirmation#/start/email)


### Step 1 - Terraform Command Line Interface installation

-  **Installation**: Let us try to install Terraform on our system.
    
    i. Goto [Terraform downloads page](https://developer.hashicorp.com/terraform/downloads) and download the appropriate version of the terraform. Leave it as is after download
    
    ii. Create a folder by the name C:\terraform
    
    iii. Goto advanced setting. Click on environment variables. 
    
    iv. Click on path and Add a new variable as "C:\terraform". Save and close
    
    v. Click on the downloaded Terraform excecutable and unzip it at C:\terraform
    
    vi. Click on the .exe file and wait.
    
    vii. Open windows powershell and type "terraform -help". If all the terraform commands appear on the screen, terraform has been installed successfully otherwise please revisit the steps above.


### Step 2 - AWS Command Line Interface installation

-  **Installation**: Now we will install AWS CLI on your device.

    i. Goto [AWS CLI installation](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) page and download the approriate version.
    
    ii. Run the file after download.
    
    iii. Open command prompt and run the command "aws configure"
    
    iv. Then it will ask for AWS Access key ID and Secret Access Key. If you have one please use it else visit [this page](https://docs.aws.amazon.com/powershell/latest/userguide/pstools-appendix-sign-up.html) to create one. The user mus have EC2 Full access, S3 full access, VPC Full access, Lambda Full Access, IAM Full Access.
    
    v. Now the setup is done.


### Step 3 - Writing the code the create resources

-  **Initializing the code**:  We will use below code to initialize the code.

```go`
    terraform {
      required_providers {
        aws = {
          source  = "hashicorp/aws"
          version = "~> 3.27"
        }
      }
    }

    provider "aws" {
      profile = "default"
      region  = "ap-south-1"
    }
```
    
 
-  **Creating EC2 Instance**: EC2 will be created using the code below. Also please use the correct ami for the instance. 

```go
    resource "aws_instance" "vm-web" {
      ami           = "ami-0ded8326293d3201b"
      instance_type = "t2.micro"

      tags = {
        Name = "server for web"
        Env = "dev"
      }
    }
```


-  **Creating S3 Bucket**: S3 will be created using the code below. 

```go
    resource "aws_s3_bucket" "my_protected_bucket" {
      bucket = var.bucket_name
    }
```


-  **Disabling Bucket versioning**: Bucket Version disabling will be done using the code below. 

```go
    resource "aws_s3_bucket_versioning" "my_protected_bucket_versioning" {
      bucket = aws_s3_bucket.my_protected_bucket.id
      versioning_configuration {
        status = "Disabled"
      }
    }
```


-  **Disabling Public access**: Bucket public access will be disables using the code below. 

```go
    resource "aws_s3_bucket_public_access_block" "my_protected_bucket_access" {
      bucket = aws_s3_bucket.my_protected_bucket.id
      # Block public access
      block_public_acls   = true
      block_public_policy = true
      ignore_public_acls = true
      restrict_public_buckets = true
    }
```

-  **Creating IAM policy document for Lambda function**: IAM policy for lambda will be created using the code below. 

```go
    data "aws_iam_policy_document" "policy" {
      statement {
        sid    = ""
        effect = "Allow"
        principals {
          identifiers = ["lambda.amazonaws.com"]
          type        = "Service"
        }
        actions = ["sts:AssumeRole"]
      }
    }
```

-  **Creating IAM policy using JSON**: IAM policy in form of a JSON will be created using the code below. 

```go
    resource "aws_iam_role" "iam_for_lambda" {
      name               = "iam_for_lambda"
      assume_role_policy = data.aws_iam_policy_document.policy.json
    }
```

-  **Creating Lambda Function**: Lambda Function is created using simple python code as below. 

```python
    import json

    def lambda_handler(event, context):
        print("Hello")
        return {
            'statusCode': 200,
            'body': json.dumps('Hello from Lambda!')
        }
```

### Step 4 - Building the code using CodePipeline
    
-  **Source Stage**:
    
    i. Navigate to CodePipeline.
    
    ii. Click on create new pipeline. Provide the name of the pipeline and click next.
    
    iii. Under Source provider select "GitHub (Version 2)". Then select the connection, Repository name, Branch name and click next.
    
https://user-images.githubusercontent.com/56908240/220592891-0cb7cc28-3546-42f3-a21e-d378027ec09d.mp4

    
-  **Build Stage**:
    
    i. In the build provider select CodeBuild and either click on create Project if you donot have a project or select the one from dropdown if already created .
    
    ii. If you clicked on Create project then select Managed Image, Ubuntu Operating system, Standard runtime, choose the latest version of the image, choose new service and click on continue. 
    
    iii. In this process a file named Buildspec.yml would be required. It contains shell commands to be run before, during, and after build process. We have provided a basic buildspec.yaml in this repo as well. This file must be present in the Root Directory of the repo.
    
    iv. Select Single option and click next
    
https://user-images.githubusercontent.com/56908240/220592944-15927a1b-96dd-45a0-afca-a74009b262ec.mp4


-  **Deploy Stage**: 
    
    i. Select Amazon S3 in deploy stage and the name of the bucket.
    
    ii. Check the " Extract File before Deploy " button as well. 
    
    iii. Click next and the pipeline will be deployed.

https://user-images.githubusercontent.com/56908240/220593038-9369c12c-7806-4319-b517-5be38a2f2037.mp4


### Step 5 - Integrating and Delivering the updated code

-  **Check if the code is working**: 
    
    i. Goto Amazon S3 bucket and select the bucket. Goto Properties and go to the bottom and click on "Static website Hosting" URL.
    
    ii. Verify if the page is loading perfectly
    
    
-  **Updating the code in Repo**: 
    
    i. Now goto the Repo and update index.html
    
    ii. Commit the code and push it to the root directory.
    
    iii. Verify if the CodePipeline is running.
    
    iv. Now click on "Static website Hosting" URL again and verify the changes.
    
    
### Step 6 - Deleting the resources(Optional)

-  **Delete all the resources**:

    i. Delete the Pipeline created for the site.
    
    ii. Delete S3 bucket created to host the website.
    
    iii. If no further pipelines are required, delete the S3 bucket created for codepipelines as well.
    
    iv. Delete the connection created with GitHub.
    
    v. Delete the CodeBuild Project that were created


## Credits
1. [Build a CI/CD pipeline on AWS](https://medium.com/nerd-for-tech/build-a-ci-cd-pipeline-on-aws-f806e427db22)
2. [Simple CI/CD pipeline with AWS CodePipeline](https://osusarak.medium.com/ci-cd-with-aws-codepipeline-d8d0538a52f2#:~:text=CI%2FCD%20is%20one%20of,is%2C%20CI%2FCD%20pipeline)
3. [About Us page](https://www.w3schools.com/howto/howto_css_about_page.asp)
