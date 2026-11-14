unit tst_Telname;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, TelnameModel;

type
  TTestTelnameModel = class(TTestCase)
  published
    procedure ConvertsLettersToTelephoneDigits;
    procedure KeepsNonLetters;
    procedure GeneratesTelephoneLetterCombinations;
    procedure RejectsNonDigitInput;
    procedure LimitsGeneratedCombinations;
  end;

implementation

procedure TTestTelnameModel.ConvertsLettersToTelephoneDigits;
var
  Model: TTelnameModel;
begin
  Model := TTelnameModel.Create;
  try
    CheckEquals('43556', Model.NameToNumber('HELLO'));
    CheckEquals('43556', Model.NameToNumber('hello'));
  finally
    Model.Free;
  end;
end;

procedure TTestTelnameModel.KeepsNonLetters;
var
  Model: TTelnameModel;
begin
  Model := TTelnameModel.Create;
  try
    CheckEquals('435-56 2', Model.NameToNumber('HEL-LO 2'));
  finally
    Model.Free;
  end;
end;

procedure TTestTelnameModel.GeneratesTelephoneLetterCombinations;
var
  Model: TTelnameModel;
  Names: TStringList;
begin
  Model := TTelnameModel.Create;
  Names := TStringList.Create;
  try
    Model.NumberToNames('23', Names);
    CheckEquals(9, Names.Count);
    CheckEquals('AD', Names[0]);
    CheckEquals('AE', Names[1]);
    CheckEquals('AF', Names[2]);
    CheckEquals('BD', Names[3]);
    CheckEquals('CF', Names[8]);
  finally
    Names.Free;
    Model.Free;
  end;
end;

procedure TTestTelnameModel.RejectsNonDigitInput;
var
  Model: TTelnameModel;
  Names: TStringList;
  RaisedExpectedError: Boolean;
begin
  Model := TTelnameModel.Create;
  Names := TStringList.Create;
  try
    RaisedExpectedError := False;
    try
      Model.NumberToNames('2A', Names);
    except
      on E: ETelnameError do
        RaisedExpectedError := True;
    end;
    CheckTrue(RaisedExpectedError);
  finally
    Names.Free;
    Model.Free;
  end;
end;

procedure TTestTelnameModel.LimitsGeneratedCombinations;
var
  Model: TTelnameModel;
  Names: TStringList;
begin
  Model := TTelnameModel.Create;
  Names := TStringList.Create;
  try
    Model.NumberToNames('999', Names, 10);
    CheckEquals(10, Names.Count);
  finally
    Names.Free;
    Model.Free;
  end;
end;

initialization
  RegisterTest(TTestTelnameModel);

end.
