robocopy "\\artimages.c1.artnet.com\x$\www\artnet.com\" "\\imagesfs.qa.artnet.local\x$\www\artnet.com\" /E /XO /R:2 /W:2 /XF *.config *.conf ".DS_Store" *.asp *.log *.dll *.bac *.tmp *.exe *.zip *.rar *.db /XD  "System Volume Information" "Recycled" "RECYCLER" "DfsrPrivate" ".DS_Store" "$RECYCLE.BIN" /NS /NC /NFL /NDL /MT:32 /LOG+:C:\Excludelist\xdrive.log
$body = Get-Content C:\Excludelist\xdrive.log
Send-MailMessage -SmtpServer 192.168.1.2 -From artnet-nls@artnet.com -To melsaiedy@artnet.com -Body "$body" -Subject "XDrive Copy Status"
remove-item C:\Excludelist\xdrive.log -force