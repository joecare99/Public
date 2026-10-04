unit Unit16TextExportWorkflow;

{$IFDEF FPC}
{$MODE DELPHI}
{$ENDIF}

interface

uses
  Classes, DB, SysUtils;

type
  TUnit16TextExportContext = record
    FileName: string;
    ReportKind: string;
    ReportCaption: string;
    HeaderText02535934: string;
    HeaderText02535930: string;
    HeaderText02535438: string;
    HeaderText0061E028: string;
  end;

  IUnit16TextExportWriter = interface
    ['{A9E5B9C3-953B-4A58-A6EC-DB454F9C1C07}']
    procedure WriteLine(const Value: string);
    procedure Close;
  end;

  TUnit16TextFileExportWriter = class(TInterfacedObject,
    IUnit16TextExportWriter)
  private
    FFile: TextFile;
    FIsOpen: Boolean;
  public
    constructor Create(const FileName: string);
    destructor Destroy; override;
    procedure WriteLine(const Value: string);
    procedure Close;
  end;

  EUnit16ExportFieldMissing = class(Exception);

var
  { These globals retain their binary cell names; the original app populates
    them outside the recovered Unit16 handler. }
  GlobalVar_02535930: string;
  GlobalVar_02535934: string;
  GlobalVar_02535438: string;

procedure ExecuteUnit16TextExport(const Context: TUnit16TextExportContext;
  Table14, Table22, Table27: TDataSet;
  const Writer: IUnit16TextExportWriter);

implementation

const
  Unit16Separator =
    '----------------------------------------------------------------------------';
  Unit16HtmlDoctype =
    '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN//">';
  Unit16HtmlComment =
    '<!--Converted from AHNENWIN 5.1 (2013) by Heribert Reitmeier-->';
  Unit16HtmlBreak = '<br>';

constructor TUnit16TextFileExportWriter.Create(const FileName: string);
begin
  inherited Create;
  AssignFile(FFile, FileName);
  Rewrite(FFile);
  FIsOpen := True;
end;

destructor TUnit16TextFileExportWriter.Destroy;
begin
  Close;
  inherited Destroy;
end;

procedure TUnit16TextFileExportWriter.WriteLine(const Value: string);
begin
  if not FIsOpen then
    raise EInvalidOperation.Create('The Unit16 export writer is closed.');
  WriteLn(FFile, Value);
end;

procedure TUnit16TextFileExportWriter.Close;
begin
  if FIsOpen then
  begin
    CloseFile(FFile);
    FIsOpen := False;
  end;
end;

function IsHtmlFileName(const FileName: string): Boolean;
begin
  Result := Pos('htm', FileName) > 0;
end;

function HasListCaption(const Caption: string): Boolean;
begin
  Result := (Pos('Namens', Caption) > 0) or (Pos('Orts', Caption) > 0);
end;

function IsSupportedReportKind(const ReportKind: string): Boolean;
begin
  Result :=
    (ReportKind = 'OLPN') or (ReportKind = 'OLAP') or
    (ReportKind = 'NLBO') or (ReportKind = 'NLAP') or
    (ReportKind = 'famb') or (ReportKind = 'OFB') or
    (ReportKind = 'Einz') or (ReportKind = 'Dopp') or
    (ReportKind = 'basa') or (ReportKind = 'Sppr') or
    (ReportKind = 'Sppo') or (ReportKind = 'Vorf') or
    (ReportKind = 'Nach') or (ReportKind = 'Schacht') or
    (ReportKind = 'Tiny');
end;

procedure WriteSeparator(const Writer: IUnit16TextExportWriter;
  const HtmlSuffix: string);
begin
  Writer.WriteLine(Unit16Separator + HtmlSuffix);
end;

procedure WriteHtmlPrologue(const Writer: IUnit16TextExportWriter);
begin
  Writer.WriteLine(Unit16HtmlDoctype);
  Writer.WriteLine(Unit16HtmlComment);
  Writer.WriteLine('<HTML>');
  Writer.WriteLine('<BODY>');
end;

procedure WriteReportHeading(const Context: TUnit16TextExportContext;
  const HtmlSuffix: string; const Writer: IUnit16TextExportWriter);
var
  hasListCaption: Boolean;
  isHtml: Boolean;
begin
  hasListCaption := HasListCaption(Context.ReportCaption);
  isHtml := IsHtmlFileName(Context.FileName);

  if Context.ReportKind = 'Einz' then
  begin
    Writer.WriteLine('Einzelpersonen');
    Writer.WriteLine('( = Personen ohne Eltern, Kinder, Ehe o.ä., nicht adoptiert)');
    WriteSeparator(Writer, HtmlSuffix);
  end;

  if Context.ReportKind = 'Dopp' then
  begin
    Writer.WriteLine('Doppelte (?) Einträge');
    Writer.WriteLine(
      '( = Personen mit gleichen Namen, Vornamen, Geb.-Jahr, Taufjahr und Sterbejahr)');
    WriteSeparator(Writer, HtmlSuffix);
  end;

  if Context.ReportKind = 'Vorf' then
  begin
    if hasListCaption then
    begin
      Writer.WriteLine(Context.ReportCaption);
      WriteSeparator(Writer, HtmlSuffix);
      Writer.WriteLine(Context.HeaderText02535934);
      WriteSeparator(Writer, HtmlSuffix);
    end
    else
    begin
      Writer.WriteLine('Vorfahren von ');
      if isHtml then
        Writer.WriteLine(Unit16HtmlBreak);
      Writer.WriteLine(Unit16Separator);
      if isHtml then
        Writer.WriteLine(Unit16HtmlBreak);
      Writer.WriteLine(Context.HeaderText02535934);
      if isHtml then
        Writer.WriteLine(Unit16HtmlBreak);
      WriteSeparator(Writer, HtmlSuffix);
    end;
  end;

  if Context.ReportKind = 'famb' then
  begin
    Writer.WriteLine('Familienblatt');
    WriteSeparator(Writer, HtmlSuffix);
    Writer.WriteLine(Context.HeaderText02535934);
    WriteSeparator(Writer, HtmlSuffix);
  end;

  if Context.ReportKind = 'OFB' then
  begin
    if hasListCaption then
    begin
      Writer.WriteLine(Context.ReportCaption);
      WriteSeparator(Writer, HtmlSuffix);
    end
    else
    begin
      Writer.WriteLine('OFB');
      Writer.WriteLine(Context.HeaderText02535438);
      WriteSeparator(Writer, HtmlSuffix);
    end;
  end;

  if Context.ReportKind = 'NLAP' then
  begin
    Writer.WriteLine('Namensliste aller Personen');
    WriteSeparator(Writer, HtmlSuffix);
  end;

  if Context.ReportKind = 'NLBO' then
  begin
    Writer.WriteLine(Context.HeaderText02535930);
    WriteSeparator(Writer, HtmlSuffix);
  end;

  if Context.ReportKind = 'OLAP' then
  begin
    Writer.WriteLine('Ortsliste für alle Personen');
    WriteSeparator(Writer, HtmlSuffix);
  end;

  if Context.ReportKind = 'OLPN' then
  begin
    Writer.WriteLine(Context.HeaderText02535930);
    WriteSeparator(Writer, HtmlSuffix);
  end;

  if Context.ReportKind = 'Sppr' then
  begin
    Writer.WriteLine(Context.HeaderText02535930);
    WriteSeparator(Writer, HtmlSuffix);
  end;

  if Context.ReportKind = 'Sppo' then
  begin
    Writer.WriteLine(Context.HeaderText02535930);
    WriteSeparator(Writer, HtmlSuffix);
  end;

  if Context.ReportKind = 'Tiny' then
  begin
    Writer.WriteLine('Tiny-Tafel');
    WriteSeparator(Writer, HtmlSuffix);
  end;

  if Context.ReportKind = 'Nach' then
  begin
    if hasListCaption then
    begin
      Writer.WriteLine(Context.ReportCaption);
      WriteSeparator(Writer, HtmlSuffix);
      Writer.WriteLine(Context.HeaderText02535934);
      WriteSeparator(Writer, HtmlSuffix);
    end
    else
    begin
      Writer.WriteLine(Context.HeaderText0061E028);
      WriteSeparator(Writer, HtmlSuffix);
      Writer.WriteLine(Context.HeaderText02535934);
      WriteSeparator(Writer, HtmlSuffix);
    end;
  end;

  if Context.ReportKind = 'Schacht' then
  begin
    Writer.WriteLine(Context.HeaderText02535930);
    WriteSeparator(Writer, HtmlSuffix);
    Writer.WriteLine(Context.HeaderText02535934);
    WriteSeparator(Writer, HtmlSuffix);
  end;
end;

function RequireField(DataSet: TDataSet; const FieldName: string): TField;
begin
  if DataSet = nil then
    raise EArgumentNilException.Create('DataSet');
  Result := DataSet.FindField(FieldName);
  if Result = nil then
    raise EUnit16ExportFieldMissing.CreateFmt(
      'Unit16 export dataset is missing field "%s".', [FieldName]);
end;

procedure WriteTable22Rows(DataSet: TDataSet;
  const HtmlSuffix: string; const Writer: IUnit16TextExportWriter);
var
  noField: TField;
  additionalTextField: TField;
begin
  noField := RequireField(DataSet, 'No');
  additionalTextField := RequireField(DataSet, 'Zus');
  DataSet.Open;
  DataSet.First;
  while not DataSet.Eof do
  begin
    Writer.WriteLine(noField.AsString + ' ' + additionalTextField.AsString +
      HtmlSuffix);
    DataSet.Next;
  end;
end;

procedure WriteTable14Rows(DataSet: TDataSet;
  const HtmlSuffix: string; const Writer: IUnit16TextExportWriter);
var
  lineField: TField;
  nameField: TField;
begin
  lineField := RequireField(DataSet, 'Zeile');
  nameField := RequireField(DataSet, 'Nm');
  DataSet.Open;
  DataSet.First;
  while not DataSet.Eof do
  begin
    Writer.WriteLine(nameField.AsString + ' ' + lineField.AsString +
      HtmlSuffix);
    DataSet.Next;
  end;
end;

procedure WriteTable27Rows(DataSet: TDataSet;
  const HtmlSuffix: string; const Writer: IUnit16TextExportWriter);
var
  nameField: TField;
begin
  nameField := RequireField(DataSet, 'Namvorn');
  DataSet.Open;
  DataSet.First;
  while not DataSet.Eof do
  begin
    Writer.WriteLine(nameField.AsString + HtmlSuffix);
    DataSet.Next;
  end;
end;

procedure WriteReportRows(const Context: TUnit16TextExportContext;
  Table14, Table22, Table27: TDataSet; const HtmlSuffix: string;
  const Writer: IUnit16TextExportWriter);
begin
  if ((Context.ReportKind = 'Vorf') or (Context.ReportKind = 'Nach') or
      (Context.ReportKind = 'OFB')) and HasListCaption(Context.ReportCaption) then
    WriteTable22Rows(Table22, HtmlSuffix, Writer)
  else if (Context.ReportKind = 'basa') or (Context.ReportKind = 'Sppr') or
          (Context.ReportKind = 'Sppo') then
    WriteTable27Rows(Table27, HtmlSuffix, Writer)
  else
    WriteTable14Rows(Table14, HtmlSuffix, Writer);
end;

procedure ExecuteUnit16TextExport(const Context: TUnit16TextExportContext;
  Table14, Table22, Table27: TDataSet;
  const Writer: IUnit16TextExportWriter);
var
  html: Boolean;
  htmlSuffix: string;
begin
  if Writer = nil then
    raise EArgumentNilException.Create('Writer');

  try
    html := IsHtmlFileName(Context.FileName);
    htmlSuffix := '';
    if html then
    begin
      htmlSuffix := '<p>';
      WriteHtmlPrologue(Writer);
    end;

    if not IsSupportedReportKind(Context.ReportKind) then
      Exit;

    WriteReportHeading(Context, htmlSuffix, Writer);
    WriteReportRows(Context, Table14, Table22, Table27, htmlSuffix, Writer);
    WriteSeparator(Writer, htmlSuffix);
    Writer.WriteLine('AHNENWIN 5.1 / ' + DateToStr(Now));

    if html then
    begin
      Writer.WriteLine('</BODY>');
      Writer.WriteLine('</HTML>');
    end;
  finally
    Writer.Close;
  end;
end;

end.
