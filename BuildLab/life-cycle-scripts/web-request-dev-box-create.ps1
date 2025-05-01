

# Create a new dev box in the pool
$projectName = "onbehalf-project"  
$poolName = "number-two-pool"

$userID = 'bbc28698-d0fe-42d0-ab02-19099f309d70' # testing app id

$subId = az account show --query "{SubscriptionId:id}" --output tsv
#$devCenterName = "build-${subId.Substring(0, 6)}-dc"

write-host "Dev Center Name: $devCenterName"

#az devcenter dev dev-box create --pool-name $poolName --name $devBoxName --dev-center-name $devCenterName --project-name $projectName --user-id $userID

# send request to create dev box
# Define the necessary variables
$tenantId = "72f988bf-86f1-41af-91ab-2d7cd011db47"
$devboxLocation = "centraluseuap" # The location where the Dev Box will be created

# Create the request body
$requestBody = @{
    poolName = $poolName
    osType = "Windows"
}

# Get the Azure AD token
#$token = az account get-access-token --resource 'https://devcenter.azure.com' --query accessToken --output tsv
$token = Get-Content -Path ".\temp-token.txt" -Raw # TESTING

# Convert the request body to JSON
$jsonBody = $requestBody | ConvertTo-Json

# test exaxmple: https://72f988bf-86f1-41af-91ab-2d7cd011db47-build-3de261-dc.centraluseuap.devcenter.azure.com/

# Define the API endpoint
#$apiUrl = "https://$tenantId-$devcenterName.$devboxLocation.devcenter.azure.com/projects/$projectName/users/$userID/devboxes/web-test-devbox?api-version=2025-04-01-preview"

#$apiUrl = "https://$tenantId-$devCenterName.$devboxLocation.devcenter.azure.com/projects?api-version=2025-04-01-preview"

# $apiUrl = "https://72f988bf-86f1-41af-91ab-2d7cd011db47-build-3de261-dc.centraluseuap.devcenter.azure.com/projects/onbehalf-project/users/$userID/web-test-devbox?api-version=2025-04-01-preview"

Write-Warning "fetch token complete"

# Convert the request body to JSON
$jsonBody = $requestBody | ConvertTo-Json

# Define the API endpoint
$apiUrl = "https://$tenantId-build-3de261-dc.$devboxLocation.devcenter.azure.com/projects/$projectName/users/$userID/devboxes/my-build-devbox?api-version=2025-04-01-preview"

Write-Warning "send request to create dev box"
Write-Warning "API URL: $apiUrl"

# Send the web request to create the Dev Box
$response = Invoke-RestMethod -Uri $apiUrl -Method Put -Headers @{Authorization = "Bearer $token"} -Body $jsonBody -ContentType "application/json"

# Output the response
$response