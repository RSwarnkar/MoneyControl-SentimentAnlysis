

## Create Service Principal (Client ID and Clinet Secret) to be used: 


# Step-1 : Login via Global-Admin:

## Change Tenant and Subscription ID if needed
$TENANT_ID       = "061bc4a2-a11e-446a-ad8e-c717e269679d"
$SUBSCRIPTION_ID = "bffb9b10-3e3c-486c-bb68-6ac0e94329f7"

Write-Host "Connecting..."
Connect-AzAccount -Tenant $TENANT_ID -UseDeviceAuthentication -SubscriptionId $SUBSCRIPTION_ID

Set-AzContext -SubscriptionId $SUBSCRIPTION_ID


# Step-2 : Create Service Principal: 

$adate = Get-Date -Format "yyyyMMM"

# Variables 
$servicePrincipalName = "sp4tf-${adate}-$(-join ((97..122) | Get-Random -Count 5 | % {[char]$_}))"

$scope = "/subscriptions/$($SUBSCRIPTION_ID)/"

# https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles
$role_name = "Owner"

Write-Host "Attempting to create new Service Principal: $($servicePrincipalName)"

$sp = New-AzADServicePrincipal -DisplayName $servicePrincipalName 

$display_name  = $sp.DisplayName 
$client_id     = $sp.AppId # Application (Client ID) 
$client_secret = $sp.PasswordCredentials.SecretText  # Application (Client) Secret 
$object_id     = $sp.Id # Object ID 

Write-Host "Attempting to assign RBAC role to new Service Principal: $($servicePrincipalName)"

New-AzRoleAssignment -ApplicationId $client_id -RoleDefinitionName $role_name -Scope $scope

Write-Host "=============================================================="

Write-Host "Azure DevOps: Create Variable Group with below details: "


Write-Host "client_id                : $($client_id)"
Write-Host "client_secret            : $($client_secret)"
Write-Host "devops_subscription_id   : $($SUBSCRIPTION_ID)"
Write-Host "project_subscription_id  : $($SUBSCRIPTION_ID)"
Write-Host "tenant_id                : $($TENANT_ID)"
Write-Host "sp_name                  : $($display_name)"

# $env:ARM_CLIENT_ID       = $($client_id)
# $env:ARM_CLIENT_SECRET   = $($client_secret)
# $env:ARM_SUBSCRIPTION_ID = $($SUBSCRIPTION_ID)
# $env:ARM_TENANT_ID       = $($TENANT_ID)

# $SP_ClientID     = $env:ARM_CLIENT_ID
# $SP_SubID        = $env:ARM_SUBSCRIPTION_ID
# $SP_ClientSecret = ConvertTo-SecureString $env:ARM_CLIENT_SECRET -AsPlainText -Force
# $SP_Credential   = New-Object System.Management.Automation.PSCredential($SP_ClientID , $SP_ClientSecret)
# Connect-AzAccount -Credential $SP_Credential -Tenant $env:ARM_TENANT_ID -ServicePrincipal
# Set-AzContext -SubscriptionId $SP_SubID



Write-Host "=============================================================="

Write-Host "Terraform Console env vars: Login using AZ PWSH"

Write-Host "`$env:ARM_CLIENT_ID       = `"$($client_id)`""
Write-Host "`$env:ARM_CLIENT_SECRET   = `"$($client_secret)`""
Write-Host "`$env:ARM_SUBSCRIPTION_ID = `"$($SUBSCRIPTION_ID)`""
Write-Host "`$env:ARM_TENANT_ID       = `"$($TENANT_ID)`""


Write-Host '''
$SP_ClientID     = $env:ARM_CLIENT_ID
$SP_SubID        = $env:ARM_SUBSCRIPTION_ID

$SP_ClientSecret = ConvertTo-SecureString $env:ARM_CLIENT_SECRET -AsPlainText -Force
$SP_Credential   = New-Object System.Management.Automation.PSCredential($SP_ClientID , $SP_ClientSecret)
Connect-AzAccount -Credential $SP_Credential -Tenant $env:ARM_TENANT_ID -ServicePrincipal
Set-AzContext -SubscriptionId $SP_SubID
'''

Write-Host "=============================================================="


Write-Host "Terraform Console env vars: Login using AZ CLI"
Write-Host "`$env:ARM_CLIENT_ID       = `"$($client_id)`""
Write-Host "`$env:ARM_CLIENT_SECRET   = `"$($client_secret)`""
Write-Host "`$env:ARM_SUBSCRIPTION_ID = `"$($SUBSCRIPTION_ID)`""
Write-Host "`$env:ARM_TENANT_ID       = `"$($TENANT_ID)`""

Write-Host '''
Remove-Item -Recurse -Force "$env:USERPROFILE\.azure"
$client_id=$env:ARM_CLIENT_ID
$client_secret=$env:ARM_CLIENT_SECRET
$tenant_id=$env:ARM_TENANT_ID
$subscription_id=$env:ARM_SUBSCRIPTION_ID
az login --service-principal -u $client_id -p $client_secret --tenant $tenant_id --allow-no-subscriptions
az account set --subscription $subscription_id
az account show
'''

Write-Host "=============================================================="



# # Create RG for state file storage: 
# $rg_name = "rg-tfstate-$(-join ((97..122) | Get-Random -Count 5 | % {[char]$_}))"
# New-AzResourceGroup -Name  $rg_name -Location "East US"


# # Create blob SA for state file storage: 
# $sa_name = "rswarnka$(-join ((97..122) | Get-Random -Count 6 | % {[char]$_}))"
# New-AzStorageAccount -ResourceGroupName $rg_name -Name $sa_name -Location "East US" -SkuName "Standard_LRS" -AllowBlobPublicAccess $True -AllowCrossTenantReplication $False 

# # Create blob container 
# $ctx = New-AzStorageContext -StorageAccountName $sa_name
# $container_name = "tfstate-$(-join ((97..122) | Get-Random -Count 4 | % {[char]$_}))"
# New-AzStorageContainer -Name $container_name -Context $ctx


# ## Ini file Output : 

# Write-Host "=============================================================="

# Write-Host "###### Terraform Backend Container Config ######"
# Write-Host "container_name          = `"$($container_name)`""
# Write-Host "subscription_id         = `"$($env:ARM_SUBSCRIPTION_ID)`""
# Write-Host "resource_group_name     = `"$($rg_name)`""
# Write-Host "storage_account_name    = `"$($sa_name)`""
# Write-Host "key                     = `"project.terraform.tfstate`""
 
# Write-Host "Create Ini File with this details..."


