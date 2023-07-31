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

-  **Creating required files**:  We will create main.tf and variable.tf to place all the details. All the code provided below will be present in main.tf.

-  **Initializing the code**:  We will use below code to initialize the code.

```go
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

-  **Creating Lambda Function code**: Lambda Function is created using simple python code as below. 

```python
    import json

    def lambda_handler(event, context):
        print("Hello")
        return {
            'statusCode': 200,
            'body': json.dumps('Hello from Lambda!')
        }
```

-  **Creating Lambda Function in AWS**: Lambda Function is created using simple code as below. 

```go
    resource "aws_lambda_function" "lambda" {
      function_name = "welcome"
      filename         = data.archive_file.zip.output_path
      source_code_hash = data.archive_file.zip.output_base64sha256
      role    = aws_iam_role.iam_for_lambda.arn
      handler = "welcome.lambda_handler"
      runtime = "python3.7"
    }
```

### Step 4 - Implementation of terraform code
    
-  **Implementation**:
    
    i. Open microsoft powershell.
    
    ii. Navigate to C:\terraform.
    
    iii. To initialize type **terraform init**
    
    iv. To create a plan type **terraform plan -out aws-ec2-s3-lambda-creation**
    
    v. To apply the plan type **terraform apply "aws-ec2-s3-lambda-creation"**
    
    vi. Just after this you will see the EC2 instance, S3 bucket and Lambda function being created.
    
    
### Step 6 - Deleting the resources(Optional)

-  **Delete all the resources**:

    i. To Delete all the resources type on powershell **terraform destroy**. This will delete all the resources.


## Credits
1. [Set up Terraform and AWS CLI](https://medium.com/@shanmorton/set-up-terraform-tf-and-aws-cli-build-a-simple-ec2-1643bcfcb6fe)
2. [How to Create an S3 Bucket with Terraform](https://blog.purestorage.com/purely-informational/how-to-create-an-s3-bucket-with-terraform/)
3. [Terraform Lambda Example Create and Deploy - AWS](https://www.middlewareinventory.com/blog/aws-lambda-terraform/)
