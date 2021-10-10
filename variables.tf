variable "project_id"{
    description = "The project id to host the network in"
    default     = "candidate-ssarangi"
}
variable "region" {
    description = "Region"
    default     = "us-central1"
}
variable "network_name"{
    description = "network name"
    default     = "dss-pro"
}
variable "ip_cidr_range"{
    description = "cidr"
    default     = "10.1.0.0/25"
}
variable "ip_k8scidr_range"{
    description = "cidr"
    default     = "10.2.0.0/28"
}
variable "zone"{
    description = "dss zone"
    default     = "us-central1-a"
}
variable "machine_type"{
    description = "machine type"
    default     = "e2-standard-4"
}
variable "data_disk_size"{
    description = "data disk size"
    default     = "100"
}
variable "service_account_scopes"{
    description = "list of scopes for the instance"
    type        = list
    default     = [
        "https://www.googleapis.com/auth/compute",
        "https://www.googleapis.com/auth/logging.write",
        "https://www.googleapis.com/auth/devstorage.full_control",
    ]
}
