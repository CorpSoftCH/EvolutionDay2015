


Import-Module Sharegate

#Set Variables
$username = 'rfaeh@evodaydemo.onmicrosoft.com'
$passwordString = "kAF!JjK?m@_mR"
$password = ConvertTo-SecureString $passwordString -AsPlainText -Force

$creds = New-Object System.Management.Automation.PSCredential($username,$password)

$sourceCredentials = $creds
$destinationCredentials = $creds

if(-not(Test-Path -Path "C:\SharegateReports")){
    New-Item -ItemType Directory -Path "C:\SharegateReports"
}

$reportPath = "C:\SharegateReports"

$sourceSiteRoot = "https://evodaydemo.sharepoint.com/sites/MigrationDemoSiteCollection"
$targetSiteRoot = "https://evodaydemo.sharepoint.com/sites/SharegateMigrationTarget"

#Connect the Source and Tartget Site
$sourceSite = Connect-Site -Url $sourceSiteRoot -Credential $sourceCredentials
$destinationSite = Connect-Site -Url $targetSiteRoot -Credential $destinationCredentials

$copySettings = New-CopySettings -OnError Skip -OnWarning Continue -OnContentItemExists IncrementalUpdate -OnSiteObjectExists Merge

$mappingSettings = Get-UserAndGroupMapping -SourceSite $sourceSite -DestinationSite $destinationSite
$mappingSettings = Set-UserAndGroupMapping -MappingSettings $mappingSettings -UnresolvedUserOrGroup -Destination "rfaeh@evodaydemo.onmicrosoft.com"

#Get the Source and Target List
$sourceList = Get-List -Name "ContactList" -Site $sourceSite
$destinationList = Get-List -Name "ContactList" -Site $destinationSite

#Copy the Content
$result = Copy-Content -SourceList $sourceList -DestinationList $destinationList -copySettings $copySettings -mappingSettings $mappingSettings -InsaneMode

#Generate a Report
$date = Get-Date -Format "yyyyMMdd"
$reportFullPath = $script:reportPath+"\Report_ItemNumber_"+$number+"_"+$date+".xlsx"
Export-Report -CopyResult $result -Path $reportFullPath
	

	



