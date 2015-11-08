


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


$siteUrl = "https://evodaydemo.sharepoint.com/sites/MigrationDemoSiteCollection/"
$targetUrl = "https://evodaydemo.sharepoint.com/sites/SharegateMigrationTarget/"

$deltaMigration = $false

if($deltaMigration){
		

	$sub = Get-Subsite -Site $sourceSite | Where-Object {$_.Address.AbsoluteUri -eq "$siteName/"}
			
	$result = Copy-Site -Site $sub -DestinationSite $destinationSite -MappingSettings $mappingSettings -Verbose -copySettings $copySettings -NoNavigation -NoCustomPermissions -NoWorkflows -NoSiteFeatures -NoWebParts -NoCustomizedFormsAndViews -NoNintexWorkflowHistory
			
    $date = Get-Date -Format "yyyyMMdd"
	$reportFullPath = $script:reportPath+"\Report_SiteMigration"+"_"+$date+".xlsx"
	Export-Report -CopyResult $result -Path $reportFullPath
			
		
}
else{
		
	$sub = Get-Subsite -Site $sourceSite | Where-Object {$_.Address.AbsoluteUri -eq "$siteName/"}
			
	$result = Copy-Site -Site $sub -DestinationSite $destinationSite -MappingSettings $mappingSettings -Verbose -copySettings $copySettings
			
    $date = Get-Date -Format "yyyyMMdd"
	$reportFullPath = $script:reportPath+"\Report_SiteMigration"+"_"+$date+".xlsx"
	Export-Report -CopyResult $result -Path $reportFullPath
		
}



