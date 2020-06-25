variable "project_name" {
  default = "cosmic-sensor-277618"
}

variable "gcp_region" {
  default = "europe-west1"
}

variable "machine_type" {
  default = "n1-standard-4"
}

variable "gcp_ssh_user" {
  type = string
}

variable "gcp_ssh_pub_key_file" {
  default = "~/.ssh/id_rsa.pub"
}
