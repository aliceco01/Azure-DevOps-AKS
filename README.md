![image](https://github.com/user-attachments/assets/199206ae-f86e-4186-a940-ccb7d2ba8ed7)# AKS Cluster with Application Gateway Ingress Controller

[![Deploy To Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fyour-repo%2Fmain%2Fdeploy.json)
[![Visualize](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/visualizebutton.svg?sanitize=true)](http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fyour-repo%2Fmain%2Fdeploy.json)




## Overview

This repository contains a Bicep template that deploys a secure, production-ready Azure Kubernetes Service (AKS) cluster with Application Gateway Ingress Controller. The solution implements Azure best practices for enterprise Kubernetes deployments.

![image](https://github.com/user-attachments/assets/edfb6c8a-f3f6-4957-93b4-1860b56f2b23)


### Key Features

- AKS-managed AAD integration
- Azure RBAC for Kubernetes Authorization
- Managed identity instead of service principal
- Azure Active Directory pod-managed identities
- Azure Network Policies
- Azure Monitor for containers
- Application Gateway Ingress Controller add-on

## Prerequisites

- Azure subscription
- Azure CLI (latest version)
- Bicep CLI (latest version)
- Owner or Contributor permissions on your subscription
- Required resource providers registered:
  - Microsoft.ContainerService
  - Microsoft.Network
  - Microsoft.Storage
  - Microsoft.ManagedIdentity

## Getting Started

### Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/your-repo/aks-appgw-ingress.git
   cd aks-appgw-ingress
   ```

2. Deploy using Azure CLI:
   ```bash
   az login
   az account set --subscription <your-subscription-id>
   
   # Deploy with default parameters
   az deployment group create \
     --resource-group <your-resource-group> \
     --template-file main.bicep
   
   # Or deploy with custom parameters
   az deployment group create \
     --resource-group <your-resource-group> \
     --template-file main.bicep \
     --parameters resourceNamePrefix=myaks \
                  location=eastus \
                  aksClusterSku=Standard \
                  createPrivateCluster=true
   ```

### Configuration Options

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| resourceNamePrefix | string | aks | Prefix for all resource names |
| location | string | eastus | Azure region for deployment |
| aksClusterSku | string | Standard | AKS cluster SKU |
| createPrivateCluster | bool | false | Deploy as private cluster |
| aksNodeCount | int | 3 | Node count for user node pool |
| aksVmSize | string | Standard_DS3_v2 | VM size for AKS nodes |
| ...additional parameters... | | | |

## Architecture

The deployment creates a comprehensive Azure environment with the following components:

### Network Infrastructure
- Virtual network with 4 subnets:
  - AksSubnet: Hosts the AKS cluster
  - VmSubnet: Hosts jumpbox VM and private endpoints
  - AppGatewaySubnet: Hosts Application Gateway WAF2
  - AzureBastionSubnet: Azure Bastion

### Kubernetes Environment
- AKS cluster with:
  - System node pool (critical system pods only)
  - User node pool (application workloads)
  - User-defined managed identity

### Security Components
- Azure Bastion for secure VM access
- Application Gateway with WAF
- Key Vault for secrets management
- Private endpoints for secure service access
- Private DNS zones for name resolution

### Monitoring
- Log Analytics workspace for centralized logging
- Diagnostic settings for all resources

## Application Gateway Ingress Controller

This solution uses the AGIC add-on for AKS, which provides:

- Simplified deployment compared to Helm
- Automatic updates
- Enhanced AKS integration

### Multi-Namespace Support

AGIC can monitor multiple namespaces by:
- Removing the watchNamespace key
- Setting watchNamespace to an empty string
- Adding comma-separated namespaces

### Service Limits

- Standard V2: Maximum 100 active listeners, backend pools, etc.
- WAF V2: Maximum 40 active listeners, backend pools, etc.

## WAF Protection

The Web Application Firewall is configured in Prevention mode with:

- OWASP 3.1 rule set
- Custom sample rules:
  - Block requests with "blockme" in query string
  - Block requests with "evilbot" in User-Agent header

WAF policies apply in this order:
1. Per-URI policy
2. Listener-specific policy
3. Global policy

## Usage Examples

### Deploy a Sample Application

```bash
# Connect to your AKS cluster
az aks get-credentials --resource-group <your-resource-group> --name <your-aks-name>

# Deploy a sample application with ingress
kubectl apply -f examples/sample-app.yaml
```

### Configure Ingress with AGIC

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: sample-ingress
  annotations:
    kubernetes.io/ingress.class: azure/application-gateway
spec:
  rules:
  - host: sample.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: sample-service
            port:
              number: 80
```

## Troubleshooting

- **Check AGIC pod logs:**
  ```bash
  kubectl logs -n kube-system -l app=ingress-appgw
  ```

- **Verify Application Gateway health:**
  ```bash
  az network application-gateway show-backend-health -g <resource-group> -n <appgw-name>
  ```

- **Common issues:**
  - Network Security Group blocking traffic
  - Certificate issues with HTTPS listeners
  - Subnet address space exhaustion

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## References

- [AKS Documentation](https://docs.microsoft.com/en-us/azure/aks/)
- [Application Gateway Documentation](https://docs.microsoft.com/en-us/azure/application-gateway/)
- [AGIC Documentation](https://docs.microsoft.com/en-us/azure/application-gateway/ingress-controller-overview)
