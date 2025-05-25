
## Optional: To Create SA for State Store
## Paste the outcome from Script-01 

# $env:ARM_CLIENT_ID       = "___"
# $env:ARM_CLIENT_SECRET   = "___"
# $env:ARM_SUBSCRIPTION_ID = "___"
# $env:ARM_TENANT_ID       = "___"
 

# $SP_ClientID     = $env:ARM_CLIENT_ID
# $SP_SubID        = $env:ARM_SUBSCRIPTION_ID
# $SP_ClientSecret = ConvertTo-SecureString $env:ARM_CLIENT_SECRET -AsPlainText -Force
# $SP_Credential   = New-Object System.Management.Automation.PSCredential($SP_ClientID , $SP_ClientSecret)
# Connect-AzAccount -Credential $SP_Credential -Tenant $env:ARM_TENANT_ID -ServicePrincipal
# Set-AzContext -SubscriptionId $SP_SubID

# Create RG for state file storage: 
$rg_name = "rg-tfstate-$(-join ((97..122) | Get-Random -Count 4 | % {[char]$_}))"
New-AzResourceGroup -Name  $rg_name -Location "East US"


# Create blob SA for state file storage: 
$sa_name = "tfstate$(-join ((97..122) | Get-Random -Count 4 | % {[char]$_}))"
New-AzStorageAccount -ResourceGroupName $rg_name -Name $sa_name -Location "East US" -SkuName "Standard_LRS" -AllowBlobPublicAccess $True -AllowCrossTenantReplication $False 

# Create blob container 
$ctx = New-AzStorageContext -StorageAccountName $sa_name
$container_name = "tfstate-$(-join ((97..122) | Get-Random -Count 4 | % {[char]$_}))"
New-AzStorageContainer -Name $container_name -Context $ctx


## Ini file Output : 

Write-Host "=============================================================="
Write-Host "Update Ini File with below details: Terraform\init\sc300-lab\sc300-lab.ini "
Write-Host ""
Write-Host "###### Terraform Backend Container Config ######"
Write-Host "container_name          = `"$($container_name)`""
Write-Host "subscription_id         = `"$($env:ARM_SUBSCRIPTION_ID)`""
Write-Host "resource_group_name     = `"$($rg_name)`""
Write-Host "storage_account_name    = `"$($sa_name)`""
Write-Host "key                     = `"sc-300-lab.terraform.tfstate`""
 
