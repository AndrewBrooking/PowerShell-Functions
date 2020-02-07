Function Get-Local-Drive {
    <#
    .SYNOPSIS
        Obtains the local drive of a specified system

    .PARAMETER ComputerName
        Hostname of remote computer to get local drive

    .EXAMPLE
        PS C:\> Get-Local-Drive -ComputerName "12345"
    
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
        $Drive = $null
    } Process {
        Try {
            $Drive = Get-WmiObject -Class "Win32_LogicalDisk" -ComputerName $ComputerName -Filter "DeviceID='C:'"
        } Catch {
            Write-Error "Failed to obtain hard drive information for $ComputerName"
        }
    } End {
        Write-Output $Drive
    }
}