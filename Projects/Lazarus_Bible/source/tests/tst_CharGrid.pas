unit tst_CharGrid;

{$IFDEF FPC}
{$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils{$IFDEF FPC} , fpcunit, testutils, testregistry {$ELSE} , testsuite {$ENDIF};

type

  TTestCharGrid= class(TTestCase)
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestHookUp;
  end;

implementation

uses Forms, Frm_CharGridABOUT,Frm_CharGridMAIN;

procedure TTestCharGrid.TestHookUp;
begin
  Fail('Write your own test');
end;

procedure TTestCharGrid.SetUp;
begin
  if not assigned(frmCharGridMain) then
    Application.CreateForm(TfrmCharGridMain,frmCharGridMain);
  if not assigned(frmCharGridMain) then
    Application.CreateForm(TfrmCharGridMain,frmCharGridMain);

end;

procedure TTestCharGrid.TearDown;
begin

end;

initialization

  RegisterTest(TTestCharGrid);
end.

