provider "google" {
  credentials = file("/Users/romainsagean/Downloads/cosmic-sensor-277618-64ab058bd050.json")
  project     = var.project_name
  region      = var.gcp_region
}

// A single Google Cloud Engine instance
resource "google_compute_instance" "manager" {
  name         = "manager"
  machine_type = var.machine_type
  zone         = "${var.gcp_region}-d"

  boot_disk {
    initialize_params {
      image = "centos-7"
      type = "pd-ssd"
      size = "50"
    }
  }

  metadata = {
    ssh-keys = "${var.gcp_ssh_user}:${file(var.gcp_ssh_pub_key_file)}"
  }

  network_interface {
    network = "default"

    access_config {
      // Include this section to give the VM an external ip address
    }
  }
}

// A single Google Cloud Engine instance
resource "google_compute_instance" "master" {
  name         = "master"
  machine_type = var.machine_type
  zone         = "${var.gcp_region}-d"

  boot_disk {
    initialize_params {
      image = "centos-7"
      type = "pd-ssd"
      size = "50"
    }
  }

  metadata = {
    ssh-keys = "${var.gcp_ssh_user}:${file(var.gcp_ssh_pub_key_file)}"
  }

  network_interface {
    network = "default"

    access_config {
      // Include this section to give the VM an external ip address
    }
  }
}

// A single Google Cloud Engine instance
resource "google_compute_instance" "edge" {
  name         = "edge"
  machine_type = var.machine_type
  zone         = "${var.gcp_region}-d"

  boot_disk {
    initialize_params {
      image = "centos-7"
      type = "pd-ssd"
      size = "50"
    }
  }

  metadata = {
    ssh-keys = "${var.gcp_ssh_user}:${file(var.gcp_ssh_pub_key_file)}"
  }

  network_interface {
    network = "default"

    access_config {
      // Include this section to give the VM an external ip address
    }
  }
}

// A single Google Cloud Engine instance
resource "google_compute_instance" "worker_3" {
  name         = "worker-3"
  machine_type = var.machine_type
  zone         = "${var.gcp_region}-d"

  boot_disk {
    initialize_params {
      image = "centos-7"
      type = "pd-ssd"
      size = "50"
    }
  }

  metadata = {
    ssh-keys = "${var.gcp_ssh_user}:${file(var.gcp_ssh_pub_key_file)}"
  }

  network_interface {
    network = "default"

    access_config {
      // Include this section to give the VM an external ip address
    }
  }
}

// A single Google Cloud Engine instance
resource "google_compute_instance" "worker_2" {
  name         = "worker-2"
  machine_type = var.machine_type
  zone         = "${var.gcp_region}-d"

  boot_disk {
    initialize_params {
      image = "centos-7"
      type = "pd-ssd"
      size = "50"
    }
  }

  metadata = {
    ssh-keys = "${var.gcp_ssh_user}:${file(var.gcp_ssh_pub_key_file)}"
  }

  network_interface {
    network = "default"

    access_config {
      // Include this section to give the VM an external ip address
    }
  }
}

// A single Google Cloud Engine instance
resource "google_compute_instance" "worker_1" {
  name         = "worker-1"
  machine_type = var.machine_type
  zone         = "${var.gcp_region}-d"

  boot_disk {
    initialize_params {
      image = "centos-7"
      type = "pd-ssd"
      size = "50"
    }
  }

  metadata = {
    ssh-keys = "${var.gcp_ssh_user}:${file(var.gcp_ssh_pub_key_file)}"
  }

  network_interface {
    network = "default"

    access_config {
      // Include this section to give the VM an external ip address
    }
  }
}

// A single Google Cloud Engine instance
resource "google_compute_instance" "deploy" {
  name         = "deploy"
  machine_type = "n1-standard-1"
  zone         = "${var.gcp_region}-d"

  boot_disk {
    initialize_params {
      image = "centos-7"
      type = "pd-ssd"
      size = "50"
    }
  }

  metadata = {
    ssh-keys = "${var.gcp_ssh_user}:${file(var.gcp_ssh_pub_key_file)}"
  }

  network_interface {
    network = "default"

    access_config {
      // Include this section to give the VM an external ip address
    }
  }
}

// open cm and hue port to the internet
resource "google_compute_firewall" "default" {
  name    = "allow-scm"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["7180","7183", "8888"]
  }

  source_ranges = ["0.0.0.0/0"]
}