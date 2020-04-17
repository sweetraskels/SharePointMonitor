Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue
#CSS Styles for the Table
$style = "Site Collection Admin Report: "
$style = $style + "<style>BODY{font-family: Arial; font-size: 10pt;}"
$style = $style + "TABLE{border: 1px solid black; }"
$style = $style + "TH{border: 1px solid black; background: #8064a2; padding: 5px; }"
$style = $style + "TD{border: 1px solid black; padding: 2px; }"
$style = $style + "</style>"
$ReportDate = Get-Date -format "dd-MM-yyyy"
#Get All Web Applications
$WebAppsCollection = Get-SPWebApplication
 
#Array to Hold Result - PSObjects
$LargeListsResult = @()
 
foreach($WebApp in $WebAppsCollection)
{


    #Get the Throttling Limit of the Web App
    $Threshold = $WebApp.MaxItemsPerThrottledOperation
 
    foreach($Site in $WebApp.Sites)
    {
        foreach($Web in $Site.AllWebs)
        {
            Write-host "Scanning site:"$Web.URL
             
            foreach($List in $Web.Lists)
            {
                if($list.ItemCount -gt $Threshold)
                {
                    $Result = New-Object PSObject
                    $Result | Add-Member NoteProperty -name "Title" -value $list.Title
                    $Result | Add-Member NoteProperty -name "URL" -value $web.URL
                    $Result | Add-Member NoteProperty -name "Count" -value $list.ItemCount
                     
                    #Add the object with property to an Array
                    $LargeListsResult += $Result
                }
            }
        }
    }
}

$EmailBody= $LargeListsResult | ConvertTo-Html -Head $style


Write-host "Total Number of Large Lists Found:"$LargeListsResult.Count -f Green
#Get outgoing Email Server
$EmailServer = (Get-SPWebApplication -IncludeCentralAdministration | Where { $_.IsAdministrationWebApplication } ) | %{$_.outboundmailserviceinstance.server} | Select Address
$From = "jayaraja@sharepointlovers.com"
$To = "jayaraja@sharepointlovers.com"
$Subject = "List Threshold Inventory Report as on: "+$ReportDate 
$Body = "Below is the List Threshold Report as on $ReportDate <br><br><br>" + $EmailBody
#Send Email
Send-MailMessage -smtpserver $EmailServer.Address -from $from -to $to -subject $subject -body $body -BodyAsHtml
