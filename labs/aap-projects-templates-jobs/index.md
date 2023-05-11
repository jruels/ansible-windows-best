# AAP - Projects and Job Templates

An Automation Platform **Project** is a logical collection of Ansible playbooks. You can manage your playbooks by placing them into a source code management (SCM) system supported by AAP, including Git/GitHub, Subversion, and Mercurial.



## Create the playbook

For this lab we will create a new playbook in your  `ansible-working` Git repository and reference that repo from AAP 

Create a playbook to manage users, and groups. Name the playbook `create_user.yml`

```yaml
- name: Create Windows group and user
  hosts: webservers
  become: yes
  become_method: runas
  become_user: Administrator
  tasks:
    - name: Create Remote Admins group
      win_group:
        name: Remote Admins
        state: present

    - name: Grant Remote Desktop permissions to Remote Admins group
      win_acl:
        path: 'hklm:\system\currentcontrolset\control\terminal server'
        user: 'Remote Admins'
        rights: 'FullControl'
        type: allow

    - name: Create user Bob and add to Remote Admins group
      win_user:
        name: Bob
        password: 'P@ssw0rd'
        groups: 'Remote Admins'
        state: present
```

To configure and use this repository as a **Source Control Management (SCM)** system in AAP you have to create a **Project** that uses the repository



## Create the Project

Go to **Resources → Projects** in the side menu view click the **Add** button. Fill in the form: 

* **Name**: Ansible Workshop Examples
* **Organization**: Default
* **Execution Environment**: Default execution environment
* **Source Control Credential Type**: Git

Now fill in the **Type Details**: 

**Source Control URL**: `https://github.com/<your account)>/ansible-working`

**Options**: Select Clean, Delete, Update Revision on Launch to request a fresh copy of the repository and to update the repository when launching a job.

* Click **Save**

The new project will be synced automatically after creation. But you can also do this manually: Sync the Project again with the Git repository by going to the **Projects** view and clicking the circular arrow **Sync Project** icon to the right of the Project.

After starting the sync job, go to the **Jobs** view: there is a new job for the update of the Git repository.



## Create a Job Template and Run a Job

A job template is a definition and set of parameters for running an Ansible job. Job templates are useful to execute the same job many times. So before running an Ansible **Job** from automation controller you must create a **Job Template** that pulls together:

- **Inventory**: On what hosts should the job run?
- **Credentials**: What credentials are needed to log into the hosts?
- **Project**: Where is the playbook?
- **What**: playbook to use?

Okay, let’s do that: Go to the **Resources -> Templates**, click the **Add** button and choose **Add job template**.



**TIP**: Remember that you can often click on the magnifying glass to get an overview of options to pick to fill in fields.

Fill in the following: 

* **Name**: User management

* **Job Type**: Run

* **Inventory**: AAP Inventory

* **Project**: Ansible Workshop Examples

* **Execution Environment**: Default execution environment 

* **Playbook**: create_user.yml

* **Credentials**: win_cred
* **Variables**:
  ```
  #Database details
  ip_address: 192.168.2.2
  database_name: Adventrueworks
  ```

* **Options**: The tasks need to run as `admin` so check **Privilege Escalation**

* Click **Save**



This playbook targets hosts in the `webservers` group. We need to add our servers to the `webservers` group. 

Go to **Resources → Inventories**, and click **AAP Inventory**. 

At the top of the screen click **Groups** and then **Add**. Fill in the following: 

* **Name**: webservers

* **Description**: A group for web servers

* Click **Save**

At the top of the page click **Hosts**, **Add**, **Add existing host,** and select **webserver1**

After adding the host, go launch the Template

Go to **Resources → Templates**.



You can start the job by directly clicking the blue **Launch** button, or by clicking on the rocket in the Job Templates overview. After launching the Job Template, you are automatically brought to the job overview where you can follow the playbook execution in real-time:



Job Output: 

![image-20220223001406020](images/image-20220223001406020.png)

After the Job has finished go to the main **Jobs** view: All jobs are listed here, you should see directly before the Playbook run an Source Control Update was started. This is the Git update we configured for the **Project** on launch.



## Congrats! 
