<#
    .SYNOPSIS
    Creates New Cachet Incidents

    .DESCRIPTION
    Allows Incident Creation through Cachet REST API

    .PARAMETER CachetServer
    Specifies Cachet Server URL, enter as 'site-name.domain.org'

    .PARAMETER APIToken
    Specifies API Token

    .PARAMETER IncidentName
    Specifies IncidentName to be created

    .PARAMETER IncidentMessage
    Specifies IncidentMessage to be inserted to Incident

    .PARAMETER IncidentStatus
    Specifies Newly Created Incident Status, Converted into Numerics by Function

    .PARAMETER IncidentVisible
    Specifies if the Incident is visible to the public

    .PARAMETER Componentname
    Specifies the ComponentName that is currently having a Incident
    
    .PARAMETER ComponentStatus
    Specifies the ComponentStatus that is currently going on

    .PARAMETER IncidentNotify
    Specifies if the Incident should notify subscribers

    .EXAMPLE
     New-CachetIncident -CachetServer 'site-name.domain.org' -IncidentName 'On Site Email Issues' `
    -IncidentMessage 'Exchange Is Down' -IncidentStatus Investigating -IncidentVisible 1 `
    -ComponentName "Exchange OnPrem" -ComponentStatus MajorOutage -APIToken "1111111111111"
#>

Function New-CachetIncident {

 param (
        [string]$CachetServer,
        [string]$IncidentName,
        [string]$IncidentMessage,
        [ValidateSet('Scheduled','Investigating','Identified','Watching','Fixed')]
        $IncidentStatus,
        [ValidateSet(0,1)]
        [int]$IncidentVisible = 1,
        $ComponentName,
        [ValidateSet('Operational','PerformanceIssues','PartialOutage','MajorOutage')]
        $ComponentStatus,
        [ValidateSet('true','false')]
        $IncidentNotify,
        [string]$APIToken
    )
    
    $componentID = Get-CachetComponent -CachetServer $CachetServer -APIToken $APIToken -componentName $($ComponentName) | select -ExpandProperty id

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
            Uri    =  "https://$CachetServer/api/v1/incidents"
            Method =  'post'
            Body   =  $cachetBody
            APIToken  =  $APIToken
          }
Try {
        Write-Warning "Creating New Incident: $IncidentName"
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
