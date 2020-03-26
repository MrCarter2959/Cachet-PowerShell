<#
    .Synopsis
     Obtain Cachet Server Version Through API

    .Description
     Using the API, returns the Cachet Server Version

    .Parameter CachetServer
    Specifies Cachet Server URL, enter as 'site-name.domain.org'

    .Example
     # Get a list of all components
     Get-CachetVersion -CachetServer 'site-name.domain.org'
#>

Function Get-CachetVersion {

    param (
        [parameter(mandatory = $true)]
            [string]$CachetServer
    )

    $cachetParameters = @{
        URi       = "https://$CachetServer/api/v1/version"
        Method    =  'get'
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