Function Get-Apps {
    <#
    .SYNOPSIS
        Creates a list of all installed applications

    .PARAMETER ComputerName
        Hostname of remote computer to get installed applications

    .EXAMPLE
        PS C:\> Get-Apps -ComputerName "12345"
    
    .NOTES
        Author: Andrew Brooking
        Last Edit: 2019-03-19
        Version 1.0 - Initial release
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,ValueFromPipeline=$True)][ValidateNotNullOrEmpty()][String] $ComputerName,
        [Parameter(Mandatory=$False)][Array] $Exclude
    )

    Begin {
        $Installed = @()
    } Process {
        Try {
            Get-WmiObject -Class "Win32_InstalledWin32Program" -ComputerName $ComputerName | ForEach-Object {
                $Valid = $True

                ForEach($Name in $Exclude) {
                    If($_.Name -like $Name) {
                        $Valid = $False
                    }
                }

                If($Valid) {
                    $Installed += $_
                }
            }
        } Catch {
            Write-Error "Failed to obtain installed applications for $ComputerName"
        }
    } End {
        Write-Output $Installed
    }
}