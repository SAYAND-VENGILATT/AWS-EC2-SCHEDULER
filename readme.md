# AWS EC2 Scheduler 
## PROJECT OVERVIEW
A cloud cost optimization solution that automatically starts and stops EC2 instances during work hours using AWS Lambda and Terraform.

## Features

- **Automated Scheduling**: Starts EC2 instances at 8 AM and stops at 8 PM daily
- **Cost Optimization**: Reduces EC2 costs by 65% for non-production instances
- **Tag-based Management**: Uses tags to identify instances to manage
- **Infrastructure as Code**: Fully automated deployment with Terraform
- **CI/CD Pipeline**: Automated deployment via GitHub Actions.

##  Manual Deployment

### Step 1: Clone and Setup
```bash
git clone https://github.com/SAYAND-VENGILATT/AWS-EC2-SCHEDULER.git
cd aws-ec2-scheduler
```
### Step 2: Package Lambda Functions
```bash
cd lambdafunctions
```

 #Create zip files using Python
```bash
python -c "import shutil; shutil.make_archive('../start_instances', 'zip', '.', 'start-instance.py')"
python -c "import shutil; shutil.make_archive('../stop_instances', 'zip', '.', 'stop-instance.py')"

cd ..
```

### Step 3: Deploy with Terraform
```bash
cd terraform
```
#Initialize Terraform
```bash
terraform init
```
#Deploy infrastructure
```bash
terraform apply -auto-approve

cd ..
```

## Configuration
### Environment Variables
The Lambda functions use these environment variables:

* TAG_KEY: Tag key to identify instances (default: AutoSchedule)

* TAG_VALUE: Tag value to identify instances (default: true)

### Scheduling
* Start Time: 8:00 AM UTC daily

* Stop Time: 8:00 PM UTC daily

You can modify these in terraform/variables.tf and main.tf

## Tagging EC2 Instances
Tag your EC2 instances with:

* Key: AutoSchedule

* Value: true

Instances with this tag will be automatically started and stopped.

## CI/CD Deployment (GitHub Actions)
The project includes GitHub Actions workflow that automatically deploys when you push to main branch.

Required GitHub Secrets:
* AWS_ACCESS_KEY_ID

* AWS_SECRET_ACCESS_KEY
