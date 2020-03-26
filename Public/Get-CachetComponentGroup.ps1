<#
    .SYNOPSIS
    Gets Cachet Component Groups

    .DESCRIPTION
    Allows Cachet Component Groups to be obtained through REST API

    .PARAMETER CachetServer
    Specifies Cachet Server URL, enter as 'site-name.domain.org'

    .PARAMETER APIToken
    Specifies API Token

    .PARAMETER ComponentGroupName
    Specifies Component Group Name to be found

    .PARAMETER ComponentGroupID
    Specifies Componen Group ID to be found

    .EXAMPLE
    Get-CachetComponentGroup -CachetServer 'site-name.domain.org' -APIToken "1111111111111"

    .EXAMPLE
    Get-CachetComponentGroup -CachetServer 'site-name.domain.org' -APIToken "1111111111111" `
    -ComponentGroupName 'Office 365'

    .EXAMPLE
    Get-CachetComponentGroup 'site-name.domain.org' -APIToken "1111111111111" `
    -ComponentGroupID 15
#>

Function Get-CachetComponentGroup {
    
    Param(
        [parameter(mandatory = $true)]
        [string]$CachetServer,
        [string]$APIToken,
        [parameter(mandatory = $false)]
        [string]$ComponentGroupName,
        [int]$ComponentGroupID
    )
    
    $cachetValues = @{}

     If (($ComponentGroupName -eq '') -and ($ComponentGroupID -eq ''))
        {
            $cachetParameters = @{
                Uri    =  "https://$CachetServer/api/v1/components/groups"
                Method =  'Get'
                APIToken  =  $APIToken
            }
        }

    If ($ComponentGroupName)
        {
            $cachetParameters = @{
                Uri    =  "https://$CachetServer/api/v1/components/groups?name=$ComponentGroupName"
                Method =  'Get'
                APIToken  =  $APIToken
            }
        }
    
    If ($ComponentGroupID)
        {
             $cachetParameters = @{
                Uri    =  "https://$CachetServer/api/v1/components/groups?id=$ComponentGroupID"
                Method =  'Get'
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
