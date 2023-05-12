# AAP - Workflows



## Objective

The basic idea of a workflow is to link multiple Job Templates together. They may or may not share inventory, playbooks, or even permissions. The links can be conditional:

- Job Deploy IIS and Deploy MySQL run in parallel and if Deploy IIS Succeeds then Configure web.config runs.

And the workflows are not even limited to Job Templates, but can also include project or inventory updates.

This enables new applications for Ansible automation controller: different Job Templates can build upon each other. E.g. the networking team creates playbooks with their own content, in their own Git repository, and even targeting their own inventory, while the operations team also has their own repos, playbooks, and inventory.

In this lab, you’ll learn how to set up a workflow.

## Guide

### Lab scenario

You have two departments in your organization:

- The web operations team that is developing playbooks to deploy infrastructure for the development team who will deploy their application to the infrasture as they complete new versions

### Web operations team

- Install IIS, Install MySQL, Configure the web app to use the new MYSQL server by updating its web.config with the MySQL server details

### Create a linux credential
This lab deploys MySQL to our Ubuntu VM. To access it, we need to provide our private SSH key. 

In Putty, run the following command to: 

```bash
cat ~/.ssh/id_rsa
```

Copy the **complete private key** (including “BEGIN” and “END” lines) , and save it for the next step.

Now configure the credentials to access the managed hosts from Ansible Automation Platform.

In the **Resources** menu choose **Credentials**, and click **Add** then fill in the following:

- **Name**: linux
- **Description**: Credentials to authenticate over SSH
- **Organization**: Default
- **Credential Type**: Machine

Under **Type Details** fill in:

- **Username**: ubuntu
- **SSH Private Key**: Paste the private key from above.

**Privilege Escalation Method**: sudo

- Click **Save**

Go back to the **Resources -> Credentials -> Linux credentials** and note that the SSH key is not visible.

You have now set up credentials for Ansible to access your managed host.



### Add your Anible host to the AAP Inventory

In the web UI menu on the left side, go to **Resources** → **Inventories**, choose ****

Provide the following:

- **Name**: First Inventory
- **Description**: My first inventory file
- **Organization**: Default

Click **Save**

At the top of the page click the **Hosts** button, the list will be empty since we have not added any hosts yet.

Let's add our hosts.

For each (`node1`, `node2`) Add the host to the inventory in Automation Platform:

Click the **Add** button and give a **Name**, and **Description**:

- **Name**: Server (1 or 2)

- **Description**: Node (1 or 2) from the spreadsheet

- Under **Variables** confirm **YAML** is highlighted and then paste the following:

  ```
  ansible_host: <IP of node (1 or 2) from spreadsheet> 
  ```

  

- Click **Save**



create a new host in the AAP Inventory

* name: ubuntu_server 
* credential: linux


### Set up projects

First you have to set up a reference to the ansible-best-practice-windows repo where the Deploy IIS, Deploy My SQL and Configure web.config playbook are stored

> **Warning**
>
> If you are still logged in as user **wweb**, log out of and log in as user **admin**.

Within **Resources** -> **Projects**, click the **Add** button to create a project for the web operations team. Fill out the form as follows:

| Parameter                        | Value                                             |
| -------------------------------- | ------------------------------------------------- |
| Name                             | Webops Git Repo                                   |
| Organization                     | Default                                           |
| Execution Environment            | Default execution environment                     |
| Source Control Credential Type   | Git                                               |
| Source Control URL               | `https://github.com/jruels/workshop-examples.git` |
| Options                          | ✓ Clean✓ Delete✓ Update Revision on Launch        |

Click **Save**

------
### Set up job templates

Now you have to create two Job Templates like you would for “normal” Jobs.

Within **Resources** -> **Templates**, click the **Add** button and choose **Add job template**:

| Parameter             | Value                                |
| --------------------- | ------------------------------------ |
| Name                  | Deploy IIS                           |
| Job Type              | Run                                  |
| Inventory             | AAP Inventory                        |
| Project               | Webops Git Repo                      |
| Execution Environment | Default execution environment        |
| Playbook              | `Deploy IIS`                         |
| Credentials           | win_cred                             |
| Limit                 | web                                  |
| Options               | ✓ Privilege Escalation               |

Click **Save**

------

Within **Resources** -> **Templates**, click the **Add** button and choose **Add job template**:

| Parameter             | Value                              |
| --------------------- | ---------------------------------- |
| Name                  | Deploy MySQL                       |
| Job Type              | Run                                |
| Inventory             | AAP Inventory                      |
| Project               | Webdev Git Repo                    |
| Execution Environment | Default execution environment      |
| Playbook              | `Deploy MySQL`                     |
| Credentials           | linux                              |
| Limit                 | webservers                         |
| Options               | ✓ Privilege Escalation             |

Click **Save**

------

Within **Resources** -> **Templates**, click the **Add** button and choose **Add job template**:

| Parameter             | Value                              |
| --------------------- | ---------------------------------- |
| Name                  | Update web.config                  |
| Job Type              | Run                                |
| Inventory             | AAP Inventory                      |
| Project               | Webdev Git Repo                    |
| Execution Environment | Default execution environment      |
| Playbook              | `Web_Deploy_Workflow.yml`          |
| Credentials           | win_cred                           |
| Limit                 | webservers                         |
| Options               | ✓ Privilege Escalation             |

Click **Save**

> **Tip**
>
> If you want to know what the Ansible Playbooks look like, check out the Github URL and switch to the appropriate branches.


### Set up the workflow

Workflows are configured in the **Templates** view, you might have noticed you can choose between **Add job template** and **Add workflow template** when adding a template.

Within **Resources** -> **Templates**, click the **Add** button and choose **Add workflow template**:

| **Parameter** | Value                |
| ------------- | -------------------- |
| Name          | Deploy Webapp Server |
| Organization  | Default              |

Click **Save**

After saving the template the **Workflow Visualizer** opens to allow you to build a workflow. You can later open the **Workflow Visualizer** again by using the button on the template details page and selecting **Visualizer** from the menu.

![start](https://aap2.demoredhat.com/exercises/ansible_rhel/2.6-workflows/images/start.png)

Click on the **Start** button, an **Add Node** window opens. Assign an action to the node, via node type by selecting **Job Template**.

Select the **Web App Deploy** job template and click **Save**.

![Add Node](https://aap2.demoredhat.com/exercises/ansible_rhel/2.6-workflows/images/add_node.png)

A new node is shown, connected to the **START** button with the name of the job template. Hover the mouse pointer over the node, you’ll see options to add a node (+), view node details (i), edit the node (pencil), link to an available node (chain), and delete the node (trash bin).

![workflow node](https://aap2.demoredhat.com/exercises/ansible_rhel/2.6-workflows/images/workflow_node.png)

Hover over the node and click the (+) sign to add a new node.

- For the **Run Type** select **On Success** (default) and click **Next**.

> **TIP**: The run type allows for more complex workflows. You could lay out different execution paths for successful and for failed playbook runs.

- For **Node Type** select **Job Template** (default) and choose the **Deploy MySQL** job template. Click **Save**.

  ![Add Nodejs](https://aap2.demoredhat.com/exercises/ansible_rhel/2.6-workflows/images/add_node_nodejs.png)

Click **Save** in the top right corner of the **Visualizier** view.


Hover over the node and click the (+) sign to add a new node.

- For the **Run Type** select **On Success** (default) and click **Next**.

> **TIP**: The run type allows for more complex workflows. You could lay out different execution paths for successful and for failed playbook runs.

- For **Node Type** select **Job Template** (default) and choose the **Update Web.Config** job template. Click **Save**.

  ![Add Nodejs](https://aap2.demoredhat.com/exercises/ansible_rhel/2.6-workflows/images/add_node_nodejs.png)

Click **Save** in the top right corner of the **Visualizier** view.



### Launch workflow

From within the **Deploy Webapp Server** Details page, **Launch** the workflow.

![launch](https://aap2.demoredhat.com/exercises/ansible_rhel/2.6-workflows/images/launch.png)



Note how the workflow run is shown in the Jobs > Deploy Webapp Server Output. In contrast to a normal job template job execution, there is no playbook output when the job completes but the time to complete the job is displayed. If you want to look at the actual playbook run, hover over the node you wish to see the details on and click it. Within the Details view of the job, select the **Output** menu to see the playbook output. If you want to get back the **Output** view of the **Deploy WebappServer** workflow, under **Views -> Jobs -> XX - Deploy Webapp Server** will take you back to the Output overview.

NOTE: Where `XX` is the number of the job run.

![jobs view of workflow](https://aap2.demoredhat.com/exercises/ansible_rhel/2.6-workflows/images/job_workflow.png)

## Challenge Lab: Recovery workflow
Using what you learned in this lab, create a workflow with three jobs (JobA, JobB, JobC). If JobA is successful, JobB runs; if JobA fails, JobC runs.


## Congrats!
