@echo off
SETLOCAL EnableDelayedExpansion
title FlowFuse Installer

REM #### Setup the environment ####################################
set MIN=18
set VERSION=Unknown
set NPMMIN=8
set NPMVERSION=Unknown


REM #### Print header #############################################
echo **************************************************************
echo *                                                            *
echo *                    FlowFuse Installer                      *
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
echo * Installing FlowFuse...                                     *
title FlowFuse Installer - Installing

REM Clean up before install
cd app
if exist node_modules rd /q /s node_modules
if exist package-lock.json del /q package-lock.json

REM #### Install FlowFuse #########################################
call npm install --production --no-fund --no-audit --silent 
cd ..
copy /Y app\node_modules\@flowfuse\flowfuse\etc\flowforge.yml etc > nul
copy /Y app\node_modules\@flowfuse\file-server\etc\flowforge-storage.yml etc > nul
call :PRINT "> FlowFuse Install Complete"

REM #### Install Node-RED Stack ###################################
echo *                                                            *
echo * Installing latest Node-RED as a stack...                   *
call bin\ff-install-stack.bat latest
call :PRINT "> Node-RED Stack Install Complete"


REM #### All done, print final part ###############################
echo *                                                            *
echo * FlowFuse  can be started with bin\flowfuse.bat             *
echo *                                                            *
echo **************************************************************

title FlowFuse Installer - Complete
goto :the_end


REM #### NodeJS Problem ###########################################
:node_problem
title FlowFuse Installer - NodeJS Problem
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
title FlowFuse Installer - NPM Problem
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
