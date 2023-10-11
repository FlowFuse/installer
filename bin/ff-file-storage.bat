@echo off

set F_DRIVE=%~d0
set F_PATH=%~dp0

%F_DRIVE%
cd %F_PATH%
cd ..
SET FLOWFORGE_HOME=%CD%

.\app\node_modules\.bin\ff-file-storage.cmd
