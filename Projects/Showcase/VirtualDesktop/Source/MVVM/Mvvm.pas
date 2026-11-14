unit Mvvm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TPropertyChangedEvent = procedure(Sender: TObject;
    const APropertyName: string) of object;
  TNotifyCanExecuteChanged = procedure(Sender: TObject) of object;
  TExecuteCommandEvent = procedure(Sender: TObject;
    const AParameter: string) of object;
  TCanExecuteCommandEvent = function(Sender: TObject;
    const AParameter: string): Boolean of object;

  INotifyPropertyChanged = interface
    ['{0A2A0A80-8DF8-4D4F-9B12-F6D0F6AA2C11}']
    procedure AddPropertyChanged(const AConsumer: TPropertyChangedEvent);
    procedure RemovePropertyChanged(const AConsumer: TPropertyChangedEvent);
  end;

  ICommand = interface
    ['{D01B3BA0-8F30-4F18-91D0-B0E5A7E07E65}']
    function CanExecute(const AParameter: string): Boolean;
    procedure Execute(const AParameter: string);
    procedure AddCanExecuteChanged(const AConsumer: TNotifyCanExecuteChanged);
    procedure RemoveCanExecuteChanged(const AConsumer: TNotifyCanExecuteChanged);
  end;

  TNotifyPropertyChangedObject = class(TInterfacedObject, INotifyPropertyChanged)
  private
    FConsumers: array of TPropertyChangedEvent;
  protected
    procedure NotifyPropertyChanged(const APropertyName: string);
  public
    procedure AddPropertyChanged(const AConsumer: TPropertyChangedEvent);
    procedure RemovePropertyChanged(const AConsumer: TPropertyChangedEvent);
  end;

  TDelegateCommand = class(TInterfacedObject, ICommand)
  private
    FExecute: TExecuteCommandEvent;
    FCanExecute: TCanExecuteCommandEvent;
    FConsumers: array of TNotifyCanExecuteChanged;
  public
    procedure NotifyCanExecuteChanged;
    constructor Create(const AExecute: TExecuteCommandEvent;
      const ACanExecute: TCanExecuteCommandEvent = nil);
    function CanExecute(const AParameter: string): Boolean;
    procedure Execute(const AParameter: string);
    procedure AddCanExecuteChanged(const AConsumer: TNotifyCanExecuteChanged);
    procedure RemoveCanExecuteChanged(const AConsumer: TNotifyCanExecuteChanged);
  end;

implementation

function SamePropertyConsumer(const ALeft, ARight: TPropertyChangedEvent): Boolean;
begin
  Result := (TMethod(ALeft).Code = TMethod(ARight).Code) and
    (TMethod(ALeft).Data = TMethod(ARight).Data);
end;

function SameCommandConsumer(const ALeft, ARight: TNotifyCanExecuteChanged): Boolean;
begin
  Result := (TMethod(ALeft).Code = TMethod(ARight).Code) and
    (TMethod(ALeft).Data = TMethod(ARight).Data);
end;

procedure TNotifyPropertyChangedObject.AddPropertyChanged(
  const AConsumer: TPropertyChangedEvent);
var
  I: Integer;
begin
  if not Assigned(AConsumer) then
    Exit;
  for I := 0 to High(FConsumers) do
    if SamePropertyConsumer(FConsumers[I], AConsumer) then
      Exit;
  SetLength(FConsumers, Length(FConsumers) + 1);
  FConsumers[High(FConsumers)] := AConsumer;
end;

procedure TNotifyPropertyChangedObject.RemovePropertyChanged(
  const AConsumer: TPropertyChangedEvent);
var
  I: Integer;
begin
  for I := 0 to High(FConsumers) do
    if SamePropertyConsumer(FConsumers[I], AConsumer) then
    begin
      FConsumers[I] := FConsumers[High(FConsumers)];
      SetLength(FConsumers, Length(FConsumers) - 1);
      Exit;
    end;
end;

procedure TNotifyPropertyChangedObject.NotifyPropertyChanged(
  const APropertyName: string);
var
  I: Integer;
  Consumers: array of TPropertyChangedEvent;
begin
  Consumers := Copy(FConsumers);
  for I := 0 to High(Consumers) do
    Consumers[I](Self, APropertyName);
end;

constructor TDelegateCommand.Create(const AExecute: TExecuteCommandEvent;
  const ACanExecute: TCanExecuteCommandEvent);
begin
  inherited Create;
  if not Assigned(AExecute) then
    raise EArgumentNilException.Create('A command execute handler is required.');
  FExecute := AExecute;
  FCanExecute := ACanExecute;
end;

function TDelegateCommand.CanExecute(const AParameter: string): Boolean;
begin
  Result := not Assigned(FCanExecute) or FCanExecute(Self, AParameter);
end;

procedure TDelegateCommand.Execute(const AParameter: string);
begin
  if CanExecute(AParameter) then
    FExecute(Self, AParameter);
end;

procedure TDelegateCommand.AddCanExecuteChanged(
  const AConsumer: TNotifyCanExecuteChanged);
var
  I: Integer;
begin
  if not Assigned(AConsumer) then
    Exit;
  for I := 0 to High(FConsumers) do
    if SameCommandConsumer(FConsumers[I], AConsumer) then
      Exit;
  SetLength(FConsumers, Length(FConsumers) + 1);
  FConsumers[High(FConsumers)] := AConsumer;
end;

procedure TDelegateCommand.RemoveCanExecuteChanged(
  const AConsumer: TNotifyCanExecuteChanged);
var
  I: Integer;
begin
  for I := 0 to High(FConsumers) do
    if SameCommandConsumer(FConsumers[I], AConsumer) then
    begin
      FConsumers[I] := FConsumers[High(FConsumers)];
      SetLength(FConsumers, Length(FConsumers) - 1);
      Exit;
    end;
end;

procedure TDelegateCommand.NotifyCanExecuteChanged;
var
  I: Integer;
  Consumers: array of TNotifyCanExecuteChanged;
begin
  Consumers := Copy(FConsumers);
  for I := 0 to High(Consumers) do
    Consumers[I](Self);
end;

end.
