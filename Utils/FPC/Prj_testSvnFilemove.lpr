program Prj_testSvnFilemove;

uses Interfaces,
  SysUtils,
  unt_cdate in 'C:\unt_cdate.pas',
  Unt_FileMove in '..\Source\Unt_FileMove.pas',
  Cmp_SEWFile in '..\..\daten\Source\Cmp_SEWFile.pas';

begin
  Application.Init;
  Application.Title:='Test SVN-FileMove';
  Application.SvnMoveFile(paramstr(1),paramstr(2));
end.

