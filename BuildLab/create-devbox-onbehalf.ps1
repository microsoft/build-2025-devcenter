# This is just a testing script in progress.

$resourceGroupName = 'myResourceGroup-buildlab'
$location = 'EastUS'
$keyVaultName = 'myKeyVault-buidlab'

# Ensure you are logged into your Azure account
Connect-AzAccount

# Create the resource group if it doesn't exist
$resourceGroup = Get-AzResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue
if (-not $resourceGroup) {
    New-AzResourceGroup -Name $resourceGroupName -Location $location
}

# Create the Key Vault
New-AzKeyVault -ResourceGroupName $resourceGroupName -VaultName $keyVaultName -Location $location

# Create a devcenter for the user
$devCenterName = 'myDevCenter'
New-AzDevCenter -ResourceGroupName $resourceGroupName -Name $devCenterName -Location $location

# Create a Dev Box definition
$devBoxDefinitionName = 'VSCodeWin11WithHibernate-devboxdefinition'
$imageReference = @{
    Publisher = 'MicrosoftWindowsDesktop'
    Offer     = 'office-365'
    Sku       = 'win11-21h2-pro'
    Version   = 'latest'
}
New-AzDevBoxDefinition -ResourceGroupName $resourceGroupName `
    -DevCenterName $devCenterName `
    -Name $devBoxDefinitionName `
    -ImageReference $imageReference `
    -HibernateSupport $true `
    -Description "Windows 11 with VS Code and Hibernate support"

# Add a project in the resource group
$projectName = 'myProject'
New-AzDevCenterProject -ResourceGroupName $resourceGroupName `
    -DevCenterName $devCenterName `
    -Name $projectName `
    -Location $location

# Create a new pool in the project using Microsoft-hosted network in WestUS3
$poolName = 'myPool'
New-AzDevCenterPool -ResourceGroupName $resourceGroupName `
    -DevCenterName $devCenterName `
    -ProjectName $projectName `
    -Name $poolName `
    -DevBoxDefinitionName $devBoxDefinitionName `
    -NetworkConnectionType 'MicrosoftHostedNetwork' `
    -Location 'WestUS3'