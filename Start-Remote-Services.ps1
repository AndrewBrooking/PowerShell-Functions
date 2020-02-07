Function Start-Remote-Services {
    <#
    .SYNOPSIS
        Starts the WinRM, RasAuto, RasMan, RpcSs, and RpcLocator services on a remote system

    .PARAMETER ComputerName
        Hostname of remote computer to start services on

    .EXAMPLE
        PS C:\> Start-Remote-Services -ComputerName "12345"
    
    .NOTES
        Author: Andrew Brooking
        Last Edit: 2019-03-22
        Version 1.0 - Initial release
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,ValueFromPipeline=$True)][ValidateNotNullOrEmpty()][String] $ComputerName
    )

    Begin {
        Write-Verbose "Attempting to start services on $ComputerName"
        $Services = 'WinRM', 'RasAuto', 'RasMan', 'RpcSs', 'RpcLocator'
    } Process {
        ForEach ($Service in $Services) {
            Write-Verbose "Starting service: $Service"
            Try {
                Get-Service -Name $Service -ComputerName $ComputerName | Start-Service
            } Catch {
                Write-Error "Could not start service: $Service on $ComputerName"
            }
        }
    } End {
        Write-Verbose "Finished starting services on $ComputerName"
    }
}