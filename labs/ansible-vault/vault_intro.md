# Ansible Vault

## Scenario

There are several features unique to Ansible playbooks that provide robust functionality. This exercise explores many of these features in a practical scenario of deploying a web server. Most notably, this exercise deals with confidential data in an Ansible vault and working with tags in Ansible playbooks.

## Tasks

Log in to the control node as `ec2-user` and sudo to the `ansible` user.
 ```
 sudo su - ansible
 ```

### Prerequisites

Before we begin, we need to pull the latest changes from our lab repo.

cd into the lab repo directory and pull updates.

```
cd ~/ansible-best-practices && git pull
```



Create and enter a working directory

 ```
mkdir /home/ansible/lab-vault && cd /home/ansible/lab-vault
 ```



### Use ansible-vault to protect the confidential information

Use `ansible-vault` to encrypt `/home/ansible/ansible-best-practices/labs/ansible-vault/conf/confidential` to protect the confidential information stored within using the password "I love ansible".

Run 
```
ansible-vault encrypt /home/ansible/ansible-best-practices/labs/ansible-vault/conf/confidential
``` 
and supply the password "I love ansible".

### Create a playbook that deploys httpd on webservers

Create a playbook in `/home/ansible/lab-vault/webserver.yml` that deploys `httpd` on the webservers. It should be tagged with `base-install` and contain a handler that restarts the `httpd` daemon that is flagged by both installation and service manipulation for `httpd`.

Create the file `/home/ansible/lab-vault/webserver.yml` and add the following content:

```yaml
---
- hosts: webservers
  become: yes
  vars_files:
    - /home/ansible/ansible-best-practices/labs/ansible-vault/conf/confidential
  tasks:
    - name: install httpd
      yum:
        name: httpd
        state: latest
      notify: httpd service
      tags:
        - base-install
  handlers:
    - name: Restart and enable httpd
      service:
        name: httpd
        state: restarted
        enabled: yes
      listen: httpd service
```

### Deploy the templates stored on the control node to the webservers group

Configure `webserver.yml` to deploy the templates `/home/ansible/ansible-best-practices/labs/ansible-vault/conf/vhost.conf.j2` and `/home/ansible/ansible-best-practices/labs/ansible-vault/conf/htpasswd.j2` to the `webservers` group. `httpd` must restart on config change. The tasks should be tagged `vhost`.

Add the following text to `webserver.yml` just **before** the handler section:

```yaml
    - name: configure virtual host
      template:
        src: /home/ansible/ansible-best-practices/labs/ansible-vault/conf/vhost.conf.j2
        dest: /etc/httpd/conf.d/vhost.conf
      notify: httpd service
      tags:
        - vhost
    - name: configure site auth
      template:
        src: /home/ansible/ansible-best-practices/labs/ansible-vault/conf/htpasswd.j2
        dest: /etc/httpd/conf/htpasswd
      notify: httpd service
      tags:
        - vhost
```

### Asynchronously execute data-job on webservers

We need to copy the `data-job.sh` script to the managed nodes. 

Add the following task to the `webserver.yml` **after* the `configure site auth` task

```yaml
    - name: copy data job to all hosts
      copy:
        src: "{{ lookup('env', 'HOME') }}/ansible-best-practices/labs/ansible-vault/bin/data-job.sh"
        dest: /opt/data-job.sh
        mode: 775
```

Configure `webserver.yml` to asynchronously execute `/home/ansible/ansible-best-practices/labs/ansible-vault/bin/data-job.sh` located on the webservers with a timeout of 600 seconds and no polling. The task should be tagged with `data-job`.

Add the following text to `webserver.yml` just **before** the handler section:

```yaml
    - name: run data job
      command: /opt/data-job.sh
      async: 600
      poll: 0
      tags:
        - data-job
```

- Your complete file should look similar to the below:

```yaml
---
- hosts: webservers
  become: yes
  vars_files:
    - /home/ansible/ansible-best-practices/labs/ansible-vault/conf/confidential
  tasks:
    - name: install httpd
      yum:
        name: httpd
        state: latest
      notify: httpd service
      tags:
        - base-install
    - name: configure virtual host
      template:
        src: /home/ansible/ansible-best-practices/labs/ansible-vault/conf/vhost.conf.j2
        dest: /etc/httpd/conf.d/vhost.conf
      notify: httpd service
      tags:
        - vhost
    - name: configure site auth
      template:
        src: /home/ansible/ansible-best-practices/labs/ansible-vault/conf/htpasswd.j2
        dest: /etc/httpd/conf/htpasswd
      notify: httpd service
      tags:
        - vhost
    - name: copy data job to all hosts
      copy:
        src: "{{ lookup('env', 'HOME') }}/ansible-best-practices/labs/ansible-vault/bin/data-job.sh"
        dest: /opt/data-job.sh
        mode: 755
    - name: run data job
      command: /opt/data-job.sh
      async: 600
      poll: 0
      tags:
        - data-job
  handlers:
    - name: Restart and enable httpd
      service:
        name: httpd
        state: restarted
        enabled: yes
      listen: httpd service
```

Use what you've learned in previous labs to create an inventory including a `webservers` group with both managed nodes.

### Execute playbook to verify your playbook works correctly

Execute playbook `webserver.yml` to verify your playbook works correctly.

Run `ansible-playbook -i inventory --ask-vault-pass webserver.yml` from the control node and provide the vault password "I love ansible".

## Conclusion

Congratulations, you've completed this hands-on lab!

## Test
Confirm the following: 
* Playbook execution prompts for vault password
* Playbook completes successfully
* `/opt/data-job.sh` is running on both nodes
* Apache returns a `401 Unauthorized` status

## Congrats!

