# Create a Network Security Group rule config for your HDInsight cluster's NSG
$nsgRule_parameters = @{
    Name                     = "HDInsight-Required"
    Description              = "Be sure to tighten this NSG down to allow only trusted sources"
    Protocol                 = "Tcp"
    SourcePortRange          = "*"
    DestinationPortRange     = "443"
    SourceAddressPrefix      = "*"
    DestinationAddressPrefix = "*"
    Access                   = "Allow"
    Priority                 = "110"
    Direction                = "Inbound"
}
$hdNsgRuleConfig = New-AzNetworkSecurityRuleConfig @nsgRule_parameters

# Create a Network Security Group for your HDInsight cluster's subnet
$nsg_parameters = @{
    Name           = "myHdiNsg"
    ResourceGroup  = "my-hdi-rg"
    Location       = "eastus2"
    SecurityRules  = $hdNsgRuleConfig
}
$nsg = New-AzNetworkSecurityGroup @nsg_parameters

# Create a subnet configuration for your HDInsight cluster's Vnet with attached NSG
$subnet_parameters = @{
    Name                   = 'myHdiSubnet'
    AddressPrefix          = "10.0.0.0/24"
    NetworkSecurityGroupId = $nsg.Id
}
$subnet = New-AzVirtualNetworkSubnetConfig @subnet_parameters

# Create a new Vnet for your HDInsight cluster
$vnet_parameters = @{
    Name              = "myHdiVnet"
    ResourceGroupName = "my-hdi-rg"
    Location          = "eastus2"
    AddressPrefix     = "10.0.0.0/16"
    Subnet            = $subnet
}
$vnet = New-AzVirtualNetwork @vnet_parameters

# Define parameters for new HDInsight cluster
$clusterName        = "myhdicluster" # Will be created
$clusterSize        = 1
$clusterType        = "Hadoop"
$location           = "eastus2"
$osType             = "Linux"
$resourceGroupName  = "my-hdi-rg"     # Pre-existing
$storageAccountName = "myhdistoragex" # Pre-existing
$storageAccountKey  = (Get-AzStorageAccountKey -ResourceGroupName $resourceGroupName -Name $storageAccountName)[0].Value
$httpCredential     = (Get-Credential -Message "Enter new HTTP Credentials" -UserName "admin")
$sshCredential      = (Get-Credential -Message "Enter new SSH Credentials" -UserName "sshuser")
$defStorageAccount  = "$($storageAccountName).blob.core.windows.net"

$HDIcluster_parameters = @{
    ClusterName               = $clusterName
    ClusterSizeInNodes        = $clusterSize
    ClusterType               = $clusterType
    Location                  = $location
    OSType                    = $osType
    ResourceGroupName         = $resourceGroupName
    HttpCredential            = $httpCredential
    SshCredential             = $sshCredential
    DefaultStorageAccountName = $defStorageAccount
    DefaultStorageAccountKey  = $storageAccountKey
    VirtualNetworkId          = $vnet.Id
    SubnetName                = $vnet.Subnets[0].Id
}

# Create new HDInsight cluster (This may take >10 minutes)
New-AzHDInsightCluster @HDIcluster_parameters