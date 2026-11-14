unit DI.IServiceProvider;

{$mode delphi}
{$H+}

// Schaltet die FPC-Meldung "Unit 'Rtti' is experimental" stumm
{$WARN 6058 OFF}

interface

uses
  SysUtils, TypInfo, Rtti;

type
  // Reines, schlankes Interface
  IServiceProvider = interface
    ['{696144D9-6A42-4A73-A7C7-56E0EB0B6F01}']
    function Resolve(ATypeInfo: PTypeInfo): TValue;
    function CreateScope: IInterface;
  end;

// Globale generische Hilfsfunktion für bequemen Aufruf:
function Resolve<T: IInterface>(const AProvider: IServiceProvider): T;

implementation

function Resolve<T>(const AProvider: IServiceProvider): T;
var
  Val: TValue;
begin
  if AProvider = nil then
    raise EArgumentNilException.Create('Provider darf nicht nil sein.');

  Val := AProvider.Resolve(TypeInfo(T));
  Val.ExtractRawData(@Result);
end;

end.
