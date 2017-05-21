program prj_TestMPlayer;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, mplayercontrollaz,
  Frm_TestMPlayerMain
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.title := 'Test MPlayer - Project';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

