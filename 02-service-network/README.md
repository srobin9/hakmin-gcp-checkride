# 02-service-network: Terraform Project for Service VPC and Networking Resources

This Terraform project is designed to provision and manage the network infrastructure required for services within Google Cloud Platform (GCP). It is responsible for creating VPC networks, subnets, firewall rules, and Cloud NAT configurations within the designated service projects, ensuring a secure and well-isolated environment for application deployment.

## Project Overview

This project focuses on creating and managing the networking resources for service projects in GCP, building upon the foundational shared VPC provisioned in the `01-landing-zone` project. It provides a reusable and modular approach to configuring networking resources, enabling quick and consistent deployment across different projects.

### Key Components

*   **VPC Networks:** Creates custom VPC networks within each service project, connecting to the Shared VPC.
*   **Subnets:** Defines subnets within the VPC network, specifying IP address ranges and regions.
*   **Firewall Rules:** Configures firewall rules to allow or deny specific traffic based on source, destination, and protocols.
*   **Cloud NAT:** Configures Cloud NAT to enable instances in private subnets to connect to the internet.

### Architecture

This project uses multiple Terraform modules located in the `./modules` directory:

*   **`./modules/20-net-vpc`**: This module is responsible for creating a VPC and setting up shared VPC access within the specified GCP project. It also allows creation of subnets within a specified region.
*   **`./modules/21-net-vpc-firewall`**: This module allows setting custom firewall rules for the VPC, providing specific and fine-grained access policies.
*   **`./modules/22-net-cloudnat`**: This module provisions a Cloud NAT gateway, enabling instances in private subnets to communicate with the internet.

The project's root directory contains the following files:

*   **`main.tf`:** This file contains the main Terraform configuration. It uses local variables and data sources, and invokes modules to perform the resource creation based on variables provided.
*   **`data.tf`:** This file defines data sources used in the project.
*   **`outputs.tf`:** This file defines the outputs of the Terraform module, enabling data sharing with other projects if needed.
*   **`backend.tf`:** This file specifies the GCS bucket where the Terraform state will be stored for remote state management.
*   **`providers.tf`:** This file defines the Google provider and other required provider configurations.
*   **`variables.tf`:** This file defines variables that allow customization of the resources, such as the GCP region, project id, and network names.
*  **`versions.tf`**: This file defines provider versions to enforce specific provider version.
*   **`dev.tfvars`:** This is a sample variable file for the `dev` Terraform workspace to set custom variable values. The actual file name should be set to the current workspace name (e.g., `staging.tfvars` for a `staging` workspace).

## Prerequisites

Before using this Terraform project, ensure that you have the following:

*   A GCP project with billing enabled.
*   Terraform CLI installed and configured.
*   Proper authentication and authorization to manage GCP resources.
*   The shared VPC has been created by `01-landing-zone` Terraform project.

## Usage

**Important:** Terraform workspaces are used to manage different environments. Please ensure that you select the proper workspace before applying Terraform configuration. The `01-landing-zone` project does not use workspaces and requires the use of `terraform.tfvars` file directly.

### Initialization

1.  Navigate to the project directory.
    ```bash
    cd 02-service-network
    ```
2.  Initialize Terraform.
    ```bash
    terraform init
    ```

### Configuration

1. Create a workspace:
    ```bash
    terraform workspace new <workspace_name>
    ```
2. Select a workspace:
    ```bash
     terraform workspace select <workspace_name>
    ```
3.  Review and modify the `<workspace_name>.tfvars` file with your specific settings, such as:
    *   `project_id`: The GCP project ID.
    *   `region`: The GCP region.
    *   `network_name`: The name of the VPC network.
    *   `subnet_name`: The name of the subnet.
    *   `subnet_cidr`: The IP address range for the subnet.
    *   `firewall_rules`: The configurations for firewall rules.

    *  For instance if you create `dev` workspace, you should create `dev.tfvars` file and fill the values.

4.  Optionally, customize the `variables.tf` file to change any of the variable defaults.

### Deployment

1.  Plan your changes:
    ```bash
    terraform plan -var-file="<workspace_name>.tfvars"
    ```
    * Make sure you specify your current workspace's tfvars file (e.g. `dev.tfvars`)
2.  Apply the changes:
    ```bash
    terraform apply -var-file="<workspace_name>.tfvars"
    ```
    * Make sure you specify your current workspace's tfvars file (e.g. `dev.tfvars`)

### Post-Deployment Steps

1.  Verify that the VPC networks, subnets, firewall rules, and Cloud NAT resources have been successfully created in your GCP project.
2.  Verify that the subnets are using the Shared VPC provided by the `01-landing-zone` Terraform project.

## Dependencies

This project depends on the successful deployment of the `01-landing-zone` Terraform project, which configures the shared VPC and basic infrastructure.

## Variables

The following variables can be configured in a `<workspace_name>.tfvars` file (e.g. `dev.tfvars`, `prod.tfvars` etc.):

*   `project_id` (Required): The GCP project ID.
*   `region` (Optional, default: `asia-northeast3`): The GCP region for network resources.
*   `network_name` (Optional, default: `service-vpc-network`): The name of the VPC network.
*   `subnet_name` (Optional, default: `service-subnet`): The name of the subnet.
*   `subnet_cidr` (Optional, default: `10.0.0.0/20`): The IP address range for the subnet.
*   `firewall_rules` (Optional): A list of firewall rule configurations.

## Important Considerations

*   **Shared VPC:** This module assumes a shared VPC has been provisioned, and subnets will be added within that VPC.
*   **Terraform Workspaces:** This project uses Terraform workspaces for managing different environments. Ensure you have selected the correct workspace before deployment.
*   **Security:** Carefully configure firewall rules to control access to your network resources. Private IP is a must.
*   **Customization:** You can customize the variables in `variables.tf` to fit your project-specific needs.
*   **Resource Naming:** Be consistent with your naming conventions to ensure the resources are identifiable.
*    **Workspaces:** You should be using Terraform workspaces for different environments, and `terraform.tfvars` should not be used in this project.

## Troubleshooting

*   **Error: Insufficient Permissions:** Ensure that your service account has the correct permissions to create and manage GCP resources.
*  **Error: Invalid Parameters:** Double-check the values set in your  `<workspace_name>.tfvars` file to make sure all parameters are set correctly.
*   **Connection Issues:** Verify that your network configuration allows instances to communicate with the internet through Cloud NAT and your local environment.
 * If you encounter a `dependency error` ensure that you deploy `01-landing-zone` before the `02-service-network`
*  Please check the Terraform log to find more accurate error messages.

## Support

If you encounter any issues or have any questions, please contact <kimhakmin@google.com>.
