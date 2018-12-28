# 'refresh' all clones to use a newer image
Connect-SqlClone -ServerUrl 'http://artnet-ny-tcagent:14145'
$date= (Get-Date).AddDays(-6)

 
$oldImages = (Get-SqlCloneImage  -Name 'AOA*' | Where-Object {$_.CreatedDate -lt  $date})

$Images = $oldImages.name
$String = ''

foreach ($oldImage in $oldImages)
{


$oldClones = Get-SqlClone | Where-Object {$_.ParentImageId -eq $oldImage.Id -and $_.Name -ne 'AOA_Dev10' -and $_.Name -ne 'AOA_Green'}
 
IF (-not [string]::IsNullOrEmpty($oldClones)) {

$String = $String +  '


' + 'Image Being Removed: ' + $oldImage.name + '

'

 foreach ($clone in $oldClones)
{

$String = $String + $clone.Name + '
'

}


 }





 }

 IF (-not [string]::IsNullOrEmpty($String)){
 $String=$String + '
 
 Please be sure to run the build for your environment if not done so already.
 
 
 Thank You,

 SQL Clone
 ART-SQLUTILITY1'

Send-MailMessage -SmtpServer 192.168.1.2 -Body $String -Subject 'SQLClone - Database Provisioning this Weekend' -From 'SQL@artnet.com' -To 'mpatel@artnet.com'

}