[CmdletBinding()]
param (
    $SubscriptionId =    "08346c6c-bd12-45ad-8717-ba1c28f94648",
    $ResourceGroupName = "rg-sf01-green"
)

Login-AzureRmAccount

Select-AzureRmSubscription -Subscription $SubscriptionId

Remove-AzureRmResourceGroup -Name $ResourceGroupName