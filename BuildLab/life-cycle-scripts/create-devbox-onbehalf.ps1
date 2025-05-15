
# Lab Set Up: 
# Execute Script in Cloud Platform
# Language	PowerShell
# Blocking	Yes
# Delay	5 Seconds
# Timeout	10 Minutes
# Retries	0
# Error Action	Notify User


# Variables
# Every instance of the lab vm will generate a new subscription ID, which will make the of the dev center name unique.
$subId = '@lab.CloudSubscription.Id'
$rg = '@lab.CloudResourceGroup(ResourceGroup1).Name'
$segment = $subId.SubString(0, 6)
$devCenterName = "build-$segment-dc"
$roleName = "Dev Box Create OnBehalf-$devCenterName"

# Create a new dev box
$projectName = "myProject"
$poolName = "basic-image-pool"

# Get the UPN (User Principal Name) of the user
$UPN = '@lab.CloudPortalCredential(User1).Username'
$userObjectId = (Get-AzADUser -UserPrincipalName $UPN).Id

Set-LabVariable -Name ObjectId -Value $userObjectId

# Set access for the user
# Assign the 'Dev Center Dev Box User' role to the user

New-AzRoleAssignment `
    -ObjectId $userObjectId `
    -RoleDefinitionName "DevCenter Dev Box User" `
    -Scope "/subscriptions/$subId"

New-AzRoleAssignment `
    -ObjectId $userObjectId `
    -RoleDefinitionName "Reader" `
    -Scope "/subscriptions/$subId"

#New-AzRoleAssignment `
#    -ObjectId $userObjectId `
#    -RoleDefinitionName "DevCenter Dev Box User" `
#    -Scope "/subscriptions/$subId/resourceGroups/$rg/providers/Microsoft.DevCenter/projects/$projectName"

# Check for the role definition with timeout
$startTime = Get-Date
$timeout = (Get-Date).AddMinutes(5)
$roleFound = $false
$retryIntervalSeconds = 10
$attempt = 1

Write-Host "Waiting for role definition to propagate (timeout: 5 minutes)..."

while ((Get-Date) -lt $timeout -and -not $roleFound) {
    Write-Host "Attempt $($attempt) :: Checking for role '$roleName'..." -ForegroundColor Yellow
    $definition = Get-AzRoleDefinition -Name $roleName -ErrorAction SilentlyContinue
    
    if ($definition) {
        $roleFound = $true
        $elapsedTime = (Get-Date) - $startTime
        Write-Host "Role definition found after $([math]::Round($elapsedTime.TotalSeconds)) seconds!" -ForegroundColor Green
        Write-Host "Role Details:"
        $definition | Format-List
    } else {
        Write-Host "Role not found yet. Waiting $retryIntervalSeconds seconds before next check..."
        Start-Sleep -Seconds $retryIntervalSeconds
        $attempt++
    }
}

If (-not $roleFound) {
    Write-Error "Role definition not found within the timeout period." -ForegroundColor Red
    exit 1
}

Write-Host "Role Definition ID: $($definition.Id)" -ForegroundColor Green
$appObjectId = "69d563db-e4f3-4bd3-be8c-44926ea56a7d" # The object ID of the cloud splice app

# Assign the custom role to the cloud splice app object ID
New-AzRoleAssignment `
    -ObjectId $appObjectId `
    -RoleDefinitionId $definition.Id `
    -Scope "/subscriptions/$subId"

$check1 = "Assigned custom role"

Set-LabVariable -Name AssignRole -Value $check1

# Wait for the role assignment to propagate
Start-Sleep -Seconds 10 

# Send request to create dev box
$tenantId = "4cfe372a-37a4-44f8-91b2-5faf34253c62" # This is the tenat ID of the cloudslice-app
$devboxLocation = "@lab.CloudResourceTemplate(MainResourcesSetUp).Parameters[location]"  # might need to change this to 'eastasia'

# Create the request body
$requestBody = @{
    poolName = $poolName
    osType = "Windows"
}


# Get the Azure AD token
$token = (Get-AzAccessToken -ResourceUrl 'https://devcenter.azure.com').Token

Set-LabVariable -Name token -Value $token


# Convert the request body to JSON
$jsonBody = $requestBody | ConvertTo-Json

# Define the API endpoint
$apiUrl = "https://$tenantId-$devcenterName.$devboxLocation.devcenter.azure.com/projects/$projectName/users/$userObjectId/devboxes/my-build-devbox?api-version=2025-04-01-preview"


Set-LabVariable -Name apiUrl -Value $apiUrl

$Headers = @{
    'Authorization' = "Bearer $token"
    'x-ms-upn' = $UPN
}

# Send the web request to create the Dev Box
$response = Invoke-RestMethod -Uri $apiUrl -Method Put -Headers $Headers -Body $jsonBody -ContentType "application/json"


# Output the response
$response

$true