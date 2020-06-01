Add-PSSnapin microsoft.sharepoint.powershell
$tssa=$SC_RC = get-SPEnterpriseSearchServiceApplication -Identity GUIDofSSA
foreach($ts in $tssa)
{


$ssa =$ts
 $content_sources = Get-SPEnterpriseSearchCrawlContentSource -SearchApplication $ssa
 $sthr=18
 $stMin=00
 $lsthr=18
 $lMin=0
foreach($content_source in $content_sources)
{
write-host $content_source.name
if($lsthr -eq 24){$lsthr=0}

$settime="$lsthr : $lMin"

#$content_source|Set-SPEnterpriseSearchCrawlContentSource -ScheduleType Incremental -DailyCrawlSchedule -CrawlScheduleRunEveryInterval 1 -CrawlScheduleRepeatInterval 30 -CrawlScheduleRepeatDuration 1440 -CrawlScheduleStartDateTime $settime -Confirm:$false
$content_source|Set-SPEnterpriseSearchCrawlContentSource -ScheduleType Incremental -DailyCrawlSchedule -CrawlScheduleRunEveryInterval 1 -CrawlScheduleStartDateTime $settime -Confirm:$false
#$content_source.IncrementalCrawlSchedule=$null
$content_source.Update()


if($lsthr -eq 08){$lsthr =18}
else{$lsthr+=1}

if($lMin -eq 0){$lMin+=30}
elseif($lMin -eq 30){$lMin=00}
}

}
