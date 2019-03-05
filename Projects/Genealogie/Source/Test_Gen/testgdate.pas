unit TestGDate;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry, GBaseClasses;

type

  { TTestGDate }

  TTestGDate = class(TTestCase)
  private
    FDate: TGDate;
    procedure ExecuteTestAbout(const ExpDateSpan: TenumDateSpan;
      const ExpAccuracy: TenumAccuracy;Const TestFormat, ExpFormat: string);
    procedure ExecuteTestEstimate(const ExpDateSpan: TenumDateSpan;
      const ExpAccuracy: TenumAccuracy;Const TestFormat, ExpFormat: string);
    procedure ExecuteTestAccurate(const ExpDateSpan: TenumDateSpan;
      const ExpAccuracy: TenumAccuracy; const TestFormat,ExpFormat: string);
    procedure ExecuteTestAfter(const ExpDateSpan: TenumDateSpan;
      const ExpAccuracy: TenumAccuracy; const TestFormat, ExpFormat: string);
    procedure ExecuteTestBefore(const ExpDateSpan: TenumDateSpan;
      const ExpAccuracy: TenumAccuracy; const TestFormat, ExpFormat: string);
    procedure ExecuteTestCalc(const ExpDateSpan: TenumDateSpan;
      const ExpAccuracy: TenumAccuracy; const TestFormat, ExpFormat: string);
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestHookUp;
    procedure SetDate_Simple;
    procedure SetDate_Simple2;
    procedure SetDate_Simple3;
    procedure SetDate_MonthYear;
    procedure SetDate_MonthYear2;
    procedure SetDate_MonthYear3;
    procedure SetDate_YearOnly;
    procedure SetDate_About;
    procedure SetDate_About2;
    procedure SetDate_About3;
    procedure SetDate_AboutMonthYear;
    procedure SetDate_AboutMonthYear2;
    procedure SetDate_AboutMonthYear3;
    procedure SetDate_AboutYearOnly;
    procedure SetDate_Estimate;
    procedure SetDate_Estimate2;
    procedure SetDate_Estimate3;
    procedure SetDate_EstimateMonthYear;
    procedure SetDate_EstimateMonthYear2;
    procedure SetDate_EstimateMonthYear3;
    procedure SetDate_EstimateYearOnly;
    procedure SetDate_Calc;
    procedure SetDate_Calc2;
    procedure SetDate_Calc3;
    procedure SetDate_CalcMonthYear;
    procedure SetDate_CalcMonthYear2;
    procedure SetDate_CalcMonthYear3;
    procedure SetDate_CalcYearOnly;
    procedure SetDate_Before;
    procedure SetDate_Before2;
    procedure SetDate_Before3;
    procedure SetDate_BeforeMonthYear;
    procedure SetDate_BeforeMonthYear2;
    procedure SetDate_BeforeMonthYear3;
    procedure SetDate_BeforeYearOnly;
    procedure SetDate_After;
    procedure SetDate_After2;
    procedure SetDate_After3;
    procedure SetDate_AfterMonthYear;
    procedure SetDate_AfterMonthYear2;
    procedure SetDate_AfterMonthYear3;
    procedure SetDate_AfterYearOnly;
  end;

implementation

uses dateutils;

procedure TTestGDate.TestHookUp;
begin
  //  Fail('Write your own test');
end;

procedure TTestGDate.SetDate_Simple;

const
  ExpFormat = 'D. MMM YYYY';
  TestFormat = 'DD.MM.YYYY';

begin
  ExecuteTestAccurate(ds_SingleDate, Accurate_Date, TestFormat, ExpFormat);
end;

procedure TTestGDate.SetDate_Simple2;

const
  ExpFormat = 'D. MMM YYYY';
  TestFormat = 'D. MMM YYYY';

begin
  ExecuteTestAccurate(ds_SingleDate, Accurate_Date, TestFormat, ExpFormat);
end;

procedure TTestGDate.SetDate_Simple3;

const
  ExpFormat = 'D. MMM YYYY';
  TestFormat = 'D. MMMM YYYY';

begin
  ExecuteTestAccurate(ds_SingleDate, Accurate_Date, TestFormat, ExpFormat);
end;

procedure TTestGDate.SetDate_MonthYear;

const
    ExpFormat = 'MMM YYYY';
    TestFormat = 'MM.YYYY';

begin
  ExecuteTestAccurate(ds_SingleDate, Accurate_MonthYear, TestFormat, ExpFormat);
end;

procedure TTestGDate.SetDate_MonthYear2;

const
  ExpFormat = 'MMM YYYY';
  TestFormat = 'MMM YYYY';

begin
  ExecuteTestAccurate(ds_SingleDate, Accurate_MonthYear, TestFormat, ExpFormat);
end;

procedure TTestGDate.SetDate_MonthYear3;

const
    ExpFormat = 'MMM YYYY';
    TestFormat = 'MMMM YYYY';

begin
  ExecuteTestAccurate(ds_SingleDate, Accurate_MonthYear, TestFormat, ExpFormat);
end;

procedure TTestGDate.SetDate_YearOnly;

const
    ExpFormat = 'YYYY';
    TestFormat = 'YYYY';

begin
  ExecuteTestAccurate(ds_SingleDate, Accurate_Year, TestFormat, ExpFormat);
end;

const
  aboutstr: array[0..7] of string =
    ('ca.',
    'c',
    'circa',
    'ungefähr',
    'abt.',
    'a',
    'about',
    'um');

  Eststr: array[0..3] of string =
    ('ges.',
    'est.',
    'e',
    'g');

  BeforeStr: array[0..4] of string =
    ('vor',
    'v',
    'bf',
    'bef',
    'before');

  AfterStr: array[0..5] of string =
    ('nach',
    'nch',
    'n',
    'af',
    'aft',
    'after');

procedure TTestGDate.SetDate_About;

const
  Testformat = 'DD.MM.YYYY';
  ExpFormat = 'D. MMM YYYY';

begin
  ExecuteTestAbout(ds_SingleDate,About_Date,Testformat,ExpFormat);
end;

procedure TTestGDate.SetDate_About2;

const
  Testformat = 'DD. MMM. YYYY';
  ExpFormat = 'D. MMM YYYY';

begin
  ExecuteTestAbout(ds_SingleDate,About_Date,Testformat,ExpFormat);
end;

procedure TTestGDate.SetDate_About3;

const
  Testformat = 'DD. MMMM YYYY';
  ExpFormat = 'D. MMM YYYY';

begin
  ExecuteTestAbout(ds_SingleDate,About_Date,Testformat,ExpFormat);
end;

procedure TTestGDate.SetDate_AboutMonthYear;

const
  Testformat = 'MM.YYYY';
  ExpFormat = 'MMM YYYY';

begin
  ExecuteTestAbout(ds_SingleDate,About_MonthYear,Testformat,ExpFormat);
end;

procedure TTestGDate.SetDate_AboutMonthYear2;

const
  Testformat = 'MMM. YYYY';
  ExpFormat = 'MMM YYYY';

begin
  ExecuteTestAbout(ds_SingleDate,About_MonthYear,Testformat,ExpFormat);
end;

procedure TTestGDate.SetDate_AboutMonthYear3;

const
  Testformat = 'MMMM. YYYY';
  ExpFormat = 'MMM YYYY';

begin
  ExecuteTestAbout(ds_SingleDate,About_MonthYear,Testformat,ExpFormat);
end;

procedure TTestGDate.SetDate_AboutYearOnly;

const
  Testformat = 'YYYY';
  ExpFormat = 'YYYY';

begin
  ExecuteTestAbout(ds_SingleDate,About_Year,Testformat,ExpFormat);
end;

procedure TTestGDate.SetDate_Estimate;
const
  Testformat = 'DD.MM.YYYY';
  ExpFormat = 'D. MMM YYYY';

begin
  ExecuteTestEstimate(ds_SingleDate,Est_Date,Testformat,ExpFormat);
end;

procedure TTestGDate.SetDate_Estimate2;
const
  Testformat = 'DD. MMM. YYYY';
  ExpFormat = 'D. MMM YYYY';

begin
  ExecuteTestEstimate(ds_SingleDate,Est_Date,Testformat,ExpFormat);
end;

procedure TTestGDate.SetDate_Estimate3;
const
  Testformat = 'DD. MMMM YYYY';
  ExpFormat = 'D. MMM YYYY';

begin
  ExecuteTestEstimate(ds_SingleDate,Est_Date,Testformat,ExpFormat);
end;

procedure TTestGDate.SetDate_EstimateMonthYear;
const
  Testformat = 'MM.YYYY';
  ExpFormat = 'MMM YYYY';
begin

end;

procedure TTestGDate.SetDate_EstimateMonthYear2;
begin

end;

procedure TTestGDate.SetDate_EstimateMonthYear3;
begin

end;

procedure TTestGDate.SetDate_EstimateYearOnly;
begin

end;

const
  Calcstr: array[0..4] of string =
    ('cal.',
    'calc',
    'ber.',
    'berechnet',
    'b');

procedure TTestGDate.SetDate_Calc;

const
  Testformat = 'DD.MM.YYYY';
  ExpFormat = 'D. MMM YYYY';

begin
  ExecuteTestCalc(ds_SingleDate,Calc_Date,Testformat,ExpFormat);
end;

procedure TTestGDate.SetDate_Calc2;

const
  Testformat = 'DD. MMM. YYYY';
  ExpFormat = 'D. MMM YYYY';

begin
  ExecuteTestCalc(ds_SingleDate,Calc_Date,Testformat,ExpFormat);
end;

procedure TTestGDate.SetDate_Calc3;

const
  Testformat = 'DD. MMMM YYYY';
  ExpFormat = 'D. MMM YYYY';

begin
  ExecuteTestCalc(ds_SingleDate,Calc_Date,Testformat,ExpFormat);
end;

procedure TTestGDate.SetDate_CalcMonthYear;

const
  Testformat = 'MM.YYYY';
  ExpFormat = 'MMM YYYY';

begin
  ExecuteTestCalc(ds_SingleDate,Calc_MonthYear,Testformat,ExpFormat);
end;

procedure TTestGDate.SetDate_CalcMonthYear2;

const
  Testformat = 'MMM. YYYY';
  ExpFormat = 'MMM YYYY';

begin
  ExecuteTestCalc(ds_SingleDate,Calc_MonthYear,Testformat,ExpFormat);
end;

procedure TTestGDate.SetDate_CalcMonthYear3;

const
  Testformat = 'MMMM. YYYY';
  ExpFormat = 'MMM YYYY';

begin
  ExecuteTestCalc(ds_SingleDate,Calc_MonthYear,Testformat,ExpFormat);
end;

procedure TTestGDate.SetDate_CalcYearOnly;

const
  Testformat = 'YYYY';
  ExpFormat = 'YYYY';

begin
  ExecuteTestCalc(ds_SingleDate,Calc_Year,Testformat,ExpFormat);
end;

procedure TTestGDate.SetDate_Before;

const
  Testformat = 'DD.MM.YYYY';
  ExpFormat = 'D. MMM YYYY';

begin
  ExecuteTestBefore(ds_BeforeDate,Accurate_Date,Testformat,ExpFormat);
end;

procedure TTestGDate.SetDate_Before2;

const
  Testformat = 'DD. MMM. YYYY';
  ExpFormat = 'D. MMM YYYY';

begin
  ExecuteTestBefore(ds_BeforeDate,Accurate_Date,Testformat,ExpFormat);
end;

procedure TTestGDate.SetDate_Before3;

const
  Testformat = 'DD. MMMM YYYY';
  ExpFormat = 'D. MMM YYYY';

begin
  ExecuteTestBefore(ds_BeforeDate,Accurate_Date,Testformat,ExpFormat);
end;

procedure TTestGDate.SetDate_BeforeMonthYear;

const
  Testformat = 'MM.YYYY';
  ExpFormat = 'MMM YYYY';

begin
  ExecuteTestBefore(ds_BeforeDate,Accurate_MonthYear,Testformat,ExpFormat);
end;

procedure TTestGDate.SetDate_BeforeMonthYear2;

const
  Testformat = 'MMM. YYYY';
  ExpFormat = 'MMM YYYY';

begin
  ExecuteTestBefore(ds_BeforeDate,Accurate_MonthYear,Testformat,ExpFormat);
end;

procedure TTestGDate.SetDate_BeforeMonthYear3;

const
  Testformat = 'MMMM. YYYY';
  ExpFormat = 'MMM YYYY';

begin
  ExecuteTestBefore(ds_BeforeDate,Accurate_MonthYear,Testformat,ExpFormat);
end;

procedure TTestGDate.SetDate_BeforeYearOnly;

const
  Testformat = 'YYYY';
  ExpFormat = 'YYYY';

begin
  ExecuteTestBefore(ds_BeforeDate,Accurate_Year,Testformat,ExpFormat);
end;

procedure TTestGDate.SetDate_After;

const
  Testformat = 'DD.MM.YYYY';
  ExpFormat = 'D. MMM YYYY';

begin
  ExecuteTestAfter(ds_AfterDate,Accurate_Date,Testformat,ExpFormat);
end;

procedure TTestGDate.SetDate_After2;

const
  Testformat = 'DD. MMM. YYYY';
  ExpFormat = 'D. MMM YYYY';

begin
  ExecuteTestAfter(ds_AfterDate,Accurate_Date,Testformat,ExpFormat);
end;

procedure TTestGDate.SetDate_After3;

const
  Testformat = 'DD. MMMM YYYY';
  ExpFormat = 'D. MMM YYYY';

begin
  ExecuteTestAfter(ds_AfterDate,Accurate_Date,Testformat,ExpFormat);
end;

procedure TTestGDate.SetDate_AfterMonthYear;

const
  Testformat = 'MM.YYYY';
  ExpFormat = 'MMM YYYY';

begin
  ExecuteTestAfter(ds_AfterDate,Accurate_MonthYear,Testformat,ExpFormat);
end;

procedure TTestGDate.SetDate_AfterMonthYear2;

const
  Testformat = 'MMM. YYYY';
  ExpFormat = 'MMM YYYY';

begin
  ExecuteTestAfter(ds_AfterDate,Accurate_MonthYear,Testformat,ExpFormat);
end;

procedure TTestGDate.SetDate_AfterMonthYear3;

const
  Testformat = 'MMMM. YYYY';
  ExpFormat = 'MMM YYYY';

begin
  ExecuteTestAfter(ds_AfterDate,Accurate_MonthYear,Testformat,ExpFormat);
end;

procedure TTestGDate.SetDate_AfterYearOnly;

const
  Testformat = 'YYYY';
  ExpFormat = 'YYYY';

begin
  ExecuteTestAfter(ds_AfterDate,Accurate_Year,Testformat,ExpFormat);
end;

procedure TTestGDate.ExecuteTestCalc(const ExpDateSpan: TenumDateSpan;
  const ExpAccuracy: TenumAccuracy; const TestFormat, ExpFormat: string);
var
  lDate2: TGDate;
  lTestDate: TDateTime;
  lBaseDate: TDateTime;
  i: integer;
  lTestStr: string;
begin
  lDate2 := TGDate.Create;
  try
    TryEncodeDate(1, 1, 1, lBaseDate);
    lTestDate := int(now());
    lTestStr := 'Ber. ' + FormatDateTime(Testformat, lTestDate);
    Fdate.DisplayText := lTestStr;
    CheckEquals(CCalc + ' ' + FormatDateTime(ExpFormat, lTestDate)
      , FDate.DisplayText, 'Test Date Today');
    Check(FDate.ParseOK, 'Date-Parsing was OK: ' + FDate.DisplayText);
    checkEquals(ord(ExpAccuracy), ord(FDate.DateAccuracy), 'Accuracy');
    checkEquals(ord(ExpDateSpan), ord(FDate.DateSpan), 'DateSpan');

    lDate2.DisplayText := FDate.DisplayText;
    CheckEquals(CCalc + ' ' + FormatDateTime(ExpFormat, lTestDate)
      , lDate2.DisplayText, 'Test Date Today');
    Check(lDate2.ParseOK, 'Date-Parsing was OK: ' + lDate2.DisplayText);
    checkEquals(ord(ExpAccuracy), ord(lDate2.DateAccuracy), 'Accuracy');
    checkEquals(ord(ExpDateSpan), ord(lDate2.DateSpan), 'DateSpan');
    CheckEquals(FDate.MainDate,lDate2.MainDate,1e-30,'Dates render equal');

    for i := 0 to 10000 do
    begin
      lTestDate := lBaseDate + random * 800000;
      lTestStr := Calcstr[i mod length(Calcstr)] + ' ' + FormatDateTime(
        Testformat, lTestDate);
      Fdate.DisplayText := lTestStr;
      CheckEquals(CCalc + ' ' + FormatDateTime(ExpFormat, lTestDate),
        FDate.DisplayText, 'Test Date: ' + lTestStr);
      Check(FDate.ParseOK, 'Date-Parsing was OK ' + IntToStr(i) +
        ', ' + FDate.DisplayText);
      CheckEquals(ord(ExpAccuracy), ord(FDate.DateAccuracy), 'Accuracy'+ IntToStr(i) +
        ', ' + FDate.DisplayText);
      checkEquals(ord(ExpDateSpan), ord(FDate.DateSpan), 'Datespan'+ IntToStr(i) +
        ', ' + lDate2.DisplayText);
      if ExpAccuracy in [Accurate_Date,About_Date,Calc_Date] then
        checkEquals(int(lTestDate), FDate.MainDate,1e-30, 'Dates render equal'+ IntToStr(i) +
          ', ' + lDate2.DisplayText);

      lDate2.DisplayText := FDate.DisplayText;
      CheckEquals(CCalc + ' ' + FormatDateTime(ExpFormat, lTestDate),
        lDate2.DisplayText, 'Test Date2: ' + lTestStr);
      Check(lDate2.ParseOK, 'Date2-Parsing was OK ' + IntToStr(i) +
        ', ' + lDate2.DisplayText);
       CheckEquals(ord(ExpAccuracy), ord(lDate2.DateAccuracy), 'Accuracy'+ IntToStr(i) +
        ', ' + lDate2.DisplayText);
      checkEquals(ord(ExpDateSpan), ord(lDate2.DateSpan), 'Datespan'+ IntToStr(i) +
        ', ' + lDate2.DisplayText);
      checkEquals(Fdate.MainDate, lDate2.MainDate,1e-30, 'Dates render equal'+ IntToStr(i) +
        ', ' + lDate2.DisplayText);
    end;

  finally
    FreeAndNil(lDate2);
  end;
end;

procedure TTestGDate.ExecuteTestAbout(const ExpDateSpan: TenumDateSpan;
  const ExpAccuracy: TenumAccuracy; const TestFormat, ExpFormat: string);
var
  lDate2: TGDate;
  lTestDate: TDateTime;
  lBaseDate: TDateTime;
  i: integer;
  lTestStr: string;
begin
  lDate2 := TGDate.Create;
  try
    TryEncodeDate(1, 1, 1, lBaseDate);
    lTestDate := int(now());
    lTestStr := 'ca. ' + FormatDateTime(Testformat, lTestDate);
    Fdate.DisplayText := lTestStr;
    CheckEquals(CAbout + ' ' + FormatDateTime(ExpFormat, lTestDate)
      , FDate.DisplayText, 'Test Date Today');
    Check(FDate.ParseOK, 'Date-Parsing was OK: ' + FDate.DisplayText);
    checkEquals(ord(ExpAccuracy), ord(FDate.DateAccuracy), 'Accuracy');
    checkEquals(ord(ExpDateSpan), ord(FDate.DateSpan), 'DateSpan');

    lDate2.DisplayText := FDate.DisplayText;
    CheckEquals(CAbout + ' ' + FormatDateTime(ExpFormat, lTestDate)
      , lDate2.DisplayText, 'Test Date Today');
    Check(lDate2.ParseOK, 'Date-Parsing was OK: ' + lDate2.DisplayText);
    checkEquals(ord(ExpAccuracy), ord(lDate2.DateAccuracy), 'Accuracy');
    checkEquals(ord(ExpDateSpan), ord(lDate2.DateSpan), 'DateSpan');
    CheckEquals(FDate.MainDate,lDate2.MainDate,1e-30,'Dates render equal');

    for i := 0 to 10000 do
    begin
      lTestDate := lBaseDate + random * 800000;
      lTestStr := aboutstr[i mod length(aboutstr)] + ' ' + FormatDateTime(
        Testformat, lTestDate);
      Fdate.DisplayText := lTestStr;
      CheckEquals(CAbout + ' ' + FormatDateTime(ExpFormat, lTestDate),
        FDate.DisplayText, 'Test Date: ' + lTestStr);
      Check(FDate.ParseOK, 'Date-Parsing was OK ' + IntToStr(i) +
        ', ' + FDate.DisplayText);
      CheckEquals(ord(ExpAccuracy), ord(FDate.DateAccuracy), 'Accuracy'+ IntToStr(i) +
        ', ' + FDate.DisplayText);
      checkEquals(ord(ExpDateSpan), ord(FDate.DateSpan), 'Datespan'+ IntToStr(i) +
        ', ' + lDate2.DisplayText);
      if ExpAccuracy in [Accurate_Date,About_Date,Calc_Date] then
        checkEquals(int(lTestDate), FDate.MainDate,1e-30, 'Dates render equal'+ IntToStr(i) +
          ', ' + lDate2.DisplayText);

      lDate2.DisplayText := FDate.DisplayText;
      CheckEquals(CAbout + ' ' + FormatDateTime(ExpFormat, lTestDate),
        lDate2.DisplayText, 'Test Date2: ' + lTestStr);
      Check(lDate2.ParseOK, 'Date2-Parsing was OK ' + IntToStr(i) +
        ', ' + lDate2.DisplayText);
       CheckEquals(ord(ExpAccuracy), ord(lDate2.DateAccuracy), 'Accuracy'+ IntToStr(i) +
        ', ' + lDate2.DisplayText);
      checkEquals(ord(ExpDateSpan), ord(lDate2.DateSpan), 'Datespan'+ IntToStr(i) +
        ', ' + lDate2.DisplayText);
      checkEquals(Fdate.MainDate, lDate2.MainDate,1e-30, 'Dates render equal'+ IntToStr(i) +
        ', ' + lDate2.DisplayText);
    end;

  finally
    FreeAndNil(lDate2);
  end;
end;

procedure TTestGDate.ExecuteTestEstimate(const ExpDateSpan: TenumDateSpan;
  const ExpAccuracy: TenumAccuracy; const TestFormat, ExpFormat: string);
var
  lDate2: TGDate;
  lTestDate: TDateTime;
  lBaseDate: TDateTime;
  i: integer;
  lTestStr: string;
begin
  lDate2 := TGDate.Create;
  try
    TryEncodeDate(1, 1, 1, lBaseDate);
    lTestDate := int(now());
    lTestStr := 'Ges. ' + FormatDateTime(Testformat, lTestDate);
    Fdate.DisplayText := lTestStr;
    CheckEquals(CEst + ' ' + FormatDateTime(ExpFormat, lTestDate)
      , FDate.DisplayText, 'Test Date Today');
    Check(FDate.ParseOK, 'Date-Parsing was OK: ' + FDate.DisplayText);
    checkEquals(ord(ExpAccuracy), ord(FDate.DateAccuracy), 'Accuracy');
    checkEquals(ord(ExpDateSpan), ord(FDate.DateSpan), 'DateSpan');

    lDate2.DisplayText := FDate.DisplayText;
    CheckEquals(CEst + ' ' + FormatDateTime(ExpFormat, lTestDate)
      , lDate2.DisplayText, 'Test Date Today');
    Check(lDate2.ParseOK, 'Date-Parsing was OK: ' + lDate2.DisplayText);
    checkEquals(ord(ExpAccuracy), ord(lDate2.DateAccuracy), 'Accuracy');
    checkEquals(ord(ExpDateSpan), ord(lDate2.DateSpan), 'DateSpan');
    CheckEquals(FDate.MainDate,lDate2.MainDate,1e-30,'Dates render equal');

    for i := 0 to 10000 do
    begin
      lTestDate := lBaseDate + random * 800000;
      lTestStr := Eststr[i mod length(Eststr)] + ' ' + FormatDateTime(
        Testformat, lTestDate);
      Fdate.DisplayText := lTestStr;
      CheckEquals(CEst + ' ' + FormatDateTime(ExpFormat, lTestDate),
        FDate.DisplayText, 'Test Date: ' + lTestStr);
      Check(FDate.ParseOK, 'Date-Parsing was OK ' + IntToStr(i) +
        ', ' + FDate.DisplayText);
      CheckEquals(ord(ExpAccuracy), ord(FDate.DateAccuracy), 'Accuracy'+ IntToStr(i) +
        ', ' + FDate.DisplayText);
      checkEquals(ord(ExpDateSpan), ord(FDate.DateSpan), 'Datespan'+ IntToStr(i) +
        ', ' + lDate2.DisplayText);
      if ExpAccuracy in [Accurate_Date,About_Date,Est_Date,Calc_Date] then
        checkEquals(int(lTestDate), FDate.MainDate,1e-30, 'Dates render equal'+ IntToStr(i) +
          ', ' + lDate2.DisplayText);

      lDate2.DisplayText := FDate.DisplayText;
      CheckEquals(CEst + ' ' + FormatDateTime(ExpFormat, lTestDate),
        lDate2.DisplayText, 'Test Date2: ' + lTestStr);
      Check(lDate2.ParseOK, 'Date2-Parsing was OK ' + IntToStr(i) +
        ', ' + lDate2.DisplayText);
       CheckEquals(ord(ExpAccuracy), ord(lDate2.DateAccuracy), 'Accuracy'+ IntToStr(i) +
        ', ' + lDate2.DisplayText);
      checkEquals(ord(ExpDateSpan), ord(lDate2.DateSpan), 'Datespan'+ IntToStr(i) +
        ', ' + lDate2.DisplayText);
      checkEquals(Fdate.MainDate, lDate2.MainDate,1e-30, 'Dates render equal'+ IntToStr(i) +
        ', ' + lDate2.DisplayText);
    end;

  finally
    FreeAndNil(lDate2);
  end;
end;

procedure TTestGDate.ExecuteTestAccurate(const ExpDateSpan: TenumDateSpan;
  const ExpAccuracy: TenumAccuracy; const TestFormat, ExpFormat: string);
var
  lDate2: TGDate;
  lTestDate: TDateTime;
  lBaseDate: TDateTime;
  i: integer;
  lTestStr: string;
begin
  lDate2 := TGDate.Create;
  try

    TryEncodeDate(1, 1, 1, lBaseDate);
    lTestDate := int(now());
    lTestStr := FormatDateTime(TestFormat, lTestDate);
    Fdate.DisplayText := lTestStr;
    CheckEquals(FormatDateTime(ExpFormat, lTestDate)
      , FDate.DisplayText, 'Test Date Today');
    Check(FDate.ParseOK, 'Date-Parsing was OK: ' + FDate.DisplayText);
    checkEquals(ord(ExpAccuracy), ord(FDate.DateAccuracy), 'Accuracy');
    checkEquals(ord(ExpDateSpan), ord(FDate.DateSpan), 'DateSpan');
    lDate2.DisplayText := FDate.DisplayText;
    CheckEquals(FormatDateTime(ExpFormat, lTestDate)
      , lDate2.DisplayText, 'Test Date Today');
    Check(lDate2.ParseOK, 'Date-Parsing was OK: ' + lDate2.DisplayText);
    checkEquals(ord(ExpAccuracy), ord(lDate2.DateAccuracy), 'Accuracy');
    checkEquals(ord(ExpDateSpan), ord(lDate2.DateSpan), 'DateSpan');
    CheckEquals(FDate.MainDate,lDate2.MainDate,1e-30,'Dates render equal');

    lTestDate := EncodeDate(12,11,1);
    lTestStr := FormatDateTime(TestFormat, lTestDate);
    Fdate.DisplayText := lTestStr;
    CheckEquals(FormatDateTime(ExpFormat, lTestDate)
      , FDate.DisplayText, 'Test Date Today');
    Check(FDate.ParseOK, 'Date-Parsing was OK: ' + FDate.DisplayText);
    checkEquals(ord(ExpAccuracy), ord(FDate.DateAccuracy), 'Accuracy');
    checkEquals(ord(ExpDateSpan), ord(FDate.DateSpan), 'DateSpan');
    lDate2.DisplayText := FDate.DisplayText;
    CheckEquals(FormatDateTime(ExpFormat, lTestDate)
      , lDate2.DisplayText, 'Test Date Today');
    Check(lDate2.ParseOK, 'Date-Parsing was OK: ' + lDate2.DisplayText);
    checkEquals(ord(ExpAccuracy), ord(lDate2.DateAccuracy), 'Accuracy');
    checkEquals(ord(ExpDateSpan), ord(lDate2.DateSpan), 'DateSpan');
    CheckEquals(FDate.MainDate,lDate2.MainDate,1e-30,'Dates render equal');
    for i := 0 to 10000 do
    begin
      lTestDate := int(lBaseDate + random * 800000);
      lTestStr := FormatDateTime(TestFormat, lTestDate);
      Fdate.DisplayText := lTestStr;
      CheckEquals(FormatDateTime(ExpFormat, lTestDate),
        FDate.DisplayText, 'Test Date: ' + lTestStr);
      Check(FDate.ParseOK, 'Date-Parsing was OK ' + IntToStr(i) +
        ', ' + FDate.DisplayText);
      CheckEquals(ord(ExpAccuracy), ord(FDate.DateAccuracy), 'Accuracy'+ IntToStr(i) +
        ', ' + FDate.DisplayText);
      checkEquals(ord(ExpDateSpan), ord(FDate.DateSpan), 'Datespan'+ IntToStr(i) +
        ', ' + lDate2.DisplayText);
      if ExpAccuracy in [Accurate_Date,About_Date,Calc_Date] then
        checkEquals(lTestDate, FDate.MainDate,1e-30, 'Dates render equal'+ IntToStr(i) +
          ', ' + lDate2.DisplayText);


      lDate2.DisplayText := FDate.DisplayText;
      CheckEquals(FormatDateTime(ExpFormat, lTestDate),
        lDate2.DisplayText, 'Test Date2: ' + lTestStr);
      Check(lDate2.ParseOK, 'Date2-Parsing was OK ' + IntToStr(i) +
        ', ' + lDate2.DisplayText);
      CheckEquals(ord(ExpAccuracy), ord(lDate2.DateAccuracy), 'Accuracy'+ IntToStr(i) +
        ', ' + lDate2.DisplayText);
      checkEquals(ord(ExpDateSpan), ord(lDate2.DateSpan), 'Datespan'+ IntToStr(i) +
        ', ' + lDate2.DisplayText);
      checkEquals(Fdate.MainDate, lDate2.MainDate,1e-30, 'Dates render equal'+ IntToStr(i) +
        ', ' + lDate2.DisplayText);
    end;

  finally
    FreeAndNil(lDate2);
  end;
end;

procedure TTestGDate.ExecuteTestAfter(const ExpDateSpan: TenumDateSpan;
  const ExpAccuracy: TenumAccuracy; const TestFormat, ExpFormat: string);
var
  lDate2: TGDate;
  lTestDate: TDateTime;
  lBaseDate: TDateTime;
  i: integer;
  lTestStr: string;
begin
  lDate2 := TGDate.Create;
  try
    TryEncodeDate(1, 1, 1, lBaseDate);
    lTestDate := int(now());
    lTestStr := 'nach ' + FormatDateTime(Testformat, lTestDate);
    Fdate.DisplayText := lTestStr;
    CheckEquals(CAfter + ' ' + FormatDateTime(ExpFormat, lTestDate)
      , FDate.DisplayText, 'Test Date Today');
    Check(FDate.ParseOK, 'Date-Parsing was OK: ' + FDate.DisplayText);
    checkEquals(ord(ExpAccuracy), ord(FDate.DateAccuracy), 'Accuracy');
    checkEquals(ord(ExpDateSpan), ord(FDate.DateSpan), 'DateSpan');

    lDate2.DisplayText := FDate.DisplayText;
    CheckEquals(CAfter + ' ' + FormatDateTime(ExpFormat, lTestDate)
      , lDate2.DisplayText, 'Test Date Today');
    Check(lDate2.ParseOK, 'Date-Parsing was OK: ' + lDate2.DisplayText);
    checkEquals(ord(ExpAccuracy), ord(lDate2.DateAccuracy), 'Accuracy');
    checkEquals(ord(ExpDateSpan), ord(lDate2.DateSpan), 'DateSpan');
    CheckEquals(FDate.MainDate,lDate2.MainDate,1e-30,'Dates render equal');

    for i := 0 to 10000 do
    begin
      lTestDate := lBaseDate + random * 800000;
      lTestStr := Afterstr[i mod length(Afterstr)] + ' ' + FormatDateTime(
        Testformat, lTestDate);
      Fdate.DisplayText := lTestStr;
      CheckEquals(CAfter + ' ' + FormatDateTime(ExpFormat, lTestDate),
        FDate.DisplayText, 'Test Date: ' + lTestStr);
      Check(FDate.ParseOK, 'Date-Parsing was OK ' + IntToStr(i) +
        ', ' + FDate.DisplayText);
      CheckEquals(ord(ExpAccuracy), ord(FDate.DateAccuracy), 'Accuracy'+ IntToStr(i) +
        ', ' + FDate.DisplayText);
      checkEquals(ord(ExpDateSpan), ord(FDate.DateSpan), 'Datespan'+ IntToStr(i) +
        ', ' + lDate2.DisplayText);
      if ExpAccuracy in [Accurate_Date,About_Date,Calc_Date] then
        checkEquals(int(lTestDate), FDate.MainDate,1e-30, 'Dates render equal'+ IntToStr(i) +
          ', ' + lDate2.DisplayText);

      lDate2.DisplayText := FDate.DisplayText;
      CheckEquals(CAfter + ' ' + FormatDateTime(ExpFormat, lTestDate),
        lDate2.DisplayText, 'Test Date2: ' + lTestStr);
      Check(lDate2.ParseOK, 'Date2-Parsing was OK ' + IntToStr(i) +
        ', ' + lDate2.DisplayText);
       CheckEquals(ord(ExpAccuracy), ord(lDate2.DateAccuracy), 'Accuracy'+ IntToStr(i) +
        ', ' + lDate2.DisplayText);
      checkEquals(ord(ExpDateSpan), ord(lDate2.DateSpan), 'Datespan'+ IntToStr(i) +
        ', ' + lDate2.DisplayText);
      checkEquals(Fdate.MainDate, lDate2.MainDate,1e-30, 'Dates render equal'+ IntToStr(i) +
        ', ' + lDate2.DisplayText);
    end;

  finally
    FreeAndNil(lDate2);
  end;
end;

procedure TTestGDate.ExecuteTestBefore(const ExpDateSpan: TenumDateSpan;
  const ExpAccuracy: TenumAccuracy; const TestFormat, ExpFormat: string);
var
  lDate2: TGDate;
  lTestDate: TDateTime;
  lBaseDate: TDateTime;
  i: integer;
  lTestStr: string;
begin
  lDate2 := TGDate.Create;
  try
    TryEncodeDate(1, 1, 1, lBaseDate);
    lTestDate := int(now());
    lTestStr := 'vor ' + FormatDateTime(Testformat, lTestDate);
    Fdate.DisplayText := lTestStr;
    CheckEquals(CBefore + ' ' + FormatDateTime(ExpFormat, lTestDate)
      , FDate.DisplayText, 'Test Date Today');
    Check(FDate.ParseOK, 'Date-Parsing was OK: ' + FDate.DisplayText);
    checkEquals(ord(ExpAccuracy), ord(FDate.DateAccuracy), 'Accuracy');
    checkEquals(ord(ExpDateSpan), ord(FDate.DateSpan), 'DateSpan');

    lDate2.DisplayText := FDate.DisplayText;
    CheckEquals(CBefore + ' ' + FormatDateTime(ExpFormat, lTestDate)
      , lDate2.DisplayText, 'Test Date Today');
    Check(lDate2.ParseOK, 'Date-Parsing was OK: ' + lDate2.DisplayText);
    checkEquals(ord(ExpAccuracy), ord(lDate2.DateAccuracy), 'Accuracy');
    checkEquals(ord(ExpDateSpan), ord(lDate2.DateSpan), 'DateSpan');
    CheckEquals(FDate.MainDate,lDate2.MainDate,1e-30,'Dates render equal');

    for i := 0 to 10000 do
    begin
      lTestDate := lBaseDate + random * 800000;
      lTestStr := Beforestr[i mod length(Beforestr)] + ' ' + FormatDateTime(
        Testformat, lTestDate);
      Fdate.DisplayText := lTestStr;
      CheckEquals(CBefore + ' ' + FormatDateTime(ExpFormat, lTestDate),
        FDate.DisplayText, 'Test Date: ' + lTestStr);
      Check(FDate.ParseOK, 'Date-Parsing was OK ' + IntToStr(i) +
        ', ' + FDate.DisplayText);
      CheckEquals(ord(ExpAccuracy), ord(FDate.DateAccuracy), 'Accuracy'+ IntToStr(i) +
        ', ' + FDate.DisplayText);
      checkEquals(ord(ExpDateSpan), ord(FDate.DateSpan), 'Datespan'+ IntToStr(i) +
        ', ' + lDate2.DisplayText);
      if ExpAccuracy in [Accurate_Date,About_Date,Calc_Date] then
        checkEquals(int(lTestDate), FDate.MainDate,1e-30, 'Dates render equal'+ IntToStr(i) +
          ', ' + lDate2.DisplayText);

      lDate2.DisplayText := FDate.DisplayText;
      CheckEquals(CBefore + ' ' + FormatDateTime(ExpFormat, lTestDate),
        lDate2.DisplayText, 'Test Date2: ' + lTestStr);
      Check(lDate2.ParseOK, 'Date2-Parsing was OK ' + IntToStr(i) +
        ', ' + lDate2.DisplayText);
       CheckEquals(ord(ExpAccuracy), ord(lDate2.DateAccuracy), 'Accuracy'+ IntToStr(i) +
        ', ' + lDate2.DisplayText);
      checkEquals(ord(ExpDateSpan), ord(lDate2.DateSpan), 'Datespan'+ IntToStr(i) +
        ', ' + lDate2.DisplayText);
      checkEquals(Fdate.MainDate, lDate2.MainDate,1e-30, 'Dates render equal'+ IntToStr(i) +
        ', ' + lDate2.DisplayText);
    end;

  finally
    FreeAndNil(lDate2);
  end;
end;

procedure TTestGDate.SetUp;
begin
  FDate := TGDate.Create;
end;

procedure TTestGDate.TearDown;
begin
  FreeAndNil(FDate);
end;

initialization

  RegisterTest(TTestGDate);
end.
