
<#
####################################################


Office365 Trial Signup:
https://products.office.com/en-us/business/office-365-enterprise-e3-business-software

Office365 Signing Page:
https://login.microsoftonline.com

Credentials
Email:
rfaeh@evodaydemo.onmicrosoft.com
Password:
kAF!JjK?m@_mR

####################################################
#>

break

#Use SharePoint Online Module
Import-Module "C:\Program Files\SharePoint Online Management Shell\Microsoft.Online.SharePoint.PowerShell\Microsoft.Online.SharePoint.PowerShell.psd1"


$username = 'rfaeh@evodaydemo.onmicrosoft.com'
$passwordString = "kAF!JjK?m@_mR"
$password = ConvertTo-SecureString $passwordString -AsPlainText -Force
$url = "https://evodaydemo-admin.sharepoint.com/"


$credential = New-Object System.Management.Automation.PsCredential($username, $password) 

Connect-SPOService -Url $url -Credential $credential 

$siteCollectionUrl = "https://evodaydemo.sharepoint.com/sites/TestSiteCollection"
$owner = $username
$storageQuota = 100
$resourceQuota = 30
$localeID = 1033

New-SPOSite -Url $siteCollectionUrl -Owner $owner -StorageQuota $storageQuota -LocaleId $localeID -ResourceQuota $resourceQuota

Disconnect-SPOService


#Use CSOM

# Import the required DLL
# Download and install this: http://www.microsoft.com/en-us/download/details.aspx?id=42038
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Publishing.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"

$username = 'rfaeh@evodaydemo.onmicrosoft.com'

$passwordString = "kAF!JjK?m@_mR"

$password = ConvertTo-SecureString $passwordString -AsPlainText -Force

$site = "https://evodaydemo.sharepoint.com"

$context = New-Object Microsoft.SharePoint.Client.ClientContext($site)
$creds = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($username,$password)
$context.Credentials = $creds


#Create SubSite
$wci = New-Object Microsoft.SharePoint.Client.WebCreationInformation

#TeamSite Template
$wci.WebTemplate = "STS#0"

$wci.Description = "SubSite"
$wci.Title = "SubSite"
$wci.Url = "SubSite"
$wci.Language = "1033"
$subWeb = $context.Web.Webs.Add($wci)
$context.ExecuteQuery()

#Create SubSubSite
$wci = New-Object Microsoft.SharePoint.Client.WebCreationInformation
$wci.WebTemplate = "STS#0"
$wci.Description = "SubSubSite"
$wci.Title = "SubSubSite"
$wci.Url = "SubSite/SubSubSite"
$wci.Language = "1033"
$subWeb = $context.Web.Webs.Add($wci)
$context.ExecuteQuery()
