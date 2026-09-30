unit tst_FrmEditFilter;

{$mode objfpc}{$H+}

interface

uses
  Classes, Forms, SysUtils{$IFNDEF FPC},TestFramework {$Else} ,fpcunit, testutils,
  testregistry {$endif};

type

  { TTestFrmFilterEdit }

  TTestFrmFilterEdit= class(TTestCase)
  private
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSetUp;
  end;


implementation

uses frm_FilterEdit;
{ TTestFrmFilterEdit }

procedure TTestFrmFilterEdit.SetUp;
begin

end;

procedure TTestFrmFilterEdit.TearDown;
begin

end;

procedure TTestFrmFilterEdit.TestSetUp;
begin
  FrmFilterEdit.ShowModal;
end;

initialization

  RegisterTest(TTestFrmFilterEdit);
end.

