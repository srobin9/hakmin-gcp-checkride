# 03-db: Terraform Project for AlloyDB Instance Provisioning

This Terraform project is designed to provision and manage AlloyDB instances within Google Cloud Platform (GCP). It is responsible for creating AlloyDB clusters, instances, and configuring network access within the designated service projects.

## Project Overview

This project focuses on creating and managing AlloyDB database resources in GCP, providing a reusable and modular approach to configuring databases, allowing for quick and consistent deployment across different projects.

### Key Components

*   **AlloyDB Cluster:** Creates AlloyDB clusters within a designated region and network.
*   **AlloyDB Instance:** Configures AlloyDB instances within the created cluster, specifying machine types, and other settings.
* **Connection Management:** Handles the database connection settings with private IP.

### Architecture Diagram

## Prerequisites

Before using this Terraform project, ensure that you have the following:

*   A GCP project with billing enabled.
*   Terraform CLI installed and configured.
*   Proper authentication and authorization to manage GCP resources.
*  The shared VPC and service network have been created by `01-landing-zone` and `02-service-network` terraform project

## Usage

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

1.  Review and modify the `terraform.tfvars` file with your specific settings, such as:
    *   `project_id`: The GCP project ID.
    *   `region`: The GCP region.
    *   `alloydb_cluster_name`: The name of the AlloyDB cluster.
    *   `alloydb_instance_name`: The name of the AlloyDB instance.
    *   `machine_type`: The machine type for the AlloyDB instance.
    *  `authorized_network`: The self link of service VPC for AlloyDB to use private ip.

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

1.  Verify that the AlloyDB cluster and instance have been successfully created in your GCP project.
2.  Verify that the instance is configured to use private IP with authorized network.

## Dependencies

This project depends on the successful deployment of the `01-landing-zone`  and `02-service-network` Terraform projects, which set up the shared VPC and required networking.

## Variables

The following variables can be configured in the `terraform.tfvars` file:

*   `project_id` (Required): The GCP project ID.
*   `region` (Optional, default: `asia-northeast3`): The GCP region for the AlloyDB resources.
*  `alloydb_cluster_name` (Optional, default: `alloydb-cluster`): The name of the AlloyDB cluster.
*   `alloydb_instance_name` (Optional, default: `alloydb-instance`): The name of the AlloyDB instance.
*   `machine_type` (Optional, default: `db-standard-2`): The machine type for the AlloyDB instance.
* `authorized_network` (Required): The self link of service VPC for AlloyDB to use private ip.

## Important Considerations

*   **Private IP:** Make sure private IP is enabled in order to connect to the AlloyDB.
*   **Machine Type:** Choose the machine type that meets the performance requirements for your workloads.
*   **Region:** The chosen region should be aligned with your other GCP resources for optimal performance.
* **VPC Network:** The service project should be associated with shared VPC.

## Troubleshooting

*   **Error: Insufficient Permissions:** Ensure that your service account has the correct permissions to create and manage AlloyDB resources.
*  **Error: Invalid Parameters:** Double-check the values set in your `terraform.tfvars` file to make sure all parameters are set correctly.
*   **Connection Issues:** Verify that your network configuration and private IP settings allow you to connect to the AlloyDB database using internal ip addresses.
* If you encounter a `dependency error` ensure that you deploy `01-landing-zone` and `02-service-network` before deploying `03-db`.
* Please check the Terraform log to find more accurate error messages.

## Support

If you encounter any issues or have any questions, please contact the infrastructure team.
