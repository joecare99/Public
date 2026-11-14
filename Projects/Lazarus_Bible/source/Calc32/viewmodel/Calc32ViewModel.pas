{ ViewModel des Calculator-Demos.

  Vermittelt zwischen der View (Formular) und dem Rechenmodell. Die View
  ruft die Kommandos des ViewModels auf und zeigt die angezeigten Texte an. }

unit Calc32ViewModel;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  Classes, SysUtils, ViewModelBase, PropertyChangedEventArgs, Command,
  CalculatorModel;

type
  { TCalc32ViewModel }
  TCalc32ViewModel = class(TViewModelBase)
  private
    FModel: TCalculatorModel;
    FErrorMessage: string;
    FExitCommand: TCommand;
    procedure SetErrorMessage(const AValue: string);
    procedure DoExit(Sender: TObject);
    { Meldet die geaenderten Anzeigewerte. }
    procedure NotifyDisplay;
    { Nimmt einen Rechenfehler entgegen. }
    procedure ReportError(E: Exception);
    function GetDecimalText: string;
    function GetHexText: string;
    function GetBinaryText: string;
    function GetMemoryText: Integer;
    function GetOperationText: TCalcOperation;
    function GetValue: Integer;
  public
    constructor Create; override;
    destructor Destroy; override;
    { Uebernimmt eine Ziffer der Tastatur. }
    procedure Digit(ADigit: Integer);
    { Setzt eine Rechenoperation. }
    procedure Operator(AOperation: TCalcOperation);
    { Fuehrt die Rechenoperation aus. }
    procedure Equals;
    { Loescht die Eingabe. }
    procedure ClearEntry;
    { Loescht Eingabe und Zwischenspeicher. }
    procedure ClearAll;
    { Loescht die letzte Ziffer. }
    procedure Backspace;
    { Wechselt das Vorzeichen. }
    procedure Negate;
    { Bitweise Negation. }
    procedure BitwiseNot;
    { Wechselt das Eingabezahlensystem. }
    procedure Radix(ARadix: TCalcRadix);
    { Uebernimmt einen Text (z. B. aus der Zwischenablage) als Eingabe. }
    procedure SetEntryText(const AText: string);
    { Text fuer die Clipboard-Aktionen (je nach Zahlensystem). }
    function CurrentText: string;
    property DecimalText: string read GetDecimalText;
    property HexText: string read GetHexText;
    property BinaryText: string read GetBinaryText;
    property MemoryText: Integer read GetMemoryText;
    property OperationText: TCalcOperation read GetOperationText;
    property Value: Integer read GetValue;
    property Model: TCalculatorModel read FModel;
    property ErrorMessage: string read FErrorMessage write SetErrorMessage;
    property ExitCommand: TCommand read FExitCommand;
  end;

implementation

constructor TCalc32ViewModel.Create;
begin
  inherited Create;
  FModel := TCalculatorModel.Create;
  FExitCommand := TCommand.Create('Beenden');
  FExitCommand.OnExecute := DoExit;
end;

destructor TCalc32ViewModel.Destroy;
begin
  FreeAndNil(FExitCommand);
  FreeAndNil(FModel);
  inherited Destroy;
end;

procedure TCalc32ViewModel.SetErrorMessage(const AValue: string);
begin
  if SetStringProperty(FErrorMessage, AValue, 'ErrorMessage') then
    PropertyChanged('DecimalText');
end;

{ Fuehrt eine Operation aus und faengt Rechenfehler ab. }
procedure TCalc32ViewModel.NotifyDisplay;
begin
  PropertyChanged('DecimalText');
  PropertyChanged('HexText');
  PropertyChanged('BinaryText');
  PropertyChanged('MemoryText');
  PropertyChanged('OperationText');
  PropertyChanged('Value');
end;

procedure TCalc32ViewModel.ReportError(E: Exception);
begin
  ErrorMessage := E.Message;
  NotifyDisplay;
end;

procedure TCalc32ViewModel.Digit(ADigit: Integer);
begin
  try
    FModel.InputDigit(ADigit);
    ErrorMessage := '';
  except
    on E: Exception do
      ReportError(E);
  end;
  NotifyDisplay;
end;

procedure TCalc32ViewModel.Operator(AOperation: TCalcOperation);
begin
  try
    FModel.SetOperator(AOperation);
    ErrorMessage := '';
  except
    on E: Exception do
      ReportError(E);
  end;
  NotifyDisplay;
end;

procedure TCalc32ViewModel.Equals;
begin
  try
    FModel.Equals;
    ErrorMessage := '';
  except
    on E: Exception do
      ReportError(E);
  end;
  NotifyDisplay;
end;

procedure TCalc32ViewModel.ClearEntry;
begin
  FModel.ClearEntry;
  ErrorMessage := '';
  NotifyDisplay;
end;

procedure TCalc32ViewModel.ClearAll;
begin
  FModel.ClearAll;
  ErrorMessage := '';
  NotifyDisplay;
end;

procedure TCalc32ViewModel.Backspace;
begin
  try
    FModel.Backspace;
    ErrorMessage := '';
  except
    on E: Exception do
      ReportError(E);
  end;
  NotifyDisplay;
end;

procedure TCalc32ViewModel.Negate;
begin
  FModel.Negate;
  NotifyDisplay;
end;

procedure TCalc32ViewModel.BitwiseNot;
begin
  FModel.BitwiseNot;
  NotifyDisplay;
end;

procedure TCalc32ViewModel.Radix(ARadix: TCalcRadix);
begin
  FModel.SetRadix(ARadix);
  NotifyDisplay;
end;

procedure TCalc32ViewModel.SetEntryText(const AText: string);
begin
  try
    FModel.SetEntryText(AText);
    ErrorMessage := '';
  except
    on E: Exception do
      ReportError(E);
  end;
  NotifyDisplay;
end;

function TCalc32ViewModel.CurrentText: string;
begin
  case FModel.Radix of
    radixDecimal: Result := FModel.DecimalText;
    radixHex: Result := FModel.HexText;
    radixBinary: Result := FModel.BinaryText;
  else
    Result := FModel.DecimalText;
  end;
end;

procedure TCalc32ViewModel.DoExit(Sender: TObject);
begin
  { Das Beenden der Anwendung bleibt bei der View. }
end;

function TCalc32ViewModel.GetDecimalText: string;
begin
  Result := FModel.DecimalDisplay;
end;

function TCalc32ViewModel.GetHexText: string;
begin
  Result := FModel.HexDisplay;
end;

function TCalc32ViewModel.GetBinaryText: string;
begin
  Result := FModel.BinaryDisplay;
end;

function TCalc32ViewModel.GetMemoryText: Integer;
begin
  Result := FModel.Memory;
end;

function TCalc32ViewModel.GetOperationText: TCalcOperation;
begin
  Result := FModel.Operator;
end;

function TCalc32ViewModel.GetValue: Integer;
begin
  Result := FModel.Accumulator;
end;

end.
