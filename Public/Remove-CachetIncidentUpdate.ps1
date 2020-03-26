<#
    .SYNOPSIS
    Deletes a Cachet Incident Update

    .DESCRIPTION
    Allows Cachet Incident Updates to be Deleted through REST API

    .PARAMETER CachetServer
    Specifies Cachet Server URL, enter as 'site-name.domain.org'

    .PARAMETER APIToken
    Specifies API Token

    .PARAMETER CachetIncidentID
    Specifies Incident ID to put a Update into

    .PARAMETER UpdateIncidentID
    Specifies IncidentUpdateID which is required to update

    .EXAMPLE
    Delete-CachetIncidentUpdate -CachetServer 'site-name.domain.org' -CachetIncidentID 25 `
    -IncidentUpdateID 12 -APIToken "1111111111111"
#>

Function Remove-CachetIncidentUpdate {
    
    param (
        [parameter(mandatory = $true)]
        [string]$CachetServer,
        [string]$APIToken,
        [int]$CachetIncidentID,
        [int]$IncidentUpdateID

    )
	
        $cachetValues = @{
            group = $CachetIncidentUpdateID;
        }
    
    $findUpdate = Get-CachetIncidentUpdate -CachetServer $CachetServer -APIToken $APIToken -IncidentID $CachetIncidentID | Select name

    $cachetBody = $cachetValues | ConvertTo-Json;

    $cachetParameters = @{
        URi       = "https://$CachetServer/api/v1/incidents/$CachetIncidentID/updates/$IncidentUpdateID"
        Method    =  'delete'
        Body      =  $cachetBody
        APIToken  =  $APIToken
    }

    Try {
        Write-Warning "Deleting $($findUpdate.name)"
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
