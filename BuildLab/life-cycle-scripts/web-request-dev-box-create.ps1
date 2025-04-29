# This is just a testing script in progress to create a dev box on behalf of the lab user.

# Don't need az login and the devcenter extension has already been installed on the vm disk.

# Variables
$resourceGroupName = 'onbehalfrg'
$devCenterName = 'onBehalfDevCenter'
$location = 'westus3'
$userID = '7e199eac-e561-43fc-b1d3-dd9dbb4bef71' # This is the object ID of the cloudslice-app

# test create a devcenter
#az group create -l $location -n $resourceGroupName
#az devcenter admin devcenter create --location $locaiton --name $devCenterName --resource-group $resourceGroupName

# Create a log analytics workspace for the dev center
$laworkspace = az monitor log-analytics workspace create --resource-group $resourceGroupName --workspace-name "DevCenterLogs" --location "westus2"


# Create a diagnostic setting on the devcenter
$laworkspaceid = ($laworkspace | ConvertFrom-Json).id
$devcenters = (az devcenter admin devcenter list | ConvertFrom-Json) | Where-Object { $_.name.ToLower() -like "*build*" }
$devcenterid = $devcenters.id
az monitor diagnostic-settings create --name DevCenter-Diagnostics --resource $devcenterid --logs '[{"categoryGroup":"allLogs","enabled":true}]' --workspace $laworkspaceid


# Create a new dev box in the pool
$projectName = "myProject"
$poolName = "basic-image-pool"
$devBoxName = "myDevBox"
$userID = '7e199eac-e561-43fc-b1d3-dd9dbb4bef71' # This is the object ID of the cloudslice-app

#az devcenter dev dev-box create --pool-name $poolName --name $devBoxName --dev-center-name $devCenterName --project-name $projectName --user-id $userID

# send request to create dev box
# Define the necessary variables
$tenantId = "4cfe372a-37a4-44f8-91b2-5faf34253c62"
$devboxLocation = "centraluseuap" # The location where the Dev Box will be created

# Create the request body
$requestBody = @{
    poolName = $poolName
    osType = "Windows"
}

# Get the Azure AD token
$token = az account get-access-token --query accessToken --output tsv

# Convert the request body to JSON
$jsonBody = $requestBody | ConvertTo-Json

# test exaxmple: https://72f988bf-86f1-41af-91ab-2d7cd011db47-mybuilddevcenter.eastus2.devcenter.azure.com/



# Define the API endpoint
$apiUrl = "https://$tenantId-$devcenterName.$devboxLocation.devcenter.azure.com/projects/$projectName/users/$userID/devboxes/$devBoxName?api-version=2025-02-01"

# Send the web request to create the Dev Box
$response = Invoke-RestMethod -Uri $apiUrl -Method Put -Headers @{Authorization = "Bearer $token"} -Body $jsonBody -ContentType "application/json"

# Output the response
$response
