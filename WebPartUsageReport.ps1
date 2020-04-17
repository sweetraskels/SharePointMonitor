Add-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction SilentlyContinue
 #CSS Styles for the Table
$style = "WebPart Usage Report Collection Admin Report: "
$style = $style + "<style>BODY{font-family: Arial; font-size: 10pt;}"
$style = $style + "TABLE{border: 1px solid black; }"
$style = $style + "TH{border: 1px solid black; background: #8064a2; padding: 5px; }"
$style = $style + "TD{border: 1px solid black; padding: 2px; }"
$style = $style + "</style>"
$ReportDate = Get-Date -format "dd-MM-yyyy"

$WebAppsCollection = Get-SPWebApplication
 
#Array to Hold Result - PSObjects
$LargeListsResult = @()
 
foreach($WebApp in $WebAppsCollection)
{


#Configuration parameters
$SiteURL = $WebApp.Url
 
$ResultCollection = @()
 
#Get All Subsites in a site collection and iterate through each
$Site = Get-SPSite $SiteURL -Limit all
ForEach($Web in $Site.AllWebs)
{
    write-host Processing $Web.URL
    # If the Current Web is Publishing Web
    if ([Microsoft.SharePoint.Publishing.PublishingWeb]::IsPublishingWeb($Web))
    {
        #Get the Publishing Web
        $PubWeb = [Microsoft.SharePoint.Publishing.PublishingWeb]::GetPublishingWeb($Web)
                   
        #Get the Pages Library
        $PagesLib = $PubWeb.PagesList
     }
     else
     {
        $PagesLib = $Web.Lists["Site Pages"]
     }            
        #Iterate through all Pages 
        foreach ($Page in $PagesLib.Items | Where-Object {$_.Name -match ".aspx"})
        {
            $PageURL=$web.site.Url+"/"+$Page.File.URL
            $WebPartManager = $Page.File.GetLimitedWebPartManager([System.Web.UI.WebControls.WebParts.PersonalizationScope]::Shared)
                 
            #Get All Web Parts data
            foreach ($WebPart in $WebPartManager.WebParts)
            {
                $Result = New-Object PSObject
                $Result | Add-Member -type NoteProperty -name "Site URL" -value $web.Url
                $Result | Add-Member -type NoteProperty -name "Page URL" -value $PageURL
                $Result | Add-Member -type NoteProperty -name "Web Part Title" -value $WebPart.Title
                $Result | Add-Member -type NoteProperty -name "Web Part Type" -value $WebPart.GetType().ToString()
 
                $ResultCollection += $Result
            }
        }
}


}


$EmailBody= $ResultCollection | ConvertTo-Html -Head $style


Write-host "Total Number of Large Lists Found:"$LargeListsResult.Count -f Green
#Get outgoing Email Server
$EmailServer = (Get-SPWebApplication -IncludeCentralAdministration | Where { $_.IsAdministrationWebApplication } ) | %{$_.outboundmailserviceinstance.server} | Select Address
$From = "jayaraja@sharepointlovers.com"
$To = "jayaraja@sharepointlovers.com"
$Subject = "WebParts Usage Report as on: "+$ReportDate 
$Body = "Below is the WebPart Usages Report as on $ReportDate <br><br><br>" + $EmailBody
#Send Email
Send-MailMessage -smtpserver $EmailServer.Address -from $from -to $to -subject $subject -body $body -BodyAsHtml


