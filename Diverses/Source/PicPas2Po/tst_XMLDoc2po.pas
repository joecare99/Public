unit tst_XMLDoc2po;

{$IFDEF FPC}
{$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils,{$IFDEF FPC}  fpcunit, testutils, testregistry, {$ELSE}  Ttstsuite, {$ENDIF} frm_XMLDoc2po;

type

  { TTestXMLDoc2Po }

  TTestXMLDoc2Po= class(TTestCase)
  private
    FDataPath:String;
    Procedure LoadTestData;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  public
    Constructor Create;
  published
    procedure TestSetUp;
  end;

implementation
uses Forms;

Const BaseDir='Data';

procedure TTestXMLDoc2Po.LoadTestData;
begin
  CheckNotNull(frmXml2PoMain,'Mainform is initialized');
  frmXml2PoMain.fraPoFile1.LoadPOFile(;
end;

procedure TTestXMLDoc2Po.SetUp;
var
  i: Integer;
begin
  if FDataPath='' then
    begin
      FDataPath:=BaseDir;
      for i := 0 to 2 do
        if DirectoryExists(FDataPath) then
          break
        else
          FDataPath:='..'+DirectorySeparator+FDataPath;
      // Plan B
      if not DirectoryExists(FDataPath) then
        begin
          FDataPath:=GetAppConfigDir(true);

        end;
    end;
  if not assigned(frmXml2PoMain) then
    Application.CreateForm(TfrmXml2PoMain,frmXml2PoMain);

end;

procedure TTestXMLDoc2Po.TearDown;
begin

end;

constructor TTestXMLDoc2Po.Create;
begin

end;

procedure TTestXMLDoc2Po.TestSetUp;
begin
  CheckNotNull(frmXml2PoMain,'Mainform is initialized');

end;

initialization

  RegisterTest(TTestXMLDoc2Po{$IFNDEF FPC}.Suite {$ENDIF});
end.

