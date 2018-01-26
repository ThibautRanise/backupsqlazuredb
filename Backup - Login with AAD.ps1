$subcriptionId = ""
$resourceGroupName = ""

#Sql server and target database
$ServerName = ""
$DatabaseName = ""

#target storage informations
$StorageKeytype = ""
$StorageKey = ""
$storageUriTarget = ""

#sql credentials
$pwdClear = ""
$userName = ""
$pwd = ConvertTo-SecureString $pwdClear -AsPlainText -Force
$creds = New-Object System.Management.Automation.PSCredential ($userName, $pwd)

#Backup naming logic
$bacpactName = "{0:yyyy-MM-dd}.bacpac" -f (get-date)
$uriTarget = $storageUriTarget + '/' + $DatabaseName + '-' + $bacpactName

#Azure credentials
$password = ""
$tenantId = ""
$servicePrincipalId = ""
$secpasswd = ConvertTo-SecureString $password -AsPlainText -Force
$mycreds = New-Object System.Management.Automation.PSCredential ($servicePrincipalId, $secpasswd)

Login-AzureRmAccount -ServicePrincipal -TenantId $tenantId -Credential $mycreds

$exportRequest = New-AzureRmSqlDatabaseExport -ResourceGroupName $ResourceGroupName -ServerName $ServerName -DatabaseName $DatabaseName -StorageKeytype $StorageKeytype -StorageKey $StorageKey -StorageUri $uriTarget -AdministratorLogin $creds.UserName -AdministratorLoginPassword $creds.Password

while ($exportRequest.Status -eq "InProgress")
{
   $exportRequest = Get-AzureRmSqlDatabaseImportExportStatus -OperationStatusLink $exportRequest.OperationStatusLink
   [Console]::Write(" Export in progress..")
   Start-Sleep -s 10
}

if ($exportRequest.Status -eq "Succeeded")
{
   [Console]::Write(" Export done")
}