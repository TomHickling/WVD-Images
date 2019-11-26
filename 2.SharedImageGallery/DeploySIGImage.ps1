#Create a Shared Image Gallery and put an Azure Image Builder into it to them deploy via WVD.

#Setup some variables: $ResourceGroupName is for the Shared Image Gallery, $AIBRG is the RG that already exists and has your AIB Image in it and $HPRG is the WVD host pool RG
$ResourceGroupName = "WVD_EUS_SharedImageGallery"
$AIBRG = "WVD_EUS_AzureImageBuilder"
$HPRG = "WVD_NEU-HP1"
$SIG = "WVD_Gallery"
$Def = "WVD_ImageDefinition"
#Either use this for Local template
# $TemplateFile = "Path To\DeployAHostPoolFromaSIGImage.json"
# $TemplateParameterFile = "Path To\DeployAHostPoolFromASIGImage.parameters.json"
#Or from Github
$TemplateURI = "https://raw.githubusercontent.com/TomHickling/WVD-Images/master/2.SharedImageGallery/DeployAHostPoolFromASIGImage.json"
$TemplateParameterURI = "https://raw.githubusercontent.com/TomHickling/WVD-Images/master/2.SharedImageGallery/DeployAHostPoolFromASIGImage.parameters.json"

#Install Module if you don't have it yet
# Install-Module Az -Force

#Login to Azure RM if you havent already
# Add-AzAccount

#Create New ResourceGroup if not already existing
New-AzResourceGroup -Name $resourceGroupName -Location EastUS
#Create Shared Image Gallery
New-AzGallery -ResourceGroupName $ResourceGroupName -name $SIG -Location EastUS -Description "Shared Image Gallery for WVD Deployments"
#Create an Image Definition
New-AzgalleryImageDefinition -Name $Def -GalleryName $SIG -ResourceGroupName $ResourceGroupName -Location 'East US' -OsState generalized -OsType Windows -Publisher 'myPublisher' -Offer 'myOffer' -Sku 'mySKU'

#Assign Azure Image Builder rights to the SIG
New-AzRoleAssignment -RoleDefinitionName "Contributor" -ApplicationId "cf32a0cc-373c-47c9-9156-0db11f6a6dfc" -ResourceGroupName $ResourceGroupName

##Distribute section. 
#Distribute the Image metadata to Shared Image Gallery via Github
$DistributeTemplateUri = "https://raw.githubusercontent.com/TomHickling/WVD-Images/master/2.SharedImageGallery/DistributeAnImageToSIG.json"
#Or local file
# $DistributeTemplatefile = "Path to\2. Shared Image Gallery\DistributeAnImageToSIG.json"
#Image Definition
$ImageDefinitionId = "/subscriptions/7c793f65-5192-45b9-862f-698414ecf392/resourceGroups/WVD_EUS_SharedImageGallery/providers/Microsoft.Compute/galleries/WVD_Gallery/images/WVD_ImageDefinition"
                    
New-AzResourceGroupDeployment -ResourceGroupName $AIBRG -TemplateUri $DistributeTemplateUri -OutVariable Output -Verbose -SIGImageDefinitionId $ImageDefinitionId
#Or
# New-AzResourceGroupDeployment -ResourceGroupName $AIBRG -TemplateFile $DistributeTemplatefile -OutVariable Output -Verbose -SIGImageDefinitionId $ImageDefinitionId

#Start Image Build
$ImageTemplateName = $Output.Outputs["imageTemplateName"].Value
Invoke-AzResourceAction -ResourceGroupName $AIBRG -ResourceType Microsoft.VirtualMachineImages/imageTemplates -ResourceName $ImageTemplateName -Action Run

#Check the status of the build
(Get-AzResource -ResourceGroupName $AIBRG -ResourceType Microsoft.VirtualMachineImages/imageTemplates -Name $ImageTemplateName).Properties.lastRunStatus

##WVD Host pool section
#Start the WVD host pool deployment
New-AzResourceGroup -Name $HPRG -Location NorthEurope
#Create Shared Image Gallery
#Either Local
New-AzResourceGroupDeployment -ResourceGroupName $hprg -TemplateFile $TemplateFile -TemplateParameterFile $TemplateParameterFile -Verbose
#OR Github
New-AzResourceGroupDeployment -ResourceGroupName $hprg -TemplateURI $TemplateURI -TemplateParameterUri $TemplateParameterURI -Verbose

