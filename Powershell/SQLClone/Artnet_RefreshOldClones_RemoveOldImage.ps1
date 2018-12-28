# 'refresh' all clones to use a newer image
Connect-SqlClone -ServerUrl 'http://artnet-ny-tcagent:14145'
$date= (Get-Date).AddDays(-6)

 
$oldImages = (Get-SqlCloneImage  -Name 'Artnet*' | Where-Object {$_.CreatedDate -lt  $date})

foreach ($oldImage in $oldImages)
{

$newImage = (Get-SqlCloneImage  -Name 'Artnet*' | Select-Object -First 1 )
 
$oldClones = Get-SqlClone | Where-Object {$_.ParentImageId -eq $oldImage.Id -and $_.Name -ne 'Artnet_Dev10' -and $_.Name -ne 'Artnet_Green'}
 
foreach ($clone in $oldClones)
{
    $thisDestination = Get-SqlCloneSqlServerInstance | Where-Object {$_.Id -eq $clone.LocationId}
 
    Remove-SqlClone $clone | Wait-SqlCloneOperation
 
    "Removed clone ""{0}"" from instance ""{1}"" " -f $clone.Name , $thisDestination.Server + '\' + $thisDestination.Instance;  
 
    $newImage | New-SqlClone -Name $clone.Name -Location $thisDestination  | Wait-SqlCloneOperation
 
    "Added clone ""{0}"" to instance ""{1}"" " -f $clone.Name , $thisDestination.Server + '\' + $thisDestination.Instance;  
  
  
  #Identify Database to Run Sanitization Script
    IF ($clone.Name -like '*Dev*'){
        $hostName='10.5.1.130'
    }
    ELSEIF ($clone.Name -like '*Black*' -or $clone.Name -like '*White*'){
        $hostName='10.7.1.131'
    }
    ELSE {
        $hostName='10.7.1.130'
    }

    "Hostname Selected:" + $hostName

    #Run Sanitization
$Query = "EXEC sp_start_job Restore_"+$clone.Name+"_CLONE"
$WaitQuery = "WHILE (1=1) BEGIN IF EXISTS(select 1 from msdb.dbo.sysjobs_view job inner join msdb.dbo.sysjobactivity activity on job.job_id = activity.job_id where activity.run_Requested_date is not null and activity.stop_execution_date is null and job.name = 'Restore_"+$clone.Name+"_CLONE') BEGIN WAITFOR DELAY '00:00:05.000'; END ELSE break; END"

Invoke-Sqlcmd -ServerInstance $hostName -Database "msdb" -Query $Query -QueryTimeout 18000
Invoke-Sqlcmd -ServerInstance $hostName -Database "msdb" -Query $WaitQuery -QueryTimeout 18000


}
# Remove the old image
IF (-not [string]::IsNullOrEmpty($oldImage)) {

$oldClones = Get-SqlClone | Where-Object {$_.ParentImageId -eq $oldImage.Id -and $_.Name} 

 IF (-not [string]::IsNullOrEmpty($oldClones)) {

 echo 'Clone Still Exists - Image was not Removed'

 }
ELSE {
Remove-SqlCloneImage -Image $oldImage;
}
}
}