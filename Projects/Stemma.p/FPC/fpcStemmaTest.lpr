program fpcStemmaTest;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, fpcunittestrunner, testStemma,dm_GenData, frm_ConnectDB;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner );
  Application.CreateForm(TdmGenData, dmGenData);
  Application.CreateForm(TfrmConnectDb, frmConnectDb);
  Application.Run;
end.

