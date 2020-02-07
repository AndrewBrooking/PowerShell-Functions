Function Reset-Network {
    <#
    .SYNOPSIS
        Reset network settings and caches.

    .PARAMETER Restart
        $True to restart system after reset

    .EXAMPLE
        PS C:\> Reset-Network -Restart $True
    
    .NOTES
        Author: Andrew Brooking
        Last Edit: 2019-04-16
        Version 1.0 - Initial release
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,ValueFromPipeline=$True)][ValidateNotNullOrEmpty()][Boolean] $Restart
    )

    Begin {
        Write-Verbose "Resetting network..."
    } Process {
        IPCONFIG /FLUSHDNS
        NBTSTAT -R
        NBTSTAT -RR
        NETSH INT IP RESET
        NETSH WINSOCK RESET
    } End {
        If ($Restart) { SHUTDOWN -r -t 0 }
    }
}