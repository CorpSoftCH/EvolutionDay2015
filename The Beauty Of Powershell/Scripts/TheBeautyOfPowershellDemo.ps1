<#

The Beauty of Powershell - Demo


#>

break

################################## Nested Pipelines

function Generate-DemoFiles{
    
    1..10 | Foreach-Object{
        
        $path = "C:\Scripts\TestFile"+$_+"_Data.txt"

        $item = New-Item -ItemType "File" -Path $path -Force
        Set-Content -Path $item.FullName -Value "IAmATestValue"
        
    }


}



#Example 1
Get-Childitem -Path "C:\Scripts" | Foreach-Object{
    
        (Get-Content -Path $_.FullName) -replace "TestValue","TestValueRenamed!" | Set-Content -Path $_.Fullname

}

#Example 2

Get-Childitem -Path "C:\Scripts" | Foreach-Object{
    
        (Get-Content -Path $_.FullName) -replace "TestValue","TestValueRenamed!" | Set-Content -Path $_.Fullname -Passthru | Foreach-Object{
            
            Write-Host $_

            $_ -replace "Renamed!","2ndReplace" | Out-Host

        }

}


################################## ATS & ETS Demo

$service = Get-Service -Name Spooler

$service | Get-Member

$service | Add-Member -MemberType ScriptMethod -Name "GetServiceName" -Value {$this.ServiceName}

$cimService = Get-CimInstance -Query "SELECT * FROM Win32_Service WHERE name = 'Spooler'"
$startMode = $cimService.StartMode

$service | Add-Member -MemberType NoteProperty -Name "StartMode" -Value $startMode

#PSObject

$object = New-Object -TypeName PSObject

$object | Add-Member -MemberType NoteProperty -Name "Name" -Value "Raphael Fäh"
$object | Add-Member -MemberType NoteProperty -Name "Beruf" -Value "Consultant"
$object | Add-Member -MemberType NoteProperty -Name "Firma" -Value "Corporate Software AG"
$object | Add-Member -MemberType ScriptMethod -Name "Introduce" -Value {"I am very pleased to introduce $($this.Name) to you. He is a $($this.Beruf), working for $($this.Firma)."}

$object.IntroDuce()

#Access the PSObject on any Powershell Object
$service.PSObject



################################## Dynamic Parameters

#Example 1


Function Get-RestaurantOrderv1{
    
    [CmdletBinding()]
    param(
        
        [int]$quantity,
        [ValidateSet("Starter","MainCourse","Dessert","Softdrink","AlcoholicDrink")]
        [string]$orderType = "Starter",
        [int]$age

    )

    Begin{

        if(($PSBoundParameters.age) -and ($PSBoundParameters.age -lt 18) -and ($PSBoundParameters.orderType -eq "AlcoholicDrink")){
        
            $warning = "We are sorry, but to order alcoholic Drinks, you need to be at least 18"

            Write-Error $warning -ErrorAction Stop
        

        }
    }
    
    Process{

        $order = "Serving $quantity $orderType"

        Write-Host $order

    }

}






Function Get-RestaurantOrderV2{
    
    [CmdletBinding()]
    param(
        
        [int]$quantity,
        [ValidateSet("Starter","MainCourse","Dessert","Softdrink","AlcoholicDrink")]
        [string]$orderType = "Starter"

    )

    DynamicParam {
        if ($orderType -eq "AlcoholicDrink"){

            #create a new ParameterAttribute Object
            $parameterAttribute = New-Object System.Management.Automation.ParameterAttribute
            $parameterAttribute.Position = 3
            $parameterAttribute.Mandatory = $true
            $parameterAttribute.HelpMessage = "Please enter your Age:"
 
            #create an attributecollection object
            $attributeCollection = New-Object -TypeName System.Collections.ObjectModel.Collection[System.Attribute]
 
            #add the attribute to the collection
            $attributeCollection.Add($parameterAttribute)
 
            #add our paramater specifying the attribute collection
            $runtimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter('age', [Int], $attributeCollection)
 
            #expose the name of our parameter
            $paramDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
            $paramDictionary.Add('age', $runtimeParameter)
            return $paramDictionary
        }
    }

    Begin{

        if(($PSBoundParameters.age) -and ($PSBoundParameters.age -lt 18)){
        
            $warning = "We are sorry, but to order alcoholic Drinks, you need to be at least 18"

            Write-Error $warning -ErrorAction Stop
        

        }
    }
    
    Process{

        $order = "Serving $quantity $orderType"

        Write-Host $order

    }

}




################################## Proxy Functions

$metadata = New-Object System.Management.Automation.CommandMetaData (Get-Command Export-CSV)
[System.Management.Automation.ProxyCommand]::Create($metadata) | Clip



function Export-CSV {
<#

.ForwardHelpTargetName Export-Csv
.ForwardHelpCategory Cmdlet

#>
    [CmdletBinding(DefaultParameterSetName='Delimiter', SupportsShouldProcess=$true, ConfirmImpact='Medium')]
    param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [System.Management.Automation.PSObject]
        ${InputObject},

        [Parameter(Mandatory=$true, Position=0)]
        [Alias('PSPath')]
        [System.String]
        ${Path},

        [Switch]
        ${Force},

        [Switch]
        ${NoClobber},

        [ValidateSet('Unicode','UTF7','UTF8','ASCII','UTF32','BigEndianUnicode','Default','OEM')]
        [System.String]
        ${Encoding},

        [Parameter(ParameterSetName='Delimiter', Position=1)]
        [ValidateNotNull()]
        [System.Char]
        ${Delimiter},

        [Parameter(ParameterSetName='UseCulture')]
        [Switch]
        ${UseCulture},

        [Alias('NTI')]
        [Switch]
        ${NoTypeInformation},
        
        [Switch]
        $useDefault)
        

    begin
    {
        try {
            $outBuffer = $null
            if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer))
            {
                $PSBoundParameters['OutBuffer'] = 1
            }
            $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Export-Csv', [System.Management.Automation.CommandTypes]::Cmdlet)

            if ($PSBoundParameters['useDefault']) {
                $PSBoundParameters.Remove('useDefault') | Out-Null
                If ($PSBoundParameters['Delimiter']) { 
                    $PSBoundParameters.Remove('Delimiter') | Out-Null
                }
                If ($PSBoundParameters['Encoding']) { 
                    $PSBoundParameters.Remove('Encoding') | Out-Null
                }
                $scriptCmd = {& $wrappedCmd @PSBoundParameters -Delimiter ";" -NoTypeInformation -Encoding UTF8 -Force}
            } else {
                $scriptCmd = {& $wrappedCmd @PSBoundParameters }
            }        

            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($PSCmdlet)
        } catch {
            throw
        }
    }

    process
    {
        try {
            $steppablePipeline.Process($_)
        } catch {
            throw
        }       
    }

    end
    {
        try {
            $steppablePipeline.End()
        } catch {
            throw
        }
    }
}



#Export-PSSession and Implicit Remoting


$session = New-PSSession -ComputerName ""

Invoke-Command -Session $session -ScriptBlock {Import-Module ActiveDirectory}

Export-PSSession -Session $session -CommandName "*-AD*" -Force -OutputModule "RemoteActiveDirectory"

Remove-PSSession -Session $session

Import-Module RemoteActiveDirectory -Prefix "Remote"

$users = Get-RemoteADUser -Filter "*" -Properties samaccountname,department

foreach($user in $users){

    Set-RemoteADUser -Identity $user.SamAccountName -Department "IT"

}