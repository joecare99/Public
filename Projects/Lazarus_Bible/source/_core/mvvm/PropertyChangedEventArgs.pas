{ Daten der Aenderungsmeldung einer Eigenschaft. }

unit PropertyChangedEventArgs;

interface

type
  { TPropertyChangedEventArgs }
  TPropertyChangedEventArgs = class
  private
    FPropertyName: string;
    FOldValue: Variant;
    FNewValue: Variant;
  public
    constructor Create(const APropertyName: string;
      const AOldValue, ANewValue: Variant);
    property PropertyName: string read FPropertyName;
    property OldValue: Variant read FOldValue;
    property NewValue: Variant read FNewValue;
  end;

implementation

constructor TPropertyChangedEventArgs.Create(const APropertyName: string;
  const AOldValue, ANewValue: Variant);
begin
  inherited Create;
  FPropertyName := APropertyName;
  FOldValue := AOldValue;
  FNewValue := ANewValue;
end;

end.
