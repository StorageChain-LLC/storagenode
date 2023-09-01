@echo off

:: Remove IPFS data and logs
rmdir /s /q "%userprofile%\.ipfs"
rmdir /s /q "%userprofile%\.ipfs-cluster-follow"

@echo off

:: Specify the names of your batch scripts and log files
set "script1=script.bat"
set "script2=clusterconfig.bat"
set "script3=startup.bat"
set "log1=logs/log_script1.txt"
set "log2=logs/log_script2.txt"
set "log3=logs/log_script3.txt"

:: Run the first script and redirect its output to log1
start /wait cmd /c script.bat > "%log1%" 2>&1

:: Wait for 5 seconds
timeout /t 5 /nobreak
:: Run the second script and redirect its output to log2
start /wait cmd /c clusterconfig.bat > "%log2%" 2>&1

:: Run the second script and redirect its output to log2
start /wait cmd /c startup.bat > "%log3%" 2>&1

:: Print the contents of the log file of the last script (log2)
type "%log3%"
