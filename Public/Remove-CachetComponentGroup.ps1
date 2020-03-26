<#
    .SYNOPSIS
    Deletes Cachet Component Groups

    .DESCRIPTION
    Deletes Cachet Component Groups through REST API

    .PARAMETER CachetServer
    Specifies Cachet Server URL, enter as 'site-name.domain.org'

    .PARAMETER APIToken
    Specifies API Token

    .PARAMETER ComponentGroupID
    Specifies Component Group ID to be Deleted

    .EXAMPLE
    Delete-CachetComponentGroup -CachetServer 'site-name.domain.org' -APIToken "1111111111111" `
    -ComponentGroupID 8
#>

Function Remove-CachetComponentGroup {

    param (
        [parameter(mandatory = $true)]
        [string]$CachetServer,
        [string]$APIToken,
        [string]$ComponentGroupID
    )

        $cachetValues = @{
            group = $ComponentGroupID;
        }
    
    $findGroup = Get-CachetComponentGroup -CachetServer $CachetServer -APIToken $APIToken -ComponentGroupID $ComponentGroupID | Select -ExpandProperty Name

    $cachetBody = $cachetValues | ConvertTo-Json;

    $cachetParameters = @{
        URi       = "https://$CachetServer/api/v1/components/groups/$ComponentGroupID"
        Method    =  'delete'
        Body      =  $cachetBody
        APIToken  =  $APIToken
    }

    Try {
        Write-Warning "Deleting $($findGroup)"
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