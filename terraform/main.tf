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

resource "scaleway_instance_ip" "public_ip" {}

#resource "scaleway_instance_server" "zabbix_web" {
#  type        = "GP1-XS"
#  image       = "ubuntu_focal"
#  name        = "zabbix_web"
 
#  tags = [ "zabbix_web", "1" ]
#}


#resource "scaleway_instance_server" "zabbix_server" {
#  type        = "GP1-XS"
#  image       = "ubuntu_focal"
#  name        = "zabbix_server"

#  tags = [ "zabbix_server", "2" ]
#}

resource "scaleway_instance_server" "web" {
  type = "DEV1-S"
  image = "debian_bullseye"
  ip_id = scaleway_instance_ip.public_ip.id
  user_data = {
    cloud-init = file("./zabbix.sh")
  #ip_id = scaleway_instance_ip.public_ip.id
  }
}

#resource "scaleway_lb" "base" {
#  ip_id  = scaleway_lb_ip.ip.id
#  zone = "fr-par-1"
#  type   = "LB-S"
#  release_ip = false
#}
