Import-Module ServerManager
Add-WindowsFeature Web-Server –IncludeAllSubFeature

Install ink and handwriting services feature

md "D:\Logs\ULS"
md "D:\ProgramData\Microsoft\OfficeWebApps\Working\d"
md "D:\ProgramData\Microsoft\OfficeWebApps\Working\waccache"


Add-WindowsFeature Web-Server,Web-Mgmt-Tools,Web-Mgmt-Console,Web-WebServer,Web-Common-Http,Web-Default-Doc,Web-Static-Content,Web-Performance,Web-Stat-Compression,Web-Dyn-Compression,Web-Security,Web-Filtering,Web-Windows-Auth,Web-App-Dev,Web-Net-Ext45,Web-Asp-Net45,Web-ISAPI-Ext,Web-ISAPI-Filter,Web-Includes,NET-Framework-Features,NET-Framework-Core,NET-HTTP-Activation,NET-Non-HTTP-Activ,NET-WCF-HTTP-Activation45

