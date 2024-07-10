# Lab: Using Ansible Roles to Create a Windows User with Permissions, Connect Ansible with that Account, Install IIS, Create a Web.config File, and Copy Web Files

In this lab, you will learn how to use Ansible roles to break down the tasks of creating a Windows user with permissions to install services, connecting Ansible with that account, installing IIS, creating a `web.config` file using a template, and copying web files to the `c:\inetpub\wwwroot` folder. You will edit files using Visual Studio Code, commit and push changes to your GitHub repository named `ansible-working`, and use an SSH connection in PuTTY to pull down the files to the Ansible Control host before executing the Ansible playbook.

## Prerequisites

Before starting this lab, you should have the following:

- A Windows machine running with the latest updates installed.
- Ansible installed on your Ansible Control host.
- PuTTY installed on your Windows host to create an SSH connection to the Ansible host.
- Visual Studio Code installed on your Windows host.
- A GitHub account.

## Step 1: Set Default connection account for Ansible
Perform the following steps on the Windows Host in VS Code

Configure Ansible to connect with the `ansible` user account we will create in a later next step.

1. Open the `ansible.cfg` file on in the ansible-working folder in VS Code and edit the file to appear as below:

   ```
   [defaults]
   INVENTORY = inventory_groups.yml
   remote_user = ansible
   ```

   This tells Ansible to connect to the remote Windows machine using the `ansible` user account.

2. Save the `ansible.cfg` file and close it.

## Step 2: Create 4 roles
1. Create the `create-user` role
   ```
   ansible-galaxy role init create-user
   ```
2. Create a new Ansible role named `install-iis` using the following command:

   ```
   ansible-galaxy role init install-iis
   ```
3. Create a new Ansible role named `create-web-config` using the following command:

   ```
   ansible-galaxy role init create-web-config
   ```
4. Create a new Ansible role named `copy-web-files` using the following command:

   ```
   ansible-galaxy role init copy-web-files
   ```
5. Perform a `git push` to sync the new roles with the `ansible-working` repo so that we can edit the files

## Step 3: Commit and Push Changes to GitHub

6. Use the following command to push changes to your `ansible-working` repository to keep it in sync
```
git add .
git commit -m "added new roles"
git push
```
7. When prompted enter your git user name and when prompted for password paste in the personal access token created during an earlier lab.

## Step 4: Update the Ansible-working repo on the Windows Host 

1. In VS Code on the Source Control Pane
2. Perform a Pull or a Sync of the ansible-working repo so that you can edit the new roles

## Step 5: Creating a Windows User with Permissions

The first step is to create a Windows user with permissions to install services. You will use Ansible to automate this task.
User the explorer pane in VS Code to navigate to the appropriate folders and edit files

1. Open the `tasks/main.yml` file in the `create-user` role and add the following code:

   ```
   - name: Create user ansible
     win_user: 
       name: ansible
       password: Password123
       state: present
       groups:
         - Administrators
     become: yes  
     ignore_errors: yes
     register: result
   ```

   This code creates a new user named `ansible` with the password `Password123`, adds the user to the `Administrators` group, grants the user remote desktop access, and grants the user administrator privileges.

2. Save the `main.yml` file and close it.

## Step 6: Installing IIS

The next step is to install IIS on the remote Windows machine using Ansible.
User the explorer pane in VS Code to navigate to the appropriate folders and edit files

2. Open the `tasks/main.yml` file in the `install-iis` role and add the following code:

   ```
   - name: Install IIS
     win_feature:
       name: Web-Server
       state: present
       include_management_tools: yes
   ```

   This code installs IIS on the remote Windows machine with the management tools included.

3. Save the `main.yml` file and close it.

## Step 7: Copying Web Files to the `c:\inetpub\wwwroot` Folder

The next step is to copy the web files to the `c:\inetpub\wwwroot` folder.
User the explorer pane in VS Code to navigate to the appropriate folders and edit files

1. Open the `tasks/main.yml` file in the `copy-web-files` role and add the following code:

   ```
   - name: Copy web files
     win_copy:
       src: ./files
       dest: C:\inetpub\wwwroot
   ```

   This code copies the contents of the `./files` folder to the `C:\inetpub\wwwroot` folder on the remote Windows machine.

2. Save the `main.yml` file and close it.

## Step 8: Combining the Roles in an Ansible Playbook

The final step is to combine the roles in an Ansible playbook.
User the explorer pane in VS Code to navigate to the appropriate folders and edit files

1. Create a new file named `roles_playbook.yml` in your Ansible Control host in the ansible-working folder and add the following code:

   ```
   ---
   - name: Install IIS and configure website
     hosts: windows
     become: yes
     become_method: runas
     become_user: Administrator
     vars:
         ansible_user: administrator
         ansible_password: JustM300
         ansible_connection: winrm
         ansible_winrm_transport: ntlm
         ansible_winrm_server_cert_validation: ignore
         ip_address: 10.0.0.1
         database_name: mydatabase
         db_username: sqluser
         db_password: Pa$$w0rd
     roles:
       - create-user
       - install-iis
       - create-web-config
       - copy-web-files
   ```

   This code defines an Ansible playbook that runs the `create-user`, `install-iis`, `create-web-config`, and `copy-web-files` roles.

2. Save the `roles_playbook.yml` file and close it.

## Step 9: Save and Push files to the `ansible-working` repo

1. In the sidebar, click on the "Source Control" icon (it looks like a branch).
2. In the File menu select Save All
3. In the "Source Control" pane, review the changes you made to the file.
4. Enter a commit message that describes the changes you made.
5. Click the checkmark icon to commit the changes.
6. Click on the "..." menu in the "Source Control" pane, and select "Push" to push the changes to GitHub.

## Step 10: Update the Ansible Control Host

1. Return to the connection to your Ansible control host in PuTTY on Windows.
2. Navigate to the directory where you cloned repository.
3. Run `git pull` to update the repository on the control host.

## Step 11: Executing the Ansible Playbook

To execute the Ansible playbook, follow these steps:

1. Open PuTTY and connect to the Ansible host using SSH.

2. Navigate to the folder where the playbook is stored.

3. Run the following command to execute the playbook:

   ```
   ansible-playbook roles_playbook.yml
   ```

   This command will run the `playbook.yml` file and execute the roles in the specified order.

4. Wait for the playbook to finish executing.

Congratulations! You have successfully created an Ansible playbook that creates a Windows user with permissions to install services, installs IIS, creates a Web.config file using a template, and copies web files to the `C:\inetpub\wwwroot` folder. 
