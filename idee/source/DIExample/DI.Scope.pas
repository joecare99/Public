unit DI.Scope;

{$mode delphi}
{$H+}

interface

uses
  DI.IServiceProvider, DI.IServiceScope;

type
  // Verweist intern auf den Container
  TDIScope = class(TInterfacedObject, IServiceScope)
  private
    FScopedProvider: IServiceProvider;
  public
    constructor Create(AScopedProvider: IServiceProvider);
    function GetServiceProvider: IServiceProvider;
  end;

implementation

constructor TDIScope.Create(AScopedProvider: IServiceProvider);
begin
  inherited Create;
  FScopedProvider := AScopedProvider;
end;

function TDIScope.GetServiceProvider: IServiceProvider;
begin
  Result := FScopedProvider;
end;

end.
