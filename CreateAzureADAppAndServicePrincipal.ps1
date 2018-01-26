# Service principal role
$role = "owner"

# Azure AD app configuration
$uniqueIdentifier = [guid]::NewGuid()
$appDisplayName = [String]::Format("app.{0}.{1}", $env:USERNAME, [guid]::NewGuid())
$appHomePage = [String]::Format("http://{0}", $appDisplayName)
$AppUris = $appHomePage
$password = ""
$subsciptionId = ""

Login-AzureRmAccount -SubscriptionId $subsciptionId

$tenantId = (Get-AzureRmSubscription -SubscriptionId $subId).TenantId

#Create the Azure Ad app
$azureAdApp = New-AzureRmADApplication -DisplayName $appDisplayName -HomePage $appHomePage -IdentifierUris $AppUris -Password $password
$azureAdAppId = $azureAdApp.ApplicationId

#Define a service principal on the app
$sp = New-AzureRmADServicePrincipal -ApplicationId $azureAdAppId

#Assign a role to the service principal
New-AzureRmRoleAssignment -RoleDefinitionName $role -ServicePrincipalName $sp.ServicePrincipalNames[0]

Write-Output "Service principal Id: $azureAdAppId"
Write-Output "Azure tenant Id: $tenantId"
Write-Output "App password : $password"