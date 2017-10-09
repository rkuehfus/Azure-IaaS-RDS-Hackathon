#Make sure to create an Azure Automation Runas Account first
$connectionName = "AzureRunAsConnection"
try
{
    # Get the connection "AzureRunAsConnection "
    $servicePrincipalConnection = Get-AutomationConnection -Name $connectionName         

    "Logging in to Azure..."
    Add-AzureRmAccount `
        -ServicePrincipal `
        -TenantId $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint   $servicePrincipalConnection.CertificateThumbprint 
}
catch {
    if (!$servicePrincipalConnection)
    {
        $ErrorMessage = "Connection $connectionName not found."
        throw $ErrorMessage
    } else{
        Write-Error -Message $_.Exception
        throw $_.Exception
    }
} 


$VMname = '<name'
$rgName = '<ResourceGroupName>'
$subscriptionId = '<SubIDGUID>'
Select-AzureRmSubscription -SubscriptionId $subscriptionId


    $VM = Get-AzureRmVM -Name $VMname -ResourceGroupName $rgName
    $VMStatus = (Get-AzureRmVM -Name $VMname -ResourceGroupName $rgName -Status).Statuses
    Write-Host Hostname $VM.Name Status $VMStatus.DisplayStatus

    if($VMStatus[1].DisplayStatus -eq 'VM running'){
        Write-Host VM is running OK
        Stop-AzureRmVM -ResourceGroupName $rgName -Name $VM.Name -Force
    }
