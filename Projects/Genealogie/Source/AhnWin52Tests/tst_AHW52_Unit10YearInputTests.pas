unit tst_AHW52_Unit10YearInputTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52Unit10YearInput = class(TTestCase)
  published
    procedure TestDecrementUsesStrictLowerBoundary;
    procedure TestIncrementUsesStrictUpperBoundary;
    procedure TestArrowComparisonsPreserveLegacyLexicalBehavior;
    procedure TestWhitespaceInputIsRejectedByRawIntegerConversion;
    procedure TestMalformedYearDoesNotChangeEditText;
  end;

implementation

uses
  Forms, StdCtrls, Unit10;

function CreateYearInputForm: TForm10;
begin
  Result := TForm10.CreateNew(nil);
  Result.Edit1 := TEdit.Create(Result);
  Result.Edit1.Parent := Result;
end;

procedure TTestAHW52Unit10YearInput.TestDecrementUsesStrictLowerBoundary;
var
  form: TForm10;
begin
  form := CreateYearInputForm;
  try
    form.Edit1.Text := '1582';
    form.Button2Click(form.Button2);
    AssertEquals('The lower boundary is not decremented.', '1582',
      form.Edit1.Text);

    form.Edit1.Text := '1583';
    form.Button2Click(form.Button2);
    AssertEquals('A year above the lower boundary is decremented.', '1582',
      form.Edit1.Text);
  finally
    form.Free;
  end;
end;

procedure TTestAHW52Unit10YearInput.TestIncrementUsesStrictUpperBoundary;
var
  form: TForm10;
begin
  form := CreateYearInputForm;
  try
    form.Edit1.Text := '2500';
    form.Button1Click(form.Button1);
    AssertEquals('The upper boundary is not incremented.', '2500',
      form.Edit1.Text);

    form.Edit1.Text := '2499';
    form.Button1Click(form.Button1);
    AssertEquals('A year below the upper boundary is incremented.', '2500',
      form.Edit1.Text);
  finally
    form.Free;
  end;
end;

procedure TTestAHW52Unit10YearInput.
  TestArrowComparisonsPreserveLegacyLexicalBehavior;
var
  form: TForm10;
begin
  form := CreateYearInputForm;
  try
    form.Edit1.Text := '999';
    form.Button2Click(form.Button2);
    AssertEquals('The decrement gate compares text lexically.', '998',
      form.Edit1.Text);

    form.Edit1.Text := '19999';
    form.Button1Click(form.Button1);
    AssertEquals('The increment gate compares text lexically.', '20000',
      form.Edit1.Text);
  finally
    form.Free;
  end;
end;

procedure TTestAHW52Unit10YearInput.
  TestWhitespaceInputIsRejectedByRawIntegerConversion;
var
  form: TForm10;
begin
  form := CreateYearInputForm;
  try
    form.Edit1.Text := ' 1583 ';
    form.Button2Click(form.Button2);
    AssertEquals('The listing parses the original untrimmed edit text.',
      ' 1583 ', form.Edit1.Text);
  finally
    form.Free;
  end;
end;

procedure TTestAHW52Unit10YearInput.TestMalformedYearDoesNotChangeEditText;
var
  form: TForm10;
begin
  form := CreateYearInputForm;
  try
    form.Edit1.Text := 'not-a-year';
    form.Button2Click(form.Button2);
    AssertEquals('Invalid input is left unchanged.', 'not-a-year',
      form.Edit1.Text);
  finally
    form.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52Unit10YearInput);

end.
