program prj_TestPalTransport;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, FrmPalTransport, frmPalPoolMain, unt_MPBase
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(Tfrm_PalTransport, frm_PalTransport);
  Application.Run;
end.

