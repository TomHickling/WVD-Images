##Create a VM image using Azure Image Builder that we will later store in Shared IMage Gallery and deploy to a WVD Host Pool

#Set Variables - Resource Group to deploy into and the ARM template we use later
$RG = "WVD_EUS_AzureImageBuilder"
$TemplateUri = "https://raw.githubusercontent.com/TomHickling/WVD-Images/master/1.AzureImageBuilder/DeployAnImage.json"

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
New-AzResourceGroup -Name $RG -Location 'East US'
#Provide "contributor" rights to the RG for the Service Principle
New-AzRoleAssignment -RoleDefinitionName "Contributor" -ApplicationId "cf32a0cc-373c-47c9-9156-0db11f6a6dfc" -ResourceGroupName "$RG"

#Start Image Deployment
#Build Image Template
New-AzResourceGroupDeployment -ResourceGroupName $RG -TemplateUri $TemplateUri -OutVariable Output -Verbose

#Check Name of Image Template. In the Azure portal select "Show hidden types" in the RG
$Output.Outputs["imageTemplateName"].Value
#Build the Golden Image
$ImageTemplateName = $Output.Outputs["imageTemplateName"].Value
Invoke-AzResourceAction -ResourceGroupName $RG -ResourceType Microsoft.VirtualMachineImages/imageTemplates -ResourceName $ImageTemplateName -Action Run

#Check Build Process - Will say "Building" for awhile (about 20 mins) and then "Distributing"(for about 2 mins). Once complete there will be an Image in the resource Group
(Get-AzResource -ResourceGroupName $RG -ResourceType Microsoft.VirtualMachineImages/imageTemplates -Name $ImageTemplateName).Properties.lastRunStatus
