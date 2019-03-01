program GrueStew;

{$IFDEF FPC}
{$mode objfpc}{$H+}
{$ELSE}
{$E EXE}
{$EndIF}

uses
  {$IFDEF UNIX}
  {$IFDEF UseCThreads}
  cthreads,
  {$ENDIF }
  {$ENDIF }
  Classes,
  SysUtils,
  con_GrueStew in '..\source\GrueStew\con_GrueStew.pas',
  unt_GrueStewBase in '..\source\GrueStew\unt_GrueStewBase.pas',
  cls_GrueStewEng in '..\source\GrueStew\cls_GrueStewEng.pas',
  CustApp in '..\..\Components\Source\LazarusComp\CustApp.pas';

{$R *.res}

begin
  Application:=TMyApplication.Create(nil);
  Application.Title:='My Application';
  Application.Run;
  Application.Free;
end.

