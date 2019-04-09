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
    procedure InitDirLen(const Dir, Len: extended);
    function Add(const sum:TFtuple):TFTuple;
    function AddTo(const sum:TFtuple):TFTuple;
    function Subt(const dmin:TFtuple):TFTuple;
    function SubtTo(const dmin:TFtuple):TFTuple;
    function Mul(const fak:TFtuple):extended;overload;
//    function Div(const div:TFtuple):TFTuple;overload;
    function Mul(const fak:extended):TFTuple;overload;
    function MulTo(const fak:extended):TFTuple;overload;
    function Divide(const divs:extended):TFTuple;overload;
    function VMul(const fak:TFtuple):TFTuple;overload;
    function Equals(const probe:TFtuple;eps:extended):boolean;overload;
    class Function Copy(nx, ny: extended): TFTuple;static; overload;
    class Function Copy(Vect: TFTuple): TFTuple;static; overload;
    Function Copy: TFTuple; overload;
    function GLen:Extended ;
    function GDir: Extended;
    function MLen: Extended;
    case Boolean of
    true:(X,Y:Extended);
    false:(V:array[0..1] of Extended);
  end;
  PFTuple=^TFTuple;

  { TFTriple }

  TFTriple=record
    function ToString:string;
    procedure Init(const aX, aY, aZ: extended);
    procedure InitDirLen(const Len, DirZ, DirX: extended);
    function Add(const sum:TFtriple):TFTriple;
    function AddTo(const sum:TFtriple):TFTriple;
    function Subt(const dmin:TFtriple):TFTriple;
    function SubtTo(const dmin:TFtriple):TFTriple;
    function Mul(const fak:TFtriple):extended;overload;
//    function Div(const div:TFtriple):TFTriple;overload;
    function Mul(const fak:extended):TFTriple;overload;
    function MulTo(const fak:extended):TFTriple;overload;
    function Divide(const divs:extended):TFTriple;overload;
    function XMul(const fak:TFTriple):TFTriple;overload;
    function Equals(const probe:TFtriple;eps:extended):boolean;overload;
    class function Copy(nx, ny, nz: extended): TFTriple; static; overload;
    class Function Copy(Vect: TFTriple): TFTriple;static; overload;
    Function Copy: TFTriple; overload;
    function GLen:Extended ;
    function GDir: TFTuple;
    function MLen: Extended;
    case Boolean of
    true:(X,Y,Z:Extended);
    false:(V:array[0..2] of Extended);
  end;
  PFTriple=^TFTriple;

  { TAngle }

  TAngle=  record
  private
    function GetAsGrad: Extended;
    procedure SetAsGrad(AValue: Extended);
  public
    value:extended;
  public
    class Function Normalize(w:TAngle):TAngle;static;overload;
  public
    function Normalize:TAngle;overload;
    Function Sum(w:TAngle):TAngle;
    Function Add(w:TAngle):TAngle;
    Function ToString:String;
  public
    property AsGrad:Extended read GetAsGrad write SetAsGrad;
  end;
  PAngle = ^TAngle;

  TRenderBaseObject=class

  end;

function FTuple(const x,y:extended):TFTuple;inline;
function FTriple(const x,y,z:extended):TFTriple;inline;
function Angle(const aVal:extended):TAngle;

const ZeroTup:TFTuple=(x:0.0;y:0.0);
      ZeroTrp:TFTriple=(x:0.0;y:0.0;z:0.0);
      ZeroAngle:TAngle=(Value:0.0);

implementation

uses math;
{ TFTuple }

resourceString
  rsTupleToString='<%0:f; %1:f>';
  rsTripleToString='<%0:f; %1:f; %2:f>';
  rsAngleToString='%0:f°';

var vfs:TFormatSettings;

function FTuple(const x, y: extended): TFTuple;
begin
  result.init(x,y);
end;

function FTriple(const x, y, z: extended): TFTriple;
begin
   result.init(x,y,z);
end;

function Angle(const aVal: extended): TAngle;
begin
  Result.value:=aVal;
end;

{ TAngle }

function TAngle.GetAsGrad: Extended;
begin
  result := value *180 / pi;
end;

procedure TAngle.SetAsGrad(AValue: Extended);
begin
  value := AValue /180 *pi;
end;

class function TAngle.Normalize(w: TAngle): TAngle;
begin
    result.value := w.value-floor((w.value+ pi)/pi/2)*pi*2;
end;

function TAngle.Normalize: TAngle;
begin
   self :=     Normalize(self);
  result := self
end;

function TAngle.Sum(w: TAngle): TAngle;
begin
    result := Normalize(angle(self.value + w.value));
end;

function TAngle.Add(w: TAngle): TAngle;
begin
  self := Normalize(angle(self.value + w.value));
  result := self;
end;

function TAngle.ToString: String;
begin
  result :=format(rsAngleToString,[GetAsGrad],vfs);
end;

{ TFTriple }

function TFTriple.ToString: string;
begin
   result := format(rsTripleToString,[x,y,z],vfs);
end;

procedure TFTriple.Init(const aX, aY, aZ: extended);
begin
  x:=ax;
  y:=ay;
  z:=az;
end;

procedure TFTriple.InitDirLen(const Len, DirZ, DirX: extended);
begin
  x:= cos(Dirz)*Len;
  y:= sin(DirZ) * len * cos(dirX);
  Z:= sin(DirZ) * len * Sin(dirX);
end;

function TFTriple.Add(const sum: TFtriple): TFTriple;
begin
  Result.x:=x+sum.x;
  Result.y:=y+sum.y;
  Result.z:=z+sum.z;
end;

function TFTriple.AddTo(const sum: TFtriple): TFTriple;
begin
  x:=x+sum.x;
  y:=y+sum.y;
  z:=z+sum.z;
  result := self;
end;

function TFTriple.Subt(const dmin: TFtriple): TFTriple;
begin
  Result.x:=x-dmin.x;
  Result.y:=y-dmin.y;
  Result.z:=z-dmin.z;

end;

function TFTriple.SubtTo(const dmin: TFtriple): TFTriple;
begin
  x:=x-dmin.x;
  y:=y-dmin.y;
  z:=z-dmin.z;
  result := self;
end;

function TFTriple.Mul(const fak: TFtriple): extended;
begin
    result := x*fak.x + y*fak.y + z*fak.z
end;

function TFTriple.Mul(const fak: extended): TFTriple;
begin
  result.x:=x*fak;
  result.Y:=y*fak;
  result.z:=z*fak;
end;

function TFTriple.MulTo(const fak: extended): TFTriple;
begin
  x:=x*fak;
  Y:=y*fak;
  z:=z*fak;
  result := self;
end;

function TFTriple.Divide(const divs: extended): TFTriple;
begin
   result.x:=x/divs;
   result.Y:=y/divs;
   result.z:=z/divs;
end;

function TFTriple.XMul(const fak: TFTriple): TFTriple;
begin
  result.x := y*fak.z-z*fak.y;
  result.y := Z*fak.X-x*fak.z;
  result.z := x*fak.y-y*fak.x;
end;

function TFTriple.Equals(const probe: TFtriple; eps: extended): boolean;
begin
    result := (abs(probe.X-x) < eps) and (abs(probe.y-y) < eps)and (abs(probe.z-z) < eps);
end;

class function TFTriple.Copy(nx, ny, nz: extended): TFTriple;
begin
  result.init(nx,ny,nz);
end;

class function TFTriple.Copy(Vect: TFTriple): TFTriple;
begin
  result := Vect;
end;

function TFTriple.Copy: TFTriple;
begin
  result := self;
end;

function TFTriple.GLen: Extended;
begin
  result := sqrt(sqr(x)+sqr(y)+sqr(z));
end;

function TFTriple.GDir: TFTuple;
begin
  if (y=0.0) and (z=0.0) then
    if (x>=0.0)then
      result := ZeroTup
    else
      result := FTuple(pi,0)
  else
    begin
      result.v[0] := FTuple(x,sqrt(sqr(y)+sqr(z))).GDir;
      result.V[1] := FTuple(y,z).gdir;
    end;
end;

function TFTriple.MLen: Extended;
begin
   result := max(abs(x),max( abs(y),abs(z)));
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

procedure TFTuple.InitDirLen(const Dir, Len: extended);
begin
  X := cos(Dir)*Len;
  y := sin(Dir)*Len;
end;

function TFTuple.Add(const sum: TFtuple): TFTuple;
begin
  result.x := x+sum.x;
  result.y := y+sum.y;
end;

function TFTuple.AddTo(const sum: TFtuple): TFTuple;
begin
  x := x+ sum.x;
  y := Y+ sum.y;
  result := Self;
end;

function TFTuple.Subt(const dmin: TFtuple): TFTuple;
begin
  result.x := x-dmin.x;
  result.y := y-dmin.y;
end;

function TFTuple.SubtTo(const dmin: TFtuple): TFTuple;
begin
  x := x-dmin.x;
  y := y-dmin.y;
  result := self;
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

function TFTuple.MulTo(const fak: extended): TFTuple;
begin
  x:=x*fak;
  Y:=y*fak;
  result := self;
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
  result := (abs(probe.X-x) < eps) and (abs(probe.y-y) < eps);
end;

class function TFTuple.Copy(nx, ny: extended): TFTuple;
begin
  result.init(nx,ny);
end;

class function TFTuple.Copy(Vect: TFTuple): TFTuple;
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

function TFTuple.GDir: Extended;
var
  lLen: Extended;
begin
  lLen := glen;
  if llen = 0.0 then
    begin
      result := 0.0;
    end
  else
    if abs(x)>abs(y) then
      begin
        if x>0 then
          result := arctan(y/x)
        else if Y>=0 then
          result := pi - arctan(-y/x)
         else
          result := -pi - arctan(-y/x)
      end
    else
      begin
        if y>0 then
          result := 0.5*pi-arctan(x/y)
        else
          result := -0.5*pi + arctan(-x/y)
      end

end;

function TFTuple.MLen: Extended;
begin
  result := max(abs(x), abs(y));
end;

initialization
  vfs.DecimalSeparator:='.';
  vfs.ThousandSeparator:=#0;

end.

