Function Get-Files {
    <#
    .SYNOPSIS
        Gathers all files within a specified path and date range.

    .PARAMETER Path
        Directory to get files from

    .PARAMETER DateMin
        Minimum date, inclusive (YYYY-MM-DD format)

    .PARAMETER DateMax
        Maximum date, inclusive (YYYY-MM-DD format)

    .EXAMPLE
        PS C:\> Get-Files -Path "C:\Users\username\Documents" -DateMin "2018-01-01" -DateMax "2018-12-31" 
    
    .NOTES
        Author: Andrew Brooking
        Last Edit: 2019-04-16
        Version 1.0 - Initial release
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,ValueFromPipeline=$True)][ValidateNotNullOrEmpty()][String] $Path,
        [Parameter(Mandatory=$True)][ValidateNotNullOrEmpty()][String] $DateMin,
        [Parameter(Mandatory=$True)][ValidateNotNullOrEmpty()][String] $DateMax
    )

    Begin {
        Write-Verbose "Gathering file information..."
        $Entries = @()
    } Process {
        Get-ChildItem -Path $Path -Force -Recurse | ForEach-Object {
            If($_.LastWriteTime -ge $DateMin -and $_.LastWriteTime -le $DateMax -and $_.Extension.Length -gt 0) {
                $Entries += $_
            }
        }
    } End {
        Write-Output $Entries
    }
}