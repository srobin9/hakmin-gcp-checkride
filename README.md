# GCP IaC with Terraform: Full Infrastructure Provisioning

This repository contains Terraform projects for provisioning and managing a complete Google Cloud Platform (GCP) infrastructure, from the foundational resources to application deployment. It leverages Terraform to automate the creation of a robust, scalable, and secure environment, encompassing GCP organization, shared VPC, network configurations, database services, Kubernetes cluster, and application deployment.

## Project Overview

This repository provides a modular and reusable approach to managing a full GCP infrastructure using Terraform. It is divided into several distinct projects, and utilizes Terraform workspaces to manage different environments for all projects, except for `01-landing-zone`. This modular design allows for greater flexibility, scalability, and maintainability.

### Key Features

*   **Full Infrastructure Automation:** Automates the entire process of provisioning GCP resources.
*   **Modular Project Structure:** Divides the infrastructure into logical modules for better management and maintainability.
*   **Terraform Workspaces:** Utilizes Terraform workspaces to manage different environments (dev, staging, prod, etc.) within the same code base for projects `02-service-network` to `05-application`.
*   **Remote State Management:** Stores Terraform state remotely in a Google Cloud Storage (GCS) bucket for collaboration and versioning.
*   **Shared VPC and Security:** Enforces network security using a Shared VPC architecture.
*   **GKE Autopilot Deployment:** Deploys and manages a GKE Autopilot cluster.
*   **CI/CD Integration:** Deploys CI/CD tools like Jenkins and ArgoCD using Helm.
*   **Database Connection:** Demonstrates database connection using a Tomcat application and AlloyDB.

### Project Structure

The repository is structured into the following Terraform projects, each representing a specific stage of infrastructure deployment:

1.  **01-landing-zone:**
    *   Sets up the GCP Organization, common resources, and a Shared VPC host project. This project is deployed once as a foundation and does not use workspaces.
2.  **02-service-network:**
    *   Provisions service VPCs, subnets, firewall rules, and Cloud NAT within service projects that will use the Shared VPC created by 01-landing-zone.
3.  **03-db:**
    *   Deploys AlloyDB instances and manages related configurations.
4.  **04-gke:**
    *   Provisions and manages a GKE Autopilot cluster, leveraging the networking configurations from 02-service-network.
5.  **05-helm:**
    *   Deploys applications like Jenkins and ArgoCD using Helm charts.
6.  **06-application:**
    *   Deploys a sample Tomcat application, configures GKE Gateway to expose the application, and verifies connectivity to the database provisioned by 03-db.

### Overall Architecture Diagram




## Prerequisites

Before using this repository, ensure that you have the following:

*   A GCP project with billing enabled and GCP Organization ID.
*   Terraform CLI installed and configured.
*   Proper authentication and authorization to manage GCP resources.
*   Basic understanding of Terraform, GCP, Kubernetes, Helm.
*   All sub-folders of this directory should have their own `terraform.tfvars` file that define variables, with the exception of `01-landing-zone` which uses `terraform.tfvars` directly.

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
       * `01-landing-zone` does not use workspaces, you should specify `terraform.tfvars` directly.

### Stage 2: Provisioning Service Networks (02-service-network)
1.  Navigate to the `02-service-network` directory.
    ```bash
    cd ../02-service-network
    ```
2.  Create a workspace:
    ```bash
     terraform workspace new <workspace_name>
    ```
3. Select a workspace:
    ```bash
    terraform workspace select <workspace_name>
    ```
4. Create a `<workspace_name>.tfvars` file (e.g. `dev.tfvars` for dev workspace) and define necessary variables for networking.
5. Initialize Terraform and apply the changes.
    ```bash
    terraform init -reconfigure
    terraform apply -var-file="<workspace_name>.tfvars"
    ```
    *   This project sets up the network infrastructure required for services, including VPCs, subnets, firewalls, and Cloud NAT.
     *  Use workspace to deploy resources for service network (e.g. create 'dev' workspace to create dev network infrastructure)

### Stage 3: Deploying Database Services (03-db)
1.  Navigate to the `03-db` directory.
    ```bash
    cd ../03-db
    ```
2. Create a workspace:
   ```bash
    terraform workspace new <workspace_name>
    ```
3. Select a workspace:
    ```bash
    terraform workspace select <workspace_name>
    ```
4.  Create a `<workspace_name>.tfvars` file (e.g. `dev.tfvars` for dev workspace) and define necessary variables for database service.
5. Initialize Terraform and apply the changes.
    ```bash
    terraform init -reconfigure
    terraform apply -var-file="<workspace_name>.tfvars"
    ```
    *   This project provisions AlloyDB instances within the networking configurations set up by `02-service-network`.
     * Use workspace to deploy databases for different environments (e.g. create 'dev' workspace to create databases for development environment)

### Stage 4: Setting Up Kubernetes (04-gke)
1.  Navigate to the `04-gke` directory.
    ```bash
    cd ../04-gke
    ```
2. Create a workspace:
   ```bash
    terraform workspace new <workspace_name>
    ```
3. Select a workspace:
    ```bash
    terraform workspace select <workspace_name>
    ```
4. Create a `<workspace_name>.tfvars` file (e.g. `dev.tfvars` for dev workspace) and define necessary variables for gke cluster.
5. Initialize Terraform and apply the changes.
    ```bash
    terraform init -reconfigure
    terraform apply -var-file="<workspace_name>.tfvars"
    ```
      *   This project provisions a GKE Autopilot cluster.
       *  Use workspace to deploy GKE clusters for different environments (e.g. create 'dev' workspace to create development GKE cluster)

### Stage 5: Deploying CI/CD Tools (05-helm)
1.  Navigate to the `05-helm` directory.
    ```bash
    cd ../05-helm
    ```
2. Create a workspace:
   ```bash
    terraform workspace new <workspace_name>
    ```
3. Select a workspace:
    ```bash
    terraform workspace select <workspace_name>
    ```
4.  Create a `<workspace_name>.tfvars` file (e.g. `dev.tfvars` for dev workspace) and define necessary variables for helm deployment.
5.  Initialize Terraform and apply the changes.
    ```bash
    terraform init -reconfigure
    terraform apply -var-file="<workspace_name>.tfvars"
    ```
       *   This project deploys applications like Jenkins and ArgoCD using Helm.
        *  Use workspace to deploy Jenkins and ArgoCD for different environments (e.g. create 'dev' workspace to create a CI/CD tool for development environment)

### Stage 6: Deploying the Application (06-application)
1.  Navigate to the `06-application` directory.
    ```bash
    cd ../06-application
    ```
2. Create a workspace:
   ```bash
    terraform workspace new <workspace_name>
    ```
3. Select a workspace:
    ```bash
    terraform workspace select <workspace_name>
    ```
4. Create a `<workspace_name>.tfvars` file (e.g. `dev.tfvars` for dev workspace) and define necessary variables for application deployment.
5.  Initialize Terraform and apply the changes.
    ```bash
    terraform init -reconfigure
    terraform apply -var-file="<workspace_name>.tfvars"
    ```
        *   This project deploys a sample Tomcat application, configures GKE Gateway, and manages database connections.
         *  Use workspace to deploy application for different environments (e.g. create 'dev' workspace to deploy tomcat for development)

### Terraform Workspaces

This repository uses Terraform workspaces to manage different environments, enabling you to deploy the same infrastructure with different configurations.

**Creating a Workspace:**
```bash
terraform workspace new <workspace_name>
```

**Listing a Workspace:**
```bash
terraform workspace list
```

**Selecting a Workspace:**
```bash
terraform workspace select <workspace_name>
```
워크스페이스별로 다른 변수 값을 사용하려면 terraform.tfvars 파일을 워크스페이스 이름으로 구분하여 생성합니다. (예: dev.tfvars, staging.tfvars, prod.tfvars)
또는, TF_WORKSPACE 환경 변수를 사용하여 조건부 변수 할당을 할 수 있습니다.
예시 (dev.tfvars, prod.tfvars):

# dev.tfvars
project_id = "my-dev-project"
region     = "us-central1"
# prod.tfvars
project_id = "my-prod-project"
region     = "us-east1"
예시 (main.tf에서 TF_WORKSPACE 사용):


terraform workspace select dev
terraform init -reconfigure -backend-config="dev.tfbackend"

Terraform

# main.tf

locals {
  env = terraform.workspace
}

resource "google_storage_bucket" "bucket" {
  name = "my-bucket-${local.env}" # 워크스페이스 이름에 따라 다른 버킷 이름 사용
}
6. 워크스페이스별 백엔드 구성 (권장):

각 워크스페이스의 상태 파일을 서로 다른 위치에 저장하려면, 백엔드 구성을 워크스페이스별로 다르게 설정해야 합니다.
terraform init 시 -backend-config 옵션을 사용하거나, terraform 블록 내에서 조건부 백엔드 구성을 사용할 수 있습니다.
예시 (terraform 블록 내 조건부 백엔드 구성):

Terraform

# main.tf

terraform {
  backend "gcs" {
    bucket = "my-tfstate-bucket"                  # Your bucket name
    prefix = "terraform/state/${terraform.workspace}" # workspace will create new folder
  }
}
```

**Deleting a Workspace**:
```bash
terraform workspace delete <workspace_name>
```

**Caution**: Delete all resources before deleting the workspace.

### Dependencies
Each project has specific dependencies. Please see the individual README.md files for each project for details.

**Important Considerations**
Authentication: Ensure that Terraform is properly authenticated with the correct permissions to manage your GCP projects.

State Management: Terraform state should be stored remotely using a GCS bucket and configured using backend.tf.

Variable Files: 01-landing-zone project should use terraform.tfvars file and other projects should create specific tfvars file for their environment using workspaces.

Versioning: Always use stable versions for dependencies and tools.

Resource Naming: Follow consistent naming conventions across all projects.

Dependency order: Make sure you run all the projects in the order mentioned above.

### Troubleshooting
Error: Insufficient Permissions: Ensure that your service account has the correct permissions to create and manage GCP resources.

Error: Invalid Parameters: Double-check the values set in your terraform.tfvars files.

Error: Dependency Errors: Ensure that you deploy Terraform projects in the correct order based on the project overview.

Resource Creation Issues: Check the GCP console and Terraform logs for detailed error messages.

### Support
If you encounter any issues or have any questions, please contact <kimhakmin@google.com>.
