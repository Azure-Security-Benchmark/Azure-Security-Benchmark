$nsgNAme = "myHdiNsg" # Pre-existing, this is the NSG attached to your HDInsight's subnet

# Get the NSG object. We will inspect the security rules for the use of Service Tags
$nsg = Get-AzNetworkSecurityGroup -Name $nsgNAme

# Use this variable to flag when a Security Rule is found to be using a Service Tag
$nsgIsUsingServiceTags = $false

# Iterate through the Security Rules for your NSG
foreach ($rule in $nsg.SecurityRules) {
    
    # Print the rule to the screen. If the Security Rule is using a Service Tag, flag will be set
    if ($rule.SourceAddressPrefix -match "[a-zA-Z]") {
        $nsgIsUsingServiceTags = $true
        Write-Host "Service Tag Detected for Security Rule '$($rule.Name)' ($($rule.SourceAddressPrefix))" -BackgroundColor Green -ForegroundColor Black
    }

    # Print the rule to the screen.
    else {
        Write-Host "No Service Tag Detected for Security Rule '$($rule.Name)'" 
    }
}

# If the nsgIsUsingServiceTags flag is set to true, print to the screen in green
if ($nsgIsUsingServiceTags) {
    Write-Host "`nNSG '$($nsg.Name)' is using Service Tag(s) in one or more of its Security Rules" -BackgroundColor Green -ForegroundColor Black
}

# If the nsgIsUsingServiceTags flag is set to false, print to the screen in yellow
else {
    Write-Host "`nNSG '$($nsg.Name)' does not appear to be utilizing Service Tags" -BackgroundColor Yellow -ForegroundColor Black
}