# This is just a testing script in progress to create a dev box on behalf of the lab user.
# Don't need az login and the devcenter extension has already been installed on the vm disk.

# Variables
# Every instance of the lab vm will generate a new subscription ID, which will make the of the dev center name unique.
$subId = '@lab.CloudSubscription.Id'
$rg = '@lab.CloudResourceGroup(ResourceGroup1).Name'
$devCenterName = "build-$($subId.SubString(0,6))-dc"

# Set the desired subscription context
Set-AzContext -SubscriptionId $subId
# Register the feature
Register-AzProviderFeature -FeatureName "DevTunnelsPreview" -ProviderNamespace "Microsoft.DevCenter"

# Create a new dev box
$projectName = "myProject"
$poolName = "basic-image-pool"

# Get the UPN (User Principal Name) of the user
$UPN = '@lab.CloudPortalCredential(User1).Username'
$userObjectId = (Get-AzADUser -UserPrincipalName $UPN).Id

Set-LabVariable -Name ObjectId -Value $userObjectId

#Write-Host "User info"
#Write-Host "User UPN: $UPN"
#Write-Host "User Object ID: $userObjectId"

# Set access for the user
# Assign the 'Dev Center Dev Box User' role to the user
New-AzRoleAssignment `
    -ObjectId $userObjectId `
    -RoleDefinitionName "DevCenter Dev Box User" `
    -Scope "/subscriptions/$subId/resourceGroups/$rg/providers/Microsoft.DevCenter/projects/$projectName"

$check1 = "assigned role"

Set-LabVariable -Name AssignRole -Value $check1

#Write-Host "Done assigning role to user"

Start-Sleep -Seconds 10 # wait for the role assignment to propagate

#Write-Host "Attempting to create dev box on behalf of the user"

# Send request to create dev box
$tenantId = "4cfe372a-37a4-44f8-91b2-5faf34253c62" # This is the tenat ID of the cloudslice-app
$devboxLocation = "@lab.CloudResourceTemplate(MainResourcesSetUp).Parameters[location]" 

# Create the request body
$requestBody = @{
    poolName = $poolName
    osType = "Windows"
}

#Write-Warning "fetch token"

# Get the Azure AD token
$token = (Get-AzAccessToken -ResourceUrl 'https://devcenter.azure.com').Token

Set-LabVariable -Name token -Value $token

#Write-Warning "fetch token complete"

# Convert the request body to JSON
$jsonBody = $requestBody | ConvertTo-Json

# Define the API endpoint
$apiUrl = "https://$tenantId-$devcenterName.$devboxLocation.devcenter.azure.com/projects/$projectName/users/$userObjectId/devboxes/my-build-devbox?api-version=2025-04-01-preview"

#Write-Warning "send request to create dev box"
#Write-Warning "API URL: $apiUrl"

Set-LabVariable -Name apiUrl -Value $apiUrl

$Headers = @{
    'Authorization' = "Bearer $token"
    'x-ms-upn' = $UPN
}

# Send the web request to create the Dev Box
$response = Invoke-RestMethod -Uri $apiUrl -Method Put -Headers $Headers -Body $jsonBody -ContentType "application/json"

#Write-Warning "Request sent"

# Output the response
$response

$true