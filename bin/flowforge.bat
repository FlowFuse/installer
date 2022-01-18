@echo off

SETLOCAL

set F_DRIVE=%~d0
set F_PATH=%~dp0

%F_DRIVE%
cd %F_PATH%

.\node_modules\.bin\flowforge.cmd

