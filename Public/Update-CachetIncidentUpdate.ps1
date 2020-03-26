<#
    .SYNOPSIS
    Updates a Cachet Incident Update

    .DESCRIPTION
    Allows Cachet Incident Updates to be Updated through REST API

    .PARAMETER CachetServer
    Specifies Cachet Server URL, enter as 'site-name.domain.org'

    .PARAMETER APIToken
    Specifies API Token

    .PARAMETER CachetIncidentID
    Specifies Incident ID to put a Update into

    .PARAMETER UpdateIncidentID
    Specifies IncidentUpdateID which is required to update

    .PARAMETER IncidentStatus
    Specifies a Status which is then converted in numerics by Function

    .PARAMTER IncidentMessage
    Specifies a message to post within the Incident Update

    .EXAMPLE
    Update-CachetIncidentUpdate -CachetServer 'site-name.domain.org' -CachetIncidentID 25 `
    -UpdateIncidentID 12 -IncidentStatus Fixed `
    -IncidentMessage 'Fixed' -APIToken "1111111111111" -Verbose
#>

Function Update-CachetIncidentUpdate {

    param (
        # Server FQDN or IP
        [Parameter(Mandatory=$true)]
        [string]$CachetServer,
        [int]$CachetIncidentID,
        [int]$UpdateIncidentID,
        [string]$APIToken,
        [Parameter(Mandatory=$false)]
        [ValidateSet('Investigating','Identified','Watching','Fixed')]
        $IncidentStatus,
        [string]$IncidentMessage
    )

    $iStatus = Get-CachetStatusId -StatusName $IncidentStatus

    $cachetValues = @{
            status = $iStatus;
            message = "$IncidentMessage"
        }

    $cachetBody = $cachetValues | ConvertTo-Json;

    $cachetParameters = @{
        Uri    =  "https://$CachetServer/api/v1/incidents/$CachetIncidentID/updates/$UpdateIncidentID"
        Method =  'put'
        Body   =  $cachetBody
        APIToken  =  $APIToken
    }
    
    Try {
        Write-Warning "Creating New Incident Update: Update : $IncidentMessage"
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