
## Prerequisites

Before using this Terraform project, ensure that you have the following:

*   A GCP project with billing enabled.
*   Terraform CLI installed and configured.
*   Proper authentication and authorization to manage GCP resources.
*   A GKE Autopilot cluster created by `04-gke` terraform project.
*  The custom Tomcat Image has been pushed to artifact registry.
* AlloyDB instance provisioned by `03-db` terraform project

## Usage

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

1.  Review and modify the `terraform.tfvars` file with your specific settings, such as:
    *   `project_id`: The GCP project ID.
    *   `region`: The GCP region.
    *   `gateway_namespace`: The namespace for the GKE Gateway.
     *  `app_namespace`: The namespace for Tomcat deployment and HTTPRoute
    * `db_connection_uri` : The connection string of AlloyDB
    * `db_private_ip`: The private ip of AlloyDB for connection
    *  `db_user`: The username for AlloyDB connection
    *  `db_password`: The password for AlloyDB connection
    * `db_name`: The database name for AlloyDB connection
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

1.  Verify that the GKE Gateway and HTTPRoute have been successfully created in your GKE cluster.
2.  Verify that the Tomcat application is running and accessible via the GKE Gateway's external IP.
3.  Access `/dbcheck.jsp` endpoint of Tomcat application to verify the database connection is successful.

## Dependencies

This project depends on the successful deployment of the `01-landing-zone`, `02-service-network`, `03-db` and `04-gke` Terraform projects, which set up the shared VPC, AlloyDB instance, and GKE Autopilot cluster respectively.

## Variables

The following variables can be configured in the `terraform.tfvars` file:

*   `project_id` (Required): The GCP project ID.
*    `region` (Optional, default: `asia-northeast3`): The GCP region for the GKE cluster.
*    `gateway_namespace` (Optional, default: `gke-gateway-namespace`): The namespace for the GKE Gateway.
    *   `app_namespace` (Optional, default: `default`): The namespace for the Tomcat deployment and HTTPRoute.
* `db_connection_uri` (Required): The AlloyDB instance connection name.
*  `db_private_ip` (Required): The Private IP address and Port of AlloyDB instance.
*   `db_user` (Required): The username to connect AlloyDB.
*  `db_password` (Required): The password to connect AlloyDB.
*    `db_name` (Required): The database name to connect AlloyDB.

## Important Considerations

*   **GKE Gateway:** This project assumes that a GKE Gateway is used for external load balancing and traffic management.
*   **Application Deployment:** Ensure that the container image for Tomcat is available in the specified image registry.
*   **Database Connection:** Configure database connection settings via environment variables.
*   **Health Checks:** Configure GKE Load Balancer health check for the Tomcat application.

## Troubleshooting

*   **Error: Insufficient Permissions:** Ensure that your service account has the correct permissions to create and manage GKE resources.
*   **Error: Invalid Parameters:** Double-check the values set in your `terraform.tfvars` file to make sure all parameters are set correctly.
*   **Connection Issues:** Verify that your network configuration and application settings allow your app to connect to AlloyDB correctly.
 * If you encounter a `dependency error` ensure that you deploy `01-landing-zone`, `02-service-network`, `03-db` and `04-gke` before deploying `06-application`.
* Please check the Terraform log to find more accurate error message.

## Support

If you encounter any issues or have any questions, please contact the infrastructure team.