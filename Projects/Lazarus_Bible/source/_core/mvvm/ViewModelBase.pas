{ Basisklasse aller ViewModels und Models der Delphi-Bible.

  Stellt die Aenderungsmeldung fuer Eigenschaften bereit (bewusst ohne
  Generics, damit der Code auch unter Delphi 2007 laesst) und einen kleinen
  Dienst zum Protokollieren. }

unit ViewModelBase;

interface

uses
  Classes, SysUtils, INotifyPropertyChanged, PropertyChangedEventArgs;

type
  { Ereignis: eine Eigenschaft hat sich geaendert. }
  TPropertyChangedEvent = procedure(Sender: TObject;
    const AArgs: TPropertyChangedEventArgs) of object;

  { TViewModelBase }
  TViewModelBase = class(TInterfacedObject, INotifyPropertyChanged)
  private
    FPropertyChanged: TPropertyChangedEvent;
    FLog: TStringList;
  protected
    { Setzt die Eigenschaft nur, wenn sich der Wert aendert, und meldet die
      Aenderung. Gibt True zurueck, wenn sich der Wert geaendert hat. }
    function SetStringProperty(var AField: string; const AValue: string;
      const APropertyName: string): Boolean; virtual;
    function SetIntegerProperty(var AField: Integer; const AValue: Integer;
      const APropertyName: string): Boolean; virtual;
    function SetBooleanProperty(var AField: Boolean; const AValue: Boolean;
      const APropertyName: string): Boolean; virtual;
    function SetDoubleProperty(var AField: Double; const AValue: Double;
      const APropertyName: string): Boolean; virtual;
    procedure Log(const AMessage: string);
    property LogLines: TStringList read FLog;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure PropertyChanged(const APropertyName: string); virtual;
    property OnPropertyChanged: TPropertyChangedEvent read FPropertyChanged
      write FPropertyChanged;
  end;

implementation

constructor TViewModelBase.Create;
begin
  inherited Create;
  FLog := TStringList.Create;
end;

destructor TViewModelBase.Destroy;
begin
  FreeAndNil(FLog);
  inherited Destroy;
end;

procedure TViewModelBase.PropertyChanged(const APropertyName: string);
var
  Args: TPropertyChangedEventArgs;
begin
  if Assigned(FPropertyChanged) then
  begin
    Args := TPropertyChangedEventArgs.Create(APropertyName, Unassigned, Unassigned);
    try
      FPropertyChanged(Self, Args);
    finally
      Args.Free;
    end;
  end;
end;

function TViewModelBase.SetStringProperty(var AField: string;
  const AValue: string; const APropertyName: string): Boolean;
begin
  Result := AField <> AValue;
  if Result then
  begin
    AField := AValue;
    PropertyChanged(APropertyName);
  end;
end;

function TViewModelBase.SetIntegerProperty(var AField: Integer;
  const AValue: Integer; const APropertyName: string): Boolean;
begin
  Result := AField <> AValue;
  if Result then
  begin
    AField := AValue;
    PropertyChanged(APropertyName);
  end;
end;

function TViewModelBase.SetBooleanProperty(var AField: Boolean;
  const AValue: Boolean; const APropertyName: string): Boolean;
begin
  Result := AField <> AValue;
  if Result then
  begin
    AField := AValue;
    PropertyChanged(APropertyName);
  end;
end;

function TViewModelBase.SetDoubleProperty(var AField: Double;
  const AValue: Double; const APropertyName: string): Boolean;
begin
  Result := AField <> AValue;
  if Result then
  begin
    AField := AValue;
    PropertyChanged(APropertyName);
  end;
end;

procedure TViewModelBase.Log(const AMessage: string);
begin
  FLog.Add(AMessage);
end;

end.
