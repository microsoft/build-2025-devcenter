$customRole = @{
    Name = "Test-Create-OnBehalf"
    IsCustom = $true
    Description = "Custom role for managing Dev Boxes"
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
        "/subscriptions/$subId/resourceGroups/$rg"
    )
}

# Convert the role definition to JSON
$roleDefinition = $customRole | ConvertTo-Json -Depth 10

#Set-LabVariable -Name customRoleDef -Value $roleDefinition

# Create the custom role
New-AzRoleDefinition -InputObject $roleDefinition


$role = [Microsoft.Azure.Commands.Resources.Models.Authorization.PSRoleDefinition]::new()
$role.Name = 'Create-OnBehalf'
$role.Description = 'Custom role for managing Dev Boxes'
$role.IsCustom = $true

$perms = 'Microsoft.DevCenter/projects/users/devboxes/adminStart/action'
$perms += 'Microsoft.DevCenter/projects/users/devboxes/adminStop/action'
$perms += 'Microsoft.DevCenter/projects/users/devboxes/adminRead/action'
$perms += 'Microsoft.DevCenter/projects/users/devboxes/adminWrite/action'
$perms += 'Microsoft.DevCenter/projects/users/devboxes/adminDelete/action'
$perms += 'Microsoft.DevCenter/projects/users/devboxes/userStop/action'
$perms += 'Microsoft.DevCenter/projects/users/devboxes/userStart/action'
$perms += 'Microsoft.DevCenter/projects/users/devboxes/userGetRemoteConnection/action'
$perms += 'Microsoft.DevCenter/projects/users/devboxes/userRead/action'
$perms += 'Microsoft.DevCenter/projects/users/devboxes/userWrite/action'
$perms += 'Microsoft.DevCenter/projects/users/devboxes/userDelete/action'
$perms += 'Microsoft.DevCenter/projects/users/devboxes/userActionRead/action'
$perms += 'Microsoft.DevCenter/projects/users/devboxes/userActionManage/action'
$perms += 'Microsoft.DevCenter/projects/users/devboxes/userCustomize/action'
$perms += 'Microsoft.DevCenter/projects/users/devboxes/userCreateOnBehalf/action'
$perms += 'Microsoft.DevCenter/projects/users/environments/adminRead/action'
$perms += 'Microsoft.DevCenter/projects/users/environments/userWrite/action'
$perms += 'Microsoft.DevCenter/projects/users/environments/adminWrite/action'
$perms += 'Microsoft.DevCenter/projects/users/environments/userDelete/action'
$perms += 'Microsoft.DevCenter/projects/users/environments/adminDelete/action'
$perms += 'Microsoft.DevCenter/projects/users/environments/adminAction/action'
$perms += 'Microsoft.DevCenter/projects/users/environments/adminActionRead/action'
$perms += 'Microsoft.DevCenter/projects/users/environments/adminActionManage/action'
$perms += 'Microsoft.DevCenter/projects/users/environments/adminOutputsRead/action'

$role.DataActions = $perms

$actionRoles = 'Microsoft.DevCenter/projects/*', 'Microsoft.Authorization/*/read', 'Microsoft.Resources/deployments/*', 'Microsoft.Resources/subscriptions/resourceGroups/read'

$role.Actions = $actionRoles

$notActionRoles = 'Microsoft.DevCenter/projects/write', 'Microsoft.DevCenter/projects/delete'
$role.NotActions = $notActionRoles

$role.AssignableScopes = $subId
New-AzRoleDefinition -Role $role


# OTHER STUFFF

# This is just a testing script in progress to create a dev box on behalf of the lab user.
# Don't need az login and the devcenter extension has already been installed on the vm disk.

# Variables
# Every instance of the lab vm will generate a new subscription ID, which will make the of the dev center name unique.
$subId = '@lab.CloudSubscription.Id'
$rg = '@lab.CloudResourceGroup(ResourceGroup1).Name'
$devCenterName = "build-$($subId.SubString(0,6))-dc"

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

#New-AzRoleAssignment `
#    -ObjectId $userObjectId `
#    -RoleDefinitionName "DevCenter Dev Box User" `
#    -Scope "/subscriptions/$subId/resourceGroups/$rg/providers/Microsoft.DevCenter/projects/$projectName"

# TEMP TESTING

$role = [Microsoft.Azure.Commands.Resources.Models.Authorization.PSRoleDefinition]::new()
$role.Name = 'Dev Box Create OnBehalf'
$role.Description = 'Custom role for managing Dev Boxes'
$role.IsCustom = $true

$perms = 'Microsoft.DevCenter/projects/users/devboxes/adminStart/action'
$perms += 'Microsoft.DevCenter/projects/users/devboxes/adminStop/action'
$perms += 'Microsoft.DevCenter/projects/users/devboxes/adminRead/action'
$perms += 'Microsoft.DevCenter/projects/users/devboxes/adminWrite/action'
$perms += 'Microsoft.DevCenter/projects/users/devboxes/adminDelete/action'
$perms += 'Microsoft.DevCenter/projects/users/devboxes/userStop/action'
$perms += 'Microsoft.DevCenter/projects/users/devboxes/userStart/action'
$perms += 'Microsoft.DevCenter/projects/users/devboxes/userGetRemoteConnection/action'
$perms += 'Microsoft.DevCenter/projects/users/devboxes/userRead/action'
$perms += 'Microsoft.DevCenter/projects/users/devboxes/userWrite/action'
$perms += 'Microsoft.DevCenter/projects/users/devboxes/userDelete/action'
$perms += 'Microsoft.DevCenter/projects/users/devboxes/userActionRead/action'
$perms += 'Microsoft.DevCenter/projects/users/devboxes/userActionManage/action'
$perms += 'Microsoft.DevCenter/projects/users/devboxes/userCustomize/action'
$perms += 'Microsoft.DevCenter/projects/users/devboxes/userCreateOnBehalf/action'
$perms += 'Microsoft.DevCenter/projects/users/environments/adminRead/action'
$perms += 'Microsoft.DevCenter/projects/users/environments/userWrite/action'
$perms += 'Microsoft.DevCenter/projects/users/environments/adminWrite/action'
$perms += 'Microsoft.DevCenter/projects/users/environments/userDelete/action'
$perms += 'Microsoft.DevCenter/projects/users/environments/adminDelete/action'
$perms += 'Microsoft.DevCenter/projects/users/environments/adminAction/action'
$perms += 'Microsoft.DevCenter/projects/users/environments/adminActionRead/action'
$perms += 'Microsoft.DevCenter/projects/users/environments/adminActionManage/action'
$perms += 'Microsoft.DevCenter/projects/users/environments/adminOutputsRead/action'

$role.DataActions = $perms

$actionRoles = 'Microsoft.DevCenter/projects/*', 'Microsoft.Authorization/*/read', 'Microsoft.Resources/deployments/*', 'Microsoft.Resources/subscriptions/resourceGroups/read'

$role.Actions = $actionRoles

$notActionRoles = 'Microsoft.DevCenter/projects/write', 'Microsoft.DevCenter/projects/delete'
$role.NotActions = $notActionRoles

$role.AssignableScopes = "/subscriptions/$subId/resourceGroups/$rg"
New-AzRoleDefinition -Role $role

Start-Sleep -Seconds 5

New-AzRoleAssignment `
    -ObjectId $userObjectId `
    -RoleDefinitionName "Dev Box Create OnBehalf" `
    -Scope "/subscriptions/$subId/resourceGroups/$rg/providers/Microsoft.DevCenter/projects/$projectName"

# TEMP TESTING

$check1 = "assigned custom role"

Set-LabVariable -Name AssignRole -Value $check1

#Write-Host "Done assigning role to user"

Start-Sleep -Seconds 10 # wait for the role assignment to propagate

#Write-Host "Attempting to create dev box on behalf of the user"

# Send request to create dev box
$tenantId = "4cfe372a-37a4-44f8-91b2-5faf34253c62" # This is the tenat ID of the cloudslice-app
$devboxLocation = 'eastasia' #"@lab.CloudResourceTemplate(MainResourcesSetUp).Parameters[location]" 

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