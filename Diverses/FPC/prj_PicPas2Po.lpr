program prj_PicPas2Po;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, frm_PicPas2Po, unt_PoFile, fra_PoFile, unt_PicPasFile, fra_PicPasFile
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TfrmPicPas2PoMain, frmPicPas2PoMain);
  Application.Run;
end.

