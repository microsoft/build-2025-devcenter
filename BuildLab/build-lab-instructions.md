# Build Lab Instructions

# Part 1: Connect and use your dev box

## Connect to your Dev Box
1. Open your browser and go to [devportal.microsoft.com](https://devportal.microsoft.com). Enter your credentials.
2. You should see a Dev Box in your developer portal. Click on ‘Connect via app’ to connect to your dev box.

*You will see a pop-up suggesting you [download](#) the Windows App.*

3. Follow those steps and download it from the App Store. Once installed, login into the Windows App to connect to your Dev Box from a Desktop Client.
 **Note:** you will need to sign into the Windows App with your username and password.
4. You can skip the Windows App tutorial as well.

---

## Connect to your Dev Box with the open in VS Code Feature

## 1. Provision a Dev Box
> You can skip this step if you already have a Dev Box.

5. Sign in to [Developer Portal](https://devportal.microsoft.com/) with your Microsoft account, and create a Dev Box in the project you have access to.

---

## 2. Install VS Code Extension
6.Download the Dev Box VS Code extension (preview version) from [here](https://azure.github.io/dev-box/media/ms-devbox-2.0.0-preview.vsix) and install it in your **local** VS Code — **NOT** in the Dev Box you want to connect to.

7. Open Extensions view in VS Code (`Ctrl+Shift+X`) and select the `...` icon on the top right corner.  
Choose **Install from VSIX...** and select the downloaded file.

Also make sure you have the latest version of the [Remote Development](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack) extension pack installed.

## 3. Sign in to Dev Box Extension

Click the Dev Box icon in the left sidebar, and select **Sign In**.

![Sign in to Dev Box with Microsoft](InstructionImages/Build2025Images/SignIn.png)

## 4. Create and Enable Dev Box Tunnel

After signing in, you will see all the projects you have access to. Choose the project where you created the Dev Box, and select the Dev Box you want to connect to.

If you see **No Tunnel** in the description, you will need to manually create a tunnel resource first.

![Create Tunnel Screenshot](InstructionImages/Build2025Images/CreateTunnel.png)

> *Before enabling the tunnel, you MUST log into the Dev Box at least once using any client (e.g., browser, Windows App, Remote Desktop client). This step is mandatory after each shutdown and restart to establish the required user session for setting up the tunnel. Once logged in, you can disconnect from the Dev Box.*
> 
> *You DO NOT need to log in every time you enable or connect to the tunnel — only after a shutdown or restart.*

Then, you can enable the tunnel. This process may take up to 1–3 minutes, as it will install VS Code on the Dev Box (if not already installed) and set up the tunnel.

![Enable Tunnel Screenshot](InstructionImages/Build2025Images/EnableTunnel.png)

## 5. Connect to the Dev Box in VS Code

Once everything is set up, you can open the Dev Box in VS Code by clicking the **Connect to Tunnel** button.

![Connect to Tunnel Screenshot](InstructionImages/Build2025Images/ConnectTunnel.png)

## 6. Dev Box Remote experience in VS Code

You can open any folder or workspace on the remote Dev Box using **File > Open File/Folder/Workspace** just as you would locally!

If you have a WSL environment on the Dev Box, you can connect to it using **Remote Explorer**.

![Remote Explorer Screenshot](InstructionImages/Build2025Images/WSLTarget.png)

Select WSL targets from the dropdown and all the WSL distributions will be listed. You can open any WSL distribution in the current or new window.

Select WSL targets from the dropdown and all the WSL distributions will be listed. You can open any WSL distribution in the current or new window.

![WSL Targets Screenshot](InstructionImages/Build2025Images/NewWindow.png)

For more information on the WSL development experience, please refer to the [Remote - WSL](#) and [Set up a WSL development environment](#) documentation.

---

## TODO: Open a Developer MCP Server and enable Dark Mode for your Dev Box

# TODO Part 2: Customize your Dev Box

### *Create a custom network connection*

*Create custom network connection resources to leverage firewalls or connect to [on-premise](#) resources.  
For the sake of time, we have created a VNET.*

1. Follow the steps to finish creating a Network Connection

    a. Search for ‘Network Connections’ in the search bar of the Azure portal. Click ‘Create’ to start network connection creation.  
    b. Name your network connection. Select the Virtual Network we have provided in our new region Spain Central. Click on ‘Create’.

### *Configure a custom image definition using AI*

**Create an image definition to customize dev boxes to the specific team needs and configure dev box pools to leverage the image definition when creating dev boxes**

1. Open Visual Studio Code  
2. Go to Extensions (`Ctrl+Shift+X`) and verify that the Dev Box extension is installed  
    a. If not installed, search for "Dev Box" and install it  
3. Validate that the [contoso-co/eshop](https://contoso-co/eshop) repository is cloned onto your Dev Box. If not, clone the repository  
4. Open the cloned repository in VS Code  

#### *Experience in Dev Box VS Code Extension*

5. Create a new `imagedefinition.yaml` file  
6. Copy the contents from the [sample imagedefinition.yaml file](#)  
7. For example, to configure pre-installation of VS Code and configure environment variables, add the following to the `imagedefinition.yaml` file:

    ```yaml
    - name: '~/winget'
      description: Install Visual Studio Code
      parameters:
        package: Microsoft.VisualStudioCode

    - name: '~/powershell'
      parameters:
        command: |
          $env:Path = [System.Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path','User')
    ```

8. As you like, you could continue the process to configure more packages and tools

---

### *Experience using agentic workflow in VS Code*  
To further simplify the experience of authoring the customization file, you can leverage the agentic workflow to directly generate an `imagedefinition.yaml` file through prompts and conversations

9. Open Copilot Chat  
    a. Ensure Dev Box tools are pre-selected under Select Tools  
    b. Select Agent mode and choose the model Claude 3.5 Sonnet  

10. In the chat, enter:  
    `"Help me configure a dev box to work on this repo"`  
    a. The agent will scan the repository to identify the application type and components (Web, API, Blazor, etc.)  

11. When prompted, select ‘Continue’ to configure the allowed [WinGet](#) packages and generate the `imagedefinition.yaml`  
    a. `imagedefinition.yaml` will include git cloning the specific repository onto the dev box  

12. After the initial `imagedefinition.yaml` is generated, in the chat, conversationally ask to "Change Node.js version to 18 LTS"  
13. After the `imagedefinition.yaml` is modified, select ‘Continue’ to run the Customization YAML Validator  
14. Copy and run the validation command in the Terminal  
15. Once validation completes, save the `imagedefinition.yaml`, commit it, and push it to the repository  

---

### *To save time in uploading your `imageDefinition.yaml`*  
We have already pre-created an `imageDefinition.yaml` in a specific repo that you can use.

1. After clicking on your Dev Center in the Azure Portal, click on the blue button 'Create Project' and create a front-end project for the Dev Center. Select that “Contoso-lod50664841” Dev Center. Name it ‘front-end-project’.  
2. Follow the steps to finish creating your project.  
    a. On the ‘Dev box management’ tab for the project creation flow, you can set a limit for the number of dev boxes developers can own in the project. For example, I can [limit](#) to 2 dev boxes. Please set this field to 2 or larger. After this step, click ‘Next’  
    b. On the ‘Catalogs’ tab, do not change any defaults. Click ‘Next’  
    c. On the ‘Tags’ tab, no need to select any tags. Click ‘Next’  
    d. On the ‘Review + Create’ page, [Click](#) ‘Create’  
    e. Once your project is created, click on "Go to Resource" to see your project  

3. You can create a catalog for the specific project:  
    a. Expand the 'Settings' section, select 'Identity', then 'User Assigned' tab on the blade, then ‘+Add’, and click the 'ignite-msi' option. Then, add the ignite-msi identity.  

4. To create the catalog, click 'Catalogs', Select ‘Sync settings’ and enable the use of ‘Image definitions’.  
5. Select ‘+Add’ and finish creating your project catalog by adding a name (‘MyCatalog’), selecting ‘GitHub’ as your catalog source, then select ‘Personal access token’. This will use a repository we prepared for this lab. Fill in the following:  
    a. **Repository**: `https://github.com/microsoft/build-2025-devcenter.git`  
    b. **Branch**: `main`  
    c. **Folder path**: `catalog/image-definitions`  
    d. **Secret Identifier**: `https://kv-ignite-lod50664841.vault.azure.net/secrets/PolyRepoPAT`  

6. Once the Catalog attach and sync are complete, select ‘image definitions’ and you can see image definitions imported  
    a. [Optional] Choose one of the image definitions and select ‘Build’ - this action will generate a custom image to be used when creating dev boxes, thereby enhancing dev box creation times and achieving cost savings

# Part 3: Explore dev box troubleshooting capabilities
*Take a snapshot of your dev box to (later) restore*

To access the self-serve + use the **Snapshot** and Restore feature, follow these steps:

1. Log in to the Developer Portal.
2. Navigate to the Dev Box section.
3. Select the Dev Box environment you wish to take a **snapshot** of.
4. Click on "Take **Snapshot**."
5. A dialog will appear showing the timestamp of the manual **snapshot**.
6. Confirm the **snapshot** in the dialog.
7. Your **snapshot** will be taken, which takes around 10 minutes. Once completed, your Dev Box can be used.

# Part 4: Add additional governance to your dev box setup

*We are going to edit your existing project and create a new pool to use the custom definition you previously created along with the custom network. We will add additional governance capabilities to that project + pool setup for utmost security and easiest management.*

## Configure your existing project for additional governance

1. [Navigate to](#) your existing project. Select ‘Dev Box [Settings](#)’ in the side menu.

## Apply Tunnels to allow developers to connect remotely to their dev box from other clients.

2. Select the check box to enable Dev Box tunnels.

## Apply Dev Box limits to control the amount of Dev Boxes that can be created per project as a [cost](#) control.

3. Select the check box to ‘Apply [limits](#)’. Set the limit field to 2 or larger.
4. Click on ‘Apply’ to apply [all](#) of these project edits.

## Create a dev box pool to use your image definition

5. Navigate to the Manage section in the side menu. Select the 'Dev Box pools' item. Then you can create a Dev Box Pool by clicking "Create".
6. Select a name, and in the [dropdown](#) you'll see 3 image definitions - pick 'project-sample-1'.  
   Select 32 vCPU [compute](#), and 2048 GB SSD for storage for the SKU. Later, when dev boxes are created in this pool, they'll be created based on the [imageDefinition.yaml](#), which provides the base image and a set of customizations to apply.
7. Leverage the custom network for your pool (if your network connection hasn’t finished loading, use the Microsoft Hosted Network and select the region that is best for you based on your current location for optimal latency). Leave all other options to their defaults.  
   At the very end, click on the [check-box](#) for licensing.

## Enable SSO

- From your project, click on the ‘Manage’ dropdown and then ‘Dev Box Pools’
- Click on ‘Create dev box pool’
- Name your pool and select the default definition. Select ‘Microsoft Hosted Network’
- Click on ‘Enable Single Sign On’

## Enable Open in VS Code
*Enable Open in VS Code will be Enterprise Ready; we will be adding a new Conditional Access policy and an Admin Level Pool setting.*

Enable Pool Level Setting:
1. Enable the AFEC on the subscription via the Subscription "preview features" blade.
2. Go to the Pool's blade to enable/disable the Open in VS Code option.

# Part 5: Manage your dev box in scale
*Manage your dev boxes in scale by applying project policies.*

### Create a Project Policy

1. Go to your Dev Center, click on ‘Manage’ in the lefthand navigation, then click on ‘Project Policy’ in the dropdown menu. Click on ‘Create’ to begin creating a project policy.

*We will work on creating a default policy. This will configure the settings any current and future projects will use as a default. We are going to create a policy that enables the [8vCPU SKUs](#) by default.*

2. Follow these steps to create a project policy:
   - Click on ‘Create a policy’
   - Click on ‘Select SKUs’ and then select ‘A specific SKU or group of [SKUs](#)’. Select all the 8vCPU SKUs.
   - Click on ‘Select Images’ and then select ‘All current and future images’
   - Click on ‘Select Networks’ and then select ‘All current and future networks’
   - Click on ‘Create’ to finish


# Part 6: Give yourself project access 
*Admins normally provide Dev Box user access to developers. Today, we will give ourselves access!*

1. In your project, [navigate to](#) the 'Access Control (IAM)' blade.
2. Click on '+Add', and add a role assignment.
3. Search for 'DevCenter Dev Box User' role. On the next page, pick '+Select [members](#)'.  
   Add your username, select the account, hit 'Select', then click on 'Review + assign' twice.

# Part 7: Testing out dev box in the future - what should you do? 
1.	Search for ‘Microsoft Dev Box’ in the azure portal to navigate to the Dev Box service. 
2.	Click on ‘get started’. This will navigate you to a wizard to set up your dev box resources. Fill out the fields in the template to deploy all of the necessary Azure resources for dev box. 
o	NOTE: Make sure you are using unique names for each of your resources
3.	Go to devportal.microsoft.com. From here click on ‘New Dev Box’ and follow the steps for Dev Box creation.  


# Part 8: Restore your dev box!
*We can now complete step 8 in part 2 to restore your Dev Box!* 
1. Go to devportal.microsoft.com
2. Select the Dev Box environment you wish to restore.
3. Click on "Restore."
4. Choose the desired [restore](#) point from the list of available **snapshots**.
5. Confirm the restoration process.
6. Once the restoration is complete, you will receive an email notification informing you that your Dev Box is restored and ready to use.


# Part 9: BONUS: Monitoring your dev box with Azure Monitor
