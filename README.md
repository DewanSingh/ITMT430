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

