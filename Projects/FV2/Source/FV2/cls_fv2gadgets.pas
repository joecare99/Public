unit cls_fv2gadgets;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Types, cls_fv2controls, cls_fv2canvas;

type
  TClockView = class(TControl)
  protected
    procedure DrawSelf(ACanvas: TFvCanvas); override;
  end;

  THeapView = class(TControl)
  protected
    procedure DrawSelf(ACanvas: TFvCanvas); override;
  end;

  TPalette = class(TPersistent)
  private
    FColors: array of Byte;
    function GetColor(Index: Integer): Byte;
    procedure SetColor(Index: Integer; AValue: Byte);
    function GetLength: Integer;
  public
    constructor Create(ALength: Integer = 0);
    property Colors[Index: Integer]: Byte read GetColor write SetColor; default;
    property Length: Integer read GetLength;
  end;

implementation

procedure TClockView.DrawSelf(ACanvas: TFvCanvas);
begin
  ACanvas.TextOut(0, 0, FormatDateTime('hh:nn:ss', Now));
end;

procedure THeapView.DrawSelf(ACanvas: TFvCanvas);
begin
  ACanvas.TextOut(0, 0, 'Heap');
end;

constructor TPalette.Create(ALength: Integer);
begin
  inherited Create;
  if ALength < 0 then
    raise ERangeError.Create('Palette length cannot be negative.');
  SetLength(FColors, ALength);
end;

function TPalette.GetColor(Index: Integer): Byte;
begin
  Result := FColors[Index];
end;

procedure TPalette.SetColor(Index: Integer; AValue: Byte);
begin
  FColors[Index] := AValue;
end;

function TPalette.GetLength: Integer;
begin
  Result := System.Length(FColors);
end;

end.
