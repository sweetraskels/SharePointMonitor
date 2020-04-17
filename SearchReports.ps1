Add-PSSnapin Microsoft.SharePoint.Powershell -ErrorAction SilentlyContinue
 
$SC = get-SPEnterpriseSearchServiceApplication -Identity "Enter the guid of the Search Services"

#Get all content sources
$ContentSources_RC = Get-SPEnterpriseSearchCrawlContentSource -SearchApplication $SC

$ReportDate = Get-Date -format "dd-MM-yyyy"
 
#CSS Styles for the Table
$style = "Crawl History Report: "
$style = $style + "<style>BODY{font-family: Arial; font-size: 10pt;}"
$style = $style + "TABLE{border: 1px solid black; }"
$style = $style + "TH{border: 1px solid black; background: #dddddd; padding: 5px; }"
$style = $style + "TD{border: 1px solid black; padding: 2px; }"
$style = $style + "</style>"
 
 
#Frame Email body
$RC_EmailBody = $ContentSources_RC | Select Name,CrawlState,@{label="CrawlDuration";expression={$_.CrawlCompleted - $_.CrawlStarted}},CrawlStarted,CrawlCompleted , SuccessCount, WarningCount, ErrorCount  | ConvertTo-Html -Head $style
#Set Email configurations
 
#Get outgoing Email Server
$EmailServer = (Get-SPWebApplication -IncludeCentralAdministration | Where { $_.IsAdministrationWebApplication } ) | %{$_.outboundmailserviceinstance.server} | Select Address
 
$From = "jayaraja@sharepointlovers.com"
$To = "jayaraja@sharepointlovers.com"
$Subject = "Crawl History Report as on: "+$ReportDate
$Body = "Below is the Search Crawl Report as on $ReportDate <br><br><br>" + $RC_EmailBody + "<br><br>" 
#Send Email
Send-MailMessage -smtpserver $EmailServer.Address -from $from -to $to -subject $subject -body $body -BodyAsHtml

