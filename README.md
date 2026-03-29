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
