$Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1)
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1)

Foreach($import in @($Public + $Private))
{
    Try
    {
        . $import.fullname
    }
    Catch
    {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
} #End of function foreach

Export-ModuleMember -Function $Public.BaseName