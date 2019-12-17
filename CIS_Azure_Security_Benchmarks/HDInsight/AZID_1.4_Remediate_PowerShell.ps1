$vnetName = "myHdiVnet"         # Pre-existing, this is the name of the Vnet your HDinsight cluster has been deployed into
$rgName   = "my-hdi-rg"         # Pre-existing, this is the resource group the above Vnet is in
$planName = "MyNewDdosProtPlan" # Will be created, this will be the name of your new Ddos Protection Plan
$location = "eastus"            # Location/region the Ddos protection plan will be created in

# Create a Ddos Protection Plan
$plan_parameters = @{
    ResourceGroupName = $rgName
    Name              = $planName
    Location          = $location
}
$ddosProtPlan = New-AzDdosProtectionPlan @plan_parameters

# Get the Vnet object your HDinsight cluster is deployed into that you will apply the protection plan to
$vnet_parameters = @{
    Name          = $vnetName
    ResourceGroup = $rgName
}
$vnet = Get-AzVirtualNetwork @vnet_parameters

# Insert your new Ddos Protection Plan's ID into your HDInsight Vnet
$vnet.DdosProtectionPlan = @{Id = $ddosProtPlan.Id}

# Set the Vnet's Protection Plan enabled property to "True"
$vnet.EnableDdosProtection = $true

# Update your Vnet with the new settings
Set-AzVirtualNetwork -VirtualNetwork $vnet

# Re-instantiate the Vnet object to ensure the Ddos Protection Plan has been applied
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