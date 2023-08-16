terraform {
  required_providers {
    tanzu-mission-control = {
      source = "vmware/tanzu-mission-control"
      version = "1.2.0"    # it's the provider version and you can change it as version changes
    }
  }
}
provider "tanzu-mission-control" {
  endpoint            = var.vmw_host            # optionally use TMC_ENDPOINT env var
  vmw_cloud_api_token = var.vmw_api_token # optionally use VMW_CLOUD_API_TOKEN env var
  # if you are using dev or different csp endpoint, change the default value below
  # for production environments the csp_endpoint is console.cloud.vmware.com
  # vmw_cloud_api_endpoint = "console.cloud.vmware.com" or optionally use VMW_CLOUD_ENDPOINT env var
}

resource "tanzu-mission-control_cluster_group" "create_cluster_group" {
  name = "tf-cluster-group"
  meta {
    description = "Create cluster group through terraform"
  }
}

# Create Tanzu Mission Control attach cluster with k8s cluster kubeconfig path provided
# The provider would create the cluster entry and apply the deployment link manifests on to the k8s kubeconfig provided.
resource "tanzu-mission-control_cluster" "attach_cluster_with_kubeconfig_path" {
  management_cluster_name = "attached"     # Default: attached
  provisioner_name        = "attached"     # Default: attached
  name                    = "demo-cluster" # Required

  attach_k8s_cluster {
    kubeconfig_file = "/Users/kapte/.kube/config" # Required
    description     = "optional description about the kube-config provided"
  }

  meta {
    description = "description of the cluster"
    labels      = { "type" : "azure" }
  }

  spec {
    cluster_group = tanzu-mission-control_cluster_group.create_cluster_group.name
  }

  ready_wait_timeout = "15m" # Default: waits until 3 min for the cluster to become ready
}
