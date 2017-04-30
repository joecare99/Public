program prj_SokoLevelConvert;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms,
  unt_cdate in 'c:\unt_CDate.pas',
  frmSokoLevelConvert,
  LoadLevelsetUnit,
  sokoengine
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TfrmConvertLevelData, frmConvertLevelData);
  Application.Run;
end.

