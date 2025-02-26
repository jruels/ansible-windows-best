# Lab Setup 
The username for Remote Desktop is    
`Administrator`
The Password is
`JustM300`

## MacOS 
Download Microsoft Remote Desktop from the Apple App Store and connect to remote computer using the ip address provided.

## Windows 
Connect to remote computer with Remote Desktop with ip address provided

## All

## Connect to Windows Target 1

We will do most of our work on Windows Target 1

Use Remote Desktop to remote into Windows Target 1 (ip address provided)

  1. In remote desktop enter the ip address for Windows Target 1
  1. Click `Show Options`
  1. Enter `Administrator` as the user name
  1. Click `Connect`
  1. Enter `JustM300` as the password
  1. Click `Yes`

## Clone the ClassFiles Repo

Continue to do the following steps inside of Window Target 1 RDP Session

  1. Launch VS Code from the Start Menu or Task Bar
  1. Select the Source Control Tab from the toolbar on the left
  1. In the Source Control pane click `Clone Repository`
  1. Paste the URL https://github.com/jruels/ansible-windows-best.git 
  1. In the choose a folder dialog navigate to `c:\gitrepos`
  1. Click the `select as Repository Destination` button
  1. In the Visual Studio Code dialog click the `Open` button to open the repository in VS Code

## Create a new Reposistory in your personal GitHub Account

Continue to do the following steps inside of Window Target 1 RDP Session

  1. Using Chrome, Log in or Create a new account [GitHub](https://github.com/)
  1. Click New Repository
  1. Name the reposistory `ansible-working`
  1. Check the `Add a README file` checkbox
  1. Click the `Create Repository` button
  1. In the new repository click the `code` button to expose the `https url` for the repository
  1. Click the copy button to copy the `https url` for the repo to use in the next step

## Open the newly created repository in VS Code

  1. Launch VS Code from the Start Menu or Task Bar
  1. Select the Source Control Tab from the toolbar on the left
  1. In the Source Control pane click the three dots on the top right.
  1. Click "Clone
  2. Paste the URL to newly created Repo
  3. In the choose a folder dialog navigate to `c:\gitrepos`
  4. Click the `select as Repository Destination` button
  5. In the Visual Studio Code dialog click the `Add to Workspace` button to open the repository in VS Code
  6. In the left Toolbar click the Explorer button

## Initial Setup Complete
At this point you should be connected to your Windows Server with the Classfiles repo (ansible-windows-best) and the Working repo (ansible-working) cloned.  You should be able to see both repos in Visual Studio Code in both the Explorer pane as well as the Sorce Control pane.
