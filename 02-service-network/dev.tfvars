org_id          = "497314095400"
billing_account = "01ADFE-044C15-B43759"
project_id      = "p-khm6-dev-svc"
region          = "asia-northeast3"
network_name    = "vpc"

subnet_config = [
  {
    subnet_ip                 = "10.100.0.0/24"
    subnet_name               = "subnet-dev-general"
    subnet_region             = "asia-northeast3"
    flow_logs_config = {
      flow_sampling         = 0.5
      aggregation_interval  = "INTERVAL_10_MIN"
    }
  },
  {
    subnet_ip                 = "10.100.10.0/24"
    subnet_name               = "subnet-dev-gke"
    subnet_region             = "asia-northeast3"
    secondary_ip_ranges       = {
      pods      = "172.16.0.0/20"
      services  = "192.168.0.0/24"
    }, 
    flow_logs_config = {
      flow_sampling         = 0.5
      aggregation_interval  = "INTERVAL_10_MIN"
    }
  },
]


