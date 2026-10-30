unit Unit10EasterXmlRows;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  GregorianCalendarModel;

type
  TEasterXmlOutputLines = array[0..LiturgicalSundayCount + 1] of string;
  TEasterXmlDocumentLines = array[0..LiturgicalSundayCount + 12] of string;

function BuildUnit10EasterXmlOutputLines(
  const Year: Longint): TEasterXmlOutputLines;
function BuildUnit10EasterXmlDocumentLines(
  const Year: Longint): TEasterXmlDocumentLines;

implementation

uses
  SysUtils;

const
  EasterSundayNames: array[0..LiturgicalSundayCount - 1] of string = (
    'Septuagesima',
    'Sexagesima',
    'Estomihi',
    'Invocavit',
    'Reminiscere',
    'Oculi',
    'Laetare',
    'Judica',
    'Palmarum',
    'Ostern',
    'Quasimodo',
    'Misericordia',
    'Jubilate'
  );

    XmlHeader = '<?xml version="1.0" encoding="ISO-8859-1"?>';
    XmlStyle = '<?xml-StyleSheet type="text/css" href="style.css" ?>';
    XmlConversionComment =
      '<!--Converted from AHNENWIN 5.1 (2013) by Heribert Reitmeier-->';

function BuildUnit10EasterXmlOutputLines(
    const Year: Longint): TEasterXmlOutputLines;
var
  dates: TLiturgicalSundayDates;
  dateIndex, outputIndex: Integer;
  sundayName: string;
begin
  dates := BuildLiturgicalSundayDates(CalculateGregorianEasterDate(Year));
  outputIndex := Low(Result);

  for dateIndex := Low(dates) to High(dates) do
  begin
    sundayName := EasterSundayNames[dateIndex];
    if sundayName = 'Ostern' then
    begin
      Result[outputIndex] := '<uesu>';
      Inc(outputIndex);
    end;

    Result[outputIndex] := '<tbl><tab>' + sundayName +
      '</tab><tab><rb>' + FormatDateTime('dd.mm.yyyy', dates[dateIndex]) +
      '</rb></tab></tbl>';
    Inc(outputIndex);

    if sundayName = 'Ostern' then
    begin
      Result[outputIndex] := '</uesu>';
      Inc(outputIndex);
    end;
  end;
end;

function BuildUnit10EasterXmlDocumentLines(
  const Year: Longint): TEasterXmlDocumentLines;
var
  rows: TEasterXmlOutputLines;
  rowIndex, outputIndex: Integer;
begin
  rows := BuildUnit10EasterXmlOutputLines(Year);

  Result[0] := XmlHeader;
  Result[1] := XmlStyle;
  Result[2] := XmlConversionComment;
  Result[3] := '<tb>';
  Result[4] := '<ues>Sonntage vor und nach Ostern ' + IntToStr(Year) +
    '</ues>';
  Result[5] := '<strich></strich>';
  Result[6] := '<emp15>';
  Result[7] := '<tbliste>';

  outputIndex := 8;
  for rowIndex := Low(rows) to High(rows) do
  begin
    Result[outputIndex] := rows[rowIndex];
    Inc(outputIndex);
  end;

  Result[outputIndex] := '</tbliste>';
  Inc(outputIndex);
  Result[outputIndex] := '</emp15>';
  Inc(outputIndex);
  Result[outputIndex] := '</tb>';
end;

end.
