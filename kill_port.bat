@echo off
setlocal enabledelayedexpansion

:: Define an array of port numbers
set PORTS=4001 5001 8080 9094 9095 9096 3008

:: Loop through the ports
for %%P in (%PORTS%) do (
    set PORT=%%P
    echo Checking for processes on port !PORT!
    
    :: Use netstat to find processes using the current port
    for /f "tokens=5" %%A in ('netstat -aon ^| findstr /r "\<!PORT!\>"') do (
        set PID=%%A
        
        :: Use taskkill to terminate the process
        taskkill /F /PID !PID! >nul 2>&1
        echo Terminated process !PID! using port !PORT!
    )
)
