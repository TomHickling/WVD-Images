# Azure Image Builder (AIB) and Shared Image Gallery (SIG) Templates for WVD host pool deployment

### These two templates will create a Windows 10 Image that will then be distributed to Azure Shared Image Gallery that can then be used to build a WVD Host Pool from.

There are two templates. The first is in the 1.AzureImageBuilder folder called DeployAnImage.json. Run this template by using CreateAIBImage.ps1.
- This will Register Azure Image Builder as it is currently in preview. (You will need to remove the comments)
- Create a Resource group and provide AIB with permissions to it. Set your Resource Group in the variables section.
- Then deploy an Windows 10 multi Session Image template.
- It calls SetupGoldenImage.ps1 to install software into the Image - modify this for the software you want to install.
- It then builds the Image.

### In conjunction with the above - In 2.SharedImageGallery are templates that will distribute the image to a new Shared Image gallery and then you can create a host pool from this.

This will build an Image in the Shared Image Gallery
- Start by downloading DeploySIGImage.ps1
- Run it and it will create a Resource Group for the SIG
- Create a Shared Image Gallery in that RG
- Create an Image Definition in that Gallery
- Assign AIB rights to the SIG RG in order to distribute to it
- It will then create an new image defintion and distribute to the SIG using https://raw.githubusercontent.com/TomHickling/WVD-Images/master/2.SharedImageGallery/DistributeAnImageToSIG.json. In here you can specify the name of the AIB Image name as well as specifying the Azure regions that you want to replicate the image to so that it can be used in the WVD host pool deployment.
- It will then commence the Image build
- It will then create a WVD host pool by calling
  https://raw.githubusercontent.com/TomHickling/WVD-Images/master/DeployAHostPoolFromASIGImage.json 
  which uses the parameters in:
  https://raw.githubusercontent.com/TomHickling/WVD-Images/master/DeployAHostPoolFromASIGImage.parameters.json 
  which you can set to your settings relevant to your WVD tenant and existing Shared Image gallery specific details created earlier. This is all of the WVD host pool questions that need to be answered if you were deploying a host pool from the Marketplace.

