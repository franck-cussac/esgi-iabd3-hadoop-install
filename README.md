# Cloudera Playbook 

An Ansible Playbook that installs the Cloudera stack on RHEL/CentOS

## cloud install

1. create instance on GCP with `cd infra && terraform apply && cd ..`
2. connect to the deploy instance and
    - install python3 & git `sudo yum install -y python3 git`
    - install ansible `pip3 install --user ansible`
    - clone this repository
    - send the `tf_host` file created by terraform on this machine
    - send your private ssh key on the machine or ensure the ssh key are trusted by all machine
    - from this host connect to each instance of the cluster using FQDN `ssh edge.c.cosmic-sensor-277618.internal`
3. launch ansible playbook with the generated `tf_host` inventory `ansible-playbook -i tf_hosts site.yml`
4. when the playbook finish connect to the manager on port 7180 and proceed to cluster installation (you should disable all your adblocker)

## DB info
db credential information are set in `group_vars/db_server.yml`

## Running the playbook

* Setup an [Ansible Control Machine](http://docs.ansible.com/ansible/intro_installation.html). 

**Please do not use Ansible 2.9.0**. This version has an [issue with templating](https://github.com/ansible/ansible/issues/64745) which causes the playbook execution to fail. Instead, use any 2.8.x version or a later 2.9.x version as these are not affected. 

* Create Ansible configuration (optional):

```ini
$ vi ~/.ansible.cfg

[defaults]
# disable key check if host is not initially in 'known_hosts'
host_key_checking = False

[ssh_connection]
# if True, make ansible use scp if the connection type is ssh (default is sftp)
scp_if_ssh = True
```

* Create [Inventory](http://docs.ansible.com/ansible/intro_inventory.html) of cluster hosts:

```ini
$ vi ~/ansible_hosts

[scm_server]
host1.example.com

[db_server]
host2.example.com

[krb5_server]
host3.example.com

[utility_servers:children]
scm_server
db_server
krb5_server

[edge_servers]
host4.example.com        host_template=HostTemplate-Edge role_ref_names=HDFS-HTTPFS-1

[master_servers]
host5.example.com        host_template=HostTemplate-Master1
host6.example.com        host_template=HostTemplate-Master2
host7.example.com        host_template=HostTemplate-Master3

[worker_servers]
host8.example.com
host9.example.com
host10.example.com

[worker_servers:vars]
host_template=HostTemplate-Workers

[cdh_servers:children]
utility_servers
edge_servers
master_servers
worker_servers
```

**Important**: fully qualified domain name (FQDN) is mandatory in the ansible_hosts file
   
* Run playbook
 
```shell
$ ansible-playbook -i ~/ansible_hosts cloudera-playbook/site.yml
    
-i INVENTORY
   inventory host path or comma separated host list (default=/etc/ansible/hosts)
```

Ansible communicates with the hosts defined in the inventory over SSH. It assumes you’re using SSH keys to authenticate so your public SSH key should exist in ``authorized_keys`` on those hosts. Your user will need sudo privileges to install the required packages.

By default Ansible will connect to the remote hosts using the current user (as SSH would). To override the remote user name you can specify the ``--user`` option in the command, or add the following variables to the inventory:

```ini
[all:vars]
ansible_user=ec2-user
```

AWS users can use Ansible’s ``--private-key`` option to authenticate using a PEM file instead of SSH keys.

## Overriding CDH service/role configuration

The playbook uses [Cloudera Manager Templates](https://www.cloudera.com/documentation/enterprise/latest/topics/install_cluster_template.html) to provision a cluster.
As part of the template import process Cloudera Manager applies [Autoconfiguration](https://www.cloudera.com/documentation/enterprise/latest/topics/cm_mc_autoconfig.html)
rules that set properties such as memory and CPU allocations for various roles.

If the cluster has different hardware or operational requirements then you can override these properties in ``group_vars/cdh_servers``. 
For example:

```
cdh_services:
  - type: hdfs        
    datanode_java_heapsize: 10737418240
```

These properties get added as variables to the rendered template's instantiator block and can be referenced from the service configs.
For example ``roles/cdh/templates/hdfs.j2``:

```json
"roleType": "DATANODE",
"configs": [{
  "name": "datanode_java_heapsize",
  "variable": "DATANODE_JAVA_HEAPSIZE"
}
```

License
-----------
[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0)
