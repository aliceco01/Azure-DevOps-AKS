# Azure DevOps AKS Deployment with Security Best Practices

This repository contains Infrastructure as Code (IaC) using Terraform to deploy a private Azure Kubernetes Service (AKS) cluster with Azure Application Gateway as the ingress controller and Azure Container Registry (ACR), following DevSecOps methodologies and security best practices.

## Architecture Overview

The solution deploys:

1. **Private AKS Cluster**: Kubernetes API server is not exposed to the internet
2. **Azure Container Registry (ACR)**: For storing Docker images with network ACLs
3. **Azure Application Gateway with WAF**: For secure ingress with Web Application Firewall protection
4. **Virtual Network with NSGs**: Separate subnets for AKS and Application Gateway
5. **Azure Key Vault**: For storing sensitive information and secrets
6. **Log Analytics Workspace**: For centralized logging and monitoring

## Security Features

This implementation includes several security best practices:

1. **No Hardcoded Values**: All sensitive values stored in Azure DevOps variable groups or Key Vault
2. **Private Networking**: AKS API server not exposed to the internet
3. **Network Segmentation**: Separate subnets with NSGs for AKS and Application Gateway
4. **Web Application Firewall (WAF)**: Application Gateway with WAF_v2 SKU for protection against common web vulnerabilities
5. **Security Scanning**:
   - TFSec, TFLint, and Checkov for Terraform security scanning
   - Snyk for application dependency scanning
   - Trivy for container image scanning
6. **RBAC and Managed Identities**: Proper role assignments with least privilege principle
7. **Azure Monitor Integration**: Comprehensive logging and monitoring
8. **Secure Secret Management**: Azure Key Vault integration for secrets
9. **Network Policy**: Azure CNI with network policy enabled for pod-to-pod traffic control

## Repository Structure

```
├── azure-pipelines.yml               # Pipeline for infrastructure deployment
├── nextjs-app-pipeline.yml           # Pipeline for application deployment
├── terraform/
│   ├── main.tf                       # Main Terraform configuration
│   ├── variables.tf                  # Input variables for Terraform
│   ├── outputs.tf                    # Output variables from Terraform
│   ├── backend.tf                    # Terraform backend configuration
│   ├── terraform.tfvars.example      # Example variable values (DO NOT commit actual values)
│   └── modules/                      # Terraform modules
│       ├── network/                  # Virtual Network module
│       ├── acr/                      # Azure Container Registry module
│       ├── aks/                      # Azure Kubernetes Service module
│       └── appgw/                    # Application Gateway module
└── kubernetes/                       # Kubernetes manifests for the application
```

## Prerequisites

- Azure Subscription
- Azure DevOps Organization and Project
- Service Principal with Contributor access to your Azure Subscription
- Variable groups in Azure DevOps for storing secrets

## Setup Instructions

### 1. Creating Azure DevOps Variable Groups

Create the following variable groups in Azure DevOps:

1. **azure-credentials-dev** (replace "dev" with your environment name):
   - ARM_SUBSCRIPTION_ID: Your Azure subscription ID
   - ARM_TENANT_ID: Your Azure tenant ID
   - LOCATION: Default Azure region (e.g., "eastus")
   - OWNER: Owner of the resources

2. **app-secrets-dev** (for application-specific secrets):
   - Any application-specific secrets
   - SNYK_TOKEN: (Optional) Snyk API token for security scanning

### 2. Setting up Azure Backend for Terraform

The backend configuration uses the following pattern:

```
terraform init \
  -backend-config="resource_group_name=YOUR_RG" \
  -backend-config="storage_account_name=YOUR_STORAGE_ACCOUNT" \
  -backend-config="container_name=YOUR_CONTAINER" \
  -backend-config="key=YOUR_STATE_FILE_NAME.tfstate"
```

The pipeline will create these resources if they don't exist.

### 3. Setting up Azure Service Connections

Create the following service connections in Azure DevOps:

1. **azure-dev-sc** (replace "dev" with your environment name):
   - Connection type: Azure Resource Manager
   - Authentication method: Service Principal
   - Scope level: Subscription
   - Subscription: Your subscription
   - Service connection name: azure-dev-sc

2. **acr-service-connection** (for Docker image pushing):
   - Connection type: Azure Container Registry
   - Registry type: Azure Container Registry
   - Subscription: Your subscription
   - Azure container registry: Your ACR (created by Terraform)

### 4. Infrastructure Deployment

1. Import the infrastructure pipeline:
   - Go to Pipelines > New Pipeline > Azure Repos Git > Select your repository
   - Choose "Existing Azure Pipelines YAML file"
   - Select "azure-pipelines.yml"
   - Run the pipeline to deploy the infrastructure

### 5. Application Deployment

1. Fork the Next.js application repository from https://github.com/arikbidny/nextjsbasicapp

2. Add the "nextjs-app-pipeline.yml" file to the repository

3. Import the application pipeline:
   - Go to Pipelines > New Pipeline > Azure Repos Git > Select your Next.js app repository
   - Choose "Existing Azure Pipelines YAML file"
   - Select "nextjs-app-pipeline.yml"
   - Run the pipeline to build and deploy the application

## DevSecOps Practices Implemented

1. **Infrastructure as Code (IaC)**: All infrastructure defined as code using Terraform
2. **Version Control**: All code and configuration in Git
3. **Automated Security Scanning**: Multiple security scanning tools integrated into the pipeline
4. **Continuous Integration**: Automated builds with security testing
5. **Continuous Deployment**: Automated deployment to AKS
6. **Secrets Management**: No hardcoded secrets, all sensitive data in secured variable groups or Key Vault
7. **Least Privilege**: Using appropriate RBAC roles with minimal permissions
8. **Immutable Infrastructure**: Infrastructure can be rebuilt from code
9. **Automated Testing**: Integration tests run after deployment

## Troubleshooting

1. **Terraform state lock issue**: If deployment fails with state lock errors:
   ```bash
   az storage blob lease break --account-name YOUR_STORAGE_ACCOUNT --container-name YOUR_CONTAINER --blob-name YOUR_STATE_FILE_NAME.tfstate
   ```

2. **AKS connectivity issues**: For troubleshooting private AKS:
   ```bash
   az aks command invoke --resource-group YOUR_RG --name YOUR_CLUSTER --command "kubectl get pods -A"
   ```

3. **AGIC issues**: Check the ingress controller logs:
   ```bash
   kubectl logs -n ingress-azure -l app=ingress-azure
   ```

4. **Application Gateway issues**: Check Application Gateway health:
   ```bash
   az network application-gateway show-health --resource-group YOUR_RG --name YOUR_APPGW_NAME
   ```

## Maintenance and Updates

- **Security Updates**: The AKS cluster is configured with automatic channel updates for security patches.
- **Terraform Updates**: Update the Terraform version in the pipeline as needed.
- **Scaling**: Use the HPA (Horizontal Pod Autoscaler) for application scaling.