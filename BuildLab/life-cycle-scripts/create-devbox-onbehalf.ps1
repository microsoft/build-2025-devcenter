# This is just a testing script in progress to create a dev box on behalf of the lab user.
# Don't need az login and the devcenter extension has already been installed on the vm disk.

# Variables
# Every instance of the lab vm will generate a new subscription ID, which will make the of the dev center name unique.
$subId = '@lab.CloudSubscription.Id'
$rg = '@lab.CloudResourceGroup(ResourceGroup1).Name'
$segment = $subId.SubString(0, 6)
$devCenterName = "build-$segment-dc"

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
    -Scope "/subscriptions/$subId/resourceGroups/$rg/providers/Microsoft.DevCenter/projects/$projectName"


# Define the custom role properties for OnBehalf creation
$customRole = @{
    Name = "Dev-Box-Create-OnBehalf-$devCenterName"
    IsCustom = $true
    Description = "Custom role for creating Dev Boxes on behalf of users in subscription."
    Actions = @(
        "Microsoft.DevCenter/projects/*",
        "Microsoft.Authorization/*/read",
        "Microsoft.Resources/deployments/*",
        "Microsoft.Resources/subscriptions/resourceGroups/read"
    )
    NotActions = @(
        "Microsoft.DevCenter/projects/write",
        "Microsoft.DevCenter/projects/delete"
    )
    DataActions = @(
        "Microsoft.DevCenter/projects/users/devboxes/adminStart/action",
        "Microsoft.DevCenter/projects/users/devboxes/adminStop/action",
        "Microsoft.DevCenter/projects/users/devboxes/adminRead/action",
        "Microsoft.DevCenter/projects/users/devboxes/adminWrite/action",
        "Microsoft.DevCenter/projects/users/devboxes/adminDelete/action",
        "Microsoft.DevCenter/projects/users/devboxes/userStop/action",
        "Microsoft.DevCenter/projects/users/devboxes/userStart/action",
        "Microsoft.DevCenter/projects/users/devboxes/userGetRemoteConnection/action",
        "Microsoft.DevCenter/projects/users/devboxes/userRead/action",
        "Microsoft.DevCenter/projects/users/devboxes/userWrite/action",
        "Microsoft.DevCenter/projects/users/devboxes/userDelete/action",
        "Microsoft.DevCenter/projects/users/devboxes/userActionRead/action",
        "Microsoft.DevCenter/projects/users/devboxes/userActionManage/action",
        "Microsoft.DevCenter/projects/users/devboxes/userCustomize/action",
        "Microsoft.DevCenter/projects/users/devboxes/userCreateOnBehalf/action",
        "Microsoft.DevCenter/projects/users/environments/adminRead/action",
        "Microsoft.DevCenter/projects/users/environments/userWrite/action",
        "Microsoft.DevCenter/projects/users/environments/adminWrite/action",
        "Microsoft.DevCenter/projects/users/environments/userDelete/action",
        "Microsoft.DevCenter/projects/users/environments/adminDelete/action",
        "Microsoft.DevCenter/projects/users/environments/adminAction/action",
        "Microsoft.DevCenter/projects/users/environments/adminActionRead/action",
        "Microsoft.DevCenter/projects/users/environments/adminActionManage/action",
        "Microsoft.DevCenter/projects/users/environments/adminOutputsRead/action"
    )
    AssignableScopes = @(
        "/subscriptions/$subId"
    )
}

# Convert the role definition to a valid PSRoleDefinition object
$roleDefinition = [Microsoft.Azure.Commands.Resources.Models.Authorization.PSRoleDefinition]::new()
$roleDefinition.Name = $customRole.Name
$roleDefinition.IsCustom = $customRole.IsCustom
$roleDefinition.Description = $customRole.Description
$roleDefinition.Actions = $customRole.Actions
$roleDefinition.NotActions = $customRole.NotActions
$roleDefinition.DataActions = $customRole.DataActions
$roleDefinition.AssignableScopes = $customRole.AssignableScopes

$roleDefinition | ConvertTo-Json -Depth 10

# Create the custom role
New-AzRoleDefinition -Role $roleDefinition

# Wait for the custom role definition to propagate
Start-Sleep -Seconds 60

$appObjectId = "69d563db-e4f3-4bd3-be8c-44926ea56a7d" # The object ID of the cloud splice app

# Assign the custom role to the cloud splice app object ID
New-AzRoleAssignment `
    -ObjectId $appObjectId `
    -RoleDefinitionName "Dev-Box-Create-OnBehalf-$devCenterName" `
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