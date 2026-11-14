unit cls_2DIndex;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;


type TGetIdxValuesProc = Procedure(obj:Tobject;out val1,val2:double);
     TIndexArr = array of Integer;
     TNearArr=array[0..3] of TindexArr;

  { TwoDIndex }

  TwoDIndex=class(TObject)
  private
    FGetIdxValuesProc: TGetIdxValuesProc;
    FIndex: array of TIndexArr;
    Findex2: TIndexArr;
    FMin1, FMax1, FMin2, FMax2: Double;
    FDim: Integer;
    procedure ListAppend(const ix: Integer; const idx: integer);
    procedure ListRemove(const ix: Integer; const idx: integer);
    procedure SetGetIdxValuesProc(const AValue: TGetIdxValuesProc);
  public
    constructor Create(min1,max1,min2,max2:double;Count:integer);
    procedure AppendObject(obj:TObject;idx:integer);
    procedure MoveObject(obj:TObject;idx:integer);overload;
    procedure RemoveObject(idx:integer);
    function GetList(v1,v2:double):TindexArr;
    function GetNearest(v1,v2:double):TNearArr;
    property GetIdxValuesProc:TGetIdxValuesProc read FGetIdxValuesProc write SetGetIdxValuesProc;
  published
  end;

implementation

uses Math;
{ TwoDIndex }

procedure TwoDIndex.SetGetIdxValuesProc(const AValue: TGetIdxValuesProc);
begin
  if FGetIdxValuesProc=AValue then Exit;
  FGetIdxValuesProc:=AValue;
end;

procedure TwoDIndex.ListAppend(const ix: Integer; const idx: integer);
begin
  setlength(FIndex[ix], high(FIndex[ix])+2);
  FIndex[ix][high(FIndex[ix])] := Idx;
  if high(Findex2) < idx then
    setlength(FIndex2, idx+1);
  FIndex2[idx] := ix+1; // 0 is default and also a valid cell
end;

procedure TwoDIndex.ListRemove(const ix: Integer; const idx: integer);
var
  found: Boolean;
  i: Integer;
begin
  found := false;
  for i := 0 to high(FIndex[ix]) do
    if FIndex[ix][i] = idx then
      begin
        found := true;
        FIndex[ix][i]:=FIndex[ix][high(FIndex[ix])];
        break;
      end;
  if found then
    setlength(FIndex[ix], high(FIndex[ix]));
  if high(Findex2) < idx then
    setlength(FIndex2, idx+1);
  FIndex2[idx] := 0
end;

constructor TwoDIndex.Create(min1, max1, min2, max2: double; Count: integer);

begin
  FMin1 := min1;
  FMax1 := max1;
  FMin2 := min2;
  FMax2 := max2;
  FDim := round(Exp(ln(Count*4)/3));
  setlength(FIndex,Sqr(FDim));
end;

procedure TwoDIndex.AppendObject(obj: TObject; idx: integer);
var
  val1, val2: double;
  ix, ix1, ix2: Integer;
begin
  FGetIdxValuesProc(obj,val1,val2);
  ix1 := trunc((val1-Fmin1)/(Fmax1-Fmin1)*Fdim);
  ix2 := trunc((val2-Fmin2)/(Fmax2-Fmin2)*Fdim);
  ix := min(ix1,Fdim-1)+min(ix2,Fdim-1)*Fdim;
  ListAppend(ix, idx);
end;

procedure TwoDIndex.MoveObject(obj: TObject; idx: integer);
var
  val1, val2: double;
  ix1, ix2: Int64;
  oix, ix: Integer;
begin
  oix := Findex2[idx]-1;

  FGetIdxValuesProc(obj,val1,val2);
  ix1 := trunc((val1-Fmin1)/(Fmax1-Fmin1)*Fdim);
  ix2 := trunc((val2-Fmin2)/(Fmax2-Fmin2)*Fdim);
  ix := min(ix1,Fdim-1)+min(ix2,Fdim-1)*Fdim;
  if oix <> ix then
    begin
      if oix >=0 then
        ListRemove(oix,idx);
      ListAppend(ix,idx);
    end;
end;

procedure TwoDIndex.RemoveObject(idx: integer);
var
  oix: Integer;
begin
  oix := Findex2[idx]-1;
  if oix >=0 then
    ListRemove(oix,idx);
end;

function TwoDIndex.GetList(v1, v2: double): TindexArr;
var
  ix1, ix2, ix: integer;
begin
  ix1 := trunc((v1-Fmin1)/(Fmax1-Fmin1)*Fdim);
  ix2 := trunc((v2-Fmin2)/(Fmax2-Fmin2)*Fdim);
  ix:=min(ix1,Fdim-1)+min(ix2,Fdim-1)*Fdim;
  result :=   FIndex[ix];
end;

function TwoDIndex.GetNearest(v1, v2: double):TNearArr;

var
  dx1, dx2: Double;
  i: Integer;
const o : array[0..3,0..1] of double=((-0.5,-0.5),(0.5,-0.5),(-0.5,0.5),(0.5,0.5));
begin
  dx1 :=(Fmax1-Fmin1)/Fdim;
  dx2 :=(Fmax2-Fmin2)/Fdim;
  for i := 0 to 3 do
    begin
      result[i] := getlist(max(v1+o[i,0]*dx1,Fmin1),max(v2+o[i,1]*dx2,fmin2))
    end;
end;

end.

