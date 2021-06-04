program fpcTestPicPas2Po;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, tst_PicPasFile, unt_PicPasFile, unt_PoFile,
  tst_PoFile;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

