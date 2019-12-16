$nsgNAme  = "myHdiNsg"               # Pre-existing, this is the NSG attached to your HDInsight's subnet
$nwName   = "NetworkWatcher_eastus2" # Pre-existing, Network Watcher for the region HDInsight has been deployed into
$rgName   = "my-hdi-rg"              # Pre-existing, Name of the Resource Group your Flow Log Storage Account lives in
$saName   = "myhdistoragex"          # Pre-existing, Name of the Storage Account to hold your Flow Logs

$nsg = Get-AzNetworkSecurityGroup -Name $nsgName
$nw  = Get-AzNetworkWatcher       -Name $nwName
$sa  = Get-AzStorageAccount       -Name $saName -ResourceGroupName $rgName

# Get the Flow Log status for the NSG attached to HDInsight's Subnet
$flowLogStatus_parameters = @{
    NetworkWatcher   = $nw
    TargetResourceId = $nsg.Id
    EnableFlowLog    = $true   # Set to $false to disable Flow Logs
    StorageAccountId = $sa.Id
}
$flowLogStatus = Set-AzNetworkWatcherConfigFlowLog @flowLogStatus_parameters

# If Flow Logs are enabled, display with a green background
if ($flowLogStatus.Enabled -eq $true) {
    Write-Host "Flow Logs on NSG '$($nsg.Name)' are now Enabled" -BackgroundColor Green -ForegroundColor Black
}

# If Flow Logs are disabled, display with a red background
else {
    Write-Host "Flow Logs on NSG '$($nsg.Name)' are now Disabled" -BackgroundColor Red
}