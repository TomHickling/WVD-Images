##Create a VM image using Azure Image Builder that we will later store in Shared IMage Gallery and deploy to a WVD Host Pool

#Install AZ if not already installed and login
Install-Module Az -Force
Connect-AzAccount

#Regsiter the feature whilst its in preview
Register-AzProviderFeature -ProviderNamespace Microsoft.VirtualMachineImages -FeatureName VirtualMachineTemplatePreview

#Check registration is complete - should all say "Registered"
Get-AzResourceProvider -ProviderNamespace Microsoft.VirtualMachineImages | Select-Object RegistrationState
Get-AzResourceProvider -ProviderNamespace Microsoft.Storage | Select-Object RegistrationState

#If anything is not registered run these
Register-AzResourceProvider -ProviderNamespace Microsoft.VirtualMachineImages
Register-AzResourceProvider -ProviderNamespace Microsoft.Storage

#AIB needs rights to Resource Group(s) using its SPN
#Create a new Resource Group if not already existing
New-AzResourceGroup -Name "RG2_EUS_AzureImageBuilder" -Location 'East US'
#Provide "contributor" rights to the RG for the Service Principle
New-AzRoleAssignment -RoleDefinitionName "Contributor" -ApplicationId "cf32a0cc-373c-47c9-9156-0db11f6a6dfc" -ResourceGroupName "RG2_EUS_AzureImageBuilder"

#Start Image Deployment
$TemplateUri = "https://raw.githubusercontent.com/Everink/AzureImageBuilder/master/Templates/AzureImageBuilder-ManagedImage.json"
New-AzResourceGroupDeployment -ResourceGroupName RG_EUS_AzureImageBuilder -TemplateUri $TemplateUri -OutVariable Output -Verbose

