# 04-gke: Terraform Project for GKE Cluster Provisioning (Autopilot and Standard)

This Terraform project is designed to provision and manage Google Kubernetes Engine (GKE) clusters within Google Cloud Platform (GCP). It supports provisioning of both GKE Autopilot and GKE Standard clusters and is responsible for configuring the cluster and related settings within designated service projects, leveraging the networking provided by `02-service-network`.

## Project Overview

This project focuses on creating and managing GKE clusters in GCP, providing a reusable and modular approach to configuring Kubernetes environments, enabling quick and consistent deployments across different projects. It builds upon the networking infrastructure set up by `02-service-network` and uses Terraform workspaces to manage different environments.

### Key Components

*   **GKE Autopilot Cluster:** Creates a GKE Autopilot cluster within a designated region and network if `enable_autopilot` variable is set to `true`.
*   **GKE Standard Cluster:** Provisions a GKE Standard cluster and node pools if `enable_autopilot` variable is set to `false`.
 *   **Private Endpoint Management:** Configures a bastion host VM for GKE cluster management when using a private GKE endpoint.

### Architecture

This project uses multiple Terraform modules located in the `./modules` directory:

*   **`./modules/30-gke-cluster`**: This module is responsible for creating a GKE cluster (Autopilot or Standard), setting up private cluster settings, and managing related configurations.
*   **`./modules/31-gke-nodepool`**: This module is responsible for creating and managing node pools for GKE standard clusters. It is used only when `enable_autopilot` variable is set to `false`.
*   **`./modules/32-compute-vm`**: This module is responsible for creating and managing a bastion host VM, for secure access to GKE clusters, especially when the GKE cluster is configured as private cluster. This module is used when private GKE endpoint is set up.

The project's root directory contains the following files:

*   **`main.tf`:** This file contains the main Terraform configuration. It uses local variables and data sources, and invokes modules to perform the resource creation based on variables provided. It uses output from `01-landing-zone` to retrieve project ids based on their names and uses output from `02-service-network` to retrieve network information.
*   **`data.tf`:** This file defines data sources used in the project.
*   **`outputs.tf`:** This file defines the outputs of the Terraform module, enabling data sharing with other projects if needed.
*   **`backend.tf`:** This file specifies the GCS bucket where the Terraform state will be stored for remote state management.
*   **`providers.tf`:** This file defines the Google provider and other required provider configurations.
*   **`variables.tf`:** This file defines variables that allow customization of the resources, such as the GCP region, project id, cluster names, and node pool configurations.
*  **`versions.tf`**: This file defines provider versions to enforce specific provider version.
*   **`<workspace_name>.tfvars`:** This file (e.g., `dev.tfvars` for a `dev` workspace) is used to set custom variable values for the selected Terraform workspace.

## Prerequisites

Before using this Terraform project, ensure that you have the following:

*   A GCP project with billing enabled.
*   Terraform CLI installed and configured.
*   Proper authentication and authorization to manage GCP resources.
 *  The shared VPC and service network have been created by `01-landing-zone` and `02-service-network` Terraform projects.

## Usage

**Important:** Terraform workspaces are used to manage different environments. Please ensure that you select the proper workspace before applying Terraform configuration. The `01-landing-zone` project does not use workspaces and requires the use of `terraform.tfvars` file directly.

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

1. Create a workspace:
    ```bash
    terraform workspace new <workspace_name>
    ```
2. Select a workspace:
    ```bash
    terraform workspace select <workspace_name>
    ```
3. Review and modify the `<workspace_name>.tfvars` file with your specific settings, such as:
    *   `project_name`: The name of the GCP project, this value is used to look up project ID from 01-landing-zone output.
    *   `region`: The GCP region for GKE resources.
    *   `cluster_name`: The name of the GKE cluster.
    *  `network`: The self link of service VPC which is retrieved by `02-service-network`.
   *   `enable_autopilot`: Set to `true` for an Autopilot cluster, `false` for a Standard cluster.
  *  **Standard Mode Specific**:
          * When `enable_autopilot` is `false`, you will need to configure the `node_pool_name` and `machine_type` variables.

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
        *  Make sure you specify your current workspace's tfvars file (e.g. `dev.tfvars`)

### Post-Deployment Steps

1.  Verify that the GKE cluster has been successfully created in your GCP project.
2.  Access your GKE cluster and check that nodepools are setup correctly (only for Standard cluster).
3. Check the GKE console to view the status of the cluster and workloads.

## Dependencies

This project depends on the successful deployment of the `01-landing-zone` and `02-service-network` Terraform projects. This project uses output from `01-landing-zone` to retrieve project id based on the `project_name` variable, and uses output from `02-service-network` to retrieve networking information.

## Variables

The following variables can be configured in a `<workspace_name>.tfvars` file (e.g. `dev.tfvars`, `prod.tfvars` etc.):

*   `project_name` (Required): The name of the GCP project, which is used to retrieve the project ID from 01-landing-zone output.
*   `region` (Optional, default: `asia-northeast3`): The GCP region for GKE resources.
*   `cluster_name` (Optional, default: `gke-autopilot-cluster`): The name of the GKE cluster.
*   `network` (Required): The self link of service VPC which is retrieved by `02-service-network`.
*   `enable_autopilot` (Optional, default: `true`): Set to `true` to create an Autopilot cluster. Set to `false` to create a Standard cluster.
*   **Standard Node Pool Configurations (only if `enable_autopilot` is `false`):**
    *  `node_pool_name` (Optional, default: `default-pool`): The name of the node pool for the standard cluster
    *  `machine_type` (Optional, default: `e2-medium`):  The machine type for the node pool.
  *  **Private GKE Cluster and Bastion Host:**
    * When private endpoint for gke cluster is set up (e.g. private cluster), it creates a bastion host to connect to GKE.

## Important Considerations

*   **Autopilot vs Standard:**  Set `enable_autopilot` to `true` for a GKE Autopilot cluster (recommended), or set to `false` for a GKE Standard cluster. If you choose Standard cluster, you must specify the node pool setting.
*  **VPC Network:** The GKE cluster must use a private IP network which is setup using the `02-service-network` terraform project.
*   **Terraform Workspaces:** This project uses Terraform workspaces for managing different environments. Ensure you have selected the correct workspace before deployment.
*  **Private Cluster:** Private cluster is enabled for secure communication with other GCP resources.
*   **Customization:** You can customize the variables in `variables.tf` to fit your project-specific needs.
*   **Resource Naming:** Follow consistent naming conventions for all your resources.
*  **Dependency:** This project needs output from `01-landing-zone` and `02-service-network`

## Troubleshooting

*   **Error: Insufficient Permissions:** Ensure that your service account has the correct permissions to create and manage GKE resources.
*   **Error: Invalid Parameters:** Double-check the values set in your `<workspace_name>.tfvars` file to make sure all parameters are set correctly.
*   **Cluster Creation Issues:** Check the GKE console and Terraform log for detailed error messages if the cluster cannot be created.
*  If you encounter a `dependency error` ensure that you deploy `01-landing-zone` and `02-service-network` before deploying `04-gke`.
*   Please check the Terraform log to find more accurate error messages.

## Support

If you encounter any issues or have any questions, please contact <kimhakmin@google.com>.
