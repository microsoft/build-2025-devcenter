# This is just a testing script in progress to create a dev box on behalf of the lab user.

$resourceGroupName = 'onBehalfResourceGroup-buildlab'
$location = 'WestUS3'
$userID = '7e199eac-e561-43fc-b1d3-dd9dbb4bef71' # This is the object ID of the cloudslice-app

# Ensure you are logged into your Azure account
Connect-AzAccount

# Create the resource group if it doesn't exist
$resourceGroup = Get-AzResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue
if (-not $resourceGroup) {
    New-AzResourceGroup -Name $resourceGroupName -Location $location
}

# Create a devcenter for the user
$devCenterName = 'onBehalfDevCenter' 
 az devcenter admin devcenter create 
    -Name $devCenterName
    -ResourceGroupName $resourceGroupName 
    -Location $location

# Create a Dev Box definition
$devBoxDefinitionName = 'VSCodeWin11WithHibernate-devboxdefinition'
$imageReference = @{
    Publisher = 'MicrosoftWindowsDesktop'
    Offer     = 'office-365'
    Sku       = 'win11-21h2-pro'
    Version   = 'latest'
}
    -ResourceGroupName $resourceGroupName `
    -DevCenterName $devCenterName `
    -Name $devBoxDefinitionName `
    -ImageReference $imageReference `
    -HibernateSupport $true `
    -Description "Windows 11 with VS Code and Hibernate support"

# Add a project in the resource group
$projectName = 'obBehalfProject'
    -ResourceGroupName $resourceGroupName `
    -DevCenterName $devCenterName `
    -Name $projectName `
    -Location $location

# Create a new pool in the project using Microsoft-hosted network in WestUS3
$poolName = 'onBehalfPool'
    -ResourceGroupName $resourceGroupName `
    -DevCenterName $devCenterName `
    -ProjectName $projectName `
    -Name $poolName `
    -DevBoxDefinitionName $devBoxDefinitionName `
    -NetworkConnectionType 'MicrosoftHostedNetwork' `
    -Location $location

# Create a new dev box in the pool
$devBoxName = 'onBehalfDevBox'
    -ResourceGroupName $resourceGroupName `
    -DevCenterName $devCenterName `
    -ProjectName $projectName `
    -PoolName $poolName `
    -Name $devBoxName `
    -Description "Dev Box for testing on behalf of the lab user" `
    -UserId $userID 