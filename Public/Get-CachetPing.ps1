<#
    .Synopsis
     Sends a Simple Test to the Cachet API

    .Description
     Sends a test API request that should return "Pong!", if working

    .Parameter CachetServer
    Specifies Cachet Server URL, enter as 'site-name.domain.org'

    .Example
    Get-CachetPing -CachetServer 'site-name.domain.org'
#>

Function Get-CachetPing {

    param (
        [parameter(mandatory = $true)]
            [string]$CachetServer
    )

    $cachetParameters = @{
        URi       = "https://$CachetServer/api/v1/ping"
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
