
# ==========================================================
# SCRIPT AUTOMATISE DE CONTROLE QUALITE
# Projet : DevOps-Quality
# ==========================================================

$ErrorActionPreference = "Continue"

# Chemins du projet
$ProjectRoot = $PSScriptRoot
$VenvPython = Join-Path $ProjectRoot "venv\Scripts\python.exe"
$Ruff = Join-Path $ProjectRoot "venv\Scripts\ruff.exe"
$DemoPath = Join-Path $ProjectRoot "tests-demo"
$AppFile = Join-Path $DemoPath "app.py"

# Gestion des resultats
$Failures = 0

# Toujours executer depuis la racine du projet
Push-Location $ProjectRoot

function Invoke-Check {
    param (
        [string]$Name,
        [scriptblock]$Command
    )

    Write-Host ""
    Write-Host "==================================================" -ForegroundColor Cyan
    Write-Host "CONTROLE : $Name" -ForegroundColor Cyan
    Write-Host "==================================================" -ForegroundColor Cyan

    & $Command

    if ($LASTEXITCODE -ne 0) {
        Write-Host "[ECHEC] $Name" -ForegroundColor Red
        $script:Failures++
    }
    else {
        Write-Host "[SUCCES] $Name" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "DEMARRAGE DES CONTROLES QUALITE" -ForegroundColor Yellow

# 1. Ruff
Invoke-Check "RUFF - Analyse statique" {
    & $Ruff check $DemoPath
}

# 2. Black
Invoke-Check "BLACK - Formatage" {
    & $VenvPython -m black --check $DemoPath
}

# 3. Bandit
Invoke-Check "BANDIT - Securite du code" {
    & $VenvPython -m bandit -r $DemoPath -x "*/test_*.py"
}

# 4. Pytest et couverture
$CoverageMinimum = 80

# 4. Pytest et couverture minimale de 80 %
Invoke-Check "PYTEST - Tests et couverture" {
    & $VenvPython -m pytest $DemoPath --cov=app --cov-report=term-missing --cov-fail-under=$CoverageMinimum
}

# 5. pip-audit
Invoke-Check "PIP-AUDIT - Vulnerabilites des dependances" {
    & $VenvPython -m pip_audit
}

# Resume
Write-Host ""
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "RESUME DES CONTROLES" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan

if ($Failures -eq 0) {
    Write-Host "TOUS LES CONTROLES SONT VALIDES !" -ForegroundColor Green
}
else {
    Write-Host "$Failures CONTROLE(S) EN ECHEC." -ForegroundColor Red
}

Pop-Location

# Code de sortie pour une future integration CI/CD
if ($Failures -gt 0) {
    exit 1
}
else {
    exit 0
}
