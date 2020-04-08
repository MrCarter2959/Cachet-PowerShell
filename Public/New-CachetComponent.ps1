<#
    .SYNOPSIS
    Creates New Cachet Components

    .DESCRIPTION
    Allows Component Creation through Cachet REST API

    .PARAMETER CachetServer
    Specifies Cachet Server URL, enter as 'site-name.domain.org'

    .PARAMETER APIToken
    Specifies API Token

    .PARAMETER ComponentName
    Specifies Component Name to be created

    .PARAMETER ComponentDescription
    Specifies Component Description for new Component

    .PARAMETER ComponentStatus
    Specifies Newly Created Component Status, Converted into Numerics by Function

    .PARAMETER ComputerGroupID
    Specifies which group the Component should be a part of

    .PARAMETER ComponentEnabled
    Specifies if the Component should be Enabled/Disable, Converted into Numerics By Function

    .EXAMPLE
    New-CachetComponent -CachetServer 'URL.domain.org' -APIToken "1111111111111" `
    -ComponentName 'test' -ComponentDescription 'some description' `
    -ComponentStatus Operational

    .EXAMPLE
     New-CachetComponent -CachetServer 'URL.domain.org' -APIToken "1111111111111" `
    -ComponentName 'test' -ComponentDescription 'some description' `
    -ComponentStatus Operational -ComponentGroupID 1
     
    .EXAMPLE
     New-CachetComponent -CachetServer 'URL.domain.org' -APIToken "1111111111111" 1
     -ComponentName 'test' -ComponentDescription 'some description' `
     -ComponentStatus Operational -ComponentGroupID 1 -ComponentEnabled True
#>

Function New-CachetComponent {

    Param(
        [parameter(mandatory = $true)]
        [string]$CachetServer,
        [string]$APIToken,
        [string]$ComponentName,
        [string]$ComponentDescription,
        [ValidateSet('Operational','PerformanceIssues','PartialOutage','MajorOutage')]
        $ComponentStatus,
        [parameter(mandatory = $false)]
        [int]$ComponentGroupID,
        [ValidateSet('True','False')]
        $ComponentEnabled
    )
    $cStatus = Get-CachetStatusId -StatusName $ComponentStatus

    $cachetValues = @{
            name = $ComponentName;
            description = $ComponentDescription;
            status = $cStatus;
        }

    If ($ComponentGroupID) {
        Write-Verbose 'Adding GroupID To Values'
        $cachetValues.group_id = $ComponentGroupID
    }

    If ($ComponentEnabled) {
        Write-Verbose 'Adding Enabled To Values'
            $cEnabled = Get-CachetStatusId -StatusName $ComponentEnabled
            $cachetValues.enabled = $cEnabled
    }
    
    $cachetBody = $cachetValues | ConvertTo-Json;

    $cachetParameters = @{
            Uri    =  "https://$CachetServer/api/v1/components"
            Method =  'post'
            Body   =  $cachetBody
            APIToken  =  $APIToken
          }

 Try {
        $cachetResult = Invoke-CachetRequest @cachetParameters
    }
    Catch {
        $cachetErrors = $_.Exception.Message
        If ($cachetErrors)
            {
                Write-Warning $cachetErrors -ErrorAction Stop
            }
    }
    $cachetResult.data
}
