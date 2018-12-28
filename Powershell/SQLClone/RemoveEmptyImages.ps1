# 'refresh' all clones to use a newer image
Connect-SqlClone -ServerUrl 'http://artnet-ny-tcagent:14145'
$date= (Get-Date).AddDays(-4)

 
$oldImages = (Get-SqlCloneImage | Where-Object {$_.CreatedDate -lt  $date})

foreach ($oldImage in $oldImages)
{


$oldClones = Get-SqlClone | Where-Object {$_.ParentImageId -eq $oldImage.Id}
 


# Remove the old image
IF (-not [string]::IsNullOrEmpty($oldImage)) {

$oldClones = Get-SqlClone | Where-Object {$_.ParentImageId -eq $oldImage.Id -and $_.Name} 

 IF ([string]::IsNullOrEmpty($oldClones)) {

 echo 'Removing Image: ' + $oldImage.name
 Remove-SqlCloneImage -Image $oldImage;

 }

}
}