clear
Add-PSSnapin Microsoft.SharePoint.Powershell -ErrorAction SilentlyContinue

 
#CSS Styles for the Table
$style = "Site Collection Admin Report: "
$style = $style + "<style>BODY{font-family: Arial; font-size: 10pt;}"
$style = $style + "TABLE{border: 1px solid black; }"
$style = $style + "TH{border: 1px solid black; background: #dddddd; padding: 5px; }"
$style = $style + "TD{border: 1px solid black; padding: 2px; }"
$style = $style + "</style>"
$ReportDate = Get-Date -format "dd-MM-yyyy"

#Get All Site Collections
$SitesColl = Get-SPSite -Limit All

$AdminItemCollection = @()


 $SCA_EmailBody=$null
Foreach($Site in $SitesColl)
{
    $ExportItem = New-Object PSObject 
    $ExportItem | Add-Member -MemberType NoteProperty -name "SiteURL" -value $Site.Url
    $siteAdmin=$null
    Foreach ($tSiteAdmin in $Site.RootWeb.SiteAdministrators)
    {
    $siteAdmin +=$tSiteAdmin.Email +";"
    }
    $ExportItem | Add-Member -MemberType NoteProperty -name "Site Admin" -value $siteAdmin
   	$AdminItemCollection += $ExportItem
  
}

$EmailBody= $AdminItemCollection | ConvertTo-Html -Head $style



#Get outgoing Email Server
$EmailServer = (Get-SPWebApplication -IncludeCentralAdministration | Where { $_.IsAdministrationWebApplication } ) | %{$_.outboundmailserviceinstance.server} | Select Address


$From = "jayaraja@sharepointlovers.com"
$To = "jayaraja@sharepointlovers.com"
$Subject = "Site Collection Admin Report as on: "+$ReportDate
$Body = "Below is the Site Collection Admin Report as on $ReportDate <br><br><br>" + $EmailBody
#Send Email
Send-MailMessage -smtpserver $EmailServer.Address -from $from -to $to -subject $subject -body $body -BodyAsHtml
