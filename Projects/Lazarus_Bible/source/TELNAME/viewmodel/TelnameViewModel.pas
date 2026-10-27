unit TelnameViewModel;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  Classes, SysUtils, ViewModelBase, PropertyChangedEventArgs, Command,
  TelnameModel;

type
  TTelnameViewModel = class(TViewModelBase)
  private
    FModel: TTelnameModel;
    FNameText: string;
    FNumberText: string;
    FErrorMessage: string;
    FNames: TStringList;
    FConvertNameCommand: TCommand;
    FGenerateNamesCommand: TCommand;
    procedure SetNameText(const AValue: string);
    procedure SetNumberText(const AValue: string);
    procedure SetErrorMessage(const AValue: string);
    procedure DoConvertName(Sender: TObject);
    procedure DoGenerateNames(Sender: TObject);
  public
    constructor Create; override;
    destructor Destroy; override;
    property NameText: string read FNameText write SetNameText;
    property NumberText: string read FNumberText write SetNumberText;
    property ErrorMessage: string read FErrorMessage write SetErrorMessage;
    property Names: TStringList read FNames;
    property ConvertNameCommand: TCommand read FConvertNameCommand;
    property GenerateNamesCommand: TCommand read FGenerateNamesCommand;
  end;

implementation

constructor TTelnameViewModel.Create;
begin
  inherited Create;
  FModel := TTelnameModel.Create;
  FNames := TStringList.Create;
  FConvertNameCommand := TCommand.Create('Name in Nummer umwandeln');
  FConvertNameCommand.OnExecute := DoConvertName;
  FGenerateNamesCommand := TCommand.Create('Namen erzeugen');
  FGenerateNamesCommand.OnExecute := DoGenerateNames;
end;

destructor TTelnameViewModel.Destroy;
begin
  FreeAndNil(FGenerateNamesCommand);
  FreeAndNil(FConvertNameCommand);
  FreeAndNil(FNames);
  FreeAndNil(FModel);
  inherited Destroy;
end;

procedure TTelnameViewModel.SetNameText(const AValue: string);
begin
  SetStringProperty(FNameText, AValue, 'NameText');
end;

procedure TTelnameViewModel.SetNumberText(const AValue: string);
begin
  SetStringProperty(FNumberText, AValue, 'NumberText');
end;

procedure TTelnameViewModel.SetErrorMessage(const AValue: string);
begin
  SetStringProperty(FErrorMessage, AValue, 'ErrorMessage');
end;

procedure TTelnameViewModel.DoConvertName(Sender: TObject);
begin
  try
    NumberText := FModel.NameToNumber(NameText);
    ErrorMessage := '';
  except
    on E: Exception do
      ErrorMessage := E.Message;
  end;
end;

procedure TTelnameViewModel.DoGenerateNames(Sender: TObject);
begin
  try
    FModel.NumberToNames(NumberText, FNames);
    ErrorMessage := '';
  except
    on E: Exception do
    begin
      FNames.Clear;
      ErrorMessage := E.Message;
    end;
  end;
  PropertyChanged('Names');
end;

end.
