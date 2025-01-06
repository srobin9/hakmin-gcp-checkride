# 04-helm: Terraform Project for Deploying Applications with Helm

This Terraform project is designed to deploy applications, such as Jenkins and ArgoCD, to a Google Kubernetes Engine (GKE) cluster using Helm. It is responsible for managing Helm releases and ensuring that applications are deployed in a consistent and repeatable manner.

## Project Overview

This project focuses on leveraging Helm to deploy applications to a GKE cluster provisioned by the `03-gke` Terraform project. It provides a modular and reusable approach to application deployment, enhancing the speed and reliability of application delivery.

### Key Components

*   **Helm Releases:** Defines and manages Helm releases for Jenkins and ArgoCD.
*   **Application Configuration:** Configures applications using `values.yaml` files for customization.
*   **Namespace Management:** Creates dedicated namespaces for each application.
 *   **Wordpress Release**: (Currently commented out) allows wordpress deployments using Helm.

### Architecture

This project uses multiple Terraform modules located in the `./modules` directory:

*   **`./modules/41-helm-jenkins`**: This module is responsible for deploying Jenkins using its Helm chart.
*   **`./modules/42-helm-argocd`**: This module is responsible for deploying ArgoCD using its Helm chart.
*   **`./modules/43-helm-wordpress`**: This module (currently commented out) is responsible for deploying WordPress using its Helm chart.

The project's root directory contains the following files:

*   **`main.tf`:** This file contains the main Terraform configuration. It uses local variables and data sources, and invokes modules to perform the resource creation based on variables provided. It uses output from `04-gke` project to retrieve gke cluster information.
*   **`data.tf`:** This file defines data sources used in the project.
*   **`outputs.tf`:** This file defines the outputs of the Terraform module, enabling data sharing with other projects if needed.
*   **`backend.tf`:** This file specifies the GCS bucket where the Terraform state will be stored for remote state management.
*   **`providers.tf`:** This file defines the Google provider, Helm provider and other required provider configurations.
*   **`variables.tf`:** This file defines variables that allow customization of the resources, such as the GKE region, project id, application versions and cluster information.
*   **`versions.tf`**: This file defines provider versions to enforce specific provider version.
*   **`<workspace_name>.tfvars`:** This file (e.g., `dev.tfvars` for a `dev` workspace) is used to set custom variable values for the selected Terraform workspace.

## Prerequisites

Before using this Terraform project, ensure that you have the following:

*   A GCP project with billing enabled.
*   Terraform CLI installed and configured.
*   Proper authentication and authorization to manage GCP resources.
*   A GKE Autopilot cluster created by `04-gke` Terraform project.
*   Helm Provider for Terraform installed and properly configured to access your Kubernetes cluster.

## Usage

**Important:** Terraform workspaces are used to manage different environments. Please ensure that you select the proper workspace before applying Terraform configuration. The `01-landing-zone` project does not use workspaces and requires the use of `terraform.tfvars` file directly.

### Initialization

1.  Navigate to the project directory.
    ```bash
    cd 05-helm
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
    *   `project_id`: The GCP project ID.
    *   `region`: The GCP region.
    *   `jenkins_namespace`: The namespace for Jenkins deployment.
        *   `jenkins_version`: The version of Jenkins to deploy
    *   `argocd_namespace`: The namespace for ArgoCD deployment.
        *   `argocd_version`: The version of ArgoCD to deploy
     * `gke_cluster_endpoint`: The Kubernetes cluster endpoint for helm to connect, which is obtained from the `04-gke` module.
       *  **WordPress (Optional)**: To enable WordPress configuration, review and configure variables for wordpress helm deployment. You should also uncomment the `43-helm-wordpress` module in `main.tf`

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

1.  Verify that Jenkins and ArgoCD have been successfully deployed to your GKE cluster in the specified namespaces.
2. Access your GKE cluster and check Helm deployment status

## Dependencies

This project depends on the successful deployment of the `04-gke` Terraform project, which creates the GKE Autopilot cluster. It also depends on `04-gke` to get the kubernetes cluster endpoint, which is used by the Helm provider.

## Variables

The following variables can be configured in a `<workspace_name>.tfvars` file (e.g. `dev.tfvars`, `prod.tfvars` etc.):

*   `project_id` (Required): The GCP project ID.
*   `region` (Optional, default: `asia-northeast3`): The GCP region for the GKE cluster.
*   `jenkins_namespace` (Optional, default: `jenkins`): The namespace for Jenkins deployment.
*    `jenkins_version` (Optional, default: `4.10.4`): The version of Jenkins to deploy
*   `argocd_namespace` (Optional, default: `argocd`): The namespace for ArgoCD deployment.
*    `argocd_version` (Optional, default: `5.20.0`): The version of ArgoCD to deploy
*    `gke_cluster_endpoint` (Required): The Kubernetes cluster endpoint for helm to connect, which is retrieved by `04-gke` output.
*    **WordPress (Optional)**: To enable WordPress configuration, review and configure variables like:  `wordpress_namespace`, `wordpress_version`. You should also uncomment the `43-helm-wordpress` module in `main.tf`

## Important Considerations

*   **Helm Provider:** This project requires that the Helm provider is correctly configured and installed on your local environment.
*    **Cluster Configuration:** Ensure that the kubernetes cluster is setup correctly, with the proper roles and permission set.
*   **Customization:** You can customize the values for Helm chart deployments using the `values.yaml` files provided.
*   **Versioning:** Always specify exact versions for application deployment to ensure repeatability of the deployments.
 *  **Workspaces:** You should be using Terraform workspaces for different environments, and `terraform.tfvars` should not be used in this project.
 *  **Dependency:** This project depends on `04-gke` which provides the gke cluster endpoint.

## Troubleshooting

*   **Error: Insufficient Permissions:** Ensure that your service account has the correct permissions to deploy resources to the GKE cluster.
*   **Error: Invalid Parameters:** Double-check the values set in your `<workspace_name>.tfvars` file to make sure all parameters are set correctly.
*   **Connection Issues:** Verify that your Terraform has valid credentials and can connect to the GKE cluster.
*   If you encounter a `dependency error` ensure that you deploy `04-gke` before deploying `05-helm`.
* Please check the Terraform log to find more accurate error messages.

## Support

If you encounter any issues or have any questions, please contact <kimhakmin@google.com>.
