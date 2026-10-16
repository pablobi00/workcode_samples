# environmental variables

$ctx = New-AzStorageContext -StorageAccountName '<storage acocunt>' -StorageAccountKey '<keys>'

$localSrcFile =  "/Users/pablobarcenas/temporal/file1m"
$filesystemName = "pablob-live-source-a"
$destDirname = “more-data/“

# loop to upload the files - will start at 1 and then loop while i is less or equal to the value

for (($i = 1); $i -le  3; $i++)
{
    $localDestFile = “file1m$i"
    $destPath = $destDirname + ($localDestFile)
    New-AzDataLakeGen2Item -Context $ctx -FileSystem $filesystemName -Path $destPath -Source $localSrcFile -Force
    Write-Host "`nUploaded $localSrcFile to $destPath`n" -ForegroundColor Cyan -BackgroundColor Black
}

Write-Host "`n======= [EOF] =======`n" -ForegroundColor Cyan -BackgroundColor Black