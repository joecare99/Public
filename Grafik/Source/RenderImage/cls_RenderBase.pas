unit cls_RenderBase;

{$mode objfpc}{$H+}
{$ModeSwitch autoderef}
{$ModeSwitch advancedrecords}

interface

uses
  Classes, SysUtils;

type

  { TFTuple }

  TFTuple=record
  private
    function GetValue(idx: integer): Extended;
    procedure SetValue(idx: integer; AValue: Extended);
  public
    function ToString:string;
    procedure Init(const aX, aY: extended);
    procedure InitLenDir(const Len, Dir: extended);
    function Sum(const aVal: TFtuple): TFTuple;
    function Add(const aVal: TFtuple): TFTuple;
    function Subt(const dmin:TFtuple):TFTuple;
    function SubtTo(const dmin:TFtuple):TFTuple;
    function Mul(const fak:TFtuple):extended;overload;
//    function Div(const div:TFtuple):TFTuple;overload;
    function Mul(const fak:extended):TFTuple;overload;
    function MulTo(const fak:extended):TFTuple;overload;
    function Divide(const divs:extended):TFTuple;overload;
    function VMul(const fak:TFtuple):TFTuple;overload;
    function Equals(const probe:TFtuple;eps:extended=1e-15):boolean;overload;
    class Function Copy(nx, ny: extended): TFTuple;static; overload;
    class Function Copy(Vect: TFTuple): TFTuple;static; overload;
    Function Copy: TFTuple; overload;
    function GLen:Extended ;
    function GDir: Extended;
    function MLen: Extended;
    property Value[idx:integer]:Extended read GetValue write SetValue;default;
    case Boolean of
    true:(X,Y:Extended);
    false:(V:array[0..1] of Extended);
  end;
  PFTuple=^TFTuple;

  operator := (aRight: Variant) aLeft:TFTuple;
  operator = (aPar1,aPar2:TFTuple) aLeft:boolean;
  operator + (aPar1,aPar2:TFTuple) aLeft:TFTuple;
  operator - (aPar1,aPar2:TFTuple) aLeft:TFTuple;
  operator * (aPar1,aPar2:TFTuple) aLeft:extended;overload;
  operator * (aPar1:TFTuple; aFak:extended) aLeft:TFTuple;overload;
  operator * (aFak:extended; aPar2:TFTuple) aLeft:TFTuple;overload;
  operator / (aPar1:TFTuple; aFak:extended) aLeft:TFTuple;

  function abs(Par1:TfTuple):extended;overload;

type
  { TFTriple }

  TFTriple=record
  private
    function GetValue(idx: integer): extended;
    procedure SetValue(idx: integer; AValue: extended);
  public
    function ToString:string;
    procedure Init(const aX, aY, aZ: extended);
    procedure InitDirLen(const Len, DirZ, DirX: extended);
    Procedure InitTuple(const aTuple:TFTuple;Plane:integer=0);
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
    function Equals(const probe:TFtriple;eps:extended=1e-15):boolean;overload;
    class function Copy(nx, ny, nz: extended): TFTriple; static; overload;
    class Function Copy(Vect: TFTriple): TFTriple;static; overload;
    Function Copy: TFTriple; overload;
    function GLen:Extended ;
    function GDir: TFTuple;
    function MLen: Extended;
    property Value[idx:integer]:extended read GetValue write SetValue;default;
    case Boolean of
    true:(X,Y,Z:Extended);
    false:(V:array[0..2] of Extended);
  end;
  PFTriple=^TFTriple;

  operator := (aRight: variant) aLeft:TFTriple;
  operator = (aPar1,aPar2:TFTriple) aLeft:boolean;
  operator + (aPar1,aPar2:TFTriple) aLeft:TFTriple;
  operator - (aPar1,aPar2:TFTriple) aLeft:TFTriple;
  operator * (aPar1,aPar2:TFTriple) aLeft:extended;overload;
  operator * (aPar1:TFTriple; aFak:extended) aLeft:TFTriple;overload;
  operator * (aFak:extended; aPar2:TFTriple) aLeft:TFTriple;overload;
  operator / (aPar1:TFTriple; aFak:extended) aLeft:TFTriple;

  function abs(Par1:TfTriple):extended;overload;

type
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
    Function Diff(w:TAngle):TAngle;
    Function Subt(w:TAngle):TAngle;
    Function ToString:String;
  public
    property AsGrad:Extended read GetAsGrad write SetAsGrad;
  end;
  PAngle = ^TAngle;

operator := (aRight:Extended) aLeft:TAngle;
operator := (aRight:TAngle) aLeft:Extended;

type
  TRenderPoint= TFTriple;

  TRenderVector= TFTriple;

  { TRenderRay }

  TRenderRay=Class
  private
    FDirection: TRenderVector;
    FStartPoint: TRenderPoint;
    procedure SetDirection(AValue: TRenderVector);
    procedure SetStartPoint(AValue: TRenderPoint);
  public
    constructor Create(aStart:TRenderPoint;aDir:TRenderVector);
    Property StartPoint:TRenderPoint read FStartPoint write SetStartPoint;
    Property Direction:TRenderVector read FDirection write SetDirection;
  end;

  THitData=class;

  { TRenderBaseObject }

  TRenderBaseObject=class(TPersistent) //; abstract;
  protected
    FPosition: TRenderPoint;
    procedure SetPosition(AValue: TRenderPoint);virtual;
  Public
    Function HitTest(aRay:TRenderRay;out HitData:THitData):boolean;virtual; abstract;
    Function BoundaryTest(aRay:TRenderRay;out Distance:extended):boolean;virtual; abstract;
    property Position:TRenderPoint read FPosition write SetPosition;

  end;

  THitData=Class
    Distance :extended;
    HitPoint :TRenderpoint;
    Normalvec:TRenderVector;
    AmbientVal:extended;
    ReflectionVal:extended;
    refraction:extended;
  end;

function FTuple(const x,y:extended):TFTuple;inline;
function FTriple(const x,y,z:extended):TFTriple;inline;
function Angle(const aVal:extended):TAngle;

const ZeroTup:TFTuple=(x:0.0;y:0.0);
      ZeroTrp:TFTriple=(x:0.0;y:0.0;z:0.0);
      ZeroAngle:TAngle=(Value:0.0);


implementation

uses math,variants;

resourceString
  rsTupleToString='<%0:f; %1:f>';
  rsTripleToString='<%0:f; %1:f; %2:f>';
  rsAngleToString='%0:f°';

var vfs:TFormatSettings;

  operator:=(aRight: Variant)aLeft: TFTuple;
  begin
    assert(VarIsArray(aRight),'Array must have 3 entries');
    assert(VarArrayHighBound(aRight,0)=1,'Array must have 3 entries');
    aLeft[0]:=aRight[0];
    aLeft[1]:=aRight[1];
  end;

  operator=(aPar1, aPar2: TFTuple)aLeft: boolean;
  begin
    aleft := aPar1.Equals(aPar2);
  end;

  operator+(aPar1, aPar2: TFTuple)aLeft: TFTuple; inline;
  begin
    aleft := aPar1.Sum(aPar2);
  end;

  operator-(aPar1, aPar2: TFTuple)aLeft: TFTuple; inline;
  begin
    aleft := aPar1.Subt(aPar2);
  end;

  operator*(aPar1, aPar2: TFTuple)aLeft: extended;inline;
  begin
    aleft := aPar1.mul(aPar2);
  end;

  operator*(aPar1: TFTuple; aFak: extended)aLeft: TFTuple;inline;
  begin
    aleft := aPar1.mul(aFak);
  end;

  operator*(aFak: extended; aPar2: TFTuple)aLeft: TFTuple;inline;
  begin
    aleft := aPar2.mul(aFak);
  end;

  operator/(aPar1: TFTuple; aFak: extended)aLeft: TFTuple;inline;
  begin
        aleft := aPar1.Divide(aFak);
  end;

  function abs(Par1: TfTuple): extended;
  begin
    result:= par1.GLen;
  end;

{ TFTuple }

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

{ TRenderBaseObject }

procedure TRenderBaseObject.SetPosition(AValue: TRenderPoint);
begin
  if FPosition=AValue then Exit;
  FPosition:=AValue;
end;

{ TRenderRay }

procedure TRenderRay.SetDirection(AValue: TRenderVector);
begin
  if FDirection=AValue then Exit;
  FDirection:=AValue;
end;

procedure TRenderRay.SetStartPoint(AValue: TRenderPoint);
begin
  if FStartPoint=AValue then Exit;
  FStartPoint:=AValue;
end;

constructor TRenderRay.Create(aStart: TRenderPoint; aDir: TRenderVector);
begin
  FStartPoint:=aStart;
  FDirection:=aDir;
end;

{ TAngle operators}

operator:=(aRight: Extended)aLeft: TAngle;
begin
  result.value:=aRight;
end;

operator:=(aRight: TAngle)aLeft: Extended;
begin
  result := aRight.value;
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
  self := Sum(w);
  result := self;
end;

function TAngle.Diff(w: TAngle): TAngle;
begin
  result := Normalize(angle(self.value - w.value));
end;

function TAngle.Subt(w: TAngle): TAngle;
begin
  self := diff(w);
  result := self;
end;

function TAngle.ToString: String;
begin
  result :=format(rsAngleToString,[GetAsGrad],vfs);
end;

{ TFTriple operators}

operator:=(aRight: variant)aLeft: TFTriple;
begin
  assert(VarIsArray(aRight),'Array must have 3 entries');
  assert(VarArrayHighBound(aRight,0)=2,'Array must have 3 entries');
  aLeft[0]:=aRight[0];
  aLeft[1]:=aRight[1];
  aLeft[2]:=aRight[2];
end;

operator=(aPar1, aPar2: TFTriple)aLeft: boolean;
begin
  aleft := apar1.Equals(apar2);
end;

operator+(aPar1, aPar2: TFTriple)aLeft: TFTriple;
begin
  aleft := apar1.Add(apar2);
end;

operator-(aPar1, aPar2: TFTriple)aLeft: TFTriple;
begin
  aleft := apar1.Subt(apar2);
end;

operator*(aPar1, aPar2: TFTriple)aLeft: extended;
begin
  aleft := apar1.Mul(apar2);
end;

operator*(aPar1: TFTriple; aFak: extended)aLeft: TFTriple;
begin
  aleft := apar1.Mul(aFak);
end;

operator*(aFak: extended; aPar2: TFTriple)aLeft: TFTriple;
begin
  aleft := aPar2.Mul(aFak);
end;

operator/(aPar1: TFTriple; aFak: extended)aLeft: TFTriple;
begin
  aleft := aPar1.Divide(aFak);
end;

function abs(Par1: TfTriple): extended;inline;
begin
  result:= par1.GLen;
end;

{ TFTriple }

function TFTriple.GetValue(idx: integer): extended;
begin
  result := V[idx];
end;

procedure TFTriple.SetValue(idx: integer; AValue: extended);
begin
  assert((idx>=0) and (idx<=2),'Range of index');
  v[idx] := AValue;
end;

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

procedure TFTriple.InitTuple(const aTuple: TFTuple; Plane: integer);
begin
  case plane of
    0 : init(aTuple.X,aTuple.y,0);
    1 : init(0,aTuple.X,aTuple.y);
    2 : init(aTuple.y,0,aTuple.x);
  end;
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

function TFTuple.GetValue(idx: integer): Extended;inline;
begin
  result := v[idx];
end;

procedure TFTuple.SetValue(idx: integer; AValue: Extended);inline;
begin
  v[idx] := AValue;
end;

function TFTuple.ToString: string;
begin
  result := format(rsTupleToString,[x,y],vfs);
end;

procedure TFTuple.Init(const aX, aY: extended);inline;
begin
  x:= ax;
  y:=ay;
end;

procedure TFTuple.InitLenDir(const Len, Dir: extended);inline;
begin
  X := cos(Dir)*Len;
  y := sin(Dir)*Len;
end;

function TFTuple.Sum(const aVal: TFtuple): TFTuple;
begin
  result.x := x+aVal.x;
  result.y := y+aVal.y;
end;

function TFTuple.Add(const aVal: TFtuple): TFTuple;
begin
  self := Sum(aVal);
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

