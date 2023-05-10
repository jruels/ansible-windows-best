# Lab: Using AAP to Manage Windows Hosts

Lab Objective: In this lab, you will learn how to use AAP to manage Windows hosts. You will configure AAP with the necessary credentials to allow it to authenticate against a Windows host using ntlm and winrm, and then you will run an ad-hoc command against the Windows host to verify the connection.

Lab Steps:

1. In Chrome navigate to the public IP of your Ansible Automation Platform Server
1. In AAP, navigate to the "Credentials" section (using the menu on the left) and add a new `Machine` credential for the webserver1 host using the following settings:

   * Name: win_cred
   * Organization: Default
   * Credential Type: "Machine"
   * Username: "Administrator"
   * Password: "JustM300"
   
1. Click the Save button to save your credential
1. Navigate to the `Inventories` section and add a new Inventory named `AAP Inventory` witht the following settings:

    * Name: AAP Inventory
    * Organization: Default
    * Variables:
        ```
        ansible_connection: winrm
        ansible_winrm_transport: ntlm
        ansible_winrm_server_cert_validation: ignore
        ```
1. Click the Save button to save the AAP Inventory 
1. In the "AAP Inventory", Navigate to the `Host tab` and create a new host named `webserver1` with the following settings:
    * Name: webserver1
    * Variables:
        ```
        ---
        ansible_host: <IP Address for Windows Host>
        ```
1. Click the save button to the save the host
1. Click the `Back to Hosts` link to return to the host list
1. Check the check box next to the `webserver1` host
1. Click the `Run Command` button to run an ad-hoc command against the webserver1 host 
1. In the Module dropdown select `win_ping` and click `Next`
1. On the Execution environment page select `Default execution environment` and click `Next`
1. On the Credentials Page Select `win_cred` and click `Next`
1. On the `Preview` page click `Launch`
1. Verify that the ad-hoc command was executed successfully on the `webserver1` host
   you should get the following results:
   
   webserver1 | SUCCESS => {
    "changed": false,
    "ping": "pong"
   }
