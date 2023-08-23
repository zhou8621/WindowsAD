$DCs = Get-ADDomainController -Filter *  # Get a list of all domain controllers
$OU = "OU=YourOU,DC=yourdomain,DC=com"   # Replace with the actual OU

foreach ($DC in $DCs) {
    $LogPath = "\\$($DC.Name)\Security"
    $Events = Get-WinEvent -LogName $LogPath -FilterXPath `
              "*[System[EventID=4722] and EventData[Data[@Name='TargetUserName']='$($AccountName)'] and EventData[Data[@Name='TargetDomainName']='$($DomainName)'] and EventData[Data[@Name='TargetOUName']='$OU']]"
    
    if ($Events) {
        Write-Host "Reactivation events found on $($DC.Name):"
        $Events | ForEach-Object {
            $EventTime = $_.TimeCreated
            $EventData = $_.Properties
            Write-Host "Event Time: $($EventTime), User: $($EventData[1].Value), Action: $($EventData[0].Value)"
        }
    }
}
