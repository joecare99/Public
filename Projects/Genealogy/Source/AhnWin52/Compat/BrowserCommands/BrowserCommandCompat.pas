unit BrowserCommandCompat;

{$IFDEF FPC}{$MODE DELPHI}{$ENDIF}

interface

uses
  SysUtils;

const
  BrowserCommandIdSaveAs = 4;
  BrowserCommandIdPrint = 6;
  BrowserCommandOptionDoDefault = 0;

type
  IBrowserCommandProvider = interface
    ['{FAD6D570-5B6E-4B4A-9955-A4BF65E80CB2}']
    procedure ExecuteBrowserCommand(CommandId, CommandOptions: Integer);
  end;

  EBrowserCommandCompatibilityUnsupported = class(Exception)
  private
    FCommandId: Integer;
    FCommandOptions: Integer;
    FOperation: string;
  public
    constructor Create(CommandId, CommandOptions: Integer);
    property CommandId: Integer read FCommandId;
    property CommandOptions: Integer read FCommandOptions;
    property Operation: string read FOperation;
  end;

  TUnsupportedBrowserCommandProvider = class(TInterfacedObject,
    IBrowserCommandProvider)
  public
    procedure ExecuteBrowserCommand(CommandId, CommandOptions: Integer);
  end;

function CreateUnsupportedBrowserCommandProvider: IBrowserCommandProvider;

implementation

constructor EBrowserCommandCompatibilityUnsupported.Create(CommandId,
  CommandOptions: Integer);
begin
  FCommandId := CommandId;
  FCommandOptions := CommandOptions;
  FOperation := Format('TWebBrowser.ExecWB(%d, %d)',
    [CommandId, CommandOptions]);
  inherited CreateFmt(
    'Browser command compatibility is unsupported for "%s".',
    [FOperation]);
end;

procedure TUnsupportedBrowserCommandProvider.ExecuteBrowserCommand(
  CommandId, CommandOptions: Integer);
begin
  raise EBrowserCommandCompatibilityUnsupported.Create(
    CommandId, CommandOptions);
end;

function CreateUnsupportedBrowserCommandProvider: IBrowserCommandProvider;
begin
  Result := TUnsupportedBrowserCommandProvider.Create;
end;

end.
