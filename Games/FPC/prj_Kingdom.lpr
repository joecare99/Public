program prj_Kingdom;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  DefaultTranslator,
  Forms, unt_KingdomBase, cls_KingdomEng, frm_KingdomMain, uScaleDPI
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TfrmKingdomMain, frmKingdomMain);
  uScaleDPI.AutoAdjustAllForms;
  Application.Run;
end.

