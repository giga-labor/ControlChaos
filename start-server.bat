@echo off
setlocal

cd /d "%~dp0"

set "PORT=8000"
set "HOST=localhost"

where py >nul 2>nul
if %errorlevel%==0 (
  echo Avvio server locale su http://%HOST%:%PORT%/
  py -m http.server %PORT%
  goto :eof
)

where python >nul 2>nul
if %errorlevel%==0 (
  echo Avvio server locale su http://%HOST%:%PORT%/
  python -m http.server %PORT%
  goto :eof
)

echo Python non trovato.
echo Installa Python 3 e riavvia questo script.
pause
exit /b 1
