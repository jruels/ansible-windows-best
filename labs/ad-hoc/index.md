# Lab Instructions for Running Ad-hoc Commands using Ansible on a Windows Host

In this lab, you will learn how to use Ansible to run ad-hoc commands against a Windows host. Ad-hoc commands are one-liners that you can use to perform specific tasks quickly and easily, without having to write a full playbook.

## Prerequisites

Before starting this lab, you should have the following:

- A Windows host that you can use as a target for Ansible commands
- A control node with Ansible installed

## Step 1: Run Ad-hoc commands
Run the following commands in the Ansible Control PuTTY window on the Windows host.   
Our `ansible.cfg` file should still have `ansible_vars.yml` set as the default inventory

1. Run the following ad-hoc command to check if the Windows host is reachable:

  ```bash
  ansible webservers -m win_ping
  ```

You should see a success message if the Windows host is reachable.

2. Run the following ad-hoc command to get information about the Windows host:

  ```bash
  ansible webserver1 -m setup
  ```

This command will retrieve various information about the Windows host, including hardware and software details, network settings, and more.

The following commands can be used to download and install the `7-Zip` package. After each command, confirm on the Windows server it was successful.

3. Run the following ad-hoc command to download the 7zip MSI package on the Windows host:

  ```bash
  ansible webserver1 -m win_get_url -a "url=https://www.7-zip.org/a/7z2201-x64.msi dest=C:\gitrepos\7z.msi"
  ```

4. Run the following ad-hoc command to install the 7zip package on the Windows host:

  ```bash
  ansible webserver1 -m win_package -a "path=C:\gitrepos\7z.msi state=present"
  ```


5. Run the following ad-hoc command to list the installed packages

  ```bash
  ansible webserver1 -m win_command -a "powershell Get-WmiObject -Class Win32_Product | Select-Object Name, Version"
  ```
