@echo off
setlocal enabledelayedexpansion

set "SESSIONS_FILE=server_list.txt"

REM Read the list of sessions and open each one
for /f "tokens=*" %%a in (%SESSIONS_FILE%) do (
    start SuperPutty.exe -sessionname "%%a"
    timeout /t 1 >nul
)

echo "Sessions opened."
