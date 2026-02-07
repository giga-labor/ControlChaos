@echo off
setlocal

rem Upload rapido della repo SECC dove risiede questa cartella bat.
rem Uso:
rem   bat\upload-secc.bat
rem   bat\upload-secc.bat "messaggio commit personalizzato"

set "REPO_DIR=%~dp0.."
for %%I in ("%REPO_DIR%") do set "REPO_DIR=%%~fI"

pushd "%REPO_DIR%" >nul 2>&1
if errorlevel 1 (
  echo [ERRORE] Impossibile accedere a "%REPO_DIR%"
  exit /b 1
)

git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 (
  echo [ERRORE] La cartella non e una repo git: "%REPO_DIR%"
  popd >nul
  exit /b 1
)

set "MSG=%~1"
if "%MSG%"=="" (
  set "MSG=chore: quick upload site updates"
)

echo [INFO] Repo: %REPO_DIR%
echo [INFO] Branch corrente:
git branch --show-current

echo [INFO] Stato pre-upload:
git status --short

git add -A
git diff --cached --quiet
if errorlevel 1 goto commit_push

echo [INFO] Nessuna modifica da caricare.
popd >nul
exit /b 0

:commit_push
git commit -m "%MSG%"
if errorlevel 1 (
  echo [ERRORE] Commit fallito.
  popd >nul
  exit /b 1
)

for /f %%B in ('git branch --show-current') do set "CUR_BRANCH=%%B"
if "%CUR_BRANCH%"=="" set "CUR_BRANCH=main"

git push origin "%CUR_BRANCH%"
if errorlevel 1 (
  echo [ERRORE] Push fallito su origin/%CUR_BRANCH%
  popd >nul
  exit /b 1
)

echo [OK] Upload completato su origin/%CUR_BRANCH%
popd >nul
exit /b 0
