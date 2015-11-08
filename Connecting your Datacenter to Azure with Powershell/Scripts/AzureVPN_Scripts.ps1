
<#
####################################################

#Script to Create a Connection to Azure through VPN

Hotmail Signup:
https://signup.live.com/
Azure Signup:
https://azure.microsoft.com/


AzureVPN-RRAS: 	192.168.0.201
AzureVPN-FS:	192.168.0.202
AzureVPN-DC:	192.168.0.200

Credentials
Email:
xxx@hotmail.com
Password:
12345

####################################################
#>

break

#Get Azure Module
Import-Module "Azure"


#Add Azure Tenant
Add-AzureAccount


#List all the Subscriptions in the Tenant
Get-AzureSubscription


#Get the current VNET Config on your selected Subscription
Get-AzureVNetConfig

#Set the VNET Config to what the XML File contains
Set-AzureVNetConfig -ConfigurationPath "C:\Source\AzureVirtualNetworkConfig.xml"

#Crate a VPN Gateway for the VNET
New-AzureVNetGateway –VNetName "ACME_DC_VNET" -GatewayType "DynamicRouting"


#Create Azure Storage Account
New-AzureStorageAccount -StorageAccountName "digievdaystorage" -Label "digievdaystorage" -Location "North Europe"

#Get Subscription and Storage Account Name
$storageAccountName = (Get-AzureStorageAccount).StorageAccountName
$subscriptionName = (Get-AzureSubscription).SubscriptionName

#Select Storage Account
Set-AzureSubscription -SubscriptionName $subscriptionName -CurrentStorageAccountName $storageAccountName

#Create two new Cloud Serivces
New-AzureService -ServiceName "azureACMEDC01" -Location "North Europe" -Label "azureACMEDC01"
New-AzureService -ServiceName "azureACMEFS01" -Location "North Europe" -Label "azureACMEFS01"

#Get a Server 2012 R2 Image
$image = Get-AzureVMImage | where-Object{$_.Label -eq "Windows Server 2012 R2 Datacenter, August 2015"} | Select-Object -Property ImageName

#Name the first VM
$vmname1="azureACMEDC01"

#Set the VM Size
$vmsize="Basic_A1"

#Build together the first VM and add a Local Admin Account
$vm1=New-AzureVMConfig -Name $vmname1 -InstanceSize $vmsize -ImageName $image.ImageName
$cred=Get-Credential -Message "Type the name and password of the local administrator account."
$vm1 | Add-AzureProvisioningConfig -Windows -AdminUsername $cred.GetNetworkCredential().Username -Password $cred.GetNetworkCredential().Password

#Set the first VM a Subnet and a Static IP
$vm1 | Set-AzureSubnet -SubnetNames "ACME_DC_Subnet"
$vm1 | Set-AzureStaticVNetIP -IPAddress "10.0.0.4"

#Add the first VM a Data Disk
$disksize=10
$disklabel="DataDisk"
$hcaching="None"
$vm1 | Add-AzureDataDisk -CreateNew -DiskSizeInGB $disksize -DiskLabel $disklabel -HostCaching $hcaching -LUN 1

#Create the first VM
New-AzureVM –ServiceName "azureACMEDC01" -VMs $vm1 -VNetName "ACME_DC_VNET"

#Name the second VM
$vmname2="azureACMEFS01"

#Build together the second VM and add a local Admin Account
$vm2=New-AzureVMConfig -Name $vmname2 -InstanceSize $vmsize -ImageName $image.ImageName
$vm2 | Add-AzureProvisioningConfig -Windows -AdminUsername $cred.GetNetworkCredential().Username -Password $cred.GetNetworkCredential().Password

#Set the second VM a Subnet and a Static IP
$vm2 | Set-AzureSubnet -SubnetNames "ACME_DC_Subnet"
$vm2 | Set-AzureStaticVNetIP -IPAddress "10.0.0.5"

#Create the second VM
New-AzureVM –ServiceName "azureACMEFS01" -VMs $vm2 -VNetName "ACME_DC_VNET"

##############IN VM CONFIGURATION VIA RDP##############

#Configure Cloud VM: Disable Firewall
Get-NetFirewallProfile | Set-NetFirewallProfile -Enabled 0

#Configure Cloud VM: Enable RDP
(Get-WmiObject -Class "Win32_TerminalServiceSetting" -Namespace root\cimv2\terminalservices).SetAllowTsConnections(1)
(Get-WmiObject -class "Win32_TSGeneralSetting" -Namespace root\cimv2\terminalservices -Filter "TerminalName='RDP-tcp'").SetUserAuthenticationRequired(0)

#Configure Cloud VM: Enable PSRemoting
Enable-PSRemoting -Force

#Configure Cloud VM: Set DNS Suffix Search List
Set-DNSClientGlobalSetting -SuffixSearchList "demo.local"

##############IN VM CONFIGURATION VIA RDP##############


#Check the Status of the Gateway
Get-AzureVNetGateway -VNetName "ACME_DC_VNET"

#Connect the Azure VNet to the LocalNetwork
Set-AzureVNetGateway -Connect –LocalNetworkSiteName "ACME_LocalNetwork" –VNetName "ACME_DC_VNET"

#Use Device Configuration Script from Azure Management Portal

#Install AD Binaries and Add Domain Controller to Domain

#Install DFS Replication and Namespace and add Replication and Namespace
















