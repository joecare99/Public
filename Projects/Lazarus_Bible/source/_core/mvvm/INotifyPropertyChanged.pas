{ MVVM-Basis der Delphi-Bible.

  Schnittstelle fuer die Aenderungsmeldung von Eigenschaften. Das Model und
  das ViewModel melden Aenderungen hierueber; die View bindet sich daran. }

unit INotifyPropertyChanged;

interface

type
  { Benachrichtigung ueber eine geaenderte Eigenschaft. }
  INotifyPropertyChanged = interface
    ['{A1B2C3D4-1111-2222-3333-444455556666}']
    procedure PropertyChanged(const APropertyName: string);
  end;

implementation

end.
