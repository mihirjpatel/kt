robocopy "\\10.8.2.77\n$\WWW\WWWROOT\news.artnet.com\news-upload" "\\imagesfs.qa.artnet.local\W$\www\news.artnet.com\news-upload\" /E /XO /R:2 /W:2 /TEE /LOG:c:\excludelist\newscom.log
sleep 10
robocopy "\\10.8.2.77\n$\WWW\WWWROOT\artnetnews.cn\news-upload" "\\imagesfs.qa.artnet.local\W$\www\artnetnews.cn\news-upload\" /E /XO /R:2 /W:2 /TEE /LOG:c:\excludelist\newscn.log
sleep 10
robocopy "\\10.8.2.77\n$\WWW\WWWROOT\IMAGE_UPLOAD" "\\imagesfs.qa.artnet.local\W$\www\artnet.com\wwwroot\IMAGE_UPLOAD" /E /XO /R:2 /W:2 /TEE /LOG:c:\excludelist\imageupload.log