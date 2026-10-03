unit tst_AHW52_DateWeekdayAbbreviationTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52DateWeekdayAbbreviation = class(TTestCase)
  published
    procedure TestGermanAbbreviationForEachWeekday;
    procedure TestInvalidDateReturnsEmpty;
    procedure TestParsingUsesRegionalShortDateFormat;
  end;

implementation

uses
  SysUtils,
  DateWeekdayAbbreviation;

procedure TTestAHW52DateWeekdayAbbreviation.TestGermanAbbreviationForEachWeekday;
var
  originalSettings: TFormatSettings;
begin
  originalSettings := DefaultFormatSettings;
  try
    DefaultFormatSettings.ShortDateFormat := 'dd.mm.yyyy';
    DefaultFormatSettings.DateSeparator := '.';

    AssertEquals('Mo', ResolveDateWeekdayAbbreviation('01.01.2024'));
    AssertEquals('Di', ResolveDateWeekdayAbbreviation('02.01.2024'));
    AssertEquals('Mi', ResolveDateWeekdayAbbreviation('03.01.2024'));
    AssertEquals('Do', ResolveDateWeekdayAbbreviation('04.01.2024'));
    AssertEquals('Fr', ResolveDateWeekdayAbbreviation('05.01.2024'));
    AssertEquals('Sa', ResolveDateWeekdayAbbreviation('06.01.2024'));
    AssertEquals('So', ResolveDateWeekdayAbbreviation('07.01.2024'));
  finally
    DefaultFormatSettings := originalSettings;
  end;
end;

procedure TTestAHW52DateWeekdayAbbreviation.TestInvalidDateReturnsEmpty;
var
  originalSettings: TFormatSettings;
begin
  originalSettings := DefaultFormatSettings;
  try
    DefaultFormatSettings.ShortDateFormat := 'dd.mm.yyyy';
    DefaultFormatSettings.DateSeparator := '.';
    AssertEquals('', ResolveDateWeekdayAbbreviation('31.02.2024'));
  finally
    DefaultFormatSettings := originalSettings;
  end;
end;

procedure TTestAHW52DateWeekdayAbbreviation.TestParsingUsesRegionalShortDateFormat;
var
  originalSettings: TFormatSettings;
begin
  originalSettings := DefaultFormatSettings;
  try
    DefaultFormatSettings.ShortDateFormat := 'mm/dd/yyyy';
    DefaultFormatSettings.DateSeparator := '/';
    AssertEquals('Mo', ResolveDateWeekdayAbbreviation('01/01/2024'));
  finally
    DefaultFormatSettings := originalSettings;
  end;
end;

initialization
  RegisterTest(TTestAHW52DateWeekdayAbbreviation);

end.
