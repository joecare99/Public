program prj_MemoEmptyLine;

{$IFDEF FPC}
{$MODE objfpc}{$H+}
{$ENDIF}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
 {$IFDEF FPC}
 Interfaces, // this includes the LCL widgetset
 {$ENDIF}
  Forms, {you can add units after this}
  frm_memoemptylinemain in '..\Source\MemoEmptyLine\frm_memoemptylinemain.pas';

{$IFDEF WINDOWS}{$R manifest.rc}{$ENDIF}

{$R *.res}

begin
{$IFDEF FPC}
  RequireDerivedFormResource := True;
  {$ENDIF}
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

