# 05-helm: Terraform Project for Deploying Applications with Helm

This Terraform project is designed to deploy applications, such as Jenkins and ArgoCD, to a Google Kubernetes Engine (GKE) cluster using Helm. It is responsible for managing Helm releases and ensuring that applications are deployed in a consistent and repeatable manner.

## Project Overview

This project focuses on leveraging Helm to deploy applications to a GKE cluster provisioned by the `04-gke` Terraform project. It provides a modular and reusable approach to application deployment, enhancing speed and reliability of application delivery.

### Key Components

*   **Helm Releases:** Defines and manages Helm releases for Jenkins and ArgoCD.
*   **Application Configuration:** Configures applications using `values.yaml` files for customization.
*   **Namespace Management:** Creates dedicated namespaces for each application.

### Architecture Diagram

## Prerequisites

Before using this Terraform project, ensure that you have the following:

*   A GCP project with billing enabled.
*   Terraform CLI installed and configured.
*   Proper authentication and authorization to manage GCP resources.
*   A GKE Autopilot cluster created by `04-gke` terraform project.
*   Helm Provider for Terraform installed

## Usage

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

1.  Review and modify the `terraform.tfvars` file with your specific settings, such as:
    *   `project_id`: The GCP project ID.
    *   `region`: The GCP region.
    *   `jenkins_namespace`: The namespace for Jenkins deployment.
        * `jenkins_version`: The version of Jenkins to deploy
    *   `argocd_namespace`: The namespace for ArgoCD deployment.
        * `argocd_version`: The version of ArgoCD to deploy
    *  `gke_cluster_endpoint`: The Kubernetes cluster endpoint.
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

1.  Verify that Jenkins and ArgoCD have been successfully deployed to your GKE cluster in the specified namespaces.
2. Access your GKE cluster and check Helm deployment status

## Dependencies

This project depends on the successful deployment of the `04-gke` Terraform project which creates the GKE Autopilot cluster and other pre-requisites have been configured.

## Variables

The following variables can be configured in the `terraform.tfvars` file:

*   `project_id` (Required): The GCP project ID.
*   `region` (Optional, default: `asia-northeast3`): The GCP region for the GKE cluster.
*   `jenkins_namespace` (Optional, default: `jenkins`): The namespace for Jenkins deployment.
 *    `jenkins_version` (Optional, default: `4.10.4`): The version of Jenkins to deploy
*   `argocd_namespace` (Optional, default: `argocd`): The namespace for ArgoCD deployment.
 *    `argocd_version` (Optional, default: `5.20.0`): The version of ArgoCD to deploy
 * `gke_cluster_endpoint` (Required): The kubernetes cluster endpoint for helm to connect.

## Important Considerations

*   **Helm Provider:** This project requires that the Helm provider is correctly configured and installed on your local environment.
*    **Cluster Configuration:** Ensure that the kubernetes cluster is setup correctly, with the proper roles and permission set.
*   **Customization:** You can customize the values for Helm chart deployments using the `values.yaml` files provided.
*   **Versioning:** Always specify exact version for application deployment to ensure repeatability of the deployments.

## Troubleshooting

*   **Error: Insufficient Permissions:** Ensure that your service account has the correct permissions to deploy resources to the GKE cluster.
*   **Error: Invalid Parameters:** Double-check the values set in your `terraform.tfvars` file to make sure all parameters are set correctly.
*   **Connection Issues:** Verify that your Terraform has valid credentials and can connect to the GKE cluster.
* If you encounter a `dependency error` ensure that you deploy `04-gke` before deploying `05-helm`.
* Please check the Terraform log to find more accurate error messages.

## Support

If you encounter any issues or have any questions, please contact the infrastructure team.
