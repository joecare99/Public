program fpcTestKingdom;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, tst_KingdomEng, cls_KingdomEng,
  unt_KingdomBase, tst_KingdomFrm, frm_KingdomMain;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

