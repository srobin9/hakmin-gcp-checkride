org_id          = "497314095400"
billing_account = "01ADFE-044C15-B43759"
prefix          = "khm5"

/*
The folder map is limited to three levels
The environment names are "Production", "Non Production" and "Development"
they are potentially referenced in iam.tf, service_projects.tf, and projects.tf
if you rename, e.g. "Production" to "Prod", you will need to find references like
module.cs-folders-level-1["Team 1/Production"].ids["Production"] and rename to
module.cs-folders-level-1["Team 1/Prod"].ids["Prod"]
*/
folders = {
  "Production" : {},
  "Non-Production" : {},
  "Development" : {},
}

groups = { 
  "prod1" = {
    id           = "prod1-service@kimhakmin.altostrat.com"
    display_name = "prod1-service"
    types        = ["default", "security"]
  },
  "prod2" = {
    id           = "prod2-service@kimhakmin.altostrat.com"
    display_name = "prod2-service"
    types        = ["default", "security"]
  },
  "nonprod1" = {
    id           = "nonprod1-service@kimhakmin.altostrat.com"
    display_name = "nonprod1-service"
  #  types        = ["default", "security", "admin"] <== Valid values for group types are "default", "dynamic", "security", "external".
    types        = ["default", "security"]
  },
  "nonprod2" = {
    id           = "nonprod2-service@kimhakmin.altostrat.com"
    display_name = "nonprod2-service"
    types        = ["default"]
  }
  "dev" = {
    id           = "development@kimhakmin.altostrat.com"
    display_name = "development-service"
    types        = ["default"]
  }
}

shared_vpcs = {
  "prod" = {
    network_name = "shared-vpc-prod"
    subnets = [
      {
        subnet_name               = "subnet-prod-shared-1"
        subnet_ip                 = "10.0.0.0/24"
        subnet_region             = "asia-northeast3"
        subnet_private_access     = true
        subnet_flow_logs          = true
        subnet_flow_logs_sampling = "0.5"
        subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
        subnet_flow_logs_interval = "INTERVAL_10_MIN"          
      },
      {
        subnet_name               = "subnet-prod-shared-2"
        subnet_ip                 = "10.0.10.0/24"
        subnet_region             = "asia-northeast3"
        subnet_private_access     = true
        subnet_flow_logs          = true
        subnet_flow_logs_sampling = "0.5"
        subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
        subnet_flow_logs_interval = "INTERVAL_10_MIN"             
      },
    ]
  },
  "nonprod" = {
    network_name = "shared-vpc-nonprod"
    subnets = [
      {
        subnet_name               = "subnet-nonprod-shared-1"
        subnet_ip                 = "10.10.0.0/24"
        subnet_region             = "asia-northeast3"
        subnet_private_access     = true
        subnet_flow_logs          = true
        subnet_flow_logs_sampling = "0.5"
        subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
        subnet_flow_logs_interval = "INTERVAL_10_MIN"   
      },
      {
        subnet_name               = "subnet-nonprod-shared-2"
        subnet_ip                 = "10.10.10.0/24"
        subnet_region             = "asia-northeast3"
        subnet_private_access     = true
        subnet_flow_logs          = true
        subnet_flow_logs_sampling = "0.5"
        subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
        subnet_flow_logs_interval = "INTERVAL_10_MIN"             
      },
    ]
  }
}

shared_firewall_rules = [ 
  {
    name      = "allow-icmp"
    direction = "INGRESS"
    priority  = 10000
    allow     = [{
      protocol = "icmp"
      ports    = []
    }]
    ranges = ["10.128.0.0/9"]
  },
  {
    name      = "allow-ssh"
    direction = "INGRESS"
    priority  = 10000
    allow     = [{
      protocol = "tcp"
      ports    = ["22"]
    }]
    ranges = ["35.235.240.0/20"]
  },
  {
    name      = "allow-rdp"
    direction = "INGRESS"
    priority  = 10000
    allow     = [{
      protocol = "tcp"
      ports    = ["3389"]
    }]
    ranges = ["35.235.240.0/20"]
  },
]

service_projects = {
  "prod1-svc" = {
    name            = "prod1-service"
    folder_name     = "Production"
    shared_vpc_key  = "shared-vpc-prod"
    group_key       = "prod1"
  }
  "prod2-svc" = {
    name            = "prod2-service"
    folder_name     = "Production"
    shared_vpc_key  = "shared-vpc-prod"
    group_key       = "prod2"
  }
  "nonprod1-svc" = {
    name            = "nonprod1-service"
    folder_name     = "Non-Production"
    shared_vpc_key  = "shared-vpc-nonprod"
    group_key       = "nonprod1"
  }
  "nonprod2-svc" = {
    name            = "nonprod2-service"
    folder_name     = "Non-Production"
    shared_vpc_key  = "shared-vpc-nonprod"
    group_key       = "nonprod2"
  }
  "dev-svc" = {
    name            = "development-service"
    folder_name     = "Development"
    shared_vpc_key  = "shared-vpc-nonprod"
    group_key       = "dev"
  }  
}

net_vpcs = {
  "dev" = {
    project_name = "development-service"
    network_name = "vpc-dev"
    subnets = [
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
  }
}

private_service_ranges = {
    cluster = "10.100.11.0/28"
}

nat_region = "asia-northeast3"

gke_clusters = {
  "dev" = {
    gke_deletion_protection = false #On version 5.0.0+ of the provider, you must explicitly set deletion_protection = false and run terraform apply to write the field to state in order to destroy a cluster.
    project_name            = "development-service"
    region                  = "asia-northeast3"
    network_name            = "vpc-dev"
    subnet_name             = "subnet-dev-gke"
    enable_autopilot        = false
  #  master_authorized_range = "10.100.0.0/24"
  }
}

helm_jenkins = {
  "dev" = {
    chart_version     = "5.7.26"
    ingress_enabled   = true
    ingress_host_name = "jenkins.example.com"
    admin_user        = "admin"
    admin_password    = "admin12334"
  }
}