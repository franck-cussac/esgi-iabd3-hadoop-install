resource "local_file" "hosts" {
  content     = <<EOF
127.0.1.1       localhost2
127.0.0.1       localhost
::1             localhost ip6-localhost ip6-loopback
ff02::1         ip6-allnodes
ff02::2         ip6-allrouters

${google_compute_instance.manager.network_interface.0.network_ip} ${google_compute_instance.manager.instance_id}
${google_compute_instance.master.network_interface.0.network_ip} ${google_compute_instance.master.instance_id}
${google_compute_instance.edge.network_interface.0.network_ip} ${google_compute_instance.edge.instance_id}
${google_compute_instance.worker_1.network_interface.0.network_ip} ${google_compute_instance.worker_1.instance_id}
${google_compute_instance.worker_2.network_interface.0.network_ip} ${google_compute_instance.worker_2.instance_id}
${google_compute_instance.worker_3.network_interface.0.network_ip} ${google_compute_instance.worker_3.instance_id}
  EOF
  filename = "${path.module}/../roles/prepare/files/hosts"
}
resource "local_file" "ansible_hosts" {
  content     = <<EOF
[scm_server]
${google_compute_instance.manager.network_interface.0.access_config.0.nat_ip}

[db_server]
${google_compute_instance.manager.network_interface.0.access_config.0.nat_ip}

[utility_servers:children]
scm_server
db_server

[gateway_servers]
${google_compute_instance.edge.network_interface.0.access_config.0.nat_ip}        host_template=HostTemplate-Gateway

[edge_servers]
${google_compute_instance.edge.network_interface.0.access_config.0.nat_ip}        host_template=HostTemplate-Edge    role_ref_names=HDFS-HTTPFS-1

[master_servers]
${google_compute_instance.master.network_interface.0.access_config.0.nat_ip}        host_template=HostTemplate-Master1

[worker_servers]
${google_compute_instance.worker_1.network_interface.0.access_config.0.nat_ip}
${google_compute_instance.worker_2.network_interface.0.access_config.0.nat_ip}
${google_compute_instance.worker_3.network_interface.0.access_config.0.nat_ip}

[worker_servers:vars]
host_template=HostTemplate-Workers

[cdh_servers:children]
utility_servers
gateway_servers
edge_servers
master_servers
worker_servers

[cdh_servers:vars]
ansible_user=${var.gcp_ssh_user}
  EOF
  filename = "${path.module}/../tf_hosts"
}

output "vm" {
  value = google_compute_instance.manager
}
