Requirements:

    • Terraform 
    • AWS credentials    

Configure:

    - Option #1:
        •  AWS CLI (https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

        • configure AWS CLI (https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html#cli-configure-quickstart-creds)

            # you need four pieces of information: Access key ID, Secret access key, AWS Region, Output format (json, yaml, text)

    - Option #2:
        • get AWS Access key ID, Secret access key and Region

        • enter next command in terminal (this is one command, these 3 lines):
        • in command change "your_access_key" & "your_secret_key"
                        mkdir ~/.aws && echo -e "[default]
            aws_access_key_id = your_access_key
            aws_secret_access_key = your_secret_key >> ~/.aws/credentials

        • in main.tf in "cloudfront" module set your profile and region:
            aws_profile = "your-profile"    #example: aws_profile = "default"
            aws_region = "your-region"      #example: aws_region = "eu-west-3"
    
    - For more ways how to do check (https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
            
    - In main.tf in "cloudfront" module set your domain:
            domain  = "your-domain"   #example: domain  = "example.com"     #widthout "www"

Build Infrastructure:

    - you need to initialize the directory with command:
        • terraform init

    - to preview the changes that Terraform plans to make to your infrastructure run command:
        • terraform plan
    
    - create infrastructure:
        • terraform apply -auto-approve
  
    - destroy infrastructure:
        • terraform destroy -auto-approve