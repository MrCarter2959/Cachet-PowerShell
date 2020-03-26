<#
    .SYNOPSIS
    Deletes Cachet Components

    .DESCRIPTION
    Allows Component Deletion through Cachet REST API

    .PARAMETER CachetServer
    Specifies Cachet Server URL, enter as 'site-name.domain.org'

    .PARAMETER APIToken
    Specifies API Token

    .PARAMETER ComponentID
    Specifies Component ID To be deleted
     
    .EXAMPLE
    Delete-CachetComponent -CachetServer 'site-name.domain.org' -APIToken "1111111111111" `
    -ComponentID 9
#>
Function Remove-CachetComponent {

    param (
        [parameter(mandatory = $true)]
        [string]$CachetServer,
        [string]$APIToken,
        [int]$ComponentID
    )

    $cachetValues = @{
            component = $ComponentID;
        }

    $findComponent = Get-CachetComponent -CachetServer $CachetServer -APIToken $APIToken -CachetID $ComponentID | Select Name
    
    $cachetBody = $cachetValues | ConvertTo-Json;

    $cachetParameters = @{
        URi       = "https://$CachetServer/api/v1/components/$ComponentID"
        Method    =  'delete'
        Body      =  $cachetBody
        APIToken  =  $APIToken
    }

    Try {
        Write-Warning "Deleting $($findComponent.Name)"
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