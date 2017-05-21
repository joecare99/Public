program prj_ShapedControls;

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
  Forms,
  unit1 in '..\Source\shapedcontrols\unit1.pas'
  { you can add units after this };

{$IFDEF WINDOWS}{$R manifest.rc}{$ENDIF}

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1,Form1);
  Application.Run;
end.

