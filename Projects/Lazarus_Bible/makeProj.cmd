rem @echo off
set DestP=%1
if "%1"=="" set /p DestP="ZielProjekt: "
title "Generiere Projektverzeichniss"

cd /d %~dp0
for /D %%i in (Source\*) do call :DoProject %%i %DestP%
pause

goto Ende


:DoProject 
if exist %1\%2 goto Ende

:TryD_XE
if not exist %1\D_XE goto Try2010
if exist %1\D_XE\*.200? del %1\D_XE\*.200? >nul >nul
if exist %1\%2 goto Ende
echo %1: Copy from D_XE
xcopy /d %1\D_XE %1\%2\ 
goto Clean

:Try2010
if not exist %1\2010 goto Try2009
if exist %1\2010\*.200? del %1\2010\*.200? >nul >nul
if exist %1\%2 goto Ende
echo %1: Copy from 2010
xcopy /d %1\2010 %1\%2\ 
goto Clean

:Try2009
if not exist %1\2009 goto Try2007
if exist %1\2009\*.2007 del %1\2009\*.2007 >nul >nul
if exist %1\%2 goto Ende
echo %1: Copy from 2009
xcopy /d %1\2009 %1\%2\
goto Clean

:Try2007
if not exist %1\2007 goto Try2006
if exist %1\%2 goto Ende
echo %1: Copy from 2007
xcopy /d %1\2007 %1\%2\
goto Clean

:Try2006
if not exist %1\2006 goto Unable
if exist %1\%2 goto Ende
echo %1: Copy from 2006
xcopy /d %1\2006 %1\%2\
goto Clean

:Unable
if exist %1\%2 goto Ende
if not exist %1\*.pas goto Ende
echo %1: No Project found 
goto Clean

:Clean
if exist %1\%2\*.local del %1\%2\*.local >nul >nul
if exist %1\%2\*.identcache del %1\%2\*.identcache >nul >nul
if exist %1\%2\*.cfg del %1\%2\*.cfg >nul >nul
if exist %1\%2\*.Stat del %1\%2\*.Stat >nul >nul
:Ende
