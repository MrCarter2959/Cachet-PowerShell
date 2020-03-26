<#
    .SYNOPSIS
    Updates Cachet Components

    .DESCRIPTION
    Allows Component Updates through Cachet REST API

    .PARAMETER CachetServer
    Specifies Cachet Server URL, enter as 'site-name.domain.org'

    .PARAMETER APIToken
    Specifies API Token

    .PARAMETER ComponentID
    Specifies ComponentID to be update

    .PARAMETER ComponentName
    Specifies Component Name for to be updated

    .PARAMETER ComponentLink
    Specifies Component link to be updated

    .PARAMETER ComputerOrder
    Specifies Component Update Order

    .PARAMETER ComponentGroupID
    Specifies ComponentGroupID to be Updated / Inserted to
    
    .PARAMETER ComponentNamed
    Specifies ComponentEnabled Status to be updated

    .EXAMPLE
    Update-CachetComponent -CachetServer 'site-name.domain.org' -APIToken "1111111111111" `
    -ComponentID 10 -ComponentName "Exchange OnPrem" -ComponentStatus MajorOutage -ComponentLink "https://exchange.site.domain" `
    -ComponentGroupID 1 -ComponentEnabled true -Verbose
#>
Function Update-CachetComponent {

 param (
        [parameter(mandatory = $true)]
        [string]$CachetServer,
        [string]$APIToken,
        [int]$ComponentID,
        [parameter(mandatory = $false)]
        [string]$ComponentName,
        [ValidateSet('Operational','PerformanceIssues','PartialOutage','MajorOutage')]
        $ComponentStatus,
        [string]$ComponentLink,
        [int]$ComponentOrder,
        [int]$ComponentGroupID,
        [ValidateSet('True','False')]
        [string]$ComponentEnabled
    )

    $cachetValues = @{
            name = $ComponentName;
        }

    If ($ComponentStatus)
        {
            $cStatus = Get-CachetStatusId -StatusName $ComponentStatus
            $cachetValues.Status = $cStatus;
        }
    If ($ComponentLink)
        {
            $cachetValues.link = $ComponentLink;
        }
    If ($ComponentOrder)
        {
            $cachetValues.order = $ComponentOrder;
        }
    If ($ComponentGroupID)
        {
            $cachetValues.group_id = $ComponentGroupID;
        }
    If ($ComponentEnabled)
        {
            $cEnabled = Get-CachetStatusId -StatusName $ComponentEnabled
            $cachetValues.enabled = $cEnabled;
        }

    $cachetBody = $cachetValues | ConvertTo-Json;

    $cachetParameters = @{
        URi       = "https://$CachetServer/api/v1/components/$ComponentID"
        Method    =  'put'
        Body      =  $cachetBody
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

    $cachetResult.Data
}