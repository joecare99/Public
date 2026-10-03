unit Unit18ExportWorkflow;

{$IFDEF FPC}
{$MODE DELPHI}
{$H+}
{$ENDIF}

interface

uses
  SysUtils;

type
  EUnit18ExportArgumentError = class(Exception);
  EUnit18TextWriterClosed = class(Exception);

const
  Unit18ExportHeader = 'Nr.'#9'Name'#9'geb.am'#9'in'#9'gest.am'#9'in'#9 +
    'geh.am'#9'in'#9'den/die';

type
  TUnit18ExportRow = record
    Number: Integer;
    Name: string;
    BirthDay: string;
    BirthMonth: string;
    BirthYear: string;
    BirthPlace: string;
    DeathDay: string;
    DeathMonth: string;
    DeathYear: string;
    DeathPlace: string;
    HDay: string;
    HMonth: string;
    HYear: string;
    HPlace: string;
    HName: string;
  end;

  TUnit18ExportNormalizer = procedure(InputText: AnsiString;
    var OutputText: AnsiString);

  IUnit18ExportSource = interface
    ['{648101B3-399A-4473-8B45-E837C9BD2156}']
    procedure First;
    function EOF: Boolean;
    function CurrentRow: TUnit18ExportRow;
    procedure Next;
  end;

  IUnit18ExportSourceFactory = interface
    ['{ABF3AE7E-1A29-493E-A2A0-D252715389D0}']
    function CreateSource: IUnit18ExportSource;
  end;

  IUnit18TextWriter = interface
    ['{C3A8C26B-8706-4261-928B-D056A4963EEB}']
    procedure WriteLine(const LineText: string);
    procedure Close;
  end;

  IUnit18TextWriterFactory = interface
    ['{A7C1CD34-5E6D-4258-A20B-3373BAC90639}']
    function CreateWriter(const FileName: string): IUnit18TextWriter;
  end;

  TUnit18TextFileWriter = class(TInterfacedObject, IUnit18TextWriter)
  private
    FFile: TextFile;
    FIsOpen: Boolean;
  public
    constructor Create(const FileName: string);
    destructor Destroy; override;
    procedure WriteLine(const LineText: string);
    procedure Close;
  end;

  TUnit18TextFileWriterFactory = class(TInterfacedObject,
    IUnit18TextWriterFactory)
  public
    function CreateWriter(const FileName: string): IUnit18TextWriter;
  end;

function FormatUnit18ExportRow(const Row: TUnit18ExportRow;
  NormalizeDeathDate: TUnit18ExportNormalizer): string;
procedure WriteUnit18ExportFile(Source: IUnit18ExportSource;
  Writer: IUnit18TextWriter; NormalizeDeathDate: TUnit18ExportNormalizer);

implementation

constructor TUnit18TextFileWriter.Create(const FileName: string);
begin
  inherited Create;
  AssignFile(FFile, FileName);
  Rewrite(FFile);
  FIsOpen := True;
end;

destructor TUnit18TextFileWriter.Destroy;
begin
  Close;
  inherited Destroy;
end;

procedure TUnit18TextFileWriter.WriteLine(const LineText: string);
begin
  if not FIsOpen then
    raise EUnit18TextWriterClosed.Create(
      'The export text file is not open.');
  Writeln(FFile, LineText);
end;

procedure TUnit18TextFileWriter.Close;
begin
  if FIsOpen then
  begin
    CloseFile(FFile);
    FIsOpen := False;
  end;
end;

function TUnit18TextFileWriterFactory.CreateWriter(
  const FileName: string): IUnit18TextWriter;
begin
  Result := TUnit18TextFileWriter.Create(FileName);
end;

function FormatUnit18ExportRow(const Row: TUnit18ExportRow;
  NormalizeDeathDate: TUnit18ExportNormalizer): string;
var
  NumberText: string;
  DeathDateText: AnsiString;
begin
  DeathDateText := '';
  if Row.Number = 0 then
    NumberText := Format('%5s', [' '])
  else
    NumberText := Format('%5s', [IntToStr(Row.Number)]);

  if not Assigned(NormalizeDeathDate) then
    raise EUnit18ExportArgumentError.Create(
      'NormalizeDeathDate must be assigned.');
  NormalizeDeathDate(Row.DeathDay + '.' + Row.DeathMonth + '.' +
    Row.DeathYear, DeathDateText);

  Result := NumberText + #9 + Row.Name + #9 + Row.BirthDay + '.' +
    Row.BirthMonth + '.' + Row.BirthYear + #9 + Row.BirthPlace + #9 +
    DeathDateText + #9 + Row.DeathPlace + #9 + Row.HDay + '.' +
    Row.HMonth + '.' + Row.HYear + #9 + Row.HPlace + #9 + Row.HName;
end;

procedure WriteUnit18ExportFile(Source: IUnit18ExportSource;
  Writer: IUnit18TextWriter; NormalizeDeathDate: TUnit18ExportNormalizer);
var
  Row: TUnit18ExportRow;
begin
  if Source = nil then
    raise EUnit18ExportArgumentError.Create('Source must not be nil.');
  if Writer = nil then
    raise EUnit18ExportArgumentError.Create('Writer must not be nil.');

  Source.First;
  Writer.WriteLine(Unit18ExportHeader);
  Writer.WriteLine(' ');
  while not Source.EOF do
  begin
    Row := Source.CurrentRow;
    Writer.WriteLine(FormatUnit18ExportRow(Row, NormalizeDeathDate));
    Source.Next;
  end;
end;

end.
