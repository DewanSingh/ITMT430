# Project Title
ITMT 430 Project

## Description
This project sets up a Django environment with automated Git operations.

## Setup
Step 1: Install Python
To verify if Python is installed and to check the version, run the following
python3 --version
If Python is not installed or you need to install the latest version, run:
sudo apt update
sudo apt install python3

Step 2: Install pip (Python package installer)
To install pip3, run the following command:
sudo apt install python3-pip
Verify the installation by checking the pip version:
pip3 --version

Step 3: Install virtualenv to create a virtual environment
Virtual environments are useful for isolating project dependencies. Install virtualenv by running:
sudo apt install python3-venv

Step 4: Create a virtual environment
Navigate to the directory where you want to set up your Django project and create a virtual environment:
cd /path/to/your/project
python3 -m venv myenv
Here, myenv is the name of the virtual environment. You can name it anything you like.

Step 5: Activate the virtual environment
Activate the virtual environment using the following command:
source myenv/bin/activate
Once the virtual environment is activated, you should see the environment name (myenv) at the beginning of the command prompt.
To deactivate it later, simply run:
deactivate

Step 6: Install Django in the virtual environment
With the virtual environment activated, you can now install Django using pip:
pip install django
Verify the installation by checking the Django version:
django-admin --version

Step 7: Start a new Django project
Now that Django is installed, create a new Django project by running:
django-admin startproject projectname
Replace projectname with the project name blog_project. This will create a new Django project directory.
Notes: Make sure your projectname is provided as per naming convention in Django.
Step 8: Run the Django development server
Navigate to the project directory:
cd projectname
Run the development server:
python3 manage.py runserver

You should see output indicating that the server is running, and you can visit the default Django page by going to http://127.0.0.1:8000 in your browser.


## Usage
git_push.sh is used to add, commit, and push code to the GitHub Repository after changes are made. Use git_push.sh by running 'bash ./git_push' in the /home/sadmin/ITMT430 directory




##      Sprint 2         ##


## How to Install Docker
If Docker is not installed, follow these steps for your operating system:
For Ubuntu/Linux:

1. Update your existing package list:

sudo apt-get update

2. Install necessary packages to allow apt to use repositories over HTTPS:

sudo apt-get install apt-transport-https ca-certificates curl software-properties-common

3. Add Docker’s GPG key:

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

4. Add the Docker repository to apt sources:

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
5. Update your package list again and install Docker:

sudo apt-get updatec
sudo apt-get install docker-ce

6. Check if Docker is installed correctly by running:

sudo systemctl status docker
7. To check version, run
docker --version
Then to dockerize applications follow the below steps:


Step 1: Create a Dockerfile

In your project root, create a file named Dockerfile and include script the following:

 

# Use an official Python runtime as a parent image
FROM python:3.10

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install dependencies with updated pip
COPY requirements.txt /app/
RUN pip install --upgrade pip && \
    pip install -r /app/requirements.txt

# Create and set working directory
RUN mkdir -p /app
WORKDIR /app/blog_project

# Copy entire project
COPY . /app/

# Run the application
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "blog_project.wsgi:application"]

Step 2: Create a docker-compose.yml

Create a docker-compose.yml file in your project root once again:

version: '3.8'

services:
  web:
    build: .
    volumes:
      - ./:/app
    working_dir: /app/blog_project
    command: python manage.py runserver 0.0.0.0:8000
    ports:
      - "8000:8000"
    environment:
      - PYTHONPATH=/
      - DJANGO_SETTINGS_MODULE=blog_project.settings
      - DB_HOST=your-rds-endpoint.rds.amazonaws.com
      - DB_NAME=blog_db
      - DB_USER=coursera
      - DB_PASSWORD=coursera
    depends_on:
      db:
        condition: service_healthy
    networks:
      - blog_network

  db:
    image: mysql:8.0
    environment:
      - MYSQL_ROOT_PASSWORD= your_root_password
      - MYSQL_DATABASE=blog_db
    volumes:
      - blog_db_data:/var/lib/mysql
    command: --default-authentication-plugin=mysql_native_password
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
      timeout: 20s
      interval: 5s
      retries: 10
    ports:
      - "3307:3306"
    networks:
      - blog_network

volumes:
  blog_db_data:

networks:
  blog_network:

Step 3: Update Requirements

Update your requirements.txt file to include the following dependencies:

Django==5.2.1
mysqlclient==2.2.7
::
gunicorn==20.1.0

Step 4: Update Django Settings for Docker

Modify blog_project/settings.py to use environment variables and all ips allowance:

from pathlib import Path
import os

# ...

DEBUG = int(os.environ.get('DEBUG', default=0))
ALLOWED_HOSTS = ['*']

# ...

Pip: Useful command

1.	To view dependencies (good to have environment activated for isolation of items)
pip freeze 

Docker CLI: Some useful docker commands

2.	To check if Docker is running:
There are a few ways to check if the Docker daemon is running:
a) Using systemctl (on systems that use systemd):
sudo systemctl status docker
If you see "active (running)" in green, the Docker daemon is running 
b) Using a Docker command:
sudo docker info
or
sudo docker version
If Docker is running, you'll get a valid response. If not, you'll get an error message 
2.	To view created containers:
The command to list Docker containers is:
sudo docker ps
By default, this shows only running containers. To see all containers, including stopped ones, use:
sudo docker ps -a
Additional useful options:
•	To show only container IDs: docker ps -aq
•	To show the most recently created container: docker ps -l
•	To show the n most recently created containers: docker ps -n <number>
•	To show container sizes: docker ps -s


Step 5: Build and Run Docker Container

1.	Download Docker images for ARM (aarch64) or AMD64 platform architectures: 
         
export LATEST_BUILDX=$(curl -s https://api.github.com/repos/docker/buildx/releases/latest | grep 'tag_name' | cut -d\" -f4)
ARCH=$(uname -m)

if [ "$ARCH" = "x86_64" ]; then
    DOWNLOAD_ARCH="amd64"
elif [ "$ARCH" = "aarch64" ]; then
    DOWNLOAD_ARCH="arm64"
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

mkdir -p ~/.docker/cli-plugins/
curl -SL https://github.com/docker/buildx/releases/download/"${LATEST_BUILDX}"/buildx-"${LATEST_BUILDX}".linux-"${DOWNLOAD_ARCH}" -o ~/.docker/cli-plugins/docker-buildx
chmod +x ~/.docker/cli-plugins/docker-buildx

2.	Restart Docker: sudo systemctl restart docker

3.	Prep for docker image builds by running
docker buildx create --use
4.	Build Docker Images seperately for popular architectures: (make sure to include the period at the end of each line)

sudo docker buildx build --platform linux/amd64 -t blog_project-web:latest-amd64 --load .
        
sudo docker buildx build --platform linux/arm64 -t blog_project-web:latest-arm64 --load .

5.	Start your RDS Instance (wait till it starts)
6.	Run the Docker container: sudo docker compose up
7.	Visit http://localhost:8000 to verify the containerized app is working.

Good commands to know
docker buildx ls
List the running containers run: sudo docker ps -a
Clean up orphaned containers: docker container prune --force
                                                                   or docker compose up --remove-orphans

Take screenshots of your running Docker containers, the Django app homepage, and successful database connection.
To show a successful database connection here are a few ways
>Run the Django shell in the docker container 
docker compose run web python manage.py shell
Add in following lines (one line at a time) in shell

from django.db import connection
connection.ensure_connection()
print("Connection successful")
or
from django.db import connection
with connection.cursor() as cursor:
cursor.execute("SELECT 1")
	print(cursor.fetchone())
 Press enter twice to see outcome 
 Exit shell at prompt   
 >>> exit()
or
> Show admin page at Log into the Django admin interface (usually at   
    http://localhost:8000/admin/)
    If you can see the admin interface and it loads properly, it indicates a successful 
    database connection.
    Take a screenshot of the admin dashboard as a valid home landing page.

Step 6: Prepare for EC2 Deployment

Before pushing your Docker image to EC2, follow steps below to create permissions for the AmazonEC2ContainerRegistryReadOnly policy as an IAM user in AWS Console:

1. Go to IAM service in AWS Console
2. Navigate to "Users" in the left sidebar
3. Select your user
4. Go to the "Permissions" tab
5. Click "Add permissions"
6. Choose "Attach policies directly"
7. Search for "AmazonEC2ContainerRegistryReadOnly"
8. Select the checkbox next to it
9. Click "Next: Review"
10. Click "Add permissions"

This policy grants read-only access to ECR, which includes:
•  ecr:DescribeRepositories
•  ecr:DescribeImages
•  ecr:ListImages

1.	Create an ECR (Elastic Container Registry) repository:

aws ecr create-repository --repository-name blog_project-web --region us-east-1

2.	Authenticate Docker to your ECR registry:

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $(aws sts get-caller-identity --query "Account" --output text).dkr.ecr.us-east-1.amazonaws.com

3.	Tag your image:

docker tag blog_project-web:latest-amd64 $(aws sts get-caller-identity --query "Account" --output text).dkr.ecr.us-east-1.amazonaws.com/blog_project-web:latest-amd64

4.	Push the image to ECR:

docker push $(aws sts get-caller-identity --query "Account" --output text).dkr.ecr.us-east-1.amazonaws.com/blog_project-web:latest-amd64

5.	Check for success if ECR is available in your repository!

aws ecr describe-images --repository-name blog_project-web --region us-east-1
Some additional useful commands

docker images

docker container prune -f  # Remove all stopped containers to free up space

history | grep docker

##	Sprint 3	##

Sprint 3: Deploying Django Blog to EC2 with CI/CD

Objective: Deploy the containerized Django blog application to an EC2 instance using a CI/CD pipeline, configure it to use the RDS database, and make it publicly accessible.
Step 1: Create EC2 Instance 
1.	Log in to AWS Console and navigate to EC2 service.
2.	Click "Launch Instance" 
3.	Under Name and Tags choose as Name as django-blog-server
4.	Under Quick Start choose “Ubuntu"
5.	For AMI, choose “Ubuntu Server 24.04 LTS (HVM)".
6.	For Architecture leave default “64-bit (x86)”
7.	Select t2.micro instance type (free tier eligible).
8.	Creating a Key Pair 
This is part of a key pair used to SSH into EC2 instances. The key pair consists of a public key, which AWS maintains, and a private key, which you need to download and safely keep.
Under Key pair (login) click on Create new key pair
Choose a name such as blog_project for your key pair for the file format, check .pem for .pem file, which is standard for SSH.
Once created, it will automatically download. This file contains your private key.
9.	Configure Network settings:
•	Network: Leave default VPC
•	Subnet: Keep default (public subnet)
•	Auto-assign public IP: Enable
10.	For Firewall settings, click Create security group and check each of the following:
•	Allow SSH (port 22) traffic from anywhere
•	Allow HTTPS (port 443) traffic from internet
•	Allow HTTP (port 80) traffic from internet
11.	Under Configure storage: Use default 8GB gp3 volume.
12.	Review settings then click Launch instance button.

Step 2: Log into EC2 instance via SSH
First grab your *public ip from your running EC2 instance

SSH into EC2 from your Ubuntu ‘local’ desktop as follows:
chmod 400 /path/to/your-key.pem
ssh -i /path/to/your-key.pem ubuntu@your-ec2-public-ip

example: ssh -i blog_project.pem ubuntu@3.84.148.60
*Alternatively, if you set an Identity policy in AWS Console for DescribeInstances, you can create a bash file that retrieves your pubip automatically to your check ip, especially if they refresh!

Sample script follows.

#!/bin/bash

# Fetch the instance ID dynamically, assuming you tag your instance
INSTANCE_ID=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=MyEC2Instance" \
  --query "Reservations[*].Instances[*].InstanceId" \
  --output text)

# Fetch the public IP dynamically
PUBLIC_IP=$(aws ec2 describe-instances \
  --instance-ids $INSTANCE_ID \
  --query "Reservations[*].Instances[*].PublicIpAddress" \
  --output text)

# Use the dynamic public IP in the SSH command
ssh -i "blog_project.pem" ubuntu@$PUBLIC_IP

Step 3: Install Required Software on EC2
Update system and install dependencies:
 
sudo apt update && sudo apt upgrade -y
sudo apt install -y python3 python3-pip nginx

Install Docker:
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install -y docker-ce
 

Install Docker Compose:
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

Start docker and enable on start up command
sudo systemctl start docker
sudo systemctl enable docker

Configure Nginx:
sudo nano /etc/nginx/sites-available/blog_project
Add the following configuration:
 
server {
    listen 80;
    server_name your_domain.com;

    location / {
        proxy_pass http://localhost:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}

Enable the site and restart Nginx:
sudo ln -s /etc/nginx/sites-available/blog_project /etc/nginx/sites-enabled
sudo nginx -t
sudo systemctl restart nginx

Step 4: Deploy Application to EC2 using CI/CD Pipeline

The script that follows, allows the automatic public ip retrieval for efficiency when running your CI/CD workflow. If you haven’t already created an EC2 IAM DescribeInstances policy please do so now via your AWS console.  Follow the next steps to set a custom IAM policy.

Navigate to your AWS console’s visual path as follows to search for DescribeInstance:
IAM > Create Policy > Visual editor > Service > EC2 > Access level > List > DescribeInstances

Set a desired name such as EC2DescribeInstancesPolicy for your DescribeInstance policy.

Once complete, back at your navigation pane, click “Users” and select “your username”. Then proceed to add attach a custom policy as an IAM user:
1. On the user details page, go to the “Permissions” tab.
2. Click “Add permissions” and choose “Attach policies directly.”
3. In the policy search box, type “EC2DescribeInstancesPolicy” and check its box.
4. Click “Next,” then “Add permissions” to finalize.
5. Wait a few minutes for the policy to propagate.
6. Run “aws ec2 describe-instances” cli command to confirm the policy works. No access denied should not be rendered based on command.

Also give your EC2 instance permissions to pull from ECR using the AWS Console as follows:


1. Create an IAM Role:
•  Go to AWS Console → IAM
•  Click "Roles" in the left sidebar
•  Click "Create role"
•  Select "AWS service" as the trusted entity
•  Choose "EC2" as the use case
•  Click "Next"
•  In the permissions search box, type "AmazonEC2ContainerRegistryReadOnly"
•  Check the box next to it
•  Click "Next"
•  Name the role something like "EC2-ECR-Pull-Role"
•  Click "Create role"

2. Attach the Role to EC2:
•  Go to AWS Console → EC2
•  Select your instance
•  Click "Actions" button
•  Go to "Security" → "Modify IAM role"
•  From the dropdown, select the role you just created ("EC2-ECR-Pull-Role")
•  Click "Update IAM role"

After completing these steps:
1. Wait about 1 minute for permissions to propagate
2. The EC2 instance will now have permissions to pull from ECR

Next, from your local machine inside your .github/workflows/ directory, create a file called deploy.yml and enter content that follows which includes Github secrets and variables that will be shown in Step 5.

name: Deploy to EC2

on:
  push:
    branches: [main]
  workflow_dispatch:

jobs:
  deploy:		
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v1
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1

      - name: Login to Amazon ECR
        id: login-ecr
        uses: aws-actions/amazon-ecr-login@v1

      - name: Build, tag, and push image to Amazon ECR
        env:
          ECR_REGISTRY: ${{ steps.login-ecr.outputs.registry }}
          ECR_REPOSITORY: blog_project-web
          IMAGE_TAG: ${{ github.sha }}
        run: |
          docker build -t $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG .
          docker push $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG

      - name: Get EC2 instance Public IP
        id: get-ip
        run: |
          INSTANCE_ID=$(aws ec2 describe-instances \
            --filters "Name=tag:Name,Values=MyEC2Instance" \
            --query "Reservations[*].Instances[*].InstanceId" \
            --output text)
          PUBLIC_IP=$(aws ec2 describe-instances \
            --instance-ids $INSTANCE_ID \
            --query "Reservations[*].Instances[*].PublicIpAddress" \
            --output text)
          echo "PUBLIC_IP=$PUBLIC_IP" >> $GITHUB_ENV

      - name: Deploy to EC2
        env:
          PRIVATE_KEY: ${{ secrets.EC2_SSH_PRIVATE_KEY }}
          HOST: ${{ env.PUBLIC_IP }}
          USER: ubuntu
          ECR_REGISTRY: ${{ steps.login-ecr.outputs.registry }}
          IMAGE_TAG: ${{ github.sha }}
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        run: |
          echo "$PRIVATE_KEY" > private_key && chmod 600 private_key
          ssh -o StrictHostKeyChecking=no -i private_key ${USER}@${HOST} "
            source /home/ubuntu/.aws-cli-venv/bin/activate
            aws ecr get-login-password --region us-east-1 | sudo docker login --username AWS --password-stdin $ECR_REGISTRY
            if [ \"\$(docker ps -aq -f name=blog_web)\" ]; then
              echo 'Stopping and removing existing container ''blog_web''...'
              sudo docker stop blog_web
              sudo docker rm blog_web
            fi
            sudo docker pull $ECR_REGISTRY/blog_project-web:$IMAGE_TAG
            sudo docker run --rm -d --name blog_web -p 8000:8000 \
              -e AWS_ACCESS_KEY_ID='$AWS_ACCESS_KEY_ID' \
              -e AWS_SECRET_ACCESS_KEY='$AWS_SECRET_ACCESS_KEY' \
              $ECR_REGISTRY/blog_project-web:$IMAGE_TAG
            sudo docker exec blog_web python manage.py migrate
          "


Commit / Push changes to your Github repo

Adding keys as ‘Secrets’ to Github. 
Adding keys to your repository's secrets configuration ensures they're only accessible to workflows that need them.

Incorporate your AWS keys and SSH private key into GitHub secrets and variables, by following these steps so your YAML workflow can access them:

1. Access GitHub Repository Settings:
   - Go to your GitHub repository in a web browser.
   - Click on the "Settings" tab near the top of the repository page.

2. Navigate to Secrets and Variables:
   - In the left sidebar, click on "Secrets and variables" and then select "Actions" to manage secrets for GitHub Actions.

3. Add Secrets:
   - Click the "New repository secret" button.
   - Enter a name for your secret as AWS_ACCESS_KEY_ID and paste the corresponding key value into the "Value" field.
   - Save the secret.
   - Repeat the process for AWS_SECRET_ACCESS_KEY and EC2_SSH_PRIVATE_KEY.
   - Save each secret.

4. Ensure Workflow Access:
   - Your .github/workflows YAML file will automatically have access to these secrets when properly referenced using ${{ secrets.NAME_OF_SECRET }} within the workflow file.
5. Verify the Workflow:
   - After adding all necessary secrets, run your workflow to ensure everything is correctly configured. 
To run your workflow initially 
a. Navigate to the Actions Tab:
   - Go to your GitHub repository page.
   - Click on the "Actions" tab at the top of the page.
b. Select the Workflow:
   - In the sidebar, select the workflow which now includes workflow_dispatch which should be named Deploy to EC2.

c. Manually Trigger the Workflow:
   - You should see a "Run workflow" button at the top-right of the workflow page.
   - A drop-down will appear allowing you to select the branch you want to run the workflow against (and any optional inputs if you've defined them).
   - Click the green "Run workflow" button, and it will start executing the workflow immediately. 
*Note your workflows will automatically trigger upon any push from your dev environment.

By following these steps, your secrets will be securely stored and accessible to your GitHub Actions workflows, facilitating the use of these credentials during automated testing and deployment processes.

Step 5: Test Application
SSH into your EC2 instance and test locally:
curl http://localhost:8000
To test publicly, use your EC2 instance's public IP or domain name:
http://your-ec2-public-ip
or
http://your-domain.com
To get the public IP of your EC2 instance:
aws ec2 describe-instances --instance-ids your-instance-id --query 'Reservations[0].Instances[0].PublicIpAddress' --output text

