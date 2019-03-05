program fpcTestClsHej;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, tst_ClsHej, cls_HejIndData, cls_HejMarrData,
  frm_ConnectDB, dm_GenData2, tst_ClsIndHej, tst_ClsMarrHej, tst_ClsAdopHej,
  tst_ClsPlaceHej, tst_ClsSourceHej, cls_HejBase, tst_fraIndIndex,
  unt_IndTestData, unt_MarrTestData, tst_ClsHejFilter, unt_PlaceTestData;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.CreateForm(TfrmConnectDb, frmConnectDb);
  Application.Run;
end.

