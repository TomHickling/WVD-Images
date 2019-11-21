#Setup variables
$ResourceGroupName = "test"
$TemplateFile = "C:\Users\thhickli\OneDrive - Microsoft\End User Computing\Windows Virtual Desktop\Images\Image-Templates\DeployAHostPoolFromaSIGImage.json"
$TemplateParameterFile = "C:\Users\thhickli\OneDrive - Microsoft\End User Computing\Windows Virtual Desktop\Images\Image-Templates\DeployAHostPoolFromASIGImage.parameters.json"

#Install Module if you don't have it yet
Install-Module Az -Force

#Login to Azure RM if you havent already
Add-AzAccount

#Create New ResourceGroup if not already existing
New-AzResourceGroup -Name $resourceGroupName -Location NorthEurope

#Start the deployment
New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile $TemplateFile -TemplateParameterFile $TemplateParameterFile -Verbose
