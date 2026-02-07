@echo off
setlocal

rem Mostra versione SECC e numero sequenziale ultima estrazione.

set "REPO_DIR=%~dp0.."
for %%I in ("%REPO_DIR%") do set "REPO_DIR=%%~fI"

set "VERSION_FILE=%REPO_DIR%\assets\js\version.js"
set "DRAWS_FILE=%REPO_DIR%\archives\draws\draws.csv"

if not exist "%VERSION_FILE%" (
  echo [ERRORE] File versione non trovato: "%VERSION_FILE%"
  exit /b 1
)

if not exist "%DRAWS_FILE%" (
  echo [ERRORE] File estrazioni non trovato: "%DRAWS_FILE%"
  exit /b 1
)

for /f "usebackq delims=" %%V in (`powershell -NoProfile -Command "$line=Get-Content '%VERSION_FILE%' -TotalCount 1; $q=[char]39; $parts=$line.Split($q); if($parts.Length -ge 2){ $parts[1] }"`) do set "SECC_VERSION=%%V"

for /f "usebackq delims=" %%N in (`powershell -NoProfile -Command "$last=Get-Content '%DRAWS_FILE%' | Where-Object { $_.Trim() -ne '' } | Select-Object -Last 1; if($last){ ($last -split ',')[0].Trim() }"`) do set "LAST_SEQ=%%N"

if "%SECC_VERSION%"=="" set "SECC_VERSION=N/D"
if "%LAST_SEQ%"=="" set "LAST_SEQ=N/D"

echo SECC_VERSION=%SECC_VERSION%
echo LAST_DRAW_SEQ=%LAST_SEQ%

exit /b 0
