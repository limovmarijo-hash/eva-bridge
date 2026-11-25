[CmdletBinding(SupportsShouldProcess = $true)]
param(
  [string]$TaskName = 'EVA - ChatGPT automatic activation',
  [string]$Root = "$env:USERPROFILE\EVA-Automation"
)
$ErrorActionPreference = 'Stop'
$BackupDir = Join-Path $Root 'TaskBackups'
New-Item -ItemType Directory -Force -Path $BackupDir | Out-Null

$matches = @(Get-ScheduledTask -TaskName $TaskName -ErrorAction Stop)
if ($matches.Count -ne 1) {
  throw "Ocekivan je tocno jedan zadatak '$TaskName'; pronadjeno: $($matches.Count). Nista nije promijenjeno."
}
$task = $matches[0]
$taskPath = $task.TaskPath
$originalXml = Export-ScheduledTask -TaskName $TaskName -TaskPath $taskPath
[xml]$doc = $originalXml
$nsUri = $doc.DocumentElement.NamespaceURI
$ns = New-Object System.Xml.XmlNamespaceManager($doc.NameTable)
$ns.AddNamespace('t', $nsUri)
$triggersNode = $doc.SelectSingleNode('/t:Task/t:Triggers', $ns)
if (-not $triggersNode) { throw 'Task XML nema Triggers element; nista nije promijenjeno.' }

$existing = @($triggersNode.ChildNodes | Where-Object { $_.NodeType -eq [System.Xml.XmlNodeType]::Element })
$isAlreadySet = $false
if ($existing.Count -eq 1 -and $existing[0].LocalName -eq 'CalendarTrigger') {
  $rep = $existing[0].SelectSingleNode('t:Repetition', $ns)
  $interval = if ($rep -and $rep.SelectSingleNode('t:Interval', $ns)) { $rep.SelectSingleNode('t:Interval', $ns).InnerText } else { '' }
  $duration = if ($rep -and $rep.SelectSingleNode('t:Duration', $ns)) { $rep.SelectSingleNode('t:Duration', $ns).InnerText } else { '' }
  $days = $existing[0].SelectSingleNode('t:ScheduleByDay/t:DaysInterval', $ns)
  $start = $existing[0].SelectSingleNode('t:StartBoundary', $ns)
  $isAlreadySet = ($interval -eq 'PT2H' -and $duration -eq 'P1D' -and $days -and
    $days.InnerText -eq '1' -and $start -and $start.InnerText -match 'T00:00:00$')
}
if ($isAlreadySet) {
  Write-Host 'EVA_SCHEDULE_ALREADY_TWO_HOURLY'
  exit 0
}

$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$backupName = "$($TaskName -replace '[^A-Za-z0-9_-]','_')-$stamp.xml"
$backupPath = Join-Path $BackupDir $backupName
[System.IO.File]::WriteAllText($backupPath, $originalXml, [System.Text.UTF8Encoding]::new($true))

# Replace only triggers; retain exported actions, principal, settings, and other task properties.
while ($triggersNode.HasChildNodes) { [void]$triggersNode.RemoveChild($triggersNode.FirstChild) }
$trigger = $doc.CreateElement('CalendarTrigger', $nsUri)
$repetition = $doc.CreateElement('Repetition', $nsUri)
foreach ($pair in @(@('Interval','PT2H'), @('Duration','P1D'), @('StopAtDurationEnd','false'))) {
  $node = $doc.CreateElement($pair[0], $nsUri)
  $node.InnerText = $pair[1]
  [void]$repetition.AppendChild($node)
}
[void]$trigger.AppendChild($repetition)
$startNode = $doc.CreateElement('StartBoundary', $nsUri)
$startNode.InnerText = (Get-Date -Format 'yyyy-MM-dd') + 'T00:00:00'
[void]$trigger.AppendChild($startNode)
$enabledNode = $doc.CreateElement('Enabled', $nsUri)
$enabledNode.InnerText = 'true'
[void]$trigger.AppendChild($enabledNode)
$byDay = $doc.CreateElement('ScheduleByDay', $nsUri)
$daysNode = $doc.CreateElement('DaysInterval', $nsUri)
$daysNode.InnerText = '1'
[void]$byDay.AppendChild($daysNode)
[void]$trigger.AppendChild($byDay)
[void]$triggersNode.AppendChild($trigger)

if ($PSCmdlet.ShouldProcess("$taskPath$TaskName", 'Postavi aktivaciju svakih 2 sata (00:00-22:00)')) {
  Register-ScheduledTask -TaskName $TaskName -TaskPath $taskPath -Xml $doc.OuterXml -Force | Out-Null

  try {
    $afterXml = Export-ScheduledTask -TaskName $TaskName -TaskPath $taskPath
    [xml]$after = $afterXml
    $afterNs = New-Object System.Xml.XmlNamespaceManager($after.NameTable)
    $afterNs.AddNamespace('t', $after.DocumentElement.NamespaceURI)
    $afterTrigger = $after.SelectSingleNode('/t:Task/t:Triggers/t:CalendarTrigger', $afterNs)
    if (-not $afterTrigger) { throw 'Nedostaje CalendarTrigger nakon upisa.' }
    $afterInterval = $afterTrigger.SelectSingleNode('t:Repetition/t:Interval', $afterNs).InnerText
    $afterDuration = $afterTrigger.SelectSingleNode('t:Repetition/t:Duration', $afterNs).InnerText
    $afterStart = $afterTrigger.SelectSingleNode('t:StartBoundary', $afterNs).InnerText
    $afterActions = $after.SelectSingleNode('/t:Task/t:Actions', $afterNs).OuterXml
    $beforeActions = $doc.SelectSingleNode('/t:Task/t:Actions', $ns).OuterXml
    $afterPrincipalNode = $after.SelectSingleNode('/t:Task/t:Principals', $afterNs)
    $beforePrincipalNode = $doc.SelectSingleNode('/t:Task/t:Principals', $ns)
    $afterPrincipal = if ($afterPrincipalNode) { $afterPrincipalNode.OuterXml } else { '' }
    $beforePrincipal = if ($beforePrincipalNode) { $beforePrincipalNode.OuterXml } else { '' }
    if ($afterInterval -ne 'PT2H' -or $afterDuration -ne 'P1D' -or
        $afterStart -notmatch 'T00:00:00$' -or $afterActions -ne $beforeActions -or
        $afterPrincipal -ne $beforePrincipal) {
      throw 'Post-write verification failed.'
    }
  } catch {
    Register-ScheduledTask -TaskName $TaskName -TaskPath $taskPath -Xml $originalXml -Force | Out-Null
    throw "Provjera nije prosla; izvorni zadatak je vracen. Backup: $backupPath. Detalj: $($_.Exception.Message)"
  }

  Write-Host 'EVA_SCHEDULE_TWO_HOURLY_VERIFIED'
  Write-Host 'Aktivacije: 00:00, 02:00, 04:00, ... 22:00 (lokalno vrijeme racunala).'
  Write-Host "Backup: $backupPath"
  Write-Host 'Akcija i principal zadatka sacuvani su i provjereni.'
}
