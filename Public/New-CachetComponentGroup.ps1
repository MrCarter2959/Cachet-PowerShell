<#
    .SYNOPSIS
    Creates New Cachet Component Groups

    .DESCRIPTION
    Creates New Cachet Component Groups through REST API

    .PARAMETER CachetServer
    Specifies Cachet Server URL, enter as 'site-name.domain.org'

    .PARAMETER APIToken
    Specifies API Token

    .PARAMETER ComponentGroupName
    Specifies Component Group Name to be found

    .PARAMETER ComponentCollapsed
    Specifies if the Component Group should expand upon issues, be closed, or always open

    .PARAMETER ComponentGroupOrder
    Specifies the order of the Component Group

    .EXAMPLE
    New-CachetComponentGroup -CachetServer 'site-name.domain.org' -APIToken "1111111111111" `
    -ComponentGroupName "VMware" -ComponentCollapsed ExpandOnIssues -ComponentGroupOrder 1
#>

Function New-CachetComponentGroup {

    Param(
        [parameter(mandatory = $true)]
        [string]$CachetServer,
        [string]$APIToken,
        [string]$ComponentGroupName,
        [parameter(mandatory = $false)]
        [ValidateSet('Yes','No','ExpandOnIssues')]
        $ComponentCollapsed,
        [int]$ComponentGroupOrder
    )

    $cachetValues = @{
            name = $ComponentGroupName;
        }

    If ($ComponentGroupOrder)
        {
           Write-Verbose 'Adding Order To Values'
           $cachetValues.order = $ComponentGroupOrder
        }
    If ($ComponentCollapsed)
        {
            Write-Verbose 'Adding Collapse Status To Values'
            $collapsedStatus = Get-CachetStatusId -StatusName $ComponentCollapsed
            $cachetValues.collapsed = $collapsedStatus
        }

    $cachetBody = $cachetValues | ConvertTo-Json;

    $cachetParameters = @{
        Uri    =  "https://$CachetServer/api/v1/components/groups"
        Method =  'post'
        Body   =  $cachetBody
        APIToken  =  $APIToken
    }
    
    Try {
        Write-Warning "Creating Component Group : $ComponentGroupName"
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