﻿
#Create Image
Connect-SqlClone -ServerUrl 'http://artnet-ny-tcagent:14145'
$backupLocation = Get-SqlCloneBackupLocation -Path '\\10.7.2.130\C$'
$imageDestination = Get-SqlCloneImageLocation -Path '\\10.7.2.130\s$\SQLClone\Image'

$imageOperation = New-SqlCloneImage -Name "Artnet-$(Get-Date -Format yyyyMMdd)" `
-BackupLocation $backupLocation `
-BackupFileName @('Artnet.bak') `
-Destination $imageDestination

$imageOperation | Wait-SqlCloneOperation
