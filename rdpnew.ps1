﻿  <#
      Creates an RDP file for a given target example (localhost)
      Creates an RDP file to connect to give target and puts it in the out put directory example:(C:\users\public\desktop\)
  #>
  #Variables
  $target = 'leidvacvweb06.leid_va.cernerasp.com'
  $outputdirectory = 'C:\Policies\CernerAccess'
  
  $rdp = 'screen mode id:i:1
    use multimon:i:0
    desktopwidth:i:1680
    desktopheight:i:1050
    session bpp:i:32
    winposstr:s:0,3,44,161,1403,1050
    compression:i:1
    keyboardhook:i:2
    audiocapturemode:i:0
    videoplaybackmode:i:1
    connection type:i:7
    networkautodetect:i:1
    bandwidthautodetect:i:1
    displayconnectionbar:i:1
    enableworkspacereconnect:i:0
    disable wallpaper:i:0
    allow font oothing:i:0
    allow desktop composition:i:0
    disable full window drag:i:1
    disable menu anims:i:1
    disable themes:i:0
    disable cursor setting:i:0
    bitmapcachepersistenable:i:1
    full address:s:{0}
    audiomode:i:0
    redirectprinters:i:1
    redirectcomports:i:0
    redirectsmartcards:i:1
    redirectclipboard:i:1
    redirectposdevices:i:0
    autoreconnection nabled:i:1
    authentication level:i:2
    prompt for credentials:i:0
    negotiate security layer:i:1
    remoteapplicationmode:i:0
    alternate shell:s:
    shell working directory:s:
    gatewayhostname:s:
    gatewayusagemethod:i:4
    gatewaycredentialssource:i:4
    gatewayprofileusagemethod:i:0
    promptcredentialonce:i:0
    gatewaybrokeringtype:i:0
    use redirection server name:i:0
    rdgiskdcproxy:i:0
    kdcproxyname:s:
    smart sizing:i:1
    drivestoredirect:s:
  '
  #This section will create the RDP link
  $rdp -f $target | Out-File -FilePath "$outputdirectory\$target.rdp"