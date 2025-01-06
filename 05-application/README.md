# 05-application: Terraform Project for Application Deployment and Gateway Configuration

This Terraform project is designed to deploy a demo Tomcat application to a Google Kubernetes Engine (GKE) cluster and expose it to the internet using GKE Gateway. It also verifies database connectivity using a `dbcheck.jsp` page within the Tomcat application.

## Project Overview

This project focuses on deploying a sample web application (Tomcat) with database connectivity to a GKE cluster, demonstrating end-to-end application deployment and traffic management with GKE Gateway. It builds upon the GKE cluster provisioned by the `03-gke` Terraform project and connects to the AlloyDB instance created by `03-db` project. It also includes deployment of a simple nginx pod to demonstrate load balancing.

### Key Components

*   **GKE Gateway:** Creates a GKE Gateway to provide an entry point for the web applications.
*   **HTTPRoute:** Configures HTTPRoute for the GKE Gateway to route traffic to the Tomcat and Nginx applications.
*   **Tomcat Deployment:** Deploys a Tomcat application with a custom image (including PostgreSQL Driver) to the GKE cluster.
*  **Nginx Deployment:** Deploys a simple Nginx application to the GKE cluster for testing.
*   **Database Connection Verification:** Verifies database connectivity via `/dbcheck.jsp` inside of the tomcat pod.

### Architecture

This project uses a Terraform module and additional resources organized as follows:

*   **`./modules/50-gke-gateway`**: This module is responsible for creating and managing a GKE Gateway resource, including HTTP routes and supporting services.
*   **`./docker`**: This directory contains the `Dockerfile` used to build a custom Tomcat image with the PostgreSQL JDBC driver, which will be deployed to your GKE cluster.
*   **`./gke-yaml`**: This directory contains Kubernetes manifest files for application deployment, including:
    *   `dbcheck-config.yaml`: Defines a ConfigMap to inject the `dbcheck.jsp` file into the Tomcat pod.
    *   `nginx.yaml`: Defines a deployment and service manifest for a simple Nginx container.
    *   `tomcat.yaml`: Defines a deployment and service manifest for a custom Tomcat image with `dbcheck.jsp`.

The project's root directory contains the following files:

*   **`main.tf`:** This file contains the main Terraform configuration. It uses local variables and data sources, and invokes modules to perform the resource creation based on variables provided. It uses output from `03-db` to retrieve database information and `04-gke` to get cluster details.
*   **`data.tf`:** This file defines data sources used in the project.
*   **`outputs.tf`:** This file defines the outputs of the Terraform module, enabling data sharing with other projects if needed.
*   **`backend.tf`:** This file specifies the GCS bucket where the Terraform state will be stored for remote state management.
*   **`providers.tf`:** This file defines the Kubernetes provider, and other required provider configurations.
*   **`variables.tf`:** This file defines variables that allow customization of the resources, such as the GCP region, project id, image url, application versions, database settings and cluster information.
*    **`versions.tf`**: This file defines provider versions to enforce specific provider version.
*   **`<workspace_name>.tfvars`:** This file (e.g., `dev.tfvars` for a `dev` workspace) is used to set custom variable values for the selected Terraform workspace.

## Prerequisites

Before using this Terraform project, ensure that you have the following:

*   A GCP project with billing enabled.
*   Terraform CLI installed and configured.
*   Proper authentication and authorization to manage GCP resources.
*   A GKE Autopilot cluster created by the `04-gke` Terraform project.
*  The AlloyDB instance created by `03-db` terraform project.
*   A custom Tomcat image pushed to the artifact registry using the `Dockerfile` in `./docker` folder

## Usage

**Important:** Terraform workspaces are used to manage different environments. Please ensure that you select the proper workspace before applying Terraform configuration. The `01-landing-zone` project does not use workspaces and requires the use of `terraform.tfvars` file directly.

### Initialization

1.  Navigate to the project directory.
    ```bash
    cd 06-application
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
    *   `gateway_namespace`: The namespace for the GKE Gateway.
    * `app_namespace` : The namespace for Tomcat deployment and HTTPRoute.
    * `db_connection_uri` : The connection string of AlloyDB which is retrieved by 03-db output.
    * `db_private_ip` : The private IP address and Port of AlloyDB instance, which is retrieved by 03-db output.
    * `db_user` : The username to connect AlloyDB.
    * `db_password` : The password to connect AlloyDB.
    * `db_name` : The database name to connect AlloyDB.

4. Optionally, customize the variables.tf file to change any of the variable defaults.

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

1. Verify that the GKE Gateway and HTTPRoute have been successfully created in your GKE cluster.
2. Verify that the Tomcat and Nginx applications are running and accessible via the GKE Gateway's external IP.
3. Access /dbcheck.jsp endpoint of Tomcat application to verify the database connection is successful.

## Dependencies

This project depends on the successful deployment of the 01-landing-zone, 02-service-network, 03-db, and 04-gke Terraform projects. This project uses output from 03-db to retrieve database information and 04-gke to get GKE cluster details.

## Variables

The following variables can be configured in a `<workspace_name>.tfvars` file (e.g. `dev.tfvars`, `prod.tfvars` etc.):

*   `project_name` (Required): The name of the GCP project, which is used to retrieve the project ID from 01-landing-zone output.
*   `region` (Optional, default: `asia-northeast3`): The GCP region for GKE resources.
* `gateway_namespace` (Optional, default: gke-gateway-namespace): The namespace for the GKE Gateway.
* `app_namespace` (Optional, default: default): The namespace for the Tomcat and Nginx deployment.
* `db_connection_uri` (Required): The AlloyDB instance connection name.
* `db_private_ip` (Required): The Private IP address and Port of AlloyDB instance.
* `db_user` (Required): The username to connect AlloyDB.
* `db_password` (Required): The password to connect AlloyDB.
* `db_name` (Required): The database name to connect AlloyDB.


## Important Considerations

*   **GKE Gateway**: This project assumes that a GKE Gateway is used for external load balancing and traffic management.
* **Application Deployment**: Ensure that the container image for Tomcat is available in the specified image registry.
* **Database Connection**: Configure database connection settings via environment variables.
* **Health Checks**: Configure GKE Load Balancer health check for the Tomcat application.
* **Terraform Workspaces**: This project uses Terraform workspaces for managing different environments. Ensure you have selected the correct workspace before deployment.
* **Dependency**: This project depends on 01-landing-zone, 02-service-network, 03-db and 04-gke projects.

## Troubleshooting

*   **Error: Insufficient Permissions:** Ensure that your service account has the correct permissions to create and manage GKE resources.
*   **Error: Invalid Parameters:** Double-check the values set in your `<workspace_name>.tfvars` file to make sure all parameters are set correctly.
*   **Connection Issues**: Verify that your network configuration and application settings allow your app to connect to AlloyDB correctly.
* If you encounter a dependency error ensure that you deploy 01-landing-zone, 02-service-network, 03-db and 04-gke before deploying 06-application.
* Please check the Terraform log to find more accurate error messages.

## Support

If you encounter any issues or have any questions, please contact <kimhakmin@google.com>.
