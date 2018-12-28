robocopy "\\artimages.c1.artnet.com\w$\www\artnet.com\" "\\imagesfs.qa.artnet.local\W$\www\artnet.com\" /E /XO /R:2 /W:2 /XF *.config *.conf ".DS_Store" *.asp *.log *.dll *.bac *.tmp *.exe *.zip *.rar *.db /XD  "System Volume Information" "Recycled" "RECYCLER" "DfsrPrivate" ".DS_Store" "$RECYCLE.BIN" /NS /NC /NFL /NDL /MT:32 /LOG+:C:\Excludelist\wdrive.log
$body = Get-Content C:\Excludelist\wdrive.log
Send-MailMessage -SmtpServer 192.168.1.2 -From artnet-nls@artnet.com -To melsaiedy@artnet.com -Body "$body" -Subject "WDrive Copy Status"
Remove-Item C:\Excludelist\wdrive.log -Force