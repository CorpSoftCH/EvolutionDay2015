
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


# Import the required DLL
# Download and install this: http://www.microsoft.com/en-us/download/details.aspx?id=42038
Import-Module 'C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.UserProfiles.dll'
Import-Module 'C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll'
Import-Module 'C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll'

#Admin Site URL
$site = 'https://evodaydemo-admin.sharepoint.com/' # This needs to be the "admin" site.

#Admin User Principal Name
$admin = 'rfaeh@evodaydemo.onmicrosoft.com'

$passwordString = "kAF!JjK?m@_mR"

#Get Password as secure String
$password = ConvertTo-SecureString $passwordString -AsPlainText -Force 

#Get the Client Context and Bind the Site Collection
$context = New-Object Microsoft.SharePoint.Client.ClientContext($site)

#Authenticate
$credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($admin , $password)
$context.Credentials = $credentials

#Fetch the users in Site Collection
$users = $context.Web.SiteUsers
$context.Load($users)
$context.ExecuteQuery()

#Create an Object [People Manager] to retrieve profile information
$people = New-Object Microsoft.SharePoint.Client.UserProfiles.PeopleManager($context)

ForEach($user in $users){

    $userProfile = $people.GetPropertiesFor($user.LoginName)
    $context.Load($userprofile)
    $context.ExecuteQuery()


    "Working on Account: " + $userprofile.AccountName

    #$people.SetSingleValueProfileProperty($userprofile.AccountName, "AboutMe", "Updated by CSOM")
    #$context.ExecuteQuery()

		
}


