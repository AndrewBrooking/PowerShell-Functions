Function Get-Network-Drives {
    <#
    .SYNOPSIS
        Creates a list of all mapped network drives

    .PARAMETER ComputerName
        Hostname of remote computer to get network drives

    .EXAMPLE
        PS C:\> Get-Network-Drives -ComputerName "12345"
    
    .NOTES
        Author: Andrew Brooking
        Last Edit: 2019-04-16
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
            #Get remote explorer session to identify current user
            $Explorer = Get-WmiObject -Class "Win32_Process" -ComputerName $ComputerName | Where-Object {$_.Name -eq "explorer.exe"}
    
            #If a session was returned check HKEY_USERS for Network drives under their SID
            If($Explorer) {
                $Hive = 2147483651
                $SID = ($Explorer.GetOwnerSid()).SID
                $Owner  = $Explorer.GetOwner()
                $RegProv = Get-WmiObject -Namespace "ROOT\DEFAULT" -Class "StdRegProv" -ComputerName $ComputerName
                $DriveList = $RegProv.EnumKey($Hive, "$($SID)\Network")
      
                #If the SID network has mapped drives iterate and report on said drives
                If($DriveList.sNames.count -gt 0) {
                    ForEach($Drive in $DriveList.sNames) {
                        $Drives += "$Drive,$(($RegProv.GetStringValue($Hive, "$($SID)\Network\$($Drive)", "RemotePath")).sValue)"
                    }
                }
            } Else {
                Write-Error "explorer.exe not running on $ComputerName"
            }
        } Catch {
            Write-Error "Failed to obtain network drives from $ComputerName"
        }
    } End {
        Write-Output $Drives
    }
}