
$projectName = "myProject"

$UPN = "@{lab.CloudPortalCredential(User1).Username}"
$userObjectId = (Get-AzADUser -UserPrincipalName $UPN).id

Write-Host "User info"
Write-Warning "User Object ID: $userObjectId"
Write-Warning "User UPN: $UPN"

# Set access for the user
# Assign the 'Dev Center Dev Box User' role to the user
az role assignment create `
    --assignee-object-id $userObjectId `
    --assignee-principal-type User `
    --role "DevCenter Dev Box User" `
    --scope "/subscriptions/$subId/resourceGroups/Build-2025/providers/Microsoft.DevCenter/projects/$projectName"
