# comprobar_antes_de_subir.ps1 · Busca datos que NO deberían acabar en GitHub (Windows)
# Uso:  powershell -ExecutionPolicy Bypass -File .\comprobar_antes_de_subir.ps1 -Ruta ..
param([string]$Ruta = "..")
$ficheros = Get-ChildItem -Path $Ruta -Recurse -File | Where-Object { $_.FullName -notmatch '\\\.git\\|_herramientas' }
$n = 0
foreach ($f in $ficheros) {
  $ips = Select-String -Path $f.FullName -Pattern '\b(\d{1,3}\.){3}\d{1,3}\b' -AllMatches |
         Where-Object { $_.Matches.Value -notmatch '^(127\.0\.0\.1|0\.0\.0\.0|255\.)' }
  foreach ($m in $ips) { Write-Host "IP?   $($f.Name):$($m.LineNumber)  $($m.Line.Trim())" -ForegroundColor Yellow; $n++ }
  $pw = Select-String -Path $f.FullName -Pattern '(password|passwd|contraseña)\s*[:=]\s*\S{4,}' |
        Where-Object { $_.Line -notmatch 'cambia|ejemplo|example|<|\$\{|db_pass|_PASS' }
  foreach ($m in $pw) { Write-Host "CLAVE? $($f.Name):$($m.LineNumber)  $($m.Line.Trim())" -ForegroundColor Red; $n++ }
  if ($f.Name -in @('.env','config.php','wg0.conf') -or $f.Extension -eq '.pem') { Write-Host "SECRETO: $($f.FullName)" -ForegroundColor Red; $n++ }
}
if ($n -eq 0) { Write-Host "OK: no he encontrado nada sospechoso." -ForegroundColor Green } else { Write-Host "Revisa los $n avisos antes de subir." }
