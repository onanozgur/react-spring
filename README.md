---
title: Azure Cloud Infrastructure using Terraform
description: Create Azure Cloud Infrastructure using Terraform
---

## Terraform Steps

### Step 1: Terraform Initialization
```t
# bash
  terraform init   
```
- Downloads required provider plugins (e.g., AzureRM).
- Prepares the working directory for Terraform operations.

### Step 2: Terraform Validate
```t
# bash
  terraform validate  
```

### Step 3: Terraform Plan
```t
# bash
  terraform plan  
```
- Creates an execution plan showing the resources to be created, updated, or destroyed.

### Step 4: Terraform Apply
```t
# bash
	terraform apply -auto-approve
```
- Applies the execution plan to provision infrastructure.

### Step 5: Terraform Destroy
```t
# Destroy Resources
	terraform destroy -auto-approve

# Delete Files
	rm -rf .terraform*
```

## Configure Environment Variables for the Service Principal

To enable Terraform to authenticate with Azure, set the following environment variables:

### Service Principal Variables

```t
# bash
export ARM_CLIENT_ID="<your-service-principal-client-id>"
export ARM_CLIENT_SECRET="<your-service-principal-client-secret>"
export ARM_SUBSCRIPTION_ID="<your-subscription-id>"
export ARM_TENANT_ID="<your-tenant-id>" 
```
### Steps to Retrieve Service Principal Credentials
1. Create a Service Principal:
```t
# bash
az ad sp create-for-rbac --name "TerraformSP" --role="Contributor" --scopes="/subscriptions/<SUBSCRIPTION_ID>"
```

- Replace <SUBSCRIPTION_ID> with your Azure subscription ID.
- Note the output values for appId, password, and tenant.

2. Set the Environment Variables: Use the output values to populate the environment variables:

```t
# bash
export ARM_CLIENT_ID="<appId>"
export ARM_CLIENT_SECRET="<password>"
export ARM_TENANT_ID="<tenant>"
```

3. Set the Environment Variables: Use the output values to populate the environment variables:

```t
# bash
az account show
```

- This command should display the subscription associated with your service principal.

### Tips for Managing Environment Variables

- Use a .env file for local development:

```t
# plaintext
ARM_CLIENT_ID=<your-service-principal-client-id>
ARM_CLIENT_SECRET=<your-service-principal-client-secret>
ARM_SUBSCRIPTION_ID=<your-subscription-id>
ARM_TENANT_ID=<your-tenant-id>
```

Load the variables with:

```t
# bash
export $(cat .env | xargs)
```

- For CI/CD pipelines (e.g., Azure DevOps, GitHub Actions, GitLab CI):
	- Add the variables as secrets in the pipeline configuration

## Azure Resource Explanation

### 1. Resource Group

- Purpose: Acts as a container for all the Azure resources, ensuring logical grouping and centralized management

- Key Properties:
	- Name: react-and-java-rg (default)
	- Location: eastus (default)
	
- Usage: All resources, such as the virtual network, App Services, and storage accounts, are created under this group

### 2. Virtual Network (VNet)

- Purpose: Provides network isolation and facilitates communication between resources

- Key Properties:
	- Name: react-java-vnet
	- Address Space: 10.0.0.0/16

- Usage: Contains the backend and frontend subnets to host App Services

### 3. Subnets

- Backend Subnet:
	- Purpose: Hosts the Java backend App Service
	- Address Prefix: 10.0.1.0/24
	- Service Endpoints: Microsoft.Web (enables secure connections to App Services)
	
- Frontend Subnet:
	- Purpose: Hosts the React frontend App Service
	- Address Prefix: 10.0.2.0/24
	- Service Endpoints: Microsoft.Web
	
### 4. App Service Plan

- Purpose: Provides the compute resources needed to host the App Services (both backend and frontend)

- Key Properties:
	- Name: react-and-java-plan
	- SKU: Standard (S1) (supports auto-scaling and VNet integration)
	
- Usage: Shared by the backend and frontend App Services

### 5. App Services

- Backend App Service:
	- Purpose: Hosts the Java backend application using a Docker container
	- Key Settings:
		- Container Image: <your-docker-registry>.azurecr.io/java-backend:latest
		- App Settings:
			- SPRING_PROFILES_ACTIVE=prod: Sets the Spring profile to production
			- APPINSIGHTS_INSTRUMENTATIONKEY: Enables Application Insights for monitoring
		- Virtual Network Integration: Configured to use the backend subnet
		
- Frontend App Service:
	- Purpose: Hosts the React frontend application using a Docker container
	- Key Settings:
		- Container Image: <your-docker-registry>.azurecr.io/react-frontend:latest
		- App Settings:
			- NODE_ENV=production: Sets the environment for React
			- APPINSIGHTS_INSTRUMENTATIONKEY: Enables Application Insights for monitoring
		- Virtual Network Integration: Configured to use the frontend subnet

### 6. Azure SQL Database

- Purpose: Provides a cloud-based relational database for the Java backend
- Key Properties:
	- Server Name: react-java-db-server
	- Database Name: react_java_db
	- SKU: S0 (Standard tier for small applications)
- Usage: The backend application connects to this database to persist data

##3 7. Storage Account

- Purpose: Stores static content, logs, or other application-related data
- Key Properties:
	- Name: reactjavastorage
	- Account Tier: Standard
	- Replication Type: LRS (Locally Redundant Storage)
- Usage: Provides additional storage for application needs

### 8. Log Analytics Workspace

- Purpose: Centralizes logs and metrics from all resources for monitoring and diagnostics
- Key Properties:
	- Name: react-java-logs
	- Retention: 30 days
- Usage: Used by Diagnostic Settings to store logs and metrics

### 9. Monitoring and Diagnostic Settings

- Purpose: Tracks the performance and health of the App Services.
- Key Configurations:
	- Logs:
		- AppServiceHTTPLogs: Captures HTTP logs for the backend and frontend
	- Metrics:
		- AllMetrics: Monitors all metrics for performance and resource usage
- Usage: Sends logs and metrics to the Log Analytics Workspace

### 10. Role Assignments

- Purpose: Grants necessary permissions for managing resources
- Key Assignments:
	- Service Principal:
		- Role: Contributor
		- Scope: The entire subscription for provisioning infrastructure
	- Personal Accounts:
		- Role: Contributor
		- Scope: Resource group level, enabling users to manage resources via the Azure Portal
		
## Azure DevOps Pipeline for Java Backend and React Frontend

- This pipeline automates the build, test, and deployment processes for a Java backend and React frontend application. It includes infrastructure provisioning, application deployment, and optional monitoring setup.

### Pipeline Stages

1. Trigger:

- Pipeline is triggered by changes to the main branch.

2. Environment Variables:

- Variables store sensitive credentials like service principal and Docker credentials.

3. Build Stage:

- Backend: Uses Maven to clean and package the Java Spring Boot application.
- Frontend: Uses npm to install dependencies and build the React application.

4. Test Stage:

- Backend: Runs unit tests using Maven.
- Frontend: Runs linting and unit tests using npm.

5. Dockerize Stage:

- Builds Docker images for both backend and frontend.
- Pushes the images to a Docker registry (e.g., Azure Container Registry).

6. Deploy Stage:

- Uses az CLI commands to deploy the Dockerized applications to Azure App Services.
- Deployments are environment-specific (e.g., staging, production).

### How to Use the Pipeline

1. Set Up Service Principal and Docker Credentials:

- Add ARM_CLIENT_ID, ARM_CLIENT_SECRET, ARM_SUBSCRIPTION_ID, ARM_TENANT_ID as pipeline secrets.
- Add DOCKER_USERNAME and DOCKER_PASSWORD as pipeline secrets.

2. Connect to Azure:

- Ensure the pipeline agent has access to Azure CLI for deployment.

3. Run the Pipeline:

- Commit changes to the main branch to trigger the pipeline.
