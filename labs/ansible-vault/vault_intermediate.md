# Ansible Vault

## Scenario

There are a number of features unique to Ansible playbooks which provide robust functionality. This exercise explores many of these features in a practical scenario of deploying a web server. Most notably, this exercise deals with confidential data in an Ansible vault and working with tags in Ansible playbooks.

## Tasks
Start by creating an inventory file with a `webservers` group consisting of the VMs from the provided spreadsheet.

You must create a modular playbook used for webserver management. 

Create a playbook called `webserver.yml` that meets the following requirements:

On the host group `webservers`:

* Deploy `httpd`.
* You can assume all necessary firewall rules have been deployed.
* Start and enable `httpd`.
* Configure virtual host using the provided templates in `conf` directory:
  * `vhost.conf.j2`
  * `htpasswd.j2`   
  **NOTE:** The template references a variable defined in `conf/confidential` which must be included as a variable file in your playbook   
* Use ansible vault to secure `conf/confidential` with password "I love ansible".
* Copy `bin/data-job.sh` to `/opt/data-job.sh` on each node in webservers and run asynchronously, without polling for status.
* Create tags for the following tasks: 
   - `base-install` for `httpd` installation and service configuration.
   - `vhost` for virtual host deployment
   - `data-job` to execute the asynchronous data job.

## Test
Confirm the following: 
* Playbook execution prompts for vault password
* Playbook completes successfully
* `/opt/data-job.sh` is running on both nodes

## Congrats!


