# Lab Title: Using Ansible Vault

## Lab Objective

In this lab, you will learn how to use Ansible Vault to encrypt sensitive data in a playbook. You will create a new playbook that uses a vault-encrypted variable file to deploy a website on a Windows host.

## Lab Steps
Perform the following steps on Windows in VS Code

1. In Visual Studio Code and open the `ansible-working` repository created in a previous lab.
2. Create a new directory named `vault` in the `ansible-working` repository.
3. In the `vault` directory, create a new file named `secrets.yml` and add the following content:

```
ansible_user: Administrator
ansible_password: JustM300
db_username: dbuser
db_password: pass1234
```
4. In the `vault` directory, create a new file named `win_connect.yml` and add the following content:
```
#windows connection details
ansible_connection: winrm
ansible_winrm_transport: ntlm
ansible_winrm_server_cert_validation: ignore
#Database details
ip_address: 192.168.2.2
database_name: Adventrueworks
```
Commit and push the files to the `ansible-working` repository.

5. Encrypt the `secrets.yml` file using Ansible Vault with the following command:

```
ansible-vault encrypt vault/secrets.yml
```

6. When prompted, enter a password to use for encrypting the file.
7. Create a personal access token to use for authentication to your repo from the ansible host. Intruction here: 
[https://gist.github.com/jruels/e26905c1daddbc25d188e414a0d0aee1](https://gist.github.com/jruels/e26905c1daddbc25d188e414a0d0aee1)
9. Use the following command to push changes to your `ansible-working` repository to keep it in sync
```
git add .
git commit -m "encrypt secrets.yml"
git push
```
9. When prompted enter your git user name and when prompted for password paste in the personal access token in an earlier step.

10. Create a new playbook named `deploy_website.yml` in the `ansible-working` repository and add the following content:

```
---
- name: Ensure IIS is installed and started 
  hosts: webservers
  become: yes 
  become_user: Administrator
  vars_files:
    - vault/secrets.yml
    - vault/win_connect.yml
  tasks:
    - name: Ensure IIS Server is present 
      win_feature:
        name:  Web-Server
        state: present
        restart: no
        include_sub_features: yes
        include_management_tools: yes  
    - name: Ensure latest web files are present
      win_copy:
        src: playbook-fun/files/
        dest: c:\inetpub\wwwroot\
        force: yes
    - name: Configure website
      win_template:
        src: templates/web.config.j2
        dest: C:\inetpub\wwwroot\web.config
      become: true
```

11. Save the changes to the playbook and commit them to the `ansible-working` repository using the Source Control pane in Visual Studio Code.
12. Push the changes to the `ansible-working` repository on GitHub using the Source Control pane in Visual Studio Code.
13. Switch to the Ansible control host and navigate to the directory where the `ansible-working` repository was cloned.
14. Use the `git pull` command to update the cloned repository with the latest changes.
15. Run the `deploy_website.yml` playbook against the Windows host using the following command:

```
ansible-playbook -i inventory_groups.yml deploy_website.yml --ask-vault-pass
```

16. When prompted, enter the password used to encrypt the `secrets.yml` file.

17. Verify that the website is deployed on the Windows host.
