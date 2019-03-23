program fpcTestXMLDoc2Po;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, tst_XMLDoc2po, fra_PoFile;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

