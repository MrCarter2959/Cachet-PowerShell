<#
    .SYNOPSIS
    Deletes Cachet Incidents

    .DESCRIPTION
    Allows Incident Deletes through Cachet REST API

    .PARAMETER CachetServer
    Specifies Cachet Server URL, enter as 'site-name.domain.org'

    .PARAMETER APIToken
    Specifies API Token

    .PARAMETER IncidentID
    Specifies Incident Name to be deleted

    .EXAMPLE
    Delete-CachetIncident -CachetServer 'site-name.domain.org' -IncidentID 24 `
    -APIToken "1111111111111"
#>

Function Remove-CachetIncident {
    
    param (
        [parameter(mandatory = $true)]
        [string]$CachetServer,
        [string]$APIToken,
        [int]$IncidentID
    )
    
    $cachetValues = @{
            incident = $IncidentID;
        }
    
    $findIncident = Get-CachetIncident -CachetServer $CachetServer -APIToken $APIToken -IncidentID $IncidentID | Select -ExpandProperty Name

    $cachetBody = $cachetValues | ConvertTo-Json;

    $cachetParameters = @{
        URi       = "https://$CachetServer/api/v1/incidents/$IncidentID"
        Method    =  'delete'
        Body      =  $cachetBody
        APIToken  =  $APIToken
    }

    Try {
        Write-Warning "Deleting $($findIncident)"
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