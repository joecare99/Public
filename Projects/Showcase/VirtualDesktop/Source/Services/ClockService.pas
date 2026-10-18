unit ClockService;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Services;

type
  TSystemClockService = class(TInterfacedObject, IClockService)
  public
    function Now: TDateTime;
  end;

implementation

function TSystemClockService.Now: TDateTime;
begin
  Result := SysUtils.Now;
end;

end.
