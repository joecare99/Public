unit cls_RenderBase;

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils;

type

  { TFTuple }

  TFTuple=record
    function ToString:string;
    procedure Init(const aX, aY: extended);
    function Add(const sum:TFtuple):TFTuple;
    function Subt(const dmin:TFtuple):TFTuple;
    function Mul(const fak:TFtuple):extended;overload;
//    function Div(const div:TFtuple):TFTuple;overload;
    function Mul(const fak:extended):TFTuple;overload;
    function Divide(const divs:extended):TFTuple;overload;
    function VMul(const fak:TFtuple):TFTuple;overload;
    function Equals(const probe:TFtuple;eps:extended):boolean;overload;
    Function Copy(nx, ny: extended): TFTuple; overload;
    Function Copy(Vect: TFTuple): TFTuple; overload;
    Function Copy: TFTuple; overload;
    function GLen:Extended ;
    function MLen: Extended;
    case Boolean of
    true:(X,Y:Extended);
    false:(V:array[0..1] of Extended);
  end;
  PFTuple=^TFTuple;

  TFTriple=record
    case Boolean of
    true:(X,Y,Z:Extended);
    false:(V:array[0..2] of Extended);
  end;

  TRenderBaseObject=class

  end;

function FTuple(const x,y:extended):TFTuple;inline;

const ZeroTup:TFTuple=(x:0.0;y:0.0);
      ZeroTrp:TFTriple=(x:0.0;y:0.0;z:0.0);

implementation

uses math;
{ TFTuple }

resourceString
  rsTupleToString='<%0:f; %1:f>';

var vfs:TFormatSettings;

function FTuple(const x, y: extended): TFTuple;
begin
  result.init(x,y);
end;

function TFTuple.ToString: string;
begin
  result := format(rsTupleToString,[x,y],vfs);
end;

procedure TFTuple.Init(const aX, aY: extended);
begin
  x:= ax;
  y:=ay;
end;

function TFTuple.Add(const sum: TFtuple): TFTuple;
begin
  result.x := x+sum.x;
  result.y := y+sum.y;
end;

function TFTuple.Subt(const dmin: TFtuple): TFTuple;
begin
  result.x := x-dmin.x;
  result.y := y-dmin.y;
end;

function TFTuple.Mul(const fak: TFtuple): extended;
begin
  result := x*fak.x + y*Fak.y
end;

function TFTuple.Mul(const fak: extended): TFTuple;
begin
  result.x:=x*fak;
  result.Y:=y*fak;
end;

function TFTuple.Divide(const divs: extended): TFTuple;
begin
  result.x:=x/divs;
  result.Y:=y/divs;
end;

function TFTuple.VMul(const fak: TFtuple): TFTuple;
begin
  result.X := x*fak.x - y*fak.y;
  result.y := x*fak.Y + y*fak.x;
end;

function TFTuple.Equals(const probe: TFtuple; eps: extended): boolean;
begin
  result := ((probe.X-x) < eps) and ((probe.y-y) < eps);
end;

function TFTuple.Copy(nx, ny: extended): TFTuple;
begin
  result.init(nx,ny);
end;

function TFTuple.Copy(Vect: TFTuple): TFTuple;
begin
  result.x:=Vect.X;
  Result.y := Vect.y;
end;

function TFTuple.Copy: TFTuple;
begin
  result.X :=X;
  Result.y :=y;
end;

function TFTuple.GLen: Extended;
begin
  result := sqrt(sqr(x)+sqr(y));
end;

function TFTuple.MLen: Extended;
begin
  result := max(abs(x), abs(y));
end;

initialization
  vfs.DecimalSeparator:='.';
  vfs.ThousandSeparator:=#0;

end.

