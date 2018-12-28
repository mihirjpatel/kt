# 'refresh' all clones to use a newer image
Connect-SqlClone -ServerUrl 'http://artnet-ny-tcagent:14145'
$date= (Get-Date).AddDays(-7)

 
$oldImage = (Get-SqlCloneImage  -Name 'AOA*' | Where-Object {$_.CreatedDate -lt  $date} | Select-Object -First 1)
$newImage = (Get-SqlCloneImage  -Name 'AOA*' | Select-Object -First 1 )
 
$oldClones = Get-SqlClone | Where-Object {$_.ParentImageId -eq $oldImage.Id}
 
foreach ($clone in $oldClones)
{
    $thisDestination = Get-SqlCloneSqlServerInstance | Where-Object {$_.Id -eq $clone.LocationId}
 
    Remove-SqlClone $clone | Wait-SqlCloneOperation
 
    "Removed clone ""{0}"" from instance ""{1}"" " -f $clone.Name , $thisDestination.Server + '\' + $thisDestination.Instance;  
 
    $newImage | New-SqlClone -Name $clone.Name -Location $thisDestination  | Wait-SqlCloneOperation
 
    "Added clone ""{0}"" to instance ""{1}"" " -f $clone.Name , $thisDestination.Server + '\' + $thisDestination.Instance;  
}
# Remove the old image
IF (-not [string]::IsNullOrEmpty($oldImage)) {
Remove-SqlCloneImage -Image $oldImage;
}