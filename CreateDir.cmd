rem @echo off
md %1
echo # %~n1>%1\ReadMe.md
pause
svn add %1
svn commit -F nul
move %1\ReadMe.md %2
rmdir %1
v:\INSTALL\disk\Junction\junction.exe %1 %2
