<#
    .SYNOPSIS
    Gets All/Specified Cachet Incidents

    .DESCRIPTION
    Allows Component Creation through Cachet REST API

    .PARAMETER CachetServer
    Specifies Cachet Server URL, enter as 'site-name.domain.org'

    .PARAMETER APIToken
    Specifies API Token

    .PARAMETER IncidentID
    Specifies IncidentID to be returned

    .PARAMETER ComponentName
    Specifies ComponentName to be returned

    .EXAMPLE
    Get-CachetIncident -CachetServer 'site-name.domain.org' -APIToken "1111111111111"
    
    .EXAMPLE
    Get-CachetIncident -CachetServer 'site-name.domain.org' -APIToken "1111111111111" `
    -IncidentID 5
    
    .EXAMPLE
    Get-CachetIncident -CachetServer 'site-name.domain.org' -APIToken "1111111111111"`
    -ComponentName 'Exchange OnPrem'
#>

Function Get-CachetIncident {

    Param(
        [parameter(mandatory = $true)]
        [string]$CachetServer,
        [string]$APIToken,
        [parameter(mandatory = $false)]
        [int]$IncidentID,
        [string]$ComponentName

    )

    $cachetValues = @{}
    
    If (($ComponentName -eq '') -and ($IncidentID -eq ''))
    {
        Write-Verbose 'Getting All Incidents' -Verbose
        
        $cachetParameters = @{
            Uri       =  "https://$CachetServer/api/v1/incidents"
            Method    =  'Get'
            APIToken  =  $APIToken
        }
    }

     if ($IncidentID) {
        Write-Verbose 'Adding IncidentID to splat' -Verbose

        $cachetParameters = @{
            Uri       =  "https://$CachetServer/api/v1/incidents?id=$IncidentID"
            Method    =  'Get'
            APIToken  =  $APIToken
        }

    }
    if ($ComponentName) {
        Write-Verbose 'Adding ComponentName to splat' -Verbose

        $cachetParameters = @{
            Uri       =  "https://$CachetServer/api/v1/incidents?name=$componentName"
            Method    =  'Get'
            APIToken  =  $APIToken
        }
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