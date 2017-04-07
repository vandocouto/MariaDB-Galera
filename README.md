Cluster MariaDB - Galera
===

## Project clone
<pre>
$ git clone https://github.com/vandocouto/MariaDB-Galera.git
</pre>
##Configure the keys file
step 1 - Create directory (chave)
<pre>
$ cd MariaDB-Galera/
$ mkdir chave
</pre>
step 2 - Move the .pem key into the key directory, file permission should be 400

<pre>
cd chave/
$ ls -ltr
total 4
-r-------- 1 evandrocouto evandrocouto 1692 Abr  7 12:32 Blog-Estudo.pem
</pre>
## Script deploy.sh
Step 1 - Inform AWS Access Key and AWS Secret Key
<pre>
cd ../
$ vim terraform/deploy.sh 
</pre>
##### Need full access on EC2
<pre>
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
</pre>
## Deploy infrastructure
#####Need to install Terraform and Ansible

Step 1 - Adjust the variable file

<pre>
$ vim terraform/default/variables.tf
</pre>

Step 2 - After tuning, run the command below
<pre>
 ./deploy.sh default plan
</pre>
Step 2 - Building the Infrastructure
<pre>
 ./deploy.sh default apply
</pre>

#### Output 
Will be displayed the IP's and Load Balance post construction
<pre>
Outputs:

Private IP = 10.0.0.8,10.0.3.238,10.0.1.220
Public IP = 34.203.229.66,54.236.17.153,54.91.250.110
lb_address = internal-MariaDBGalera-1689159607.us-east-1.elb.amazonaws.com
</pre>

## Running the playbook

Step 1 - Configuring the hosts file
<pre>
$ vim ansible/hosts
</pre>
Example:
##### Set as below (First public ip and private ip should be the manager)
<pre>
[galera]
34.203.229.66
54.236.17.153
54.91.250.110

[manager]
34.203.229.66

[node]
54.236.17.153
54.91.250.110

[all:children]
galera
manager
node

[all:vars]
manager_ip=10.0.0.8
node1_ip=10.0.3.238
node2_ip=10.0.1.110
root_db_password=pass
ansible_ssh_user=ubuntu
ansible_ssh_private_key_file=../chave/Blog-Estudo.pem
</pre>
Step 2 - Run the playbook
<pre>
$ ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i hosts tasks/main.yml
</pre>
### Access the instances and enter mysql with the user root and password pass
<pre>
$ mysql -u root -ppass
</pre>

Or

<pre>
mysql -u root -ppass -e "show status like 'wsrep_cluster_size'"
</pre>

If everything is correct, it should contain the value 3

<pre>
+--------------------+-------+
| Variable_name      | Value |
+--------------------+-------+
| wsrep_cluster_size | 3     |
+--------------------+-------+
</pre>