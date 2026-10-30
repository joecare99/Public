unit tst_AHW52_Unit10EasterXmlRowsTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52Unit10EasterXmlRows = class(TTestCase)
  published
    procedure TestKnownYearOutputLines;
    procedure TestCompleteDocumentLines;
    procedure TestSupportedYearBoundaries;
    procedure TestUnsupportedYearsAreRejected;
  end;

implementation

uses
  SysUtils, GregorianCalendarModel, Unit10EasterXmlRows;

procedure TTestAHW52Unit10EasterXmlRows.TestKnownYearOutputLines;
const
  ExpectedLines: TEasterXmlOutputLines = (
    '<tbl><tab>Septuagesima</tab><tab><rb>28.01.2024</rb></tab></tbl>',
    '<tbl><tab>Sexagesima</tab><tab><rb>04.02.2024</rb></tab></tbl>',
    '<tbl><tab>Estomihi</tab><tab><rb>11.02.2024</rb></tab></tbl>',
    '<tbl><tab>Invocavit</tab><tab><rb>18.02.2024</rb></tab></tbl>',
    '<tbl><tab>Reminiscere</tab><tab><rb>25.02.2024</rb></tab></tbl>',
    '<tbl><tab>Oculi</tab><tab><rb>03.03.2024</rb></tab></tbl>',
    '<tbl><tab>Laetare</tab><tab><rb>10.03.2024</rb></tab></tbl>',
    '<tbl><tab>Judica</tab><tab><rb>17.03.2024</rb></tab></tbl>',
    '<tbl><tab>Palmarum</tab><tab><rb>24.03.2024</rb></tab></tbl>',
    '<uesu>',
    '<tbl><tab>Ostern</tab><tab><rb>31.03.2024</rb></tab></tbl>',
    '</uesu>',
    '<tbl><tab>Quasimodo</tab><tab><rb>07.04.2024</rb></tab></tbl>',
    '<tbl><tab>Misericordia</tab><tab><rb>14.04.2024</rb></tab></tbl>',
    '<tbl><tab>Jubilate</tab><tab><rb>21.04.2024</rb></tab></tbl>'
  );
var
  actualLines: TEasterXmlOutputLines;
  index: Integer;
begin
  actualLines := BuildUnit10EasterXmlOutputLines(2024);
  AssertEquals('Output line count', Length(ExpectedLines), Length(actualLines));
  for index := Low(ExpectedLines) to High(ExpectedLines) do
    AssertEquals(Format('Output line %d', [index]),
      ExpectedLines[index], actualLines[index]);
end;

procedure TTestAHW52Unit10EasterXmlRows.TestCompleteDocumentLines;
const
  ExpectedPrefix: array[0..7] of string = (
    '<?xml version="1.0" encoding="ISO-8859-1"?>',
    '<?xml-StyleSheet type="text/css" href="style.css" ?>',
    '<!--Converted from AHNENWIN 5.1 (2013) by Heribert Reitmeier-->',
    '<tb>',
    '<ues>Sonntage vor und nach Ostern 2024</ues>',
    '<strich></strich>',
    '<emp15>',
    '<tbliste>'
  );
  ExpectedSuffix: array[0..2] of string = (
    '</tbliste>',
    '</emp15>',
    '</tb>'
  );
var
  documentLines: TEasterXmlDocumentLines;
  rowLines: TEasterXmlOutputLines;
  index, firstRowIndex, suffixIndex: Integer;
begin
  documentLines := BuildUnit10EasterXmlDocumentLines(2024);
  rowLines := BuildUnit10EasterXmlOutputLines(2024);
  AssertEquals('Complete document line count', Length(documentLines), 26);

  for index := Low(ExpectedPrefix) to High(ExpectedPrefix) do
    AssertEquals(Format('Document prefix line %d', [index]),
      ExpectedPrefix[index], documentLines[index]);

  firstRowIndex := High(ExpectedPrefix) + 1;
  for index := Low(rowLines) to High(rowLines) do
    AssertEquals(Format('Document row line %d', [index]),
      rowLines[index], documentLines[firstRowIndex + index]);

  suffixIndex := firstRowIndex + Length(rowLines);
  for index := Low(ExpectedSuffix) to High(ExpectedSuffix) do
    AssertEquals(Format('Document suffix line %d', [index]),
      ExpectedSuffix[index], documentLines[suffixIndex + index]);
end;

procedure TTestAHW52Unit10EasterXmlRows.TestSupportedYearBoundaries;
var
  lines: TEasterXmlOutputLines;
  documentLines: TEasterXmlDocumentLines;
begin
  lines := BuildUnit10EasterXmlOutputLines(CalendarFirstSupportedYear);
  AssertEquals('First date in supported range',
    '<tbl><tab>Septuagesima</tab><tab><rb>14.02.1582</rb></tab></tbl>',
    lines[Low(lines)]);

  lines := BuildUnit10EasterXmlOutputLines(CalendarLastSupportedYear);
  AssertEquals('Last date in supported range',
    '<tbl><tab>Jubilate</tab><tab><rb>19.04.2499</rb></tab></tbl>',
    lines[High(lines)]);

  documentLines := BuildUnit10EasterXmlDocumentLines(
    CalendarLastSupportedYear);
  AssertEquals('Year-specific document heading',
    '<ues>Sonntage vor und nach Ostern 2499</ues>', documentLines[4]);
end;

procedure TTestAHW52Unit10EasterXmlRows.TestUnsupportedYearsAreRejected;
var
  lines: TEasterXmlOutputLines;
  rejected: Boolean;
begin
  rejected := False;
  try
    lines := BuildUnit10EasterXmlOutputLines(CalendarFirstSupportedYear - 1);
  except
    on EConvertError do
      rejected := True;
  end;
  if not rejected then
    raise Exception.CreateFmt(
      'The XML row builder accepted a year below its supported range: %s.',
      [lines[Low(lines)]]);

  rejected := False;
  try
    lines := BuildUnit10EasterXmlOutputLines(CalendarLastSupportedYear + 1);
  except
    on EConvertError do
      rejected := True;
  end;
  if not rejected then
    raise Exception.CreateFmt(
      'The XML row builder accepted a year above its supported range: %s.',
      [lines[Low(lines)]]);
end;

initialization
  RegisterTest(TTestAHW52Unit10EasterXmlRows);

end.
