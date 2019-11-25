# Azure Image Builder (AIB) and Shared Image Gallery (SIG) Templates

### This template will create a Windows 10 Image that will then be distributed to Azure Shared Image Gallery that can then be used to build a WVD Host Pool from.

There are two templates. The first is in the 1.AzureImageBuilder folder called DeployAnImage.json. Run this template by using CreateAIBImage.ps1
- This will Register Azure Image Builder as it is currently in preview.
- Create a Resource group and provide AIB with permissions to it. Set your Resource Group in the variables Register the Azure Image   Builder Resource Provider
- Then deploy an Windows 10 multi Session Image template and finally the actual image.
- It callc SetupGoldenImage.ps1 to install software into the Image - modify this for the software you want to install

### In conjunction with the above - In 2.SharedImageGallery are templates that will distribute the image to a new Shared Image gallery and then you can create a host pool from this.

This will build an Image in the Shared Image Gallery
- Download DeploySIGImage.ps1
- This will create a Resource Group for the SIG
- Create a Shared Image Gallery in that RG
- Create an Image Definition in that Gallery
- Assign AIB rights to the SIG RG
- It will then create an new image and distribute to the SIG
- It will then create a WVD host pool by calling
  https://raw.githubusercontent.com/TomHickling/WVD-Images/master/DeployAHostPoolFromASIGImage.json 
  which uses the parameters in:
  https://raw.githubusercontent.com/TomHickling/WVD-Images/master/DeployAHostPoolFromASIGImage.parameters.json 
  which you can set to your settings relevant to your WVD tenant. This is all of the WVD host pool questions that need to be answered if    you were deploying a host pool from the Marketplace.

