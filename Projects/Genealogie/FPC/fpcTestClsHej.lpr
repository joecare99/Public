program fpcTestClsHej;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, tst_ClsHej, cls_HejIndData, cls_HejMarrData,
  frm_ConnectDB, dm_GenData2, tst_ClsIndHej, tst_ClsMarrHej, tst_ClsAdopHej,
  tst_ClsPlaceHej, tst_ClsSourceHej, cls_HejBase, tst_fraIndIndex,
  unt_IndTestData, unt_MarrTestData, tst_ClsHejFilter, unt_PlaceTestData,
  tst_FrmEditFilter, frm_FilterEdit, tst_ClsHejHelper, cls_HejHelper;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.CreateForm(TfrmConnectDb, frmConnectDb);
  Application.CreateForm(TFrmFilterEdit, FrmFilterEdit);
  Application.Run;
end.

