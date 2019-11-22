Azure Image Builder template

This template will create a Windows 10 Image that can be used to build a VM from.

In conjunction with 2.SharedImageGallery it will distribute the image to a new Shared Image gallery and then you can create a host pool from this.

Start by Downloading: CreateAIBImage.ps1
Set your Resource Group in the variables
Register the Azure Image Builder Resource Provider

This will run https://raw.githubusercontent.com/TomHickling/WVD-Images/master/1.AzureImageBuilder/DeployAnImage.json which calls SetupGoldenImage.ps1 which is where you define what software gets installed onto the image.

Shared Image Gallery
This will build an Image in the Shared Image Gallery

Download DeploySIGImage.ps1

It will Create an image build and distribute it to the Shared Image Gallery


It will then run https://raw.githubusercontent.com/TomHickling/WVD-Images/master/DeployAHostPoolFromASIGImage.json which uses the paramters in https://raw.githubusercontent.com/TomHickling/WVD-Images/master/DeployAHostPoolFromASIGImage.parameters.json which you can set to your settings. This is all of the WVD host pool questions that need to be answered if you were deploying a host pool from the Marketplace.




