# Scalable Web Application with CI/CD Pipeline
This project is a highly available, auto-scalable web application built on AWS infrastructure, designed with a zero-downtime deployment process. It leverages an EC2-based architecture with an Elastic Load Balancer (ELB), Auto Scaling Groups (ASGs), and Amazon RDS for database management. Continuous Integration and Continuous Deployment (CI/CD) is implemented using CodePipeline, CodeBuild, and CodeDeploy for efficient and automated deployment.

## Architecture Overview
Load Balancer (ELB): Distributes incoming traffic across multiple EC2 instances to ensure high availability.
Auto Scaling Groups (ASGs): Automatically scales the number of EC2 instances based on traffic and load.
EC2 Instances: Hosts the application, deployed with CodeDeploy for zero-downtime updates.
Amazon RDS: Manages the relational database, supporting persistence and high availability.
CI/CD Pipeline: CodePipeline triggers CodeBuild for application builds and CodeDeploy for zero-downtime deployment to the EC2 instances.
S3: Stores application artifacts for deployment.

## CI/CD Workflow
1. CodePipeline triggers the CI/CD workflow on code updates.
2. CodeBuild builds the application, runs tests, and stores artifacts in an S3 bucket.
3. CodeDeploy retrieves artifacts from S3 and deploys them to EC2 instances, managing zero-downtime deployments.
4. .github Actions (optional) can be used to monitor and trigger the pipeline.

## File-by-File Setup Guide
### 1. .github/workflows/CICDPipeline.yml
.github Actions workflow file to trigger CI/CD on pushes to the main branch.

Purpose: Defines steps to install dependencies, run tests, build, and upload to S3.
Setup: Place in .github/workflows/ to enable automated pipeline on .github.

### 2. Infrastructure/CloudFormation/Infrastructure.yml
CloudFormation template to provision AWS resources (VPC, EC2, RDS, ASG, ELB).

Purpose: Infrastructure-as-Code for easy replication and scaling.
Setup: Deploy this file through the AWS Management Console or CLI.

### 3. Infrastructure/Terraform/main.tf
Optional Terraform configuration to provision resources as an alternative to CloudFormation.

Purpose: Provides another IaC approach, supporting complex customizations.
Setup: Run terraform init and terraform apply in the Infrastructure/Terraform directory.

### 4. Src/App/main.py
Python Flask application entry point.

Purpose: Simple web application API, running on Flask.
Setup: App/main.py is executed on EC2. Requires dependencies from Requirements.txt.

### 5. Src/App/Requirements.txt
Lists Python dependencies for the application (e.g., Flask).

Purpose: Ensures all required packages are installed.
Setup: Run pip install -r Src/App/Requirements.txt to install dependencies locally or during CodeDeploy.

### 6. Src/App/Config/Settings.py
Application configuration file for setting up environment-specific variables (e.g., database credentials).

Purpose: Simplifies environment management.
Setup: Update with environment variables as needed.

### 7. Src/Static/
Holds static assets like CSS, JavaScript, and images.

Purpose: Provides front-end styling and interactivity.
Setup: Files are served with the Flask app and deployed with CodeDeploy.

### 8. Scripts/InstallDependencies.sh
Shell script to install dependencies on EC2 instances (run by CodeDeploy).

Purpose: Automates dependency installation.
Setup: CodeDeploy uses this script during BeforeInstall.

### 9. Scripts/StartServer.sh
Starts the Flask application on EC2 instances.

Purpose: Boots up the application server.
Setup: CodeDeploy executes this script after installation.

### 10. Scripts/StopServer.sh
Stops the Flask application on EC2 instances.

Purpose: Ensures a clean shutdown before deployment.
Setup: CodeDeploy runs this as part of the ApplicationStop lifecycle.

### 11. CI-CD/BuildSpec.yml
Build specification for CodeBuild.

Purpose: Defines build phases and artifact paths for CodePipeline.
Setup: CodeBuild automatically references this file during builds.

### 12. CI-CD/AppSpec.yml
Deployment specification for CodeDeploy.

Purpose: Controls deployment process, including lifecycle event scripts.
Setup: Place in the root directory so CodeDeploy can reference it.

### 13. Lambda/Auto Scaling Adjustment/handler.py
Lambda function to manage Auto Scaling configurations.

Purpose: Adjusts scaling settings based on conditions.
Setup: Deploy as a Lambda function and trigger as needed.

### 14. Lambda/DB Maintenance/handler.py
Lambda function for RDS maintenance, like database snapshots.

Purpose: Ensures database snapshots and backup routines.
Setup: Deploy as a Lambda function with CloudWatch Events for periodic execution.

### 15. .gitignore
Git ignore file to exclude unnecessary files.

Purpose: Prevents unwanted files (e.g., environment, cache) from being committed.
Setup: Update as needed to fit project needs.

### 16. README.md
Documentation for project setup and usage.

Purpose: Provides information about the project, setup instructions, and usage details.
Setup: Customize with specific setup instructions or dependencies.

## Setting Up the Project
### 1. Provision Infrastructure:

Deploy Infrastructure/CloudFormation/Infrastructure.yml on AWS (or Terraform/main.tf if using Terraform).

### 2. Configure CI/CD Pipeline:

Set up CodePipeline to monitor your repository for changes.
Link CodePipeline to CodeBuild using CI-CD/BuildSpec.yml for application builds.
Set up CodeDeploy with CI-CD/AppSpec.yml to deploy application artifacts to EC2 instances.

### 3. Run .github Actions (Optional):

Place .github/workflows/CICDPipeline.yml in the .github/workflows/ directory to enable .github Actions.
Ensure that .github repository secrets are configured for AWS credentials.

### 4. Deploy the Application:

CodePipeline will automatically deploy your app to EC2 instances, managed by Auto Scaling and served via ELB.

### 5. Configure Monitoring and Maintenance:

Deploy Lambda functions in Lambda/ to handle auto-scaling and RDS maintenance.

### 6. Testing and Verification:

Verify that the ELB routes traffic to EC2 instances, scaling up or down as needed.
Confirm that CodeDeploy performs zero-downtime deployments and the CI/CD pipeline runs as expected.
