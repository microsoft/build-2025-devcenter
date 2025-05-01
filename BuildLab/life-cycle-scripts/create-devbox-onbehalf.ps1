# This is just a testing script in progress to create a dev box on behalf of the lab user.
# Don't need az login and the devcenter extension has already been installed on the vm disk.

Param (
    [string]$upn,
    [string]$oid
)
 
Write-Host $upn
Write-Host $oid

Write-Warning "Check Sync: Hello world - test log"

# Variables
# Every instance of the lab vm will generate a new subscription ID, which will make the of the dev center name unique.
$subId = az account show --query "{SubscriptionId:id}" --output tsv
$devCenterName = "build-$($subId.SubString(0,6))-dc"

Write-Warning "attempting to create dev box on behalf of the user"

# Create a new dev box
$projectName = "myProject"
$poolName = "basic-image-pool"
$userID = '69d563db-e4f3-4bd3-be8c-44926ea56a7d' # This is the object ID of the cloud-slice-app

# Send request to create dev box
$tenantId = "4cfe372a-37a4-44f8-91b2-5faf34253c62" # This is the tenat ID of the cloudslice-app
$devboxLocation = "centraluseuap" # TESIING in eueap

# Create the request body
$requestBody = @{
    poolName = $poolName
    osType = "Windows"
}

Write-Warning "fetch token"

# Get the Azure AD token
$token = az account get-access-token --resource 'https://devcenter.azure.com' --query accessToken --output tsv

Write-Warning "fetch token complete"

# Convert the request body to JSON
$jsonBody = $requestBody | ConvertTo-Json

# Define the API endpoint
$apiUrl = "https://$tenantId-$devcenterName.$devboxLocation.devcenter.azure.com/projects/$projectName/users/$userID/devboxes/my-build-devbox?api-version=2025-04-01-preview"

Write-Warning "send request to create dev box"
Write-Warning "API URL: $apiUrl"

# Send the web request to create the Dev Box
$response = Invoke-RestMethod -Uri $apiUrl -Method Put -Headers @{Authorization = "Bearer $token"} -Body $jsonBody -ContentType "application/json"

Write-Warning "Request sent"

# Output the response
$response