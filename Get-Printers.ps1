Function Get-Printers {
    <#
    .SYNOPSIS
        Creates a list of all printers installed.

    .PARAMETER ComputerName
        Hostname of remote computer to get printers

    .EXAMPLE
        PS C:\> Get-Printers -ComputerName "12345"
    
    .NOTES
        Author: Andrew Brooking
        Last Edit: 2019-03-19
        Version 1.0 - Initial release
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,ValueFromPipeline=$True)][ValidateNotNullOrEmpty()][String] $ComputerName
    )

    Begin {
        $Printers = @()
    } Process {
        Try {
            Get-WmiObject -Class "Win32_Printer" -ComputerName $ComputerName | ForEach-Object {
                $Printers += $_
            }
        } Catch {
            Write-Error "Failed to obtain printers from $ComputerName"
        }
    } End {
        Write-Output $Printers
    }
}