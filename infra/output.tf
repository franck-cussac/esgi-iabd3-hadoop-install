resource "local_file" "ansible_hosts" {
  content     = <<EOF
[scm_server]
manager.c.${var.project_name}.internal

[db_server]
manager.c.${var.project_name}.internal

[utility_servers:children]
scm_server
db_server

[gateway_servers]
edge.c.${var.project_name}.internal        host_template=HostTemplate-Gateway

[edge_servers]
edge.c.${var.project_name}.internal        host_template=HostTemplate-Edge    role_ref_names=HDFS-HTTPFS-1

[master_servers]
master.c.${var.project_name}.internal        host_template=HostTemplate-Master1

[worker_servers]
worker-1.c.${var.project_name}.internal
worker-2.c.${var.project_name}.internal
worker-3.c.${var.project_name}.internal

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

output "connect_to_deploy" {
  value = "ssh ${var.gcp_ssh_user}@${google_compute_instance.deploy.network_interface.0.access_config.0.nat_ip}"
}
