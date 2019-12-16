# Get the Azure HDInsight clusters associated with the current subscription
$HDIclusters = Get-AzHDInsightCluster

# If clusters exist, iterate through them and check for Vnet association
if ($HDIclusters -ne $null) {
    foreach ($cluster in ($HDIclusters)) {
        $clusterObject = Get-AzResource -ResourceId $cluster.Id

        # Check if the current cluster is not associated with a Vnet
        if ($clusterObject.Properties.computeProfile.roles[0].virtualNetworkProfile -eq $null) {
           
            # Clusters not associated with a Vnet will be displayed with a green background
            Write-Host "Cluster '$($cluster.Name)' is not secured within a Vnet." -BackgroundColor Red
        }
        else {
            
            # Clusters associated with a Vnet will be displayed with a green background
            Write-Host "Cluster '$($cluster.Name)' has been secured within a Vnet." -BackgroundColor Green -ForegroundColor Black
        }
    }
}
else {
    
    # If there are no HDInsight clusters within the current subscription, notify user
    Write-Host "No HDInsight clsuters exist on current subscription." -BackgroundColor Yellow -ForegroundColor Black
}