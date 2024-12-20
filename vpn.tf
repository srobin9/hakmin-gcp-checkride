locals {
  envs = {
    prod-asia-northeast3-0 = {
      secret_name    = "cs-vpn-psk-prod-asia-northeast3-tunnel-0"
      secret_project = "cs-hc-68d939b7654140ba9f6f6249"
      secret_version = "1"
    }
    prod-asia-northeast3-1 = {
      secret_name    = "cs-vpn-psk-prod-asia-northeast3-tunnel-1"
      secret_project = "cs-hc-68d939b7654140ba9f6f6249"
      secret_version = "1"
    }
    nonprod-asia-northeast3-0 = {
      secret_name    = "cs-vpn-psk-nonprod-asia-northeast3-tunnel-0"
      secret_project = "cs-hc-68d939b7654140ba9f6f6249"
      secret_version = "1"
    }
    nonprod-asia-northeast3-1 = {
      secret_name    = "cs-vpn-psk-nonprod-asia-northeast3-tunnel-1"
      secret_project = "cs-hc-68d939b7654140ba9f6f6249"
      secret_version = "1"
    }
  }

  bgp_ips = {
    prod-prod-asia-northeast3-gateway-tnl0       = cidrhost("169.254.0.0/16", random_integer.hostnum["prod-asia-northeast3-0"].result)
    prod-prod-asia-northeast3-gateway-tnl1       = cidrhost("169.254.0.0/16", random_integer.hostnum["prod-asia-northeast3-1"].result)
    nonprod-nonprod-asia-northeast3-gateway-tnl0 = cidrhost("169.254.0.0/16", random_integer.hostnum["nonprod-asia-northeast3-0"].result)
    nonprod-nonprod-asia-northeast3-gateway-tnl1 = cidrhost("169.254.0.0/16", random_integer.hostnum["nonprod-asia-northeast3-1"].result)
  }
}

resource "random_integer" "hostnum" {
  for_each = local.envs
  min      = 1
  max      = 65535
}

data "google_secret_manager_secret_version_access" "secret_data" {
  for_each = local.envs
  project  = each.value.secret_project
  secret   = each.value.secret_name
  version  = each.value.secret_version
}

module "cs-prod-prod-asia-northeast3-gateway" {
  source     = "terraform-google-modules/vpn/google//modules/vpn_ha"
  version    = "~> 4.0"
  name       = "prod-asia-northeast3-gateway"
  project_id = module.cs-project-vpc-host-prod.project_id
  region     = "asia-northeast3"
  network    = module.cs-vpc-prod-shared.network_self_link
  stack_type = "IPV4_IPV6"
  peer_external_gateway = {
    name            = "on-premise-prod-vpn-gateway"
    redundancy_type = "TWO_IPS_REDUNDANCY"
    interfaces = [
      {
        id         = 0
        ip_address = "192.168.0.1"
      },
      {
        id         = 1
        ip_address = "192.168.0.2"
      }
    ]
  }
  router_asn         = 64600
  keepalive_interval = 20
  tunnels = {
    tnl0 = {
      bgp_peer = {
        address = cidrhost("${local.bgp_ips.prod-prod-asia-northeast3-gateway-tnl0}/30", 2)
        asn     = 65500
      }
      bgp_session_name = "prod-asia-northeast3-gateway-tnl0"
      bgp_peer_options = {
        ip_address = cidrhost("${local.bgp_ips.prod-prod-asia-northeast3-gateway-tnl0}/30", 1)
      }
      ike_version                     = 2
      vpn_gateway_interface           = 0
      peer_external_gateway_interface = 0
      shared_secret                   = data.google_secret_manager_secret_version_access.secret_data["prod-asia-northeast3-0"].secret_data
    }
    tnl1 = {
      bgp_peer = {
        address = cidrhost("${local.bgp_ips.prod-prod-asia-northeast3-gateway-tnl1}/30", 2)
        asn     = 65500
      }
      bgp_session_name = "prod-asia-northeast3-gateway-tnl1"
      bgp_peer_options = {
        ip_address = cidrhost("${local.bgp_ips.prod-prod-asia-northeast3-gateway-tnl1}/30", 1)
      }
      ike_version                     = 2
      vpn_gateway_interface           = 1
      peer_external_gateway_interface = 1
      shared_secret                   = data.google_secret_manager_secret_version_access.secret_data["prod-asia-northeast3-1"].secret_data
    }
  }
}

module "cs-nonprod-nonprod-asia-northeast3-gateway" {
  source     = "terraform-google-modules/vpn/google//modules/vpn_ha"
  version    = "~> 4.0"
  name       = "nonprod-asia-northeast3-gateway"
  project_id = module.cs-project-vpc-host-nonprod.project_id
  region     = "asia-northeast3"
  network    = module.cs-vpc-nonprod-shared.network_self_link
  stack_type = "IPV4_IPV6"
  peer_external_gateway = {
    name            = "on-premise-non-prod-vpn-gateway"
    redundancy_type = "TWO_IPS_REDUNDANCY"
    interfaces = [
      {
        id         = 0
        ip_address = "192.168.0.3"
      },
      {
        id         = 1
        ip_address = "192.168.0.4"
      }
    ]
  }
  router_asn         = 64700
  keepalive_interval = 20
  tunnels = {
    tnl0 = {
      bgp_peer = {
        address = cidrhost("${local.bgp_ips.nonprod-nonprod-asia-northeast3-gateway-tnl0}/30", 2)
        asn     = 65400
      }
      bgp_session_name = "nonprod-asia-northeast3-gateway-tnl0"
      bgp_peer_options = {
        ip_address = cidrhost("${local.bgp_ips.nonprod-nonprod-asia-northeast3-gateway-tnl0}/30", 1)
      }
      ike_version                     = 2
      vpn_gateway_interface           = 0
      peer_external_gateway_interface = 0
      shared_secret                   = data.google_secret_manager_secret_version_access.secret_data["nonprod-asia-northeast3-0"].secret_data
    }
    tnl1 = {
      bgp_peer = {
        address = cidrhost("${local.bgp_ips.nonprod-nonprod-asia-northeast3-gateway-tnl1}/30", 2)
        asn     = 65400
      }
      bgp_session_name = "nonprod-asia-northeast3-gateway-tnl1"
      bgp_peer_options = {
        ip_address = cidrhost("${local.bgp_ips.nonprod-nonprod-asia-northeast3-gateway-tnl1}/30", 1)
      }
      ike_version                     = 2
      vpn_gateway_interface           = 1
      peer_external_gateway_interface = 1
      shared_secret                   = data.google_secret_manager_secret_version_access.secret_data["nonprod-asia-northeast3-1"].secret_data
    }
  }
}
