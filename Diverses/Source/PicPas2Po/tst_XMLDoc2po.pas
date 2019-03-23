unit tst_XMLDoc2po;

{$IFDEF FPC}
{$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils,{$IFDEF FPC}  fpcunit, testutils, testregistry, {$ELSE}  Ttstsuite, {$ENDIF} frm_XMLDoc2po;

type
  TTestXMLDoc2Po= class(TTestCase)
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestHookUp;
  end;

implementation
uses Forms;

procedure TTestXMLDoc2Po.SetUp;
begin
  if not assigned(frmXml2PoMain) then
    Application.CreateForm(TfrmXml2PoMain,frmXml2PoMain);
end;

procedure TTestXMLDoc2Po.TearDown;
begin

end;

procedure TTestXMLDoc2Po.TestHookUp;
begin
  Fail('Write your own test');
end;

initialization

  RegisterTest(TTestXMLDoc2Po{$IFNDEF FPC}.Suite {$ENDIF});
end.

