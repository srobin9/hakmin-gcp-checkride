# 03-db: Terraform Project for Database Instance Provisioning (AlloyDB and Cloud SQL)

This Terraform project is designed to provision and manage database instances within Google Cloud Platform (GCP). It supports provisioning of both AlloyDB and Cloud SQL instances and is responsible for creating database clusters and instances within the designated service projects, as well as configuring network access.

## Project Overview

This project focuses on creating and managing database resources in GCP, providing a reusable and modular approach to configuring databases, allowing for quick and consistent deployment across different projects. It builds upon the networking infrastructure set up by `02-service-network` and uses Terraform workspaces to manage different environments.

### Key Components

*   **AlloyDB Cluster:** Creates AlloyDB clusters within a designated region and network.
*   **AlloyDB Instance:** Configures AlloyDB instances within the created cluster, specifying machine types, and other settings.
*   **Cloud SQL Instance:** (Currently commented out) Allows for the creation of Cloud SQL instances within a designated service project.
*   **Connection Management:** Handles the database connection settings with private IP.

### Architecture

This project uses multiple Terraform modules located in the `./modules` directory:

*   **`./modules/30-alloydb`**: This module is responsible for creating and managing AlloyDB clusters and instances, setting up private IP connections and configurations.
*   **`./modules/31-cloudsql-instance`**: This module (currently commented out) allows the creation of Cloud SQL instances, supporting various database engines and configurations.

The project's root directory contains the following files:

*   **`main.tf`:** This file contains the main Terraform configuration. It uses local variables and data sources, and invokes modules to perform the resource creation based on variables provided. It uses output from `01-landing-zone` to retrieve project ids based on their names and uses output from `02-service-network` to retrieve networking information.
*   **`data.tf`:** This file defines data sources used in the project.
*   **`outputs.tf`:** This file defines the outputs of the Terraform module, enabling data sharing with other projects if needed.
*   **`backend.tf`:** This file specifies the GCS bucket where the Terraform state will be stored for remote state management.
*   **`providers.tf`:** This file defines the Google provider and other required provider configurations.
*   **`variables.tf`:** This file defines variables that allow customization of the resources, such as the GCP region, project id, database names and connection details.
*   **`versions.tf`**: This file defines provider versions to enforce specific provider version.
*   **`<workspace_name>.tfvars`:** This file (e.g., `dev.tfvars` for a `dev` workspace) is used to set custom variable values for the selected Terraform workspace.

## Prerequisites

Before using this Terraform project, ensure that you have the following:

*   A GCP project with billing enabled.
*   Terraform CLI installed and configured.
*   Proper authentication and authorization to manage GCP resources.
*   The shared VPC and service network have been created by `01-landing-zone` and `02-service-network` Terraform projects.

## Usage

**Important:** Terraform workspaces are used to manage different environments. Please ensure that you select the proper workspace before applying Terraform configuration. The `01-landing-zone` project does not use workspaces and requires the use of `terraform.tfvars` file directly.

### Initialization

1.  Navigate to the project directory.
    ```bash
    cd 03-db
    ```
2.  Initialize Terraform.
    ```bash
    terraform init
    ```

### Configuration

1.  Create a workspace:
    ```bash
    terraform workspace new <workspace_name>
    ```
2.  Select a workspace:
    ```bash
    terraform workspace select <workspace_name>
    ```
3.  Review and modify the `<workspace_name>.tfvars` file with your specific settings, such as:
    *   `project_name`: The name of the GCP project, this value is used to look up project ID from 01-landing-zone output.
    *   `region`: The GCP region.
    *   `alloydb_cluster_name`: The name of the AlloyDB cluster.
    *   `alloydb_instance_name`: The name of the AlloyDB instance.
    *   `machine_type`: The machine type for the AlloyDB instance.
    *  `authorized_network`: The self link of service VPC for AlloyDB to use private ip which is retrieved by 02-service-network.
   *  **Cloud SQL (optional):**
     * To use Cloud SQL, uncomment the `31-cloudsql-instance` module and configure variables for cloud sql.
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

1.  Verify that the AlloyDB or Cloud SQL instance has been successfully created in your GCP project.
2.  Verify that the instance is configured to use private IP with authorized network.

## Dependencies

This project depends on the successful deployment of the `01-landing-zone` and `02-service-network` Terraform projects. This project uses output from `01-landing-zone` to retrieve project id based on the `project_name` variable and uses output from `02-service-network` to retrieve network information.

## Variables

The following variables can be configured in a `<workspace_name>.tfvars` file (e.g. `dev.tfvars`, `prod.tfvars` etc.):

*   `project_name` (Required): The name of the GCP project, which is used to retrieve the project ID from 01-landing-zone output.
*   `region` (Optional, default: `asia-northeast3`): The GCP region for the database resources.
*   `alloydb_cluster_name` (Optional, default: `alloydb-cluster`): The name of the AlloyDB cluster.
*   `alloydb_instance_name` (Optional, default: `alloydb-instance`): The name of the AlloyDB instance.
*   `machine_type` (Optional, default: `db-standard-2`): The machine type for the AlloyDB instance.
*    `authorized_network` (Required): The self link of service VPC for AlloyDB to use private ip, which is from `02-service-network` output.
 *   **Cloud SQL (optional):**
       *  To enable Cloud SQL configuration, review and configure variables like: `cloudsql_instance_name`, `database_version`, `machine_type`, `region`, etc. You should uncomment the `31-cloudsql-instance` module call in `main.tf`.

## Important Considerations

*   **Private IP:** Make sure private IP is enabled in order to connect to the AlloyDB or CloudSQL.
*   **Machine Type:** Choose the machine type that meets the performance requirements for your workloads.
*   **Region:** The chosen region should be aligned with your other GCP resources for optimal performance.
*   **VPC Network:** The service project should be associated with a Shared VPC, and specified in the `authorized_network` variable. The network information will be retrieved from `02-service-network` output.
*   **Terraform Workspaces:** This project uses Terraform workspaces for managing different environments. Ensure you have selected the correct workspace before deployment.
*   **Cloud SQL:** Please note that the Cloud SQL module is currently commented out. Uncomment the module in `main.tf` file to deploy cloud SQL instead of AlloyDB.
* **Dependency:** This project depends on `01-landing-zone` and `02-service-network` projects.

## Troubleshooting

*   **Error: Insufficient Permissions:** Ensure that your service account has the correct permissions to create and manage database resources.
*   **Error: Invalid Parameters:** Double-check the values set in your `<workspace_name>.tfvars` file to make sure all parameters are set correctly.
*   **Connection Issues:** Verify that your network configuration and private IP settings allow you to connect to the AlloyDB or Cloud SQL database using internal ip addresses.
*  If you encounter a `dependency error` ensure that you deploy `01-landing-zone` and `02-service-network` before deploying `03-db`.
* Please check the Terraform log to find more accurate error messages.

## Support

If you encounter any issues or have any questions, please contact <kimhakmin@google.com>.
