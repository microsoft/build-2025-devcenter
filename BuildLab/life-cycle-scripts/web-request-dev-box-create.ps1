

# Create a new dev box in the pool
$projectName = "onbehalf-test"  
$poolName = "onbehalf-test-eastasia-pool"

$jyotiUserID = 'fd698db4-ebc3-41b7-b6f8-0623438ae585' # this is jyoti's object ID


$devCenterName = "onbehalf-test-f6z7ja-dc"

write-host "Dev Center Name: $devCenterName"

#az devcenter dev dev-box create --pool-name $poolName --name $devBoxName --dev-center-name $devCenterName --project-name $projectName --user-id $userID

# send request to create dev box
# Define the necessary variables
$tenantId = "72f988bf-86f1-41af-91ab-2d7cd011db47"
$devboxLocation = "eastasia" # The location where the Dev Box will be created

# Create the request body
$requestBody = @{
    poolName = $poolName
    osType = "Windows"
}

# Get the Azure AD token
# $token = az account get-access-token --resource 'https://devcenter.azure.com' --query accessToken --output tsv # create dev box on manual? 


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
$apiUrl = "https://$tenantId-$devCenterName.$devboxLocation.devcenter.azure.com/projects/$projectName/users/$jyotiUserID/devboxes/manual-test-onbehalf-create?api-version=2025-04-01-preview"

Write-Warning "send request to create dev box"
Write-Warning "API URL: $apiUrl"

$Headers = @{
    'Authorization' = "Bearer $token"
    'x-ms-upn' = 'jyotilama@microsoft.com' 
}

# Send the web request to create the Dev Box
$response = Invoke-RestMethod -Uri $apiUrl -Method Put -Headers $Headers -Body $jsonBody -ContentType "application/json"

# Output the response
$response