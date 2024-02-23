#
# Modify At Chief Config File
# Created On:  12/15/2022
# Created By:  Riley Bird
#
#===================================================================================
#
# Script designed to modify the AtChief.xml config file
#
#
# Version 1.0 - RB061069  - 12/15/2022 - Initial Creation
#
####################################################################################
function Main 
{
    # Script Version
    $Script:ScriptVer = "1.0"

    # Get the values from the global and local ini files and create variables for all of the values
    Use-Framework
    Try {
        # Start logging
        Start-LogFile
        # Check that the AtChief.xml file exists
        if(!(Test-Path -Path "$AtChiefFile")) { 
            Write-ToLogFile -WriteHost "The $AtChiefFile file does not exist." -errorflag
        }
        # Set XMLFile variable
        [xml]$XMLFile = Get-Content "$AtChiefFile"
        # Modify the AtChief.xml file
        $XMLFile.AtServer.Database.UFN = $UserFriendlyName
        $XMLFile.AtServer.Database.GUID = $GUID
        $XMLFile.AtServer.Database.HostName = $HostName
        $XMLFile.AtServer.Database.ConnString = $ConnectionString
        $XMLFile.Save("$AtChiefFile")
        Write-ToLogFile -WriteHost "The modification of the AtChief.xml config file completed successfully." -infoflag
    }
    Catch {
        # Execution failed
        Write-ToLogFile -WriteHost "The modification of the AtChief.xml config file failed." -infoflag
        Exit 1
    }
    Finally {
        # Stop Logging
        Stop-LogFile
        Exit 0
    }
}

function Use-Framework
{
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingWMICmdlet", "", Scope = "Function")]
    param ()
    $ScriptPath = ""
    $Invocation = (Get-Variable MyInvocation -scope 2).Value
    $ScriptName = $Invocation.MyCommand.Name #filename.ext
    $ScriptNameFull = $Invocation.MyCommand.Definition #path\filename.ext
    if ($ScriptNameFull.Contains(":")) {
        # Convert the mapped drive to UNC
        $tmp = $ScriptNamefull.Split(":")
        $script_drive = $tmp[0] + ":"
        If (Get-Command Get-CimInstance -ErrorAction SilentlyContinue) {
            $drives = Get-CimInstance -query "Select * From Win32_LogicalDisk Where DriveType = 4"
        }
        Else {
            $drives = Get-WMIObject -query "Select * From Win32_LogicalDisk Where DriveType = 4"
        }
        foreach ($drive In $drives) {
            if ($drive.DeviceID -eq $script_drive) {
                $scriptname = Join-Path -path $drive.ProviderName $scriptnamefull.substring(3)
            }
        }
        $scriptpath = $ScriptName
    }
    else {
        $ScriptPath = $ScriptNameFull
    }
    $PathSplit = $ScriptPath.Split('\')
    $Path = join-path -path "\\" $PathSplit[2]
    if ($PathSplit[3] -eq "dfs") {
        $Path = join-path -path $Path $PathSplit[3]
        $Path = join-path -path $Path $PathSplit[4]
    }
    else {
        $Path = join-path -path $Path $PathSplit[3]
    }
    # If running from local drive $Path won't be a valid UNC
    If ([bool]([System.Uri]$path).IsUnc) {
        $GlobalFile = join-path -path $Path "Framework.psm1"
    }
    else {
        # since not running from network, look for framework in scriptpath
        $GlobalPath = Split-Path ($Invocation.MyCommand.Path)
        $GlobalFile = "$GlobalPath\Framework.psm1"
    }
    # execute the framework
    if (Test-Path $GlobalFile) {
        if ($(Get-Module -name Framework).name.length -gt 0) {
            Remove-Module Framework
        }
        Import-Module $GlobalFile
        for ($i = 0; $i -lt $script:args.Length; $i++) {
            if ($script:args[$i].ToString().substring(0, 1) -eq "-") {
                if ($i + 1 -ge $script:args.Length) {
                    Set-Variable -name $script:args[$i].ToString().substring(1) -value $true -scope "Script"
                }
                else {
                    if ($script:args[$i + 1] -is [System.Array]) {
                        Set-Variable -name $script:args[$i].ToString().substring(1) -value $script:args[$i+1] -scope "Script"
                        $i++
                    }
                    elseif ($script:args[$i + 1].ToString().substring(0, 1) -eq "-") {
                        Set-Variable -name $script:args[$i].ToString().substring(1) -value $true -scope "Script"
                    }
                    else {
                        Set-Variable -name $script:args[$i].ToString().substring(1) -value $script:args[$i+1] -scope "Script"
                        $i++
                    }
                }
            }
        }
        if ($help) {
            Show-Help
        }
    }
}
 
Main