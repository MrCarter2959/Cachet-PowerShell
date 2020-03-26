<#
    .SYNOPSIS
    Creates New Cachet Incident Updates

    .DESCRIPTION
    Allows Cachet Incident Updates to be Created through REST API

    .PARAMETER CachetServer
    Specifies Cachet Server URL, enter as 'site-name.domain.org'

    .PARAMETER APIToken
    Specifies API Token

    .PARAMETER CachetIncidentID
    Specifies Incident ID to put a Update into

    .PARAMETER IncidentStatus
    Specifies IncidentStatus which is then converted in numerics via Function

    .PARAMETER IncidentMessage
    Specified a Message to be put on the Incident Update

    .EXAMPLE
    New-CachetIncidentUpdate -CachetServer 'site-name.domain.org' -CachetIncidentID 25 `
    -IncidentStatus Watching -IncidentMessage "Exchange Servers Coming online in 5 Minutes" `
    -APIToken "1111111111111" -Verbose
#>

Function New-CachetIncidentUpdate {
    
    param (
        # Server FQDN or IP
        [Parameter(Mandatory=$true)]
        [string]$CachetServer,
        [Parameter(Mandatory=$true)]
        [int]$CachetIncidentID,
        [Parameter(Mandatory=$true)]
        [ValidateSet('Investigating','Identified','Watching','Fixed')]
        $IncidentStatus,
        [Parameter(Mandatory=$true)]
        [string]$IncidentMessage,
        [Parameter(Mandatory=$true)]
        [string]$APIToken
    )
    $iStatus = Get-CachetStatusId -StatusName $IncidentStatus

    $cachetValues = @{
            status = $iStatus;
            message = "$IncidentMessage"
        }

    $cachetBody = $cachetValues | ConvertTo-Json;

    $cachetParameters = @{
        Uri    =  "https://$CachetServer/api/v1/incidents/$CachetIncidentID/updates"
        Method =  'post'
        Body   =  $cachetBody
        APIToken  =  $APIToken
    }
    
    Try {
        Write-Warning "Creating New Incident Update: $IncidentMessage"
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