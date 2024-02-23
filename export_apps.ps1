<#
#  File Name : XenAppExport.ps1

#

#  Description: Exporting Application Data and Icons to XML format. This will allow

#               users to import applications and the applications settings in another

#               site for testing or site replication.

#>

 

# Adding Citrix Snapins
Add-PSSnapin Citrix*
 

# Setting start up location

$Location = $MyInvocation.MyCommand.Path -replace $MyInvocation.MyCommand.Name,"";

set-location $Location;
$devgroup = Get-BrokerDesktopGroup | Format-list -property Name,UID | out-string
Write-Host  "Delivery groups : $devgroup"

$groupid = Read-Host -Prompt 'Specify Delivery Group UID to Export'

# Grabs applications

$apps = Get-BrokerApplication -AssociatedDesktopGroupUid $groupid -MaxRecordCount 2147483647

 

$Results = @()

 

foreach($app in $apps)

{

    # Building Properties for each application

    

    $Properties = @{

    AdminFolderName = $app.AdminFolderName

    AdminFolderUid = $app.AdminFolderUid

    ApplicationName = $app.ApplicationName

    ApplicationType = $app.ApplicationType

    AssociatedDesktopGroupPriorities = $app.AssociatedDesktopGroupPriorities

    AssociatedDesktopGroupUUIDs = $app.AssociatedDesktopGroupUUIDs

    AssociatedDesktopGroupUids = $app.AssociatedDesktopGroupUids

    AssociatedUserFullNames = $app.AssociatedUserFullNames

    AssociatedUserNames = $app.AssociatedUserNames

    AssociatedUserUPNs = $app.AssociatedUserUPNs

    BrowserName = $app.BrowserName

    ClientFolder = $app.ClientFolder

    CommandLineArguments = $app.CommandLineArguments

    CommandLineExecutable = $app.CommandLineExecutable

    CpuPriorityLevel = $app.CpuPriorityLevel

    Description = $app.Description

    IgnoreUserHomeZone = $app.IgnoreUserHomeZone

    Enabled = $app.Enabled

    IconFromClient = $app.IconFromClient

    EncodedIconData = (Get-Brokericon -Uid $app.IconUid).EncodedIconData # Grabs Icon Image

    MetadataKeys = $app.MetadataKeys

    MetadataMap = $app.MetadataMap

    MaxPerUserInstances = $app.MaxPerUserInstances

    MaxTotalInstances = $app.MaxTotalInstances

    Name = $app.Name

    PublishedName = $app.PublishedName

    SecureCmdLineArgumentsEnabled = $app.SecureCmdLineArgumentsEnabled

    ShortcutAddedToDesktop = $app.ShortcutAddedToDesktop

    ShortcutAddedToStartMenu = $app.ShortcutAddedToStartMenu

    StartMenuFolder = $app.StartMenuFolder

    UUID = $app.UUID

    Uid = $app.Uid

    HomeZoneName = $app.HomeZoneName

    HomeZoneOnly = $app.HomeZoneOnly

    HomeZoneUid = $app.HomeZoneUid

    UserFilterEnabled = $app.UserFilterEnabled

    Visible = $app.Visible

    WaitForPrinterCreation = $app.WaitForPrinterCreation

    WorkingDirectory = $app.WorkingDirectory

    }

 

    # Stores each Application setting for export

    $Results += New-Object psobject -Property $properties

}

# Setting File name

$Date = Get-Date

$FileName = $Date.ToShortDateString() + $Date.ToLongTimeString()

$FileName = (($FileName -replace ":","") -replace " ","") -replace "/",""

$FileName = "Apps" + $FileName + ".xml"

 

# Exporting results

$Results | export-clixml .\$FileName