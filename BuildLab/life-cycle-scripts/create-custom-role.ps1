
# Lab Set Up:  
# Language	PowerShell
# Blocking	No
# Delay	120 Seconds
# Timeout	15 Minutes
# Retries	0
# Error Action	Notify User

$subId = '@lab.CloudSubscription.Id'
$segment = $subId.SubString(0, 6)
$devCenterName = "build-$segment-dc"
$roleName = "Dev Box Create OnBehalf-$devCenterName"

# Define the custom role properties for OnBehalf creation
$customRole = @{
    Name = $roleName
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