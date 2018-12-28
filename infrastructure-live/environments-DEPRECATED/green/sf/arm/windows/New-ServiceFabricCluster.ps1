[CmdletBinding()]
param (
    $SubscriptionId    = "08346c6c-bd12-45ad-8717-ba1c28f94648",
    $Location          = "eastus",
    $ResourceGroupName = "rg-sf01-green",
    $ProjectTag        = "DevOps",
    $EnvironmentTag    = "green"
)

$ErrorActionPreference = "Stop"

Login-AzureRmAccount

Select-AzureRmSubscription -Subscription $SubscriptionId

$timeStamp = Get-Date -Date ((Get-Date).ToUniversalTime()) -UFormat %Y-%m-%dT%H:%M:%SZ
$user = $env:USERNAME

$tags = @{ user = $user; project = $ProjectTag; created = $timeStamp; environment = $EnvironmentTag }

New-AzureRmResourceGroup -Name $ResourceGroupName -Location $Location -Tag $tags

$timeStampNoSpecialChars = Get-Date -Date ((Get-Date).ToUniversalTime()) -UFormat %Y%m%dT%H%M%SZ
$deploymentName = "${ResourceGroupName}-deployment-${timeStampNoSpecialChars}"
New-AzureRmResourceGroupDeployment -Name $deploymentName -ResourceGroupName $ResourceGroupName `
   -TemplateFile sf-win-template.json -TemplateParameterFile sf-win-parameters.json