unit DI.IServiceScope;

{$mode delphi}
{$H+}

interface

uses
  DI.IServiceProvider;

type
  // Vorwärtsdeklaration nicht mehr nötig, da in separater Datei
  IServiceScope = interface
    ['{B83C56E2-9F1C-4B9A-8507-6B1832A89F4B}']
    function GetServiceProvider: IServiceProvider;
    property ServiceProvider: IServiceProvider read GetServiceProvider;
  end;

implementation

end.
