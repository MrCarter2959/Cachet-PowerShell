<#
    .SYNOPSIS
    Updates Cachet Incidents

    .DESCRIPTION
    Allows Incident Updates through Cachet REST API

    .PARAMETER CachetServer
    Specifies Cachet Server URL, enter as 'site-name.domain.org'

    .PARAMETER APIToken
    Specifies API Token

    .PARAMETER IncidentName
    Specifies Incident Name to be created

    .PARAMETER IncidentMessage
    Specifies Incident Description for update

    .PARAMETER IncidentStatus
    Specifies Updated Incident Status Converted into Numerics by Function

    .PARAMETER IncidentVisible
    Specifies if the Incident Update should be visible

    .PARAMETER IncidentID
    Specifies the Incident ID that should be updated
    
    .PARAMETER ComponentName
    Specifies Component Name to be updated in Incident

    .PARAMETER ComponentStatus
    Specifies Updated Component Status Converted into Numerics by Function

    .PARAMETER IncidentNotfiy
    Specifies if the Incident Update allow notifications
     
    .EXAMPLE
    Update-CachetIncident -CachetServer 'site-name.domain.org' -IncidentName 'Looking in Email Servers - on prem' `
    -IncidentMessage 'Problem within email' -IncidentStatus Investigating -IncidentVisible 1 -IncidentID 24 `
    -ComponentName "Exchange OnPrem" -ComponentStatus PartialOutage -IncidentNotify false -APIToken "1111111111111"
#>

Function Update-CachetIncident {

 param (
        [string]$CachetServer,
        [string]$IncidentName,
        [string]$IncidentMessage,
        [ValidateSet('Scheduled','Investigating','Identified','Watching','Fixed')]
        $IncidentStatus,
        [ValidateSet(0,1)]
        [int]$IncidentVisible = 1,
        [Parameter(Mandatory=$true)]
        [int]$IncidentID,
        $ComponentName,
        [ValidateSet('Operational','PerformanceIssues','PartialOutage','MajorOutage')]
        $ComponentStatus,
        [ValidateSet('true','false')]
        $IncidentNotify,
        [string]$APIToken
    )

    $componentID = Get-CachetComponent -CachetServer $CachetServer -APIToken $APIToken -componentName $($ComponentName) | Select -ExpandProperty id

    if ($componentID) {

        $iStatus = Get-CachetStatusId -StatusName $IncidentStatus
        $cStatus = Get-CachetStatusId -StatusName $ComponentStatus

        $cachetValues = @{
            name = $IncidentName;
            message = $IncidentMessage;
            status = $iStatus;
            visible = $IncidentVisible;
            component_id = $componentID;
            component_status = $cStatus
        }

         $cachetBody = $cachetValues | ConvertTo-Json;

         $cachetParameters = @{
            Uri    =  "https://$CachetServer/api/v1/incidents/$IncidentID"
            Method =  'put'
            Body   =  $cachetBody
            APIToken  =  $APIToken
          }

Try {
        Write-Warning "Updating Incident: $IncidentName"
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
}