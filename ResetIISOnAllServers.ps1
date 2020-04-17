add-pssnapin microsoft.sharepoint.powershell
$spserver = get-spserver 
foreach ($server in $spserver)
{
   write-host "Performing IIS Reset on Server:"$server.name
   iisreset $server.Name
}