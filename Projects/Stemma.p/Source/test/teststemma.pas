unit testStemma;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry, dm_GenData;

type

  { TTestStemmaData }

  TTestStemmaData = class(TTestCase)
  private
    FPRogressFlag: boolean;
    procedure OnUpdateProgress(Sender: TObject);
  published
    procedure TestSetUp;
    procedure TestCreateDB;
    procedure TestCreatePerson;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
    procedure CreateTestData;
  end;

implementation

uses Forms, frm_ConnectDB, Controls;

const
  TestDatabase = 'StemmaTest';

function GetApplicationName: string;
begin
  Result := 'Stemma';
end;

function GetVendorName: string;
begin
  Result := 'JC-Soft';
end;

procedure TTestStemmaData.OnUpdateProgress(Sender: TObject);
begin
  Application.ProcessMessages;
  FprogressFlag := True;
end;

procedure TTestStemmaData.TestSetUp;
begin
  CheckNotNull(dmGenData, 'Datamodule is assigned');
end;

procedure TTestStemmaData.TestCreateDB;
var
  Host, User, Password, lProjectName: string;
  success, lConnected: boolean;
  aList: TStringList;
  lOrgCount: integer;

begin
  dmGenData.ReadCfgConnection(Host, User, Password);
  dmGenData.ReadCfgProject(lProjectName, lConnected);
  if lProjectName <> TestDatabase then
  begin
    frmConnectDb.SetData(Host, User, Password);
    if frmConnectDb.ShowModal <> mrOk then
      Fail('Canceled by User')
    else
      frmConnectDb.GetData(Host, User, Password);
  end;

  dmGenData.SetDBHostUserPass(Host, User, Password, Success);
  CheckTrue(success, 'Set Host,User,PW -> Success');
  CheckTrue(dmGenData.DB_Connected, 'DB Connected');
  CheckFalse(dmGenData.ProjectIsOpen, 'Project is Open');
  dmGenData.WriteCfgConnection(Host, User, Password);

  aList := TStringList.Create;
  try
    dmgenData.GetDBSchemas(aList);
    CheckNotEquals(0, aList.Count, 'Not Zero Items');
    lOrgCount := aList.Count;
    CheckEquals(-1, aList.IndexOf(TestDatabase), 'Test-DB Exists');

    FprogressFlag := False;
    dmgendata.CreateDBProject(TestDatabase, @OnUpdateProgress);
    CheckTrue(FProgressFlag, 'OnUpdateWasCalled');
    CheckTrue(dmGenData.ProjectIsOpen, 'Project is Open');
    dmgenData.GetDBSchemas(aList);
    CheckEquals(lOrgCount+1, aList.Count, 'One more Items');
    CheckNotEquals(-1, aList.IndexOf(TestDatabase), 'Test-DB Exists');
    dmGenData.WriteCfgProject(TestDatabase, dmGenData.ProjectIsOpen);
  finally
    FreeAndNil(alist);
  end;

end;

procedure TTestStemmaData.TestCreatePerson;
var
  idInd, linterest: LongInt;
  lsex, lLiving, lDate: string;
begin
  CreateTestData;
  idInd:=dmGenData.AddNewIndividual('M','L',0);
  CheckNotEquals(0,idInd,'New Individual exists');
  CheckEquals('M',dmGenData.GetSexOfInd(idInd),'Individual is a Male');
  dmGenData.GetDataOfInd(idInd,lsex,lLiving,lDate,linterest);
  CheckEquals('M',lsex,'Individual is a Male');
  CheckEquals('L',lLiving,'Individual is living');
  CheckEquals(0,linterest,'Individual interest is 0');
  CheckEquals(FormatDateTime('YYYYMMDD',now()),lDate,'Changedate is Today');
end;

procedure TTestStemmaData.SetUp;
begin
  if not assigned(OnGetVendorName) then
    OnGetVendorName := @GetVendorName;
  if not assigned(OnGetApplicationName) then
    OnGetVendorName := @GetApplicationName;
  if not assigned(dmGenData) then
    Application.CreateForm(TdmGenData, dmGenData);
end;

procedure TTestStemmaData.TearDown;
var
  aList: TStringList;
begin
  if dmGenData.DB_Connected then
    begin
      aList := TStringList.Create;
      try
        dmgenData.GetDBSchemas(aList);
        if  aList.IndexOf(TestDatabase) <> -1 then
          dmGenData.DeleteDBProject(TestDatabase);
      finally
        FreeAndNil(alist);
      end;
    end;
  dmGenData.DB_Connected := False;
end;

procedure TTestStemmaData.CreateTestData;
var
  Host, User, Password, lProjectName: String;
  lConnected, Success: boolean;
begin
  dmGenData.ReadCfgConnection(Host, User, Password);
  dmGenData.ReadCfgProject(lProjectName, lConnected);

  if lProjectName <> TestDatabase then
  begin
    frmConnectDb.SetData(Host, User, Password);
    if frmConnectDb.ShowModal <> mrOk then
      Fail('Canceled by User')
    else
      frmConnectDb.GetData(Host, User, Password);
  end;

  dmGenData.SetDBHostUserPass(Host, User, Password, Success);
  if success then
    dmgendata.CreateDBProject(TestDatabase, nil)
  else
    dmGenData.WriteCfgProject('', false);

end;


initialization

  RegisterTest(TTestStemmaData);
end.
