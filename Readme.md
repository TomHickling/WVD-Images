# Azure Image Builder and Shared Image Gallery templates

### This template will create a Windows 10 Image that will then be distributed to Azure Shared Image Gallery that can then be used to build a WVD Host Pool from.

There are two templates. The first is in the 1.AzureImageBuilder folder called DeployAnImage.json. Run this using CreateAIBImage.ps1
- This will Register Azure Image Builder (AIB) as it is currently in preview.
- Create a Resource group and provide AIB with permissions to it
- Then deploy an Windows 10 multi Session Image template and finally the actual image.
- It uses SetupGoldenImage.ps1 to install software into the Image - modify this for the software you want

In conjunction with 2.SharedImageGallery it will distribute the image to a new Shared Image gallery and then you can create a host pool from this.

Start by Downloading: CreateAIBImage.ps1 
Set your Resource Group in the variables Register the Azure Image Builder Resource Provider
This will run:
https://raw.githubusercontent.com/TomHickling/WVD-Images/master/1.AzureImageBuilder/DeployAnImage.json 

Which calls SetupGoldenImage.ps1 which is where you define what software gets installed onto the image.


Shared Image Gallery 

This will build an Image in the Shared Image Gallery

Download DeploySIGImage.ps1

It will Create an image build and distribute it to the Shared Image Gallery
It will then run:
https://raw.githubusercontent.com/TomHickling/WVD-Images/master/DeployAHostPoolFromASIGImage.json 
which uses the parameters in:
https://raw.githubusercontent.com/TomHickling/WVD-Images/master/DeployAHostPoolFromASIGImage.parameters.json 
which you can set to your settings. This is all of the WVD host pool questions that need to be answered if you were deploying a host pool from the Marketplace.

