provider "google"{
    version = "~> 3.45.0"
}
####template file 
data "template_file" "group1-startup-script"{
    template = "${file("${format("%s/install.sh.tpl",path.module)}")}"
}

####VPC Creation
resource "google_compute_network" "dss_default"{
    project                 = var.project_id
    name                    = var.network_name
    auto_create_subnetworks = false
}
####Subnet Creation
resource "google_compute_subnetwork" "dss_default"{
    name                    = "${var.network_name}-subnet"
    ip_cidr_range           = var.ip_cidr_range
    region                  = var.region
    network                 = google_compute_network.dss_default.id
}
####Subnet Creation for k8s
resource "google_compute_subnetwork" "dss_k8s"{
    name                    = "${var.network_name}-dss-k8s-subnet"
    ip_cidr_range           = var.ip_k8scidr_range
    region                  = var.region
    network                 = google_compute_network.dss_default.id
}

####firewall 
resource "google_compute_firewall" "dss_firewall_rules"{
    project                 = var.project_id
    name                    = "${var.network_name}"
    network                 = google_compute_network.dss_default.id
    description             = "Creates firewall rule targeting instances"

    allow{
        protocol = "tcp"
        ports    = ["80","8080","8443","8080","22","10000"]
    }
}

####compute instances
resource "google_compute_instance" "dss_default_instance"{
    name                    = "${var.network_name}-instance1"
    machine_type            = var.machine_type
    zone                    = var.zone

    boot_disk{
        initialize_params{
            image = "centos-cloud/centos-7"
        }
    }
    attached_disk{
        source = "${google_compute_disk.dss_data.self_link}" 
    }
    metadata = {
        "startup-script"="${data.template_file.group1-startup-script.rendered}"
    }
    network_interface{
        subnetwork          = google_compute_subnetwork.dss_default.id
        access_config{
            //Ephemeral IP
        }
    }
}
#### compute disk 
resource "google_compute_disk" "dss_data" {
  name  = "${var.network_name}-data-disk"
  type  = "pd-ssd"
  zone  = var.zone
  size  = var.data_disk_size
}
resource "google_storage_bucket" "dss-bucket" {
  name          = "${var.network_name}-gcs"
  location      = "US"
  force_destroy = true
  uniform_bucket_level_access = true
}
