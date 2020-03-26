<#
    .SYNOPSIS
    Updates New Cachet Component Groups

    .DESCRIPTION
    Updates Component Groups through REST API

    .PARAMETER CachetServer
    Specifies Cachet Server URL, enter as 'site-name.domain.org'

    .PARAMETER APIToken
    Specifies API Token

    .PARAMETER ComponentGroupID
    Specifies Component Group ID to be updated

    .PARAMETER ComponentGroupName
    Specifies a updated Component Group Name

    .PARAMETER ComponentOrder
    Specifies the order of the Component Group

    .PARAMETER ComponentCollapsed
    Specifies a updated preference for group

    .EXAMPLE
    Update-CachetComponentGroup -CachetServer 'site-name.domain.org' -APIToken "1111111111111" `
    -ComponentGroupID 8 -ComponentGroupName "VMware 2" -ComponentOrder 1 -ComponentCollapsed ExpandOnIssues
#>

Function Update-CachetComponentGroup {
    
    Param(
        [parameter(mandatory = $true)]
        [string]$CachetServer,
        [string]$APIToken,
        [string]$ComponentGroupID,
        [parameter(mandatory = $false)]
        [string]$ComponentGroupName,
        [int]$ComponentOrder,
        [ValidateSet('Yes','No','ExpandOnIssues')]
        $ComponentCollapsed

    )
    $componetGroup = Get-CachetComponentGroup -CachetServer $CachetServer -APIToken $APIToken -ComponentGroupID $ComponentGroupID | Select -ExpandProperty Name

	$cachetValues = @{}

    If ($ComponentGroupName)
        {
           Write-Verbose 'Adding name To Values'
           $cachetValues.name = $ComponentGroupName;
        }
    If ($ComponentOrder)
        {
            Write-Verbose 'Adding Order To Values'
            $cachetValues.order = $ComponentOrder;
        }
    If ($ComponentCollapsed)
        {
            Write-Verbose 'Adding Collapsed Status To Values'
            $cCollapsed = Get-CachetStatusId -StatusName $ComponentCollapsed
            $cachetValues.order = $cCollapsed;
  
        }

    $cachetBody = $cachetValues | ConvertTo-Json;

    $cachetParameters = @{
        Uri    =  "https://$CachetServer/api/v1/components/groups/$ComponentGroupID"
        Method =  'put'
        Body   =  $cachetBody
        APIToken  =  $APIToken
    }
    
    Try {
        Write-Warning "Creating Updating Component Group : $componetGroup"
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