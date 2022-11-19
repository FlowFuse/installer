@echo off
SETLOCAL EnableDelayedExpansion
title FlowForge Installer

REM #### Setup the environment ####################################
set MIN=16
set VERSION=Unknown
set NPMMIN=8
set NPMVERSION=Unknown


REM #### Print header #############################################
echo **************************************************************
echo *                                                            *
echo *                    FlowForge Installer                     *
echo *                                                            *
echo **************************************************************


REM #### Check NodeJS #############################################
echo *                                                            *
echo * Checking NodeJS...                                         *
where node >nul 2>nul
IF %ERRORLEVEL% NEQ 0 (
  call :PRINT "> Not Found!"
  goto :node_problem
) else (
  FOR /F "tokens=1delims=v." %%i in ('node --version') do (
    set VERSION=%%i
  )
  call :PRINT "> Found version !VERSION!"
  if !VERSION! GEQ %MIN% (
    REM Success version OK, continue installation
  ) else (
    goto :node_problem
  )
)

REM #### Check NPM ################################################
echo *                                                            *
echo * Checking NPM...                                            *
where npm >nul 2>nul
IF %ERRORLEVEL% NEQ 0 (
  call :PRINT "> Not Found!"
  goto :npm_problem
) else (
  FOR /F "tokens=1delims=." %%i IN ('npm --version') DO (
    set NPMVERSION=%%i
  )
  call :PRINT "> Found version !NPMVERSION!"
  if !NPMVERSION! GEQ %NPMMIN% (
    REM Success version OK, continue installation
  ) else (
    goto :npm_problem
  )
)



REM #### Begin Installation #######################################
echo *                                                            *
echo * Installing FlowForge...                                    *
title FlowForge Installer - Installing

REM Clean up first
cd app
if exist node_modules rd /q /s node_modules
if exist package-lock.json del /q package-lock.json

call npm install --production --no-fund --no-audit --silent 

cd ..
copy /Y app\node_modules\@flowforge\flowforge\etc\flowforge.yml etc > nul

REM #### Print success notice #####################################
call :PRINT "> FlowForge Install Complete"
echo *                                                            *
echo * FlowForge can be started with bin\flowforge.bat            *
echo *                                                            *
echo **************************************************************
title FlowForge Installer - Complete
goto :the_end


REM #### NodeJS Problem ###########################################
:node_problem
title FlowForge Installer - NodeJS Problem
call :PRINT "> NodeJS version !MIN! or newer is required"
echo *   Please install latest LTS release from                   *
echo *   https://nodejs.org/en/download/                          *
echo *   And ensure to install build tools when asked             *
echo *                                                            *
echo **************************************************************
echo.
pause
exit /B 1


REM #### NPM Problem ##############################################
:npm_problem
title FlowForge Installer - NPM Problem
call :PRINT "> NPM version !NPMMIN! or newer is required"
echo *   Please check your NPM installation                       *
echo *                                                            *
echo **************************************************************
echo.
pause
exit /B 2


REM #### Print Subroutine #########################################
:PRINT
set "LINE=%~1                                                              "
echo * !LINE:~0,58! *
exit /b


REM #### The End ##################################################
:the_end
echo.
pause
