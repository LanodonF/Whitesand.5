# This Script Configures System Services based off of the CIS_Microsoft_Windows_10_Stand-alone_Benchmark_v2.0.0 and CIS_Microsoft_Windows_10_Enterprise_Benchmark_v2.0.0

# Bluetooth audio gateway service
Get-Service -Name BTAGService | Stop-Service -Force
Set-Service -Name BTAGService -StartupType Disabled
# Bluetooth support service
Get-Service -Name bthserv | Stop-Service -Force
Set-Service -Name bthserv -StartupType Disabled
# Computer Browser
Get-Service -Name Browser | Stop-Service -Force
Set-Service -Name Browser -StartupType Disabled
# Downloaded Maps Manager
Get-Service -Name MapsBroker | Stop-Service -Force
Set-Service -Name MapsBroker -StartupType Disabled
#Geolocation Service
Get-Service -Name lfsvc | Stop-Service -Force
Set-Service -Name lfsvc -StartupType Disabled
#Plug and Play
Get-Service -Name PlugPlay | Stop-Service -Force
Set-Service -Name PlugPlay -StartupType Disabled
#Infrared Monitor Service
Get-Service -Name irmon | Stop-Service -Force
Set-Service -Name irmon -StartupType Disabled
# 
Get-Service -Name lltdsvc | Stop-Service -Force
Set-Service -Name lltdsvc -StartupType Disabled
# 
Get-Service -Name MSiSCSI | Stop-Service -Force
Set-Service -Name MSiSCSI -StartupType Disabled
# 
Get-Service -Name PNRPsvc | Stop-Service -Force
Set-Service -Name PNRPsvc -StartupType Disabled
# 
Get-Service -Name p2psvc | Stop-Service -Force
Set-Service -Name p2psvc -StartupType Disabled

Get-Service -Name p2imsvc | Stop-Service -Force
Set-Service -Name p2imsvc -StartupType Disabled

Get-Service -Name PNRPAutoReg | Stop-Service -Force
Set-Service -Name PNRPAutoReg -StartupType Disabled

Get-Service -Name Spooler | Stop-Service -Force
Set-Service -Name Spooler -StartupType Disabled

Get-Service -Name wercplsupport | Stop-Service -Force
Set-Service -Name wercplsupport -StartupType Disabled

Get-Service -Name RasAuto | Stop-Service -Force
Set-Service -Name RasAuto -StartupType Disabled

Get-Service -Name RemoteRegistry | Stop-Service -Force
Set-Service -Name RemoteRegistry -StartupType Disabled

Get-Service -Name simptcp | Stop-Service -Force
Set-Service -Name simptcp -StartupType Disabled

Get-Service -Name SNMP | Stop-Service -Force
Set-Service -Name SNMP -StartupType Disabled

Get-Service -Name SSDPSRV | Stop-Service -Force
Set-Service -Name SSDPSRV -StartupType Disabled

Get-Service -Name upnphost | Stop-Service -Force
Set-Service -Name upnphost -StartupType Disabled

Get-Service -Name WMSvc | Stop-Service -Force
Set-Service -Name WMSvc -StartupType Disabled

Get-Service -Name WerSvc | Stop-Service -Force
Set-Service -Name WerSvc -StartupType Disabled

Get-Service -Name Wecsvc | Stop-Service -Force
Set-Service -Name Wecsvc -StartupType Disabled

Get-Service -Name WMPNetworkSvc | Stop-Service -Force
Set-Service -Name WMPNetworkSvc -StartupType Disabled

Get-Service -Name icssvc | Stop-Service -Force
Set-Service -Name icssvc -StartupType Disabled

Get-Service -Name WpnService | Stop-Service -Force
Set-Service -Name WpnService -StartupType Disabled

Get-Service -Name PushToInstall | Stop-Service -Force
Set-Service -Name PushToInstall -StartupType Disabled

Get-Service -Name W3SVC | Stop-Service -Force
Set-Service -Name W3SVC -StartupType Disabled

Get-Service -Name XboxGipSvc | Stop-Service -Force
Set-Service -Name XboxGipSvc -StartupType Disabled

Get-Service -Name AblAuthManager | Stop-Service -Force
Set-Service -Name AblAuthManager -StartupType Disabled

Get-Service -Name XblGameSave | Stop-Service -Force
Set-Service -Name XblGameSave -StartupType Disabled

Get-Service -Name XboxNetApiSvc | Stop-Service -Force
Set-Service -Name XboxNetApiSvc -StartupType Disabled

Get-Service -Name XblAuthManager | Stop-Service -Force
Set-Service -Name XblAuthManager -StartupType Disabled

Get-Service -Name LxssManager | Stop-Service -Force
Set-Service -Name LxssManager -StartupType Disabled

# =========== Services w/ Critical Services ===========

<# SMB Critical Service/File Sharing
This goes with the SMB/File Sharing and/or OpenSSH Server #>
Get-Service -Name LanmanServer | Stop-Service -Force
Set-Service -Name LanmanServer -StartupType Disabled
Get-Service -Name Server | Stop-Service -Force
Set-Service -Name Server -StartupType Disabled
Get-Service -Name RemoteAccess | Stop-Service -Force
Set-Service -Name RemoteAccess -StartupType Disabled
Get-Service -Name FTPSVC | Stop-Service -Force
Set-Service -Name FTPSVC -StartupType Disabled
# OpenSSH Server
Get-Service -Name sshd | Stop-Service -Force
Set-Service -Name sshd -StartupType Disabled

# Internet Connection Sharing
Get-Service -Name ICS | Stop-Service -Force
Set-Service -Name ICS -StartupType Disabled
Get-Service -Name SharedAccess | Stop-Service -Force
Set-Service -Name SharedAccess -StartupType Disabled

# IIS
Get-Service -Name IISAdmin | Stop-Service -Force
Set-Service -Name IISAdmin -StartupType Disabled

# Remote Desktop Services
Get-Service -Name UmRdpService | Stop-Service -Force
Set-Service -Name UmRdpService -StartupType Disabled
Get-Service -Name TermService | Stop-Service -Force
Set-Service -Name TermService -StartupType Disabled
Get-Service -Name SessionEnv | Stop-Service -Force
Set-Service -Name SessionEnv -StartupType Disabled



<# ====== Enabling Services ===== #>
# Turns on Bitlocker Drive Encryption
Set-Service -Name BDESVC -StartupType Automatic
Start-Service -Name BDESVC

# Turns on the Windows Defender Firewall Service
Set-Service -Name mpssvc -StartupType Automatic
Start-Service -Name mpssvc

# Turns on 
Set-Service -Name Wecsvc -StartupType Automatic
Start-Service -Name Wecsvc

# Turns on the Event Log service for event viewer
Set-Service -Name EventLog -StartupType Automatic
Start-Service -Name EventLog

# Turns on Windows Update Service
Set-Service -Name wuauserv -StartupType Automatic
Start-Service -Name wuauserv
