# This is just a testing script in progress to create a dev box on behalf of the lab user.

# Don't need az login

# Add the Devcenter extension
az extension add --name devcenter

$resourceGroupName = 'onBehalfResourceGroup-buildlab'
$location = 'westus3'
$userID = '7e199eac-e561-43fc-b1d3-dd9dbb4bef71' # This is the object ID of the cloudslice-app

# Create the resource group
az group create -l $location -n $resourceGroupName

# Variables
$devboxRGName = 'Build-2025'
$devCenterName = 'myBuildDevCenter-test123' 


# Create a log analytics workspace for the dev center. Log analytics team is still rolling out must use westus2 for now.
$laworkspace = az monitor log-analytics workspace create --resource-group $resourceGroupName --workspace-name "DevCenterLogs" --location "westus2"

# Create a diagnostic setting on the devcenter
$laworkspaceid = ($laworkspace | ConvertFrom-Json).id
$devcenterid = ($devcenter | ConvertFrom-Json).id
az monitor diagnostic-settings create --name DevCenter-Diagnostics --resource $devcenterid --logs '[{"categoryGroup":"allLogs","enabled":true}]' --workspace $laworkspaceid


# Create a new dev box in the pool
$projectName = "myProject"
$poolName = "basic-image-pool"
$devBoxName = "myDevBox"
$userID = '7e199eac-e561-43fc-b1d3-dd9dbb4bef71' # This is the object ID of the cloudslice-app
az devcenter dev dev-box create --pool-name $poolName --name $devBoxName --dev-center-name $devCenterName --project-name $projectName --user-id $userID