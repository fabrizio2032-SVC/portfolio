# subir_con_gh.ps1 · Crea un repositorio público por carpeta y lo sube a GitHub (Windows)
# Requisitos: Git for Windows y GitHub CLI (winget install GitHub.cli), y después:  gh auth login
# Uso:  powershell -ExecutionPolicy Bypass -File .\subir_con_gh.ps1
$Usuario = "fabrizio2032-SVC"
Set-Location (Split-Path $PSScriptRoot -Parent)

& "$PSScriptRoot\comprobar_antes_de_subir.ps1" -Ruta .
$r = Read-Host "¿Has revisado los avisos y quieres continuar? (s/N)"
if ($r -notmatch '^[sS]$') { exit 1 }

Get-ChildItem -Directory | Where-Object Name -ne '_herramientas' | ForEach-Object {
  $repo = $_.Name
  Write-Host "== $repo" -ForegroundColor Cyan
  Push-Location $_.FullName
  if (-not (Test-Path .git)) { git init -q -b main }
  git add -A
  git commit -qm "Primera versión de $repo"
  gh repo view "$Usuario/$repo" *> $null
  if ($LASTEXITCODE -eq 0) {
    git remote add origin "https://github.com/$Usuario/$repo.git" 2>$null
    git push -u origin main
  } else {
    $desc = (Get-Content README.md -TotalCount 1) -replace '^# ', ''
    gh repo create "$Usuario/$repo" --public --source . --remote origin --push --description "$desc"
  }
  Pop-Location
}
gh api -X POST "repos/$Usuario/portfolio/pages" -f "source[branch]=main" -f "source[path]=/" *> $null
if ($LASTEXITCODE -eq 0) { Write-Host "GitHub Pages activado en portfolio" } else { Write-Host "Activa Pages a mano en Settings > Pages" }
