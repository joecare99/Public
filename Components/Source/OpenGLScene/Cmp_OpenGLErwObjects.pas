unit Cmp_OpenGLErwObjects;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses Cmp_OpenGLScene;

procedure CreateDTTraeger(nx,ny,nz:Single; nWidth,nHeight, nLength: Single; nMaterialDef: TMaterialBaseDef;FBasis:T3DBasisObject);

implementation

uses
{$IFnDEF FPC}
  OpenGL,
{$ELSE}
  gl,
{$ENDIF}
  Cmp_OpenGLSBaseObjects;

Const TTrDef: Array[0..2, 0..1] Of single = ((1, 1), (1, 0.9), (0.1, 0.8));

procedure CreateDTTraeger(nx,ny,nz:Single; nWidth,nHeight, nLength: Single; nMaterialDef: TMaterialBaseDef;FBasis:T3DBasisObject);
var
  p: Integer;
  yq: Integer;
  xq: Integer;
  I: Integer;
  F3dObject: T3DZObject;
begin
  F3dObject := T3DPrism2.Create(FBasis);
  with T3DPrism2(F3dObject) do
  begin
    Rotation[1] := 1;
    Rotation[0] := -90;
    moveto(nx, -nz, ny);
    QWidth := nWidth;
    QLength := nHeight;
    QHeight := nLength;
    MaterialDef := nMaterialDef;
    SetLength(PDef, (high(TTrDef) + 1) * 4);
    for I := 0 to high(PDef) do
    begin
      xq := (i div 6) * 2 - 1;
      yq := (((i + 3) div 6) mod 2) * 2 - 1;
      p := (i mod 3);
      if xq * yq < 0 then
        p := 2 - p;
      Pdef[i].U := Ttrdef[P, 0] * xq;
      Pdef[i].v := Ttrdef[P, 1] * yq;
    end;
    FillType := GL_TRIANGLE_STRIP;
    SetLength(FillDef, 12);
    for I := 0 to high(FillDef) do
      if (i mod 2) = 0 then
        FillDef[i] := (i div 2)
      else
        FillDef[i] := 11 - (I div 2);
  end;
end;

end.
