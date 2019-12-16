$nsgNAme  = "myHdiNsg"               # Pre-existing, this is the NSG attached to your HDInsight's subnet
$nwName   = "NetworkWatcher_eastus2" # Pre-existing, Network Watcher for the region HDInsight has been deployed into
$nsg      = Get-AzNetworkSecurityGroup -Name $nsgNAme
$nw       = Get-AzNetworkWatcher -Name $nwName

# Get the Flow Log status for the NSG attached to HDInsight's Subnet
$flowLogStatus_parameters = @{
    NetworkWatcher = $nw
    TargetResourceId = $nsg.Id
}
$flowLogStatus = (Get-AzNetworkWatcherFlowLogStatus @flowLogStatus_parameters).Enabled

# If Flow Logs are enabled, display with a green background
if ($flowLogStatus -eq $true) {
    Write-Host "Flow Logs on NSG '$($nsg.Name)' are Enabled" -BackgroundColor Green -ForegroundColor Black
}

# If Flow Logs are disabled, display with a red background
else {
    Write-Host "Flow Logs on NSG '$($nsg.Name)' are Disabled" -BackgroundColor Red
}