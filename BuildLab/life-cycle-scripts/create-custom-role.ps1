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
        "/subscriptions/3de261df-f2d8-4c00-a0ee-a0be30f1e48e"
    )
}

# Convert the role definition to JSON
$roleDefinition = $customRole | ConvertTo-Json -Depth 10

$roleDefinition

# Create the custom role
New-AzRoleDefinition -InputObject $roleDefinition



#ATTEMPT USING POWERSHELL AZ MODULES

Write-Host "TRIAL 2...."

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

$subId = '3de261df-f2d8-4c00-a0ee-a0be30f1e48e'
$role.AssignableScopes = "/subscriptions/$subId"

$role

New-AzRoleDefinition -Role $role


