variable "project_name" {
  default = "learn-gcp-terra"
}

variable "gcp_region" {
  default = "europe-west1"
}

variable "machine_type" {
  default = "c2-standard-4"
}

variable "gcp_ssh_user" {
  default = "believe"
}

variable "gcp_ssh_pub_key_file" {
  default = "~/.ssh/id_rsa.pub"
}

variable "user" {
  default = "believe"
}
