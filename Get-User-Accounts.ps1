Function Get-User-Accounts {
    <#
    .SYNOPSIS
        Creates a list of all user accounts

    .PARAMETER ComputerName
        Hostname of remote computer to get user accounts

    .EXAMPLE
        PS C:\> Get-User-Accounts -ComputerName "12345"
    
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
        $Drives = @()
    } Process {
        Try {
            Get-WmiObject -Class "Win32_UserProfile" -ComputerName $ComputerName | Where-Object {!$_.Special -and $_.LocalPath -notlike "*Administrator*"} | ForEach-Object {
                $Drives += $_
            }
        } Catch {
            Write-Error "Failed to obtain users from $ComputerName"
        }
    } End {
        Write-Output $Drives
    }
}