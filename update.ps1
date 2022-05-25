$content = ( Invoke-WebRequest -Uri "https://raw.githubusercontent.com/ASIR2SIGB/SIGB/main/SIGB.ps1" -UseBasicParsing | Select-Object content); 
$content.content | Out-File "$ENV:USERPROFILE\APPDATA\Roaming\SIGB\SIGB.ps1" -Verbose:$true
Write-Host "INICIA EL ACCESO DIRECTO LLAMADO 'SIGB' UBICADO EN SU ESCRITORIO" -ForegroundColor green


Start-Sleep -Seconds 90