# Lab: Windows Updates

The `win_updates` module is used to either check for or to install Windows Updates. The module utilizes the built in Windows Update service to function. This means that you still will need a backend system like WSUS or the online Windows Update Servers to download updates from. If your server’s Windows Update configuration is set to automatically download but not install, you can also utilize the module to stage updates by telling it to `search` for updates. We also have the ability to whitelist or blacklist updates. For example we could tell it to only install one particular security update instead of every update available.

To begin, we are going to create a new playbook. We will be repeating the steps you performed in the earlier exercises.

## Create playbook

Create a new folder `win_updates` and inside of it create a file `site.yml` with the following content:

```yaml
---
- hosts: windows
  name: This is my Windows patching playbook
  tasks:
    - name: Install Windows Updates
      win_updates:
      {% raw %}
        category_names: "{{ categories | default(omit) }}"
        reboot: '{{ reboot_server | default(true) }}'
      {% endraw %}
```

This is a very basic playbook for installing Windows Updates. Typically you would have even more tasks to accomplish the entire update process. This might entail creating service tickets, creating snapshots, or disabling monitoring.

>**What are we doing?**
>
>- `win_updates:` This module is used for checking or installing updates. We tell it to only install updates from specific categories using a variable. `reboot` attribute will automatically reboot the remote host if it is required and continue to install updates after the reboot. We will also use a survey variable to stop us from rebooting even if needed. If the reboot_server value is not specified we will set the reboot attribute to true.

Save your files, commit and push to your `ansible-working` repository. 

In Ansible Tower, resync your project so the new files show up. 



### Create a Job Template and Run a Job

1. In Chrome, navigate to the public IP of your Ansible Automation Platform Server.
2. In AAP, navigate to the "Inventories" section (using the menu on the left) and create a new group named `windows` inside the existing `AAP Inventory`. Click `Hosts` and add `webserver1` to the group.



Go to the **Resources -> Templates**, click the **Add** button and choose **Add job template**.

Fill in the following: 

* **Name**: Windows Updates
* **Job Type**: Run
* **Inventory**: AAP Inventory
* **Project**: Ansible Workshop Examples
* **Execution Environment**: Default execution environment 
* **Playbook**: `win_updates/site.yml`
* **Credentials**: win_cred
* **Options**: Enable Fact Storage
* * Click **Save**



#### Add the Survey

In the Template, click the **Survey** tab at the top, and click the **Add** button.

Fill out the form:

- **Question**: Categories
- **Description**: Which Categories to install?
- **Answer variable name**: categories
- **Answer type**: Multiple Choice (multiple select)
  - Multiple Choice Options
    - Application
    - Connectors
    - CriticalUpdates
    - DefinitionUpdates
    - DeveloperKits
    - FeaturePacks Guidance
    - SecurityUpdates
    - ServicePacks
    - Tools
    - UpdateRollups
    - Updates

  - Default Answer
    - CriticalUpdates
    - SecurityUpdates

- Click **Save**
- Click the **Add** button

In the same fashion, add a second **Survey Question**

- **Question**: Reboot after install?
- **Description**: If the server needs to reboot,  then do so after install.
- **Answer variable name**: reboot_server
- **Answer type**: Multiple choice (single select)
  - Multiple Choice Options
    - Yes
    - No
  - Default Answer
    - No
- Click **Save**
- Click the toggle to turn the Survey questions to **Enabled**

Start the job by clicking the blue **Launch** button, or by clicking on the rocket in the Job Templates overview. 

When prompted, choose update categories. answer `No` to *Reboot after install?* and click next.

After launching the Job Template, you are automatically brought to the job overview where you can follow the playbook execution in real-time.
