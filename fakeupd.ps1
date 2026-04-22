Add-Type -AssemblyName PresentationFramework

while ($true) {
    [System.Windows.MessageBox]::Show(
        "Something went wrong. Please try again.",
        "System Error",
        "OK",
        "Error"
    )
}
