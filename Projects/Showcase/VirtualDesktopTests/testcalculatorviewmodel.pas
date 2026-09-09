unit testcalculatorviewmodel;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, fpcunit, testregistry, CalculatorViewModel;

type
  TCalculatorViewModelTest = class(TTestCase)
  published
    procedure StartsWithZero;
    procedure BuildsDecimalInput;
    procedure CalculatesWithEachOperator;
    procedure ClearResetsAnInProgressCalculation;
  end;

implementation

procedure TCalculatorViewModelTest.StartsWithZero;
var
  ViewModel: TCalculatorViewModel;
begin
  ViewModel := TCalculatorViewModel.Create;
  try
    AssertEquals('0', ViewModel.Display);
  finally
    ViewModel.Free;
  end;
end;

procedure TCalculatorViewModelTest.BuildsDecimalInput;
var
  ViewModel: TCalculatorViewModel;
  DecimalSeparator: string;
begin
  ViewModel := TCalculatorViewModel.Create;
  try
    DecimalSeparator := DefaultFormatSettings.DecimalSeparator;

    ViewModel.PressDecimal;
    AssertEquals('0' + DecimalSeparator, ViewModel.Display);

    ViewModel.PressDigit('5');
    ViewModel.PressDecimal;
    ViewModel.PressDigit('2');
    AssertEquals('0' + DecimalSeparator + '52', ViewModel.Display);
  finally
    ViewModel.Free;
  end;
end;

procedure TCalculatorViewModelTest.CalculatesWithEachOperator;
var
  ViewModel: TCalculatorViewModel;
begin
  ViewModel := TCalculatorViewModel.Create;
  try
    ViewModel.PressDigit('8');
    ViewModel.PressOperator('+');
    ViewModel.PressDigit('4');
    ViewModel.PressEquals;
    AssertEquals('12', ViewModel.Display);

    ViewModel.PressDigit('9');
    ViewModel.PressOperator('-');
    ViewModel.PressDigit('2');
    ViewModel.PressEquals;
    AssertEquals('7', ViewModel.Display);

    ViewModel.PressDigit('6');
    ViewModel.PressOperator('*');
    ViewModel.PressDigit('3');
    ViewModel.PressEquals;
    AssertEquals('18', ViewModel.Display);

    ViewModel.PressDigit('2');
    ViewModel.PressOperator('/');
    ViewModel.PressDigit('4');
    ViewModel.PressEquals;
    AssertEquals(FloatToStr(0.5), ViewModel.Display);
  finally
    ViewModel.Free;
  end;
end;

procedure TCalculatorViewModelTest.ClearResetsAnInProgressCalculation;
var
  ViewModel: TCalculatorViewModel;
begin
  ViewModel := TCalculatorViewModel.Create;
  try
    ViewModel.PressDigit('9');
    ViewModel.PressOperator('+');
    ViewModel.PressDigit('1');
    ViewModel.PressClear;

    AssertEquals('0', ViewModel.Display);
  finally
    ViewModel.Free;
  end;
end;

initialization
  RegisterTest(TCalculatorViewModelTest);

end.
