# GCP IaC with Terraform: Full Infrastructure Provisioning

This repository contains Terraform projects for provisioning and managing a complete Google Cloud Platform (GCP) infrastructure, from the foundational resources to application deployment. It leverages Terraform to automate the creation of a robust, scalable, and secure environment, encompassing GCP organization, shared VPC, network configurations, database services, Kubernetes cluster, and application deployment.

## Project Overview

This repository provides a modular and reusable approach to managing a full GCP infrastructure using Terraform. It is divided into several distinct projects, each focusing on a specific set of resources and responsibilities. Terraform workspaces are used to manage different environments for all projects, except for `01-landing-zone`. This modular design allows for greater flexibility, scalability, and maintainability.

### Key Features

*   **Full Infrastructure Automation:** Automates the entire process of provisioning GCP resources using Terraform.
*   **Modular Project Structure:** Divides the infrastructure into logical modules for better management and maintainability.
*   **Terraform Workspaces:** Utilizes Terraform workspaces to manage different environments (dev, staging, prod, etc.) within the same code base for all projects except `01-landing-zone`.
*   **Remote State Management:** Stores Terraform state remotely in a Google Cloud Storage (GCS) bucket for collaboration and versioning.
*   **Shared VPC and Security:** Enforces network security using a Shared VPC architecture.
*   **GKE Autopilot and Standard Deployment:** Provisions GKE clusters, supporting both Autopilot and Standard modes.
*   **CI/CD Integration:** Deploys CI/CD tools like Jenkins and ArgoCD using Helm.
*   **Database Connection:** Demonstrates database connection using a Tomcat application and AlloyDB.
*   **Custom Tomcat Image:** Deploys a Tomcat application with a custom image which include postgresql driver and dbcheck jsp.
*   **GKE Gateway:** Creates a GKE Gateway to provide an advanced entry point for the web applications, offering features beyond traditional ingress controllers.

### Project Structure

*  **01-landing-zone:**
    *   Sets up the GCP Organization, common resources, and a Shared VPC host project. This project is deployed once as a foundation and does not use workspaces.
     *  This project must be executed from a dedicated Terraform Host Project.
*  **02-service-network:**
    *   Provisions service VPCs, subnets, firewall rules, and Cloud NAT within service projects that will use the Shared VPC created by `01-landing-zone`.
      * This project should be executed within the target gcp project
*  **03-db:**
    *   Deploys AlloyDB instances and manages related configurations, or Cloud SQL instances if desired.
      * This project should be executed within the target gcp project
*  **03-gke:**
    *   Provisions and manages a GKE Autopilot or Standard cluster, leveraging the networking configurations from `02-service-network`.
      * This project should be executed within the target gcp project
*  **04-helm:**
    *   Deploys applications like Jenkins and ArgoCD using Helm charts.
      * This project should be executed within the target gcp project
*  **05-application:**
    *   Deploys a sample Tomcat application with database connectivity, configures GKE Gateway, and exposes both tomcat and nginx applications to the internet.
        *  This project should be executed within the target gcp project

### Project Dependencies

The projects are designed with the following dependencies:

*   `02-service-network` depends on `01-landing-zone`: Uses output from `01-landing-zone` to retrieve project ids and connect to the Shared VPC.
*   `03-db` depends on `01-landing-zone` and `02-service-network`: Uses output from `01-landing-zone` to retrieve project id and from `02-service-network` to retrieve network information.
*   `03-gke` depends on `01-landing-zone` and `02-service-network`: Uses output from `01-landing-zone` to retrieve project id and from `02-service-network` to retrieve VPC information
*   `04-helm` depends on `03-gke`: Requires a GKE cluster created by `03-gke` and uses its output to connect Helm provider.
*   `05-application` depends on `01-landing-zone`, `02-service-network`, `03-db`, and `03-gke`: Uses output from `03-db` to retrieve database information and `03-gke` to get GKE cluster details.

#### Project Dependency Diagram
<img width="1038" alt="Screenshot 2025-01-06 at 2 45 53 PM" src="https://github.com/user-attachments/assets/47f23949-dd4d-4c62-aec6-ab9a598af456" />

### Overall Architecture Diagram
#### GCP Architecture 
<img width="1134" alt="Screenshot 2025-01-06 at 2 43 07 PM" src="https://github.com/user-attachments/assets/94185e4c-8ee1-415a-8325-6d474240b33a" />

#### GKE Cluster Architcture
<img width="1111" alt="Screenshot 2025-01-06 at 2 43 19 PM" src="https://github.com/user-attachments/assets/6e531543-d0d0-42d2-be7d-029c4ad7bf0a" />

## Prerequisites

Before deploying this repository, ensure that you have the following:

*   A GCP project with billing enabled and GCP Organization ID.
*   Terraform CLI installed and configured.
*   Proper authentication and authorization to manage GCP resources.
*   Basic understanding of Terraform, GCP, Kubernetes, and Helm.
* All sub-folders of this directory should have their own `terraform.tfvars` file that define variables, except for `01-landing-zone`.
* You must have a dedicated Terraform Host project to run the 01-landing-zone project
* You must have service project to run the remaining projects from 02-service-network to 05-application.

## Usage

### Stage 1: Setting Up the Foundation (01-landing-zone)

1.  Navigate to the `01-landing-zone` directory.
    ```bash
    cd 01-landing-zone
    ```
2.  Configure the `backend.tf` file with your GCS bucket details for storing the Terraform state.
3.  Create a `terraform.tfvars` file and define necessary variables for org id, billing account
4.  Initialize Terraform and apply the changes.
    ```bash
    terraform init -reconfigure
    terraform apply -var-file="terraform.tfvars"
    ```
    *   This project sets up the foundational resources, including the GCP Organization policies and the Shared VPC host project.
    *  `01-landing-zone` does not use workspaces, you should specify `terraform.tfvars` directly and must be executed on a dedicated Terraform Host Project.

### Stage 2: Provisioning Service Networks (02-service-network)

1.  Navigate to the `02-service-network` directory.
    ```bash
    cd 02-service-network
    ```
2.  Create a workspace:
    ```bash
     terraform workspace new <workspace_name>
    ```
3.  Select a workspace:
    ```bash
     terraform workspace select <workspace_name>
    ```
4.  Create a `<workspace_name>.tfvars` file (e.g., `dev.tfvars` for a `dev` workspace) and define necessary variables for networking.
5.  Initialize Terraform and apply the changes.
    ```bash
    terraform init -reconfigure
    terraform apply -var-file="<workspace_name>.tfvars"
    ```
    *   This project sets up the network infrastructure required for services, including VPCs, subnets, firewalls, and Cloud NAT.
    *  Use workspace to deploy resources for service network (e.g. create 'dev' workspace to create dev network infrastructure)

### Stage 3: Deploying Database Services (03-db)

1.  Navigate to the `03-db` directory.
    ```bash
    cd 03-db
    ```
2.  Create a workspace:
    ```bash
    terraform workspace new <workspace_name>
    ```
3.  Select a workspace:
    ```bash
    terraform workspace select <workspace_name>
    ```
4.  Create a `<workspace_name>.tfvars` file (e.g., `dev.tfvars` for a `dev` workspace) and define necessary variables for database service.
5.  Initialize Terraform and apply the changes.
    ```bash
    terraform init -reconfigure
    terraform apply -var-file="<workspace_name>.tfvars"
    ```
    *   This project provisions AlloyDB instances (or Cloud SQL instances if the module is uncommented) within the networking configurations set up by `02-service-network`.
    * Use workspace to deploy databases for different environments (e.g. create 'dev' workspace to create databases for development environment)
    *  This should be executed on the service project where you want to create resources

### Stage 4: Setting Up Kubernetes (03-gke)

1.  Navigate to the `03-gke` directory.
    ```bash
    cd 04-gke
    ```
2.  Create a workspace:
    ```bash
    terraform workspace new <workspace_name>
    ```
3.  Select a workspace:
    ```bash
    terraform workspace select <workspace_name>
    ```
4.  Create a `<workspace_name>.tfvars` file (e.g., `dev.tfvars` for a `dev` workspace) and define necessary variables for GKE cluster.
5.  Initialize Terraform and apply the changes.
    ```bash
    terraform init -reconfigure
    terraform apply -var-file="<workspace_name>.tfvars"
    ```
    *   This project provisions a GKE Autopilot or Standard cluster.
    *   Use workspace to deploy GKE clusters for different environments (e.g. create 'dev' workspace to create a development GKE cluster)
    *  This should be executed on the service project where you want to create resources

### Stage 5: Deploying CI/CD Tools (04-helm)

1.  Navigate to the `04-helm` directory.
    ```bash
    cd 04-helm
    ```
2.  Create a workspace:
    ```bash
    terraform workspace new <workspace_name>
    ```
3.  Select a workspace:
    ```bash
    terraform workspace select <workspace_name>
    ```
4.  Create a `<workspace_name>.tfvars` file (e.g., `dev.tfvars` for a `dev` workspace) and define necessary variables for Helm deployment.
5.  Initialize Terraform and apply the changes.
    ```bash
    terraform init -reconfigure
    terraform apply -var-file="<workspace_name>.tfvars"
    ```
    *   This project deploys applications like Jenkins and ArgoCD using Helm.
    *   Use workspace to deploy Jenkins and ArgoCD for different environments (e.g. create 'dev' workspace to create a CI/CD tool for development environment)
    *  This should be executed on the service project where you want to create resources

### Stage 6: Deploying the Application (05-application)

1.  Navigate to the `05-application` directory.
    ```bash
    cd 05-application
    ```
2.  Create a workspace:
    ```bash
    terraform workspace new <workspace_name>
    ```
3.  Select a workspace:
    ```bash
    terraform workspace select <workspace_name>
    ```
4. Create a `<workspace_name>.tfvars` file (e.g. `dev.tfvars` for dev workspace) and define necessary variables for application deployment.
5.  Initialize Terraform and apply the changes.
    ```bash
    terraform init -reconfigure
    terraform apply -var-file="<workspace_name>.tfvars"
    ```
    *   This project deploys a sample Tomcat application and Nginx application, configures GKE Gateway, and manages database connections.
    *  Use workspace to deploy application for different environments (e.g. create 'dev' workspace to deploy tomcat for development)
    *  This should be executed on the service project where you want to create resources
  
### Terraform Workspaces

This repository uses Terraform workspaces to manage different environments, enabling you to deploy the same infrastructure with different configurations.

*   **Creating a Workspace:**
    ```bash
    terraform workspace new <workspace_name>
    ```
*   **Listing Workspaces:**
    ```bash
    terraform workspace list
    ```
*   **Selecting a Workspace:**
    ```bash
    terraform workspace select <workspace_name>
    ```
*   **Using Workspace-Specific Variables:**
    *   Create a `terraform.tfvars` file for the `01-landing-zone` project.
    *   Create a `<workspace_name>.tfvars` file for each workspace in other projects (e.g., `dev.tfvars`, `prod.tfvars` , `staging.tfvars` etc.).
*  **Workspace-Specific Backend Configuration (Recommended):**
    * To store state files in separate locations, use the `-backend-config` option during `terraform init` or use a conditional backend configuration as follows:

```terraform
terraform {
  backend "gcs" {
    bucket = "my-tfstate-bucket"                  # Your bucket name
    prefix = "terraform/state/${terraform.workspace}" # workspace will create new folder
  }
}
````

*   **Deleting a Workspace:**
    ```bash
    terraform workspace delete <workspace_name>
    ```
**Caution**: Delete all resources before deleting the workspace.

## Dependencies
Each project has specific dependencies. Please see the individual README.md files for each project for details.

## Important Considerations

* **Authentication**: Ensure that Terraform is properly authenticated with the correct permissions to manage your GCP projects.
* **Terraform Execution**: 01-landing-zone project must be executed on a dedicated Terraform Host project. Other project should be executed on the gcp project that you want to create the resource.
* **State Management**: Terraform state should be stored remotely using a GCS bucket, and you should initialize with the same backend settings.
* **Variable Files**: 01-landing-zone project should use terraform.tfvars file and other projects should create specific tfvars file for their environment using workspaces.
* **Versioning**: Always use stable versions for dependencies and tools.
* **Resource Naming**: Follow consistent naming conventions across all projects.
* **Dependency**: Make sure you run all the projects in the order mentioned above.

## Troubleshooting

* **Error: Insufficient Permissions**: Ensure that your service account has the correct permissions to create and manage GCP resources.
* **Error: Invalid Parameters**: Double-check the values set in your terraform.tfvars files.
* **Connection Issues**: Verify that your network configuration and application settings allow your app to connect to AlloyDB correctly.
* If you encounter a dependency error ensure that you deploy the projects in correct order.
* Please check the Terraform log to find more accurate error messages.

## References
* [Google Cloud Foundation Fabric](https://github.com/GoogleCloudPlatform/cloud-foundation-fabric/blob/master/README.md)
* [Terraform Google Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
  
## Support
If you encounter any issues or have any questions, please contact the <kimhakmin@google.com>.
