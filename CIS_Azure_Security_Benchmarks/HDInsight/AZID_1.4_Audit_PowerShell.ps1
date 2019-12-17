$vnetName = "myHdiVnet" # Pre-existing, this is the name of the Vnet your HDinsight has been deployed into
$rgName   = "my-hdi-rg" # Pre-existing, this is the resource group the above Vnet is in

# Get the Vnet object your HDinsight cluster is deployed into
$vnet_parameters = @{
    Name          = $vnetName
    ResourceGroup = $rgName
}
$vnet = Get-AzVirtualNetwork @vnet_parameters


# If DDOS protection plan exists on the Vnet, display with a green background
if ($vnet.DdosProtectionPlan -ne $null) {

    # Get the name of the Ddos Protection Plan in use
    $ddosProtectionPlanName = (Get-AzResource -ResourceId $vnet.DdosProtectionPlan.Id).Name
    Write-Host "Ddos Protection Plan '$($ddosProtectionPlanName)' is Enabled for Vnet '$($vnet.Name)'" -BackgroundColor Green -ForegroundColor Black
}

# If DDOS protection plan does not exist on the Vnet, display with a red background
else {
    Write-Host "Ddos Protection Plan is not Enabled for Vnet '$($vnet.Name)'" -BackgroundColor Red
}