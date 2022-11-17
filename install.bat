@echo off
SETLOCAL EnableDelayedExpansion

REM minimum NodeJS version
set MIN=16

echo **************************************************************
echo * FlowForge Installer                                        *
echo *                                                            *
echo **************************************************************

where node >nul 2>nul
IF %ERRORLEVEL% NEQ 0 (
  echo No NodeJS Found
  pause
  exit 1
) else (
  echo NodeJS Found
  FOR /F "tokens=1delims=v." %%i in ('node --version') do (
    set VERSION=%%i
  )
  if !VERSION! GEQ %MIN% (
    echo **************************************************************
    echo * NodeJS Version 16 or newer found                           *
    echo **************************************************************
  ) else (
    echo **************************************************************
    echo * NodeJS 16 or newer required                                *
    echo * NodeJS !VERSION!                                                    *
    echo * Please install latest LTS release from                     *
    echo * https://nodejs.org/en/download/                            *
    echo * And ensure to install build tools when asked               *
    echo **************************************************************
    pause
    exit /B 1
  )
)

where npm >nul 2>nul
IF %ERRORLEVEL% NEQ 0 (
  echo **************************************************************
  echo * No npm found exiting                                       *
  echo **************************************************************
  pause
  exit /B 1
) else (
  echo **************************************************************
  echo * npm found                                                  *
  echo **************************************************************
  call npm --version
)

REM clean up for upgrades
cd app
rd /q /s node_modules
del /q package-lock.json

echo **************************************************************
echo * Installing FlowForge                                       *
echo **************************************************************

call npm install --production --no-fund --no-audit --silent 

cd ..
copy app\node_modules\@flowforge\flowforge\etc\flowforge.yml etc

echo **************************************************************
echo * Installing lastest Node-RED as a stack                     *
echo **************************************************************
bin\ff-install-stack.bat latest


echo **************************************************************
echo * Installed FlowForge                                        *
echo * Start with bin\flowforge.bat
echo **************************************************************

pause