Function Get-CachetStatusId {
    <#
    .Synopsis
     Converts a Cachet status name to its id number.

    .Description
     Converts a Cachet status name to its id number.

    .Parameter StatusName
     The name of the Cachet status without spaces.

    .Example
     # Get the number id for the 'MajorOutage' status.
     Get-CachetStatusId -StatusName MajorOutage
    #>
    param (
        [ValidateSet(
            'Scheduled',
            'Investigating',
            'Identified',
            'Watching',
            'Fixed',
            'Operational',
            'PerformanceIssues',
            'PartialOutage',
            'MajorOutage',
            'Yes',
            'No',
            'ExpandOnIssues',
            'True',
            'False')]
        [string]$StatusName
    )

    switch -Exact ($StatusName) {
        'Scheduled' {0}
        'Investigating' {1}
        'Identified' {2}
        'Watching' {3}
        'Fixed' {4}
        'Operational' {1}
        'PerformanceIssues' {2}
        'PartialOutage' {3}
        'MajorOutage' {4}
        'No' {0}
        'Yes' {1}
        'ExpandOnIssues' {2}
        'True' {1}
        'False' {0}
    }
}