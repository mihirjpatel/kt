# this is unfinished

# Login to Azure
Login-AzureRmAccount

# Get the access key for your storage account
$storageAccountKey = Get-AzureRmStorageAccountKey -ResourceGroupName 'rg-globals' -Name 'artnetdevteam'


# Create an Azure Storage context using the first access key
$storageContext = New-AzureStorageContext -StorageAccountName 'artnetdevteam' -StorageAccountKey $storageAccountKey[0].value

# Create a file share named 'resource-templates' in your Azure Storage account
$fileShare = New-AzureStorageShare -Name 'resource-templates' -Context $storageContext

# Add the TemplateTest.json file to the new file share
$templateFile = 'sf-win-template.json'
Set-AzureStorageFileContent -ShareName $fileShare.Name -Context $storageContext -Source $templateFile
