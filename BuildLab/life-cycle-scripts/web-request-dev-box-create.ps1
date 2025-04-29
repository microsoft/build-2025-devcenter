

# possible issue with az login?

# Create a new dev box in the pool
$projectName = "myProject"
$poolName = "auto-contoso-pool"
#$devBoxName = "web-test-devbox"
$userID = 'fd698db4-ebc3-41b7-b6f8-0623438ae585' # my id
$devcenterName = "mybuilddevcenter"

#az devcenter dev dev-box create --pool-name $poolName --name $devBoxName --dev-center-name $devCenterName --project-name $projectName --user-id $userID

# send request to create dev box
# Define the necessary variables
$tenantId = "72f988bf-86f1-41af-91ab-2d7cd011db47"
$devboxLocation = "eastus2" # The location where the Dev Box will be created

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