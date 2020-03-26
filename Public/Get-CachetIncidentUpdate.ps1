<#
    .SYNOPSIS
    Gets All/Specified Cachet Incident Updates

    .DESCRIPTION
    Allows Cachet Incident Updates to be obtained through REST API

    .PARAMETER CachetServer
    Specifies Cachet Server URL, enter as 'site-name.domain.org'

    .PARAMETER APIToken
    Specifies API Token

    .PARAMETER IncidentID
    Specifies Component Group Name to be found

    .EXAMPLE
    Get-CachetIncidentUpdate -CachetServer 'site-name.domain.org' -APIToken "1111111111111" `
    -IncidentID 25
#>

Function Get-CachetIncidentUpdate {
    
    param (
        [parameter(mandatory = $true)]
        [string]$CachetServer,
        [string]$APIToken,
        [string]$IncidentID
    )

    $cachetParameters = @{
        Uri    =  "https://$CachetServer/api/v1/incidents/$IncidentID/updates"
        Method =  'Get'
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
