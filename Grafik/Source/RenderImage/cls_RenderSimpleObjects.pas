unit cls_RenderSimpleObjects;

{$mode objfpc}{$H+}
{$interfaces CORBA}

interface

uses
    Classes, SysUtils, cls_RenderBase, cls_RenderColor, cls_RenderBoundary, Graphics;

type

    { TSimpleObject }

    TSimpleObject = class(TRenderBaseObject, iHasColor)
    protected
        FBaseColor: TRenderColor;
        FBoundary: TRenderBoundary;
        FSurface: TFTriple;
    public
        constructor Create(const aPosition: TRenderPoint;
            aBaseColor: TRenderColor; aSurface: TFTriple); overload;
        destructor Destroy; override;
        function GetColorAt(Point: TRenderPoint): TRenderColor; virtual;
        function BoundaryTest(aRay: TRenderRay; out Distance: extended): boolean;
            override;
    end;

    { TSphere }

    TSphere = class(TSimpleObject)

    private
        FRadius: extended;
    public
        constructor Create(const aPosition: TRenderPoint; aRadius: extended;
            aBaseColor: TRenderColor); overload;
        constructor Create(const aPosition: TRenderPoint; aRadius: extended;
            aBaseColor: TRenderColor; aSurface: TFTriple); overload;
        function HitTest(aRay: TRenderRay; out HitData: THitData): boolean; override;
    end;

    { TPlane }

    TPlane = class(TSimpleObject)

    private
        FNormal: TRenderVector;
    public
        constructor Create(const aPosition: TRenderPoint; aNormal: TRenderVector;
            aBaseColor: TRenderColor); overload;
        constructor Create(const aPosition: TRenderPoint; aNormal: TRenderVector;
            aBaseColor: TRenderColor; aSurface: TFTriple); overload;
        function HitTest(aRay: TRenderRay; out HitData: THitData): boolean; override;
        function BoundaryTest(aRay: TRenderRay; out Distance: extended): boolean;
            override;
    end;

    { TBox }

    TBox = class(TSimpleObject)

    private
        FSize: TRenderVector;
    public
        constructor Create(const aPosition: TRenderPoint; aSize: TRenderVector;
            aBaseColor: TRenderColor); overload;
        constructor Create(const aPosition: TRenderPoint; aSize: TRenderVector;
            aBaseColor: TRenderColor; aSurface: TFTriple); overload;
        function HitTest(aRay: TRenderRay; out HitData: THitData): boolean; override;
    end;

    { TDisc }

    TDisc = class(TSimpleObject)
    protected
      FNormal: TRenderVector;
      FRadius: Extended;
    public
        constructor Create(const aPosition: TRenderPoint; aNormal: TRenderVector;
            aRadius:Extended;aBaseColor: TRenderColor); overload;
        constructor Create(const aPosition: TRenderPoint; aNormal: TRenderVector;
            aRadius:Extended;aBaseColor: TRenderColor; aSurface: TFTriple); overload;
        function HitTest(aRay: TRenderRay; out HitData: THitData): boolean; override;
        function BoundaryTest(aRay: TRenderRay; out Distance: extended): boolean;
            override;
    end;


    { TCylinder }

    TCylinder = class(TSimpleObject)

    private
        FRadius: extended;
        FInnerVec: TRenderVector;
    protected
      FHHeight: Extended;
    public
        constructor Create(const aPosition, aEndPosition: TRenderPoint;
            aRadius: extended; aBaseColor: TRenderColor); overload;
        constructor Create(const aPosition, aEndPosition: TRenderPoint;
            aRadius: extended; aBaseColor: TRenderColor; aSurface: TFTriple); overload;
        function HitTest(aRay: TRenderRay; out HitData: THitData): boolean; override;
    end;


implementation

uses Math;

{ TSimpleObject }

constructor TSimpleObject.Create(const aPosition: TRenderPoint;
    aBaseColor: TRenderColor; aSurface: TFTriple);
begin
    inherited Create;
    FPosition := aPosition;
    FBaseColor := aBaseColor;
    FSurface := aSurface;
end;

destructor TSimpleObject.Destroy;
begin
    FreeAndNil(FBoundary);
    inherited Destroy;
end;

function TSimpleObject.GetColorAt(Point: TRenderPoint): TRenderColor;
begin
    Result := FBaseColor;
end;

function TSimpleObject.BoundaryTest(aRay: TRenderRay; out Distance: extended): boolean;
begin
    if Assigned(FBoundary) then
        Result := FBoundary.BoundaryTest(aRay, Distance)
    else
      begin
        Distance := (aRay.StartPoint - FPosition).GLen;
        Result := (FPosition - aRay.StartPoint) * aray.Direction > Distance * 0.5;
      end;
end;

{ TSphere }

constructor TSphere.Create(const aPosition: TRenderPoint; aRadius: extended;
    aBaseColor: TRenderColor);
begin
    Create(aPosition, aRadius, aBaseColor, FTriple(0.4, 0.6, 0.0));
end;

constructor TSphere.Create(const aPosition: TRenderPoint; aRadius: extended;
    aBaseColor: TRenderColor; aSurface: TFTriple);
begin
    inherited Create(aPosition,aBaseColor,aSurface);
    FRadius := aRadius;
    FBoundary := TBoundarySphere.Create(aPosition, aRadius);
end;

function TSphere.HitTest(aRay: TRenderRay; out HitData: THitData): boolean;
var
    lFootpLen, lOffset, lFootvLen: extended;
    lFootVec: TRenderPoint;
    lInside: boolean;
begin
    Result := False;
    HitData.Distance := -1.0;
    lFootVec := (FPosition - aRay.StartPoint);
    lFootvLen := lFootVec.GLen;
    lInside := lFootvLen <= FRadius;
    lFootpLen := lFootVec * aRay.Direction;
    if (lFootpLen > 0) or lInside then
      begin
        lOffset := sqrt(abs(sqr((FPosition - aRay.StartPoint).GLen) - sqr(lFootpLen)));
        Result := lOffset <= FRadius;
        if Result then
          begin
            if not lInside then
              begin
                HitData.Distance := lFootpLen - sqrt(sqr(FRadius) - sqr(lOffset));
                HitData.HitPoint := HitData.Distance * aRay.Direction + aRay.StartPoint;
                HitData.Normalvec := (HitData.HitPoint - FPosition) / FRadius;
              end
            else
              begin
                HitData.Distance := lFootpLen + sqrt(sqr(FRadius) - sqr(lOffset));
                HitData.HitPoint := HitData.Distance * aRay.Direction + aRay.StartPoint;
                HitData.Normalvec := (FPosition - HitData.HitPoint) / FRadius;
              end;
            HitData.AmbientVal := FSurface.x;
            HitData.ReflectionVal := FSurface.y;
            HitData.refraction := FSurface.z;
          end;
      end;
end;

{ TPlane }

constructor TPlane.Create(const aPosition: TRenderPoint; aNormal: TRenderVector;
    aBaseColor: TRenderColor);
begin
    Create(aPosition, aNormal, aBaseColor, FTriple(0.4, 0.6, 0.0));
end;

constructor TPlane.Create(const aPosition: TRenderPoint; aNormal: TRenderVector;
    aBaseColor: TRenderColor; aSurface: TFTriple);
begin
    inherited Create(aPosition,aBaseColor,aSurface);
    FNormal := aNormal / aNormal.GLen;
    FBoundary := nil;
end;

function TPlane.HitTest(aRay: TRenderRay; out HitData: THitData): boolean;
var
    lFootpVec: TRenderPoint;
    lSgn: TValueSign;
begin
    lFootpVec := (FPosition - aRay.StartPoint);
    HitData.Distance := -1.0;
    lSgn := sign(FNormal * aRay.Direction);
    Result := sign(lFootpVec * FNormal) = lsgn;
    if Result then
      begin
        HitData.Distance := lFootpVec * FNormal / (FNormal * aRay.Direction);
        HitData.HitPoint := aRay.StartPoint + HitData.Distance * aRay.Direction;
        HitData.Normalvec := FNormal * -lsgn;
        HitData.AmbientVal := FSurface.x;
        HitData.ReflectionVal := FSurface.y;
        HitData.refraction := FSurface.z;
      end;
end;

function TPlane.BoundaryTest(aRay: TRenderRay; out Distance: extended): boolean;
var
    lFootpVec: TRenderPoint;
begin
    lFootpVec := (FPosition - aRay.StartPoint);
    Distance := -1.0;
    Result := sign(lFootpVec * FNormal) = sign(FNormal * aRay.Direction);
    if Result then
        Distance := lFootpVec * FNormal / (FNormal * aRay.Direction);
end;

{ TBox }

constructor TBox.Create(const aPosition: TRenderPoint; aSize: TRenderVector;
    aBaseColor: TRenderColor);
begin
    Create(aPosition, aSize, aBaseColor, FTriple(0.6, 0.4, 0));
end;

constructor TBox.Create(const aPosition: TRenderPoint; aSize: TRenderVector;
    aBaseColor: TRenderColor; aSurface: TFTriple);
begin
    inherited Create(aPosition,aBaseColor,aSurface);
    FSize := aSize;
    FBoundary := TBoundaryBox.Create(aPosition, aSize);
end;

function TBox.HitTest(aRay: TRenderRay; out HitData: THitData): boolean;

var
    lDist: TRenderPoint;
    lTstPoint: TRenderVector;
    lInside: boolean;

begin
    lDist := FPosition - aray.StartPoint;
    lInside := (abs(ldist.X) < FSize.x * 0.5) and (abs(ldist.y) < FSize.y * 0.5) and
        (abs(ldist.Z) < FSize.z * 0.5);

    HitData.Distance := -1.0;
    if not lInside and (((ldist.x - FSize.x * 0.5 > 0) and (aray.Direction.x <= 0)) or
        ((ldist.x + FSize.x * 0.5 < 0) and (aray.Direction.x >= 0)) or
        ((ldist.y - FSize.y * 0.5 > 0) and (aray.Direction.y <= 0)) or
        ((ldist.y + FSize.y * 0.5 < 0) and (aray.Direction.y >= 0)) or
        ((ldist.z - FSize.z * 0.5 > 0) and (aray.Direction.z <= 0)) or
        ((ldist.z + FSize.z * 0.5 < 0) and (aray.Direction.z >= 0))) then
        exit(False);

    HitData.AmbientVal := FSurface.x;
    HitData.ReflectionVal := FSurface.y;
    HitData.refraction := FSurface.z;
    // Teste XY-Ebene
    if abs(aray.Direction.z) > 1e-12 then
      begin
        HitData.Normalvec := FTriple(0, 0, -sign(aray.Direction.Z));
        if lInside then
            HitData.Distance := (ldist.Z - HitData.Normalvec.z * 0.5 * FSize.z) / aRay.Direction.z
        else
            HitData.Distance := (ldist.Z + HitData.Normalvec.z * 0.5 * FSize.z) / aRay.Direction.z;
        HitData.HitPoint := aray.StartPoint + aRay.Direction * HitData.Distance;
        lTstPoint := HitData.HitPoint - FPosition;
        if (abs(lTstPoint.x) <= FSize.x * 0.5) and (abs(lTstPoint.y) <= FSize.y * 0.5) then
            exit(True);
      end;
    // Teste XZ-Ebene
    if abs(aray.Direction.y) > 1e-12 then
      begin
        HitData.Normalvec := FTriple(0, -sign(aray.Direction.y), 0);
        if lInside then
            HitData.Distance := (ldist.y - HitData.Normalvec.y * 0.5 * FSize.y) / aRay.Direction.y
        else
            HitData.Distance := (ldist.y + HitData.Normalvec.y * 0.5 * FSize.y) / aRay.Direction.y;
        HitData.HitPoint := aray.StartPoint + aRay.Direction * HitData.Distance;
        lTstPoint := HitData.HitPoint - FPosition;
        if (abs(lTstPoint.x) <= FSize.x * 0.5) and (abs(lTstPoint.z) <= FSize.z * 0.5) then
            exit(True);
      end;
    // Teste YZ-Ebene
    if abs(aray.Direction.x) > 1e-12 then
      begin
        HitData.Normalvec := FTriple(-sign(aray.Direction.x), 0, 0);
        if lInside then
            HitData.Distance := (ldist.x - HitData.Normalvec.x * 0.5 * FSize.x) / aRay.Direction.x
        else
            HitData.Distance := (ldist.x + HitData.Normalvec.x * 0.5 * FSize.x) / aRay.Direction.x;
        HitData.HitPoint := aray.StartPoint + aRay.Direction * HitData.Distance;
        lTstPoint := HitData.HitPoint - FPosition;
        if (abs(lTstPoint.y) <= FSize.y * 0.5) and (abs(lTstPoint.z) <= FSize.z * 0.5) then
            exit(True);
      end;
    HitData.Distance := -1.0;
    Result := False;
end;

{ TDisc }
// Basicly it's a Plane intersected with a shere
constructor TDisc.Create(const aPosition: TRenderPoint; aNormal: TRenderVector;
  aRadius: Extended; aBaseColor: TRenderColor);
begin
  Create(aPosition, aNormal, aRadius, aBaseColor, FTriple(0.6, 0.4, 0));
end;

constructor TDisc.Create(const aPosition: TRenderPoint; aNormal: TRenderVector;
  aRadius: Extended; aBaseColor: TRenderColor; aSurface: TFTriple);
begin
  inherited Create(aPosition,aBaseColor,aSurface);
  Fnormal := aNormal / aNormal.GLen;
  FRadius:=aRadius;
  FBoundary := nil; // !!
end;

function TDisc.HitTest(aRay: TRenderRay; out HitData: THitData): boolean;
var
  lPlaceVec: TRenderPoint;
  lSgn: TValueSign;
begin
  lPlaceVec := FPosition - aray.StartPoint;
  HitData.Distance := -1.0;
  lSgn := sign(FNormal * aRay.Direction);
  result := sign(lPlaceVec * Fnormal) = lsgn;
  if result then
    begin
      HitData.Distance := lPlaceVec * Fnormal / (Fnormal * aRay.Direction);
      HitData.HitPoint := aRay.StartPoint + Hitdata.Distance * aRay.Direction;
      result := (Hitdata.HitPoint-FPosition).Glen<=FRadius ;
      if result then
        begin
      HitData.Normalvec := FNormal * -lsgn;
      HitData.AmbientVal := FSurface.x;
      HitData.ReflectionVal := FSurface.y;
      HitData.refraction := FSurface.z;
        end
      else
        HitData.Distance := -1.0;
    end;
end;

function TDisc.BoundaryTest(aRay: TRenderRay; out Distance: extended): boolean;
  var
    lPlaceVec: TRenderVector;
    lSgn: TValueSign;
    lHitPoint: TRenderPoint;
  begin
    lPlaceVec := FPosition - aray.StartPoint;
    Distance := -1.0;
    lSgn := sign(FNormal * aRay.Direction);
    result := sign(lPlaceVec * Fnormal) = lsgn;
    if result then
      begin
        Distance := lPlaceVec * Fnormal / (Fnormal * aRay.Direction);
        lHitPoint := aRay.StartPoint + Distance * aRay.Direction;
        result := (lHitPoint-FPosition).Glen<=FRadius ;
        if not result then
          Distance := -1.0;
      end;
end;


{ TCylinder }

constructor TCylinder.Create(const aPosition, aEndPosition: TRenderPoint;
    aRadius: extended; aBaseColor: TRenderColor);
begin
    Create(aPosition, aEndPosition, aRadius, aBaseColor, FTriple(0.6, 0.4, 0));
end;

constructor TCylinder.Create(const aPosition, aEndPosition: TRenderPoint;
    aRadius: extended; aBaseColor: TRenderColor; aSurface: TFTriple);
begin
  inherited Create(0.5*(aPosition+aEndPosition),aBaseColor,aSurface);
  FInnerVec := (aEndPosition-aPosition)*0.5;
  FRadius:=aRadius;
  FHHeight:=FInnerVec.GLen;
  FBoundary := nil; // Todo: ggf: select a Propper Boundary
end;

function TCylinder.HitTest(aRay: TRenderRay; out HitData: THitData): boolean;
var
  lFootVec, lHeadVec, lOrthVec, lOrtoDirVec :TRenderVector;
  lFootHitPoint,lHeadHitPoint : TRenderPoint;
  lDist, lHeadDistance , lFootDistance, lMDistance: Extended;
  lInside, lFootPlHit, lHeadPlHit: Boolean;
  lSgn: TValueSign;
  lIVFaktor: ValReal;

begin
  lFootVec := FPosition-FInnerVec - aray.StartPoint;
  lOrthVec:= aray.Direction.XMul(FInnerVec/FHHeight);
  HitData.Distance:=-1.0;
  if (lOrthVec.MLen <> 0) then
    begin
      lDist:= (lOrthVec * lFootVec)/lOrthVec.GLen;
      if abs(lDist)>FRadius then
        exit(false);
    end;
  lHeadVec := FPosition+FInnerVec - aray.StartPoint;
  lSgn := sign(FInnerVec * aRay.Direction);

  lFootPlHit := sign(lFootVec * FInnerVec) = lsgn;
  if lFootPlHit then
    begin
      lFootDistance := lFootVec * FInnerVec / (FInnerVec * aRay.Direction);
      lFootHitPoint := aRay.StartPoint + lFootDistance * aRay.Direction;
      lFootplHit := (lFootHitPoint-FPosition-FInnerVec).Glen<=FRadius ;
    end;
  lHeadPlHit := sign(lFootVec * FInnerVec) = lsgn;
  if lHeadPlHit then
    begin
      lHeadDistance := lFootVec * FInnerVec / (FInnerVec * aRay.Direction);
      lHeadHitPoint := aRay.StartPoint + lHeadDistance * aRay.Direction;
      lHeadPlHit := (lHeadHitPoint-FPosition-FInnerVec).Glen<=FRadius ;
    end;
  if lHeadPlHit and lFootPlHit then
    begin
      // Outside
      if lFootDistance < lHeadDistance then
        begin
          HitData.Distance:=lFootDistance;
          HitData.HitPoint:=lFootHitPoint;
          HitData.Normalvec := FInnerVec/FHHeight * -lsgn;
          HitData.AmbientVal := FSurface.x;
          HitData.ReflectionVal := FSurface.y;
          HitData.refraction := FSurface.z;
          exit(true);
        end
      else
      begin
        HitData.Distance:=lHeadDistance;
        HitData.HitPoint:=lHeadHitPoint;
        HitData.Normalvec := FInnerVec/FHHeight * -lsgn;
        HitData.AmbientVal := FSurface.x;
        HitData.ReflectionVal := FSurface.y;
        HitData.refraction := FSurface.z;
        exit(true);
      end
    end;
  if lFootPlHit  then
    begin
      HitData.Distance:=lFootDistance;
      HitData.HitPoint:=lFootHitPoint;
      HitData.Normalvec := FInnerVec/FHHeight * -lsgn;
      HitData.AmbientVal := FSurface.x;
      HitData.ReflectionVal := FSurface.y;
      HitData.refraction := FSurface.z;
    end;
  if lHeadPlHit then
  begin
    HitData.Distance:=lHeadDistance;
    HitData.HitPoint:=lHeadHitPoint;
    HitData.Normalvec := FInnerVec/FHHeight * -lsgn;
    HitData.AmbientVal := FSurface.x;
    HitData.ReflectionVal := FSurface.y;
    HitData.refraction := FSurface.z;
  end;

  if lOrthVec.MLen =0 then
    exit(false);
  lOrtoDirVec:=aray.Direction-aray.Direction*FInnerVec/sqr(FHHeight)*FInnerVec;
  lMDistance := lOrtoDirVec*lFootVec/sqr(lOrtoDirVec.glen)-sqrt(sqr(FRadius)-sqr(lDist))/lOrtoDirVec.glen;
  if (HitData.Distance < 0) or (lMDistance <  HitData.Distance) then
    begin
      HitData.Distance:=lMDistance;
      HitData.HitPoint:=aray.StartPoint +lMDistance* aray.Direction ;
      lIVFaktor:=(HitData.HitPoint-FPosition)*FInnerVec/sqr(FHHeight);
      result := abs(lIVFaktor) <=1.0;
      if result then
        begin
          HitData.Normalvec := (HitData.HitPoint-FPosition-(HitData.HitPoint-FPosition)*FInnerVec/sqr(FHHeight)*FInnerVec)/FRadius ;
          HitData.AmbientVal := FSurface.x;
          HitData.ReflectionVal := FSurface.y;
          HitData.refraction := FSurface.z;
        end
      else
      HitData.Distance:=-1.0;
    end;
end;

end.


