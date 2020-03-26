<#
    .SYNOPSIS
    Gets Cachet Components through REST API

    .DESCRIPTION
    Gets all Created Components through API

    .PARAMETER CachetServer
    Specifies Cachet Server URL, enter as 'site-name.domain.org'

    .PARAMETER APIToken
    Specifies API Token

    .PARAMETER CachetID
    Specifies Component ID to be found

    .PARAMETER ComponentName
    Specifies Component ID to be found

    .EXAMPLE
    Get-CachetComponent -CachetServer 'site-name.domain.org' `
    -APIToken "1111111111111" -ComponentName "Exchange OnPrem" 

    .EXAMPLE
    Get-CachetComponent -CachetServer 'site-name.domain.org' `
    -APIToken "1111111111111" -CachetID 1
#>

Function Get-CachetComponent {

    Param(
        [parameter(mandatory = $true)]
        [string]$CachetServer,
        [string]$APIToken,
        [parameter(mandatory = $false)]
        [int]$CachetID,
        [string]$ComponentName

    )

    $cachetValues = @{}
    
     if ($ID) {
        Write-Verbose 'Adding ID to splat' -Verbose

        $cachetParameters = @{
            Uri       =  "https://$CachetServer/api/v1/components/$ID"
            Method    =  'Get'
            APIToken  =  $APIToken
        }

    }
    if ($ComponentName) {
        Write-Verbose 'Adding Name to splat' -Verbose

        $cachetParameters = @{
            Uri       =  "https://$CachetServer/api/v1/components?name=$componentName"
            Method    =  'Get'
            APIToken  =  $APIToken
        }
    }
    Else {
    $cachetParameters = @{
        Uri       =  "https://$CachetServer/api/v1/components"
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