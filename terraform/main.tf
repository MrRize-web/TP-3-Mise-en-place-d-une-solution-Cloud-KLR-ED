terraform {
 required_providers {
  scaleway = {
   source = "scaleway/scaleway"
  }
 }
 required_version = ">= 0.13"
}

provider "scaleway" {
  zone = "fr-par-1"
  region = "fr-par"
}

resource "scaleway_instance_ip" "public_ip" {
}

resource "scaleway_k8s_cluster" "KubeCluster" {
  name             = "KubeCluster"
  description      = "my awesome cluster"
  version          = "1.18.0"
  cni              = "calico"
  tags             = ["Cluster Kuber"]

  autoscaler_config {
    disable_scale_down              = false
    scale_down_delay_after_add      = "5m"
    estimator                       = "binpacking"
    expander                        = "random"
    ignore_daemonsets_utilization   = true
    balance_similar_node_groups     = true
    expendable_pods_priority_cutoff = -5
  }
}

resource "scaleway_k8s_pool" "KubeClusterPool" {
  cluster_id  = scaleway_k8s_cluster.KubeCluster.id
  name        = "KubeClusterPool"
  node_type   = "GP1-XS"
  size        = 3
  autoscaling = true
  autohealing = true
  min_size    = 1
  max_size    = 5
}

resource "scaleway_instance_volume" "data" {
  size_in_gb = 20
  type = "b_ssd"
}
resource "scaleway_instance_volume" "data2" {
  size_in_gb = 20
  type = "b_ssd"
}

resource "scaleway_instance_server" "Grafana1" {
  type        = "GP1-XS"
  image       = "ubuntu_focal"
  name        = "Grafana-1"

  tags = [ "Grafana", "1" ]

  additional_volume_ids = [ scaleway_instance_volume.data.id ]
}


resource "scaleway_instance_server" "Grafana2" {
  type        = "GP1-XS"
  image       = "ubuntu_focal"
  name        = "Grafana-2"

  tags = [ "Grafana", "2" ]

  additional_volume_ids = [ scaleway_instance_volume.data2.id ]
}

resource "scaleway_instance_server" "web" {
  type        = "GP1-XS"
  image       = "ubuntu_focal"
  name        = "Grafana-3"
 # user_name      = "user"
 # password       = "Epsi2021!"

  user_data = {
    foo        = "bar"
    cloud-init = file("${path.module}/cloud-init.yml")
  }
}


