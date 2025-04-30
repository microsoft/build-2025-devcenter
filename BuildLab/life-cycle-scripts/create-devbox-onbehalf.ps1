# This is just a testing script in progress to create a dev box on behalf of the lab user.

# Don't need az login the lab already has the context set up.

# Variables
$resourceGroupName = 'Build-2025'
$location =  'centraluseuap' #'westus3'
$userID = '69d563db-e4f3-4bd3-be8c-44926ea56a7d' # This is the object ID of the cloud-slice-app

# TEST create a devcenter - DELETE LATER
az group create -l $location -n $resourceGroupName
# az devcenter admin devcenter create --location $location --name $devCenterName --resource-group $resourceGroupName

# Every instance of the lab vm will generate a new subscription ID, which will make the of the dev center name unique.
$subId = az account show --query "{SubscriptionId:id}" --output tsv
$devCenterName = 'build-' + $subId.Substring(0, 6) + "-dc"

# Set up Monitoring for the dev center
# Create a log analytics workspace for the dev center
$laworkspace = az monitor log-analytics workspace create --resource-group $resourceGroupName --workspace-name "DevCenterLogs" --location "westus2"

# Create a diagnostic setting on the devcenter
$laworkspaceid = ($laworkspace | ConvertFrom-Json).id
$devcenters = (az devcenter admin devcenter list | ConvertFrom-Json) | Where-Object { $_.name.ToLower() -like "*build*" }
$devcenterid = $devcenters.id
az monitor diagnostic-settings create --name DevCenter-Diagnostics --resource $devcenterid --logs '[{"categoryGroup":"allLogs","enabled":true}]' --workspace $laworkspaceid


# Work In Progress
# Create a new dev box
$projectName = "myProject"
$poolName = "basic-image-pool"
$userID = '7e199eac-e561-43fc-b1d3-dd9dbb4bef71' # This is the object ID of the cloudslice-app

# Option 1: Create dev box using az devcenter command
#az devcenter dev dev-box create --pool-name $poolName --name $devBoxName --dev-center-name $devCenterName --project-name $projectName --user-id $userID

# OPtion 2: Send request to create dev box
$tenantId = "4cfe372a-37a4-44f8-91b2-5faf34253c62" # This is the tenat ID of the cloudslice-app
$devboxLocation = "centraluseuap" # TESIING in eueap

# Create the request body
$requestBody = @{
    poolName = $poolName
    osType = "Windows"
}

# Get the Azure AD token
$token = az account get-access-token --resource 'https://devcenter.azure.com' --query accessToken --output tsv

# Convert the request body to JSON
$jsonBody = $requestBody | ConvertTo-Json

# test exaxmple: https://72f988bf-86f1-41af-91ab-2d7cd011db47-mybuilddevcenter.eastus2.devcenter.azure.com/

# Define the API endpoint
$apiUrl = "https://$tenantId-$devcenterName.$devboxLocation.devcenter.azure.com/projects/$projectName/users/$userID/devboxes/web-test-devbox?api-version=2025-02-01"

# Send the web request to create the Dev Box
$response = Invoke-RestMethod -Uri $apiUrl -Method Put -Headers @{Authorization = "Bearer $token"} -Body $jsonBody -ContentType "application/json"

# Output the response
$response
