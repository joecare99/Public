{ ViewModel des Readme-Demos.

  Sucht die Readme-Datei, laedt sie ueber den Dateidienst und stellt
  Inhalt und Dateiname fuer die View bereit. Das Oeffnen der Datei mit dem
  Standardprogramm erledigt der Prozessdienst. }

unit ReadMeViewModel;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  Classes, SysUtils, ViewModelBase, PropertyChangedEventArgs, Command,
  ReadMeDocument, FileService, ProcessService;

type
  { TReadMeViewModel }
  TReadMeViewModel = class(TViewModelBase)
  private
    FDocument: TReadMeDocument;
    FFileService: TFileService;
    FProcessService: TProcessService;
    FOpenCommand: TCommand;
    FErrorMessage: string;
    procedure SetErrorMessage(const AValue: string);
    procedure DoOpen(Sender: TObject);
    { Sucht die Readme-Datei in den ueblichen Verzeichnissen. }
    function LocateReadMe: string;
  public
    constructor Create; override;
    destructor Destroy; override;
    { Laedt die Datei neu. }
    procedure Load;
    { Inhalt der Datei. }
    function GetContent: string;
    { Name der geladenen Datei. }
    function GetFileName: string;
    property Content: string read GetContent;
    property FileName: string read GetFileName;
    property ErrorMessage: string read FErrorMessage write SetErrorMessage;
    property OpenCommand: TCommand read FOpenCommand;
    property Document: TReadMeDocument read FDocument;
  end;

implementation

const
  ReadMeFile = 'Readme.Txt';
  DefDataDir = 'Data';

constructor TReadMeViewModel.Create;
begin
  inherited Create;
  FFileService := TFileService.Create;
  FProcessService := TProcessService.Create;
  FDocument := TReadMeDocument.Create('');
  FOpenCommand := TCommand.Create('Oeffnen');
  FOpenCommand.OnExecute := DoOpen;
  Load;
end;

destructor TReadMeViewModel.Destroy;
begin
  FreeAndNil(FOpenCommand);
  FreeAndNil(FDocument);
  FreeAndNil(FProcessService);
  FreeAndNil(FFileService);
  inherited Destroy;
end;

procedure TReadMeViewModel.SetErrorMessage(const AValue: string);
begin
  if SetStringProperty(FErrorMessage, AValue, 'ErrorMessage') then
    PropertyChanged('Content');
end;

{ Sucht die Readme-Datei: entweder als Kommandozeilenargument oder in den
  Datenzverzeichnissen neben dem Programm. }
function TReadMeViewModel.LocateReadMe: string;
var
  I: Integer;
  DataDir: string;
begin
  { Im Screenshot-Modus ist der erste Parameter die Bilddatei. }
  if (ParamCount >= 1) and (ParamStr(1) <> '--screenshot') then
  begin
    Result := ParamStr(1);
    Exit;
  end;
  DataDir := DefDataDir;
  for I := 0 to 2 do
    if not DirectoryExists(DataDir) then
      DataDir := '..' + PathDelim + DataDir
    else
      Break;
  Result := DataDir + PathDelim + ReadMeFile;
end;

procedure TReadMeViewModel.Load;
var
  Lines: TStringList;
  FileName: string;
begin
  FileName := LocateReadMe;
  FDocument.FileName := FileName;
  try
    Lines := FFileService.ReadLines(FileName);
    try
      FDocument.Content := Lines.Text;
    finally
      Lines.Free;
    end;
    ErrorMessage := '';
  except
    on E: Exception do
      ErrorMessage := E.Message;
  end;
  PropertyChanged('Content');
  PropertyChanged('FileName');
end;

function TReadMeViewModel.GetContent: string;
begin
  Result := FDocument.Content;
end;

function TReadMeViewModel.GetFileName: string;
begin
  Result := FDocument.FileName;
end;

procedure TReadMeViewModel.DoOpen(Sender: TObject);
begin
  if FDocument.FileName = '' then
    Exit;
  if not FProcessService.Open(FDocument.FileName) then
    ErrorMessage := 'Datei konnte nicht geoeffnet werden: ' + FDocument.FileName;
end;

end.
