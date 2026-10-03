unit CalculatorViewModel;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Mvvm;

type
  TCalculatorViewModel = class(TNotifyPropertyChangedObject)
  private
    FDisplay: string;
    FStoredValue: Double;
    FPendingOperator: Char;
    FEntering: Boolean;
    FInputCommand: ICommand;
    function CurrentValue: Double;
    procedure SetDisplayValue(const AValue: Double);
    procedure ExecuteInput(Sender: TObject; const AParameter: string);
    function CanExecuteInput(Sender: TObject; const AParameter: string): Boolean;
  public
    constructor Create;
    procedure PressDigit(const ADigit: Char);
    procedure PressDecimal;
    procedure PressOperator(const AOperator: Char);
    procedure PressEquals;
    procedure PressClear;
    property Display: string read FDisplay;
    property InputCommand: ICommand read FInputCommand;
  end;

implementation

constructor TCalculatorViewModel.Create;
begin
  inherited Create;
  FInputCommand := TDelegateCommand.Create(@ExecuteInput, @CanExecuteInput);
  PressClear;
end;

procedure TCalculatorViewModel.ExecuteInput(Sender: TObject;
  const AParameter: string);
var
  Value: Char;
begin
  if AParameter = '' then
    Exit;
  Value := AParameter[1];
  if Value = 'C' then
    PressClear
  else if Value = '.' then
    PressDecimal
  else if Value = '=' then
    PressEquals
  else if Value in ['+', '-', '*', '/'] then
    PressOperator(Value)
  else
    PressDigit(Value);
end;

function TCalculatorViewModel.CanExecuteInput(Sender: TObject;
  const AParameter: string): Boolean;
begin
  Result := Length(AParameter) = 1;
end;

function TCalculatorViewModel.CurrentValue: Double;
begin
  if not TryStrToFloat(FDisplay, Result) then
    Result := 0;
end;

procedure TCalculatorViewModel.SetDisplayValue(const AValue: Double);
begin
  FDisplay := FloatToStr(AValue);
  NotifyPropertyChanged('Display');
end;

procedure TCalculatorViewModel.PressDigit(const ADigit: Char);
begin
  if FEntering then
    FDisplay := FDisplay + ADigit
  else begin
    FDisplay := ADigit;
    FEntering := True;
    NotifyPropertyChanged('Display');
  end;
end;

procedure TCalculatorViewModel.PressDecimal;
begin
  if not FEntering then begin
    FDisplay := '0' + DefaultFormatSettings.DecimalSeparator;
    FEntering := True;
  end else if Pos(DefaultFormatSettings.DecimalSeparator, FDisplay) = 0 then
    FDisplay := FDisplay + DefaultFormatSettings.DecimalSeparator;
  NotifyPropertyChanged('Display');
end;

procedure TCalculatorViewModel.PressOperator(const AOperator: Char);
begin
  FStoredValue := CurrentValue;
  FPendingOperator := AOperator;
  FEntering := False;
  NotifyPropertyChanged('Display');
end;

procedure TCalculatorViewModel.PressEquals;
var
  Current: Double;
begin
  Current := CurrentValue;
  case FPendingOperator of
    '+': FStoredValue := FStoredValue + Current;
    '-': FStoredValue := FStoredValue - Current;
    '*': FStoredValue := FStoredValue * Current;
    '/': if Current <> 0 then FStoredValue := FStoredValue / Current;
  else
    FStoredValue := Current;
  end;
  SetDisplayValue(FStoredValue);
  FPendingOperator := #0;
  FEntering := False;
  NotifyPropertyChanged('Display');
end;

procedure TCalculatorViewModel.PressClear;
begin
  FDisplay := '0';
  FStoredValue := 0;
  FPendingOperator := #0;
  FEntering := False;
  NotifyPropertyChanged('Display');
end;

end.
