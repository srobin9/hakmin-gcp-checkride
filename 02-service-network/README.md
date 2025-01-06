# 02-service-network: Terraform Project for Service VPC and Networking Resources

This Terraform project is designed to provision and manage the network infrastructure required for services within Google Cloud Platform (GCP). It is responsible for creating VPC networks, subnets, firewall rules, and Cloud NAT configurations within the designated service projects, ensuring a secure and well-isolated environment for application deployment.

## Project Overview

This project focuses on creating and managing the networking resources for service projects in GCP, building upon the foundational shared VPC provisioned in the `01-landing-zone` project. It provides a reusable and modular approach to configuring networking resources, enabling quick and consistent deployment across different projects.

### Key Components

*   **VPC Networks:** Creates custom VPC networks within each service project.
*   **Subnets:** Defines subnets within the VPC network, specifying IP address ranges and regions.
*   **Firewall Rules:** Configures firewall rules to allow or deny specific traffic based on source, destination, and protocols.
*   **Cloud NAT:** Configures Cloud NAT to enable instances in private subnets to connect to the internet.

### Architecture Diagram

## Prerequisites

Before using this Terraform project, ensure that you have the following:

*   A GCP project with billing enabled.
*   Terraform CLI installed and configured.
*   Proper authentication and authorization to manage GCP resources.
* The shared VPC has been created by `01-landing-zone` terraform project

## Usage

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

1.  Review and modify the `terraform.tfvars` file with your specific settings, such as:
    *   `project_id`: The GCP project ID.
     *   `region`: The GCP region.
    *   `network_name`: The name of the VPC network.
    *   `subnet_name`: The name of the subnet.
    *   `subnet_cidr`: The IP address range for the subnet.
    *   `firewall_rules`: The configurations for firewall rules.
2.  Optionally, customize the `variables.tf` file to change any of the variable defaults.

### Deployment

1.  Plan your changes:
    ```bash
    terraform plan -var-file="terraform.tfvars"
    ```
2.  Apply the changes:
    ```bash
     terraform apply -var-file="terraform.tfvars"
    ```

### Post-Deployment Steps

1.  Verify that the VPC networks, subnets, firewall rules, and Cloud NAT resources have been successfully created in your GCP project.
2. Verify that the subnets are using the Shared VPC provided by the 01-landing-zone Terraform project

## Dependencies

This project depends on the successful deployment of the `01-landing-zone` Terraform project which configures the shared VPC.

## Variables

The following variables can be configured in the `terraform.tfvars` file:

*   `project_id` (Required): The GCP project ID.
*   `region` (Optional, default: `asia-northeast3`): The GCP region for network resources.
*   `network_name` (Optional, default: `service-vpc-network`): The name of the VPC network.
*   `subnet_name` (Optional, default: `service-subnet`): The name of the subnet.
*   `subnet_cidr` (Optional, default: `10.0.0.0/20`): The IP address range for the subnet.
*   `firewall_rules` (Optional): A list of firewall rule configurations.

## Important Considerations

*  **Shared VPC:** This module assumes a shared VPC has been provisioned, and subnets will be added within that VPC.
*   **Security:** Carefully configure firewall rules to control access to your network resources. Private IP is a must.
*   **Customization:** You can customize the variables in `variables.tf` to fit your project-specific needs.
*   **Resource Naming:** Be consistent with your naming conventions to ensure the resources are identifiable.

## Troubleshooting

*   **Error: Insufficient Permissions:** Ensure that your service account has the correct permissions to create and manage GCP resources.
*  **Error: Invalid Parameters:** Double-check the values set in your `terraform.tfvars` file to make sure all parameters are set correctly.
*   **Connection Issues:** Verify that your network configuration allows instances to communicate with the internet through Cloud NAT and your local environment.
* If you encounter a `dependency error` ensure that you deploy the 01-landing-zone before the `02-service-network`
* Please check the Terraform log to find more accurate error message.

## Support

If you encounter any issues or have any questions, please contact the infrastructure team.
