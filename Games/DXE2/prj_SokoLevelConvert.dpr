program prj_SokoLevelConvert;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$ENDIF}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  {$IFDEF FPC}
  Interfaces, // this includes the LCL widgetset
  {$ENDIF}
  Forms,
  unt_cdate in 'c:\unt_CDate.pas',
  frmSokoLevelConvert in '..\Source\frmSokoLevelConvert.pas',
  LoadLevelsetUnit in '..\Sokoban\LoadLevelsetUnit.pas',
  sokoengine in '..\Sokoban\sokoengine.pas'
  { you can add units after this };

{$R *.res}

begin
  {$IFDEF FPC}
  RequireDerivedFormResource := True;
  {$ENDIF}
  Application.Initialize;
  Application.CreateForm(TfrmConvertLevelData, frmConvertLevelData);
  Application.Run;
end.

