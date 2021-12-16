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
    echo * Please install latest LTS release from                     *
    echo * https://nodejs.org/en/download/                            *
    echo * And ensure to install build tools when asked               *
    echo **************************************************************
    exit /B 1
  )
)

where npm >nul 2>nul
IF %ERRORLEVEL% NEQ 0 (
  echo **************************************************************
  echo * No npm found exiting                                       *
  echo **************************************************************
  exit /B 1
) else (
  echo **************************************************************
  echo * npm found                                                  *
  echo **************************************************************
  call npm --version
)

REM clean up for upgrades
rd /q /s node_modules
del /q package-lock.json

echo **************************************************************
echo * Installing FlowForge                                       *
echo **************************************************************

npm install --production --@flowforge:registry=https://npm.hardill.me.uk
