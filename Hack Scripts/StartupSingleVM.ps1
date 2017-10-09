#Update TagName and TagValue for your environment
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


$VMname = '<name>'
$rgName = '<ResourceGroup>'
$subscriptionId = '<SubIDGUID>'
Select-AzureRmSubscription -SubscriptionId $subscriptionId

    #Update VMname
    $VM = Get-AzureRmVM -Name $VMname -ResourceGroupName $rgName
    $VMStatus = (Get-AzureRmVM -Name $VMname -ResourceGroupName $rgName -Status).Statuses
    Write-Host Hostname $VM.Name Status $VMStatus.DisplayStatus[1]

    if($VMStatus[1].DisplayStatus -eq 'VM deallocated'){
        Write-Host VM deallocated
        Start-AzureRmVM -ResourceGroupName $rgName -Name $VM.Name
    } 