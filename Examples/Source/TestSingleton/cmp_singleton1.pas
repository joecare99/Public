unit cmp_Singleton1;
{$IFDEF FPC}
{$MODE objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils;

type
  { TScreenLevels }
  TSingleton1 = class
  private
    { private declaration }
    FTableLoaded: Boolean;
    FNiveau: Integer;
    FMemDataSet: TStringList;
    FSQLTransaction: TStringList;
  public
    { public delaration }
    constructor Create;
    destructor Destroy; override;
  end;

function uSingleton1: TSingleton1;

var
  fSingleton1: TSingleton1 = nil;

implementation

function uSingleton1: TSingleton1;
begin
  if fSingleton1 = nil then
    fSingleton1 := TSingleton1.Create;
  result := fSingleton1;
end;

{ TScreenLevels }

constructor TSingleton1.Create;

begin
  inherited;
  FTableLoaded := false;
  FNiveau := 0;
  FMemDataSet := TStringList.Create;
  FSQLTransaction := TStringList.Create;
end;

destructor TSingleton1.Destroy;
begin
  if FSQLTransaction.Sorted then
    FSQLTransaction.Clear;
  FreeAndNil(FSQLTransaction);
  FMemDataSet.free;
  inherited Destroy;
  fSingleton1 := nil;
end;

end.
