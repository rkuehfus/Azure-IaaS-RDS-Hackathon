#Sample code snippits for tagging VMs in Azure

$rgName = '<ResourceGroupName>'
$subscriptionId = '<SubIDGUID>'

Login-AzureRmAccount

Select-AzureRmSubscription -SubscriptionId $subscriptionId

$groups = Get-AzureRmResourceGroup -Name $rgName

#Tag all resources in a resource group
foreach ($g in $groups) 
{
    Find-AzureRmResource -ResourceGroupNameEquals $g.ResourceGroupName | ForEach-Object {Set-AzureRmResource -ResourceId $_.ResourceId -Tag @{ App="RDS"; Environment="Demo"; TimeZone="EST"; StartTime="8:00"; EndTime="18:00" } -Force } 
}



#use this command to set the tags on a single VM
#Get-AzureRmResource -ResourceGroupName $g.ResourceGroupName -ResourceName <VMname> -ResourceType Microsoft.Compute/virtualMachines | Set-AzureRmResource -Tag @{ App="RDS"; Environment="Demo"; TimeZone="EST"; StartTime="8:00"; EndTime="18:00" } -Force
