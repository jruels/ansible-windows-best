# Ansible Error Handling
## Scenario

We have to set up automation to pull down a data file, from a notoriously unreliable third-party system, for integration purposes. Create a playbook that attempts to download https://bit.ly/3dtJtR7 and save it as `transaction_list` to `localhost`. 

The playbook should gracefully handle the site being down by outputting the message "Site appears to be down. Try again later." to stdout. If the task succeeds, the playbook should write "File downloaded." to stdout. Whether the playbook errors or not, it should always output "Attempt completed." to stdout.



## Error Handling - Introduction

In this lab, we will explore how to handle errors that may occur while running Ansible playbooks. Specifically, we will focus on how to handle errors related to Windows modules.



### Step 1: Create the report.yml Playbook


## Create playbook

### Prerequisites

In the VS Code Source Control pane: 

1. Click the three dots `...` next to the `ansible-windows-best` repository
2. Click `Pull` to get the latest updates from the repository.

In the VS Code Explorer pane:

1. Right Click in the explorer pane
1. Select `New Folder`
1. Name the folder `error-handling`
1. in the explorer view, expand the `ansible-windows-best` folder
1. expand the `labs/error-handling` folder
1. While holding down the ctrl key drag the `maint` folder and drop it on the `ansible-working/error-handling` folder created in the previous step to copy the folder and its contents.
1. Right click on the `ansible-working/error-handling` folder
1. Select `New File`
1. Name the file `report.yml`
1. Enter the name and content details below:

First, we'll specify our **host** and **tasks** (**name**, and **debug** message):

```yaml
---
- hosts: windows
  tasks:
    - name: download transaction_list
      win_get_url:
        url: https://bit.ly/3dtJtR7
        dest: 'C:\gitrepos\ansible-working\error-handling\transaction_list'
    - debug: msg="File downloaded"
```

### Add connection failure logic

We need to reconfigure a bit here, adding a **block** keyword and a **rescue**, in case the URL we're reaching out to is down:

```yaml
---
- hosts: windows
  tasks:
    - name: download transaction_list
      block:
        - win_get_url:
            url: https://bit.ly/3dtJtR7
            dest: 'C:\gitrepos\ansible-working\error-handling\transaction_list'
        - debug: msg="File downloaded"
      rescue:
        - debug: msg="Site appears to be down.  Try again later."
```



### Add an always message

An **always** block here will let us know that the playbook at least made an attempt to download the file:

```yaml
---
- hosts: windows
  tasks:
    - name: download transaction_list
      block:
        - win_get_url:
            url: https://bit.ly/3dtJtR7
            dest: 'C:\gitrepos\ansible-working\error-handling\transaction_list'
        - debug: msg="File downloaded"
      rescue:
        - debug: msg="Site appears to be down.  Try again later."
      always:
        - debug: msg="Attempt completed."
```

### Step 2: Create inventory

#### Inventory File

In the VS Code create a new inventory file:

1. Create it in the `ansible-working/error-handling` folder
1. Name the new file `inventory.yml`
1. Paste the code below into the file

```yml
windows:
  hosts:
    webserver1:
      ansible_host: <IP or hostname of the Windows server>
  vars:
    ansible_connection: winrm
    ansible_winrm_transport: ntlm
    ansible_winrm_server_cert_validation: ignore
    ansible_user: Administrator
    ansible_password: JustM300
linux:
  hosts:
    webserver2:
      ansible_host: <IP or hostname of the Ubuntu server>
  vars:
      ansible_user: ubuntu
      ansible_ssh_private_key_file: /home/ubuntu/.ssh/id_rsa
```
Make sure you update your `ansible.cfg` to point to the new inventory file.

### Step 3: Commit and Push Changes to GitHub

1. In the sidebar, click on the "Source Control" icon (it looks like a branch).
2. In the "Source Control" pane, review the changes you made to the file.
3. Enter a commit message that describes the changes you made.
4. Click the checkmark icon to commit the changes.
5. Click on the "..." menu in the "Source Control" pane, and select "Push" to push the changes to GitHub.

### Step 4: Update the Ansible Control Host

1. Connect to your Ansible control host.
2. Navigate to the directory where you cloned the `ansible-working` repository.
3. Run `git pull` to update the repository on the control host.

## Run the playbook 

Enter the `error-handling` directory

```bash
cd /home/ubuntu/ansible-working/error-handling
```

Run the playbook

```
ansible-playbook report.yml
```

Confirm the file was created on the Windows machine:

1. Open PowerShell
2. Type the following command:

```
cat 'C:\gitrepos\ansible-working\error-handling\transaction_list'
```

After confirming the playbook successfully downloads and updates the `transaction_list` file, run the `break_stuff.yml` playbook in the `maint` directory to simulate an unreachable host. 

```sh
ansible-playbook ~/ansible-working/error-handling/maint/break_stuff.yml --tags service_down
```

Confirm the host is no longer reachable 
```sh
curl -L -o transaction_list https://bit.ly/3dtJtR7
```

Run the playbook again and confirm it gracefully handles the failure.

```bash
ansible-playbook report.yml
```

Restore the service using `break_stuff.yml`, and confirm the `report.yml` playbook reports the service is back online.

```
ansible-playbook ~/ansible-working/error-handling/maint/break_stuff.yml --tags service_up
```

```
ansible-playbook report.yml
```

Congratulations! You have successfully edited an Ansible playbook to handle errors, committed and pushed changes to GitHub, and updated the Ansible control host to execute the modified playbook.
