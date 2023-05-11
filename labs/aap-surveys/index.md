# Lab: Using AAP to Manage Windows Hosts and Install IIS with Survey Input

Lab Objective: In this lab, you will learn how to use AAP to manage Windows hosts and install IIS with survey input. You will update a playbook that installs IIS on a Windows host, copies a template file to the document root, and use a survey to populate variables in the `index.html` file.



## Uninstall IIS

Create a playbook named `uninstall-iis.yml` with the following:

```yaml
---
- name: Ensure IIS is uninstalled
  hosts: all
  become: yes
  become_user: Administrator
  tasks:
    - name: Ensure IIS Server is uninstalled
      win_feature:
        name:  Web-Server
        state: absent
      tags:
        - uninstall-iis
```



Commit and push it to your `ansible-working` repository. 

### Create a Job Template and Run a Job

1. In Chrome, navigate to the public IP of your Ansible Automation Platform Server.
2. In AAP, navigate to the "Credentials" section (using the menu on the left) and verify that the `win_cred` credential has been created for the `webserver1` host.

A job template is a definition and set of parameters for running an Ansible job. Job templates are useful to execute the same job many times. So before running an Ansible **Job** from automation controller you must create a **Job Template** that pulls together:

- **Inventory**: On what hosts should the job run?
- **Credentials**: What credentials are needed to log into the hosts?
- **Project**: Where is the playbook?
- **What**: playbook to use?

Okay, let’s do that: Go to the **Resources -> Templates**, click the **Add** button and choose **Add job template**.



**TIP**: Remember that you can often click on the magnifying glass to get an overview of options to pick to fill in fields.

Fill in the following: 

* **Name**: Uninstall IIS
* **Job Type**: Run
* **Inventory**: AAP Inventory
* **Project**: Ansible Workshop Examples
* **Execution Environment**: Default execution environment 
* **Playbook**: uninstall-iis.yml
* **Credentials**: win_cred
* Click **Save**

Sart the job by clicking the blue **Launch** button, or by clicking on the rocket in the Job Templates overview. After launching the Job Template, you are automatically brought to the job overview where you can follow the playbook execution in real-time.

After the Job has finished, confirm that IIS was uninstalled by running the following PowerShell command on the Windows node. 

```powershell
get-windowsfeature web-server
```



## Install IIS

Next, we will create a playbook named `install-iis.yml` to install IIS using the default settings. 

Create the playbook with the following: 

```yaml
- name: Install IIS
  hosts: all
  tasks:
    - name: Install IIS
      win_feature:
        name: Web-Server
        state: present
```

Commit and push it to your `ansible-working` repository. 



In the Ansible Tower UI sync the **Ansible Workshop Examples** project to pull down the latest changes. 

### Create a Job Template and Run a Job

Create a new Template with the following:

* **Name**: Install IIS
* **Job Type**: Run
* **Inventory**: AAP Inventory
* **Project**: Ansible Workshop Examples
* **Execution Environment**: Default execution environment 
* **Playbook**: install-iis.yml
* **Credentials**: win_cred
* Click **Save**

Launch the job and confirm it is successful. 

After the Job has finished, confirm that IIS was installed by running the following PowerShell command on the Windows node. 

```powershell
get-windowsfeature web-server
```



## Add surveys

Surveys set extra variables for the playbook similar to ‘Prompt for Extra Variables’ but in a user-friendly question-and-answer way. Surveys also allow for the validation of user input.

You have installed IIS on your node in the job you just ran. Now we’re going to extend this:

- Use a proper role with a Jinja2 template to deploy an `index.html` file.
- Create a job **Template** with a survey to collect the values for the `index.html` template.
- Launch the job **Template**

### The IIS role

We are going to use the files from the earlier `roles` lab. 

* Update `roles_playbook.yml` to target `all` hosts, and remove the `copy-web-files` role.

* In the `templates` folder, create `index.html.j2` containing:

  ```yaml
  <html>
  <body>
  <h1>Apache is running fine</h1>
  <h1>This is survey field "First Line": {{ first_line }} </h1>
  <h1>This is survey field "Second Line": {{ second_line }}</h1>
  </body>
  </html>
  ```

* Under `create-web-config`, update the `main.yml` file in `templates` -> `tasks` with: 

  ```yaml
  ---
  # tasks file for index.html
  - name: Create index.html file
    template:
      src: templates/index.html.j2
      dest: c:/inetpub/wwwroot/index.html
  ```

  

### Create a Template with a Survey

Create a new Template with the following:

* **Name**: Create index.html
* **Job Type**: Run
* **Inventory**: AAP Inventory
* **Project**: Ansible Workshop Examples
* **Execution Environment**: Default
* **Playbook**: roles_playbook.yml
* **Credentials**: win_cred
* **Options**: Privilege Escalation
* Click **Save**

> Warning: Do not run the template yet!



#### Add the Survey

In the Template, click the **Survey** tab at the top, and click the **Add** button.

Fill out the form:

- **Question**: First Line
- **Answer Variable Name**: first_line
- **Answer Type**: Text
- Click **Save**
- Click the **Add** button

In the same fashion, add a second **Survey Question**

- **Question**: Second Line
- **Answer Variable Name**: second_line
- **Answer Type**: Text
- Click **Save**
- Click the toggle to turn the Survey questions to **Enabled**

### Launch the Template

Now launch **Create index.html** job template by selecting the **Details** tab and clicking the **Launch** button.

Before the actual launch, the survey will ask for **First Line** and **Second Line**. Fill in some text and click **Next**. The **Preview** window shows the values

If all is good, run the Job by clicking **Launch**.

After the job has completed, load `localhost` on your Windows machine and confirm it shows the values you supplied.
