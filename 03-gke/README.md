# 03-gke: Terraform Project for GKE Autopilot Cluster Provisioning

This Terraform project is designed to provision and manage a Google Kubernetes Engine (GKE) Autopilot cluster within Google Cloud Platform (GCP). It is responsible for creating the GKE Autopilot cluster and configuring necessary settings for application deployment.

## Project Overview

This project focuses on creating a GKE Autopilot cluster in GCP, providing a reusable and modular approach to configuring a Kubernetes environment, enabling quick and consistent deployments across different projects.

### Key Components

*   **GKE Autopilot Cluster:** Creates a GKE Autopilot cluster within a designated region and network.
*   **Automatic Node Management:** Leverages GKE Autopilot's automated node provisioning and management features.

### Architecture Diagram

## Prerequisites

Before using this Terraform project, ensure that you have the following:

*   A GCP project with billing enabled.
*   Terraform CLI installed and configured.
*   Proper authentication and authorization to manage GCP resources.
*  The shared VPC and service network have been created by `01-landing-zone` and `02-service-network` terraform projects

## Usage

### Initialization

1.  Navigate to the project directory.
    ```bash
    cd 04-gke
    ```
2.  Initialize Terraform.
    ```bash
    terraform init
    ```

### Configuration

1.  Review and modify the `terraform.tfvars` file with your specific settings, such as:
    *   `project_id`: The GCP project ID.
    *   `region`: The GCP region.
     *   `cluster_name`: The name of the GKE Autopilot cluster.
    *   `network`: The self link of service VPC.
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

1.  Verify that the GKE Autopilot cluster has been successfully created in your GCP project.
2.  Check the GKE console to view the status of the autopilot cluster.

## Dependencies

This project depends on the successful deployment of the `01-landing-zone` and `02-service-network` Terraform projects, which set up the shared VPC and required networking.

## Variables

The following variables can be configured in the `terraform.tfvars` file:

*   `project_id` (Required): The GCP project ID.
*  `region` (Optional, default: `asia-northeast3`): The GCP region for the GKE cluster.
*   `cluster_name` (Optional, default: `gke-autopilot-cluster`): The name of the GKE Autopilot cluster.
*   `network` (Required): The self link of service VPC where to create the cluster.

## Important Considerations

*   **Autopilot Features:** This project specifically provisions a GKE Autopilot cluster, leveraging its automatic management capabilities.
*   **VPC Network:** The GKE cluster should be attached to service VPC, which is set up using the `02-service-network` terraform project.
*   **Customization:** You can customize the variables in `variables.tf` to fit your project-specific needs.
*  **Resource Naming:** Follow consistent naming conventions for all your resources.
*  **Private Cluster:** Private cluster is enabled for secure communication with other GCP resources.

## Troubleshooting

*   **Error: Insufficient Permissions:** Ensure that your service account has the correct permissions to create and manage GKE resources.
*  **Error: Invalid Parameters:** Double-check the values set in your `terraform.tfvars` file to make sure all parameters are set correctly.
*  **Cluster Creation Issues:** Check the GKE console and terraform log for detailed error message if the cluster cannot be created.
* If you encounter a `dependency error` ensure that you deploy `01-landing-zone` and `02-service-network` before deploying `04-gke`.
* Please check the Terraform log to find more accurate error messages.

## Support

If you encounter any issues or have any questions, please contact the infrastructure team.
