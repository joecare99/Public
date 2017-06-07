@echo off
if exist .\Backup\Backup%date:~-4%%date:~3,2%%date:~,2%.rar move .\Backup\Backup%date:~-4%%date:~3,2%%date:~,2%.rar .\Backup\Backup%date:~-4%%date:~3,2%%date:~,2%.bak
"%Programfiles%\Tools\winrar\rar" a -r .\Backup\Backup%date:~-4%%date:~3,2%%date:~,2%.rar @.\ToBackup.txt -x@.\exclude.txt