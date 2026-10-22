@echo off
If not "!test!"=="" goto restart

set DestP=%1
if "%1"=="" set /p DestP="Version: "
title "Generiere Projektverzeichniss"

cd /d %~dp0
for /D %%i in (Source\*) do call :CollProject %%i %DestP% ..\..\
pause

goto Ende
:restart
cmd /V:ON /C%0 %1
goto Ende
:CollProject 
if not exist %1\%2 goto Ende

echo %1: Copy from %2
for %%j in (%1\%2\*.dpr %1\%2\*.dpk) do call :Filter %%j %2 %1  
xcopy /D %1\%2\*.dproj %1\%3%2\ 
xcopy /D %1\%2\*.res %1\%3%2\ 
goto ReLink

:ReLink

goto ende
:Filter
echo Schreibe %2\%~nx1
if exist %2\%~nx1 goto Ende
for /F "delims=" %%k in (%1) do ( 
  Set line=%%k
  if "%%k"=="" echo. >> %2\%~nx1
  if not "%%k"=="" echo !line:'..\='..\%3\! >> %2\%~nx1
)
rem pause
:Ende
