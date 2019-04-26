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
        function GetColorAt({%H-}Point: TRenderPoint): TRenderColor; virtual;
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
        FRadius: extended;
    public
        constructor Create(const aPosition: TRenderPoint; aNormal: TRenderVector;
            aRadius: extended; aBaseColor: TRenderColor); overload;
        constructor Create(const aPosition: TRenderPoint; aNormal: TRenderVector;
            aRadius: extended; aBaseColor: TRenderColor; aSurface: TFTriple); overload;
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
        FHHeight: extended;
    public
        constructor Create(const aPosition, aEndPosition: TRenderPoint;
            aRadius: extended; aBaseColor: TRenderColor); overload;
        constructor Create(const aPosition, aEndPosition: TRenderPoint;
            aRadius: extended; aBaseColor: TRenderColor; aSurface: TFTriple); overload;
        function HitTest(aRay: TRenderRay; out HitData: THitData): boolean; override;
        function BoundaryTest(aRay: TRenderRay; out Distance: extended): boolean;
            override;
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
    inherited Create(aPosition, aBaseColor, aSurface);
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
                HitData.HitPoint := aRay.RayPoint( HitData.Distance);
                HitData.Normalvec := (HitData.HitPoint - FPosition) / FRadius;
              end
            else
              begin
                HitData.Distance := lFootpLen + sqrt(sqr(FRadius) - sqr(lOffset));
                HitData.HitPoint := aRay.RayPoint( HitData.Distance);
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
    inherited Create(aPosition, aBaseColor, aSurface);
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
        HitData.HitPoint := aRay.RayPoint( HitData.Distance);
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
    inherited Create(aPosition, aBaseColor, aSurface);
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
            HitData.Distance :=
                (ldist.Z - HitData.Normalvec.z * 0.5 * FSize.z) / aRay.Direction.z
        else
            HitData.Distance :=
                (ldist.Z + HitData.Normalvec.z * 0.5 * FSize.z) / aRay.Direction.z;
        HitData.HitPoint := aRay.RayPoint( HitData.Distance);
        lTstPoint := HitData.HitPoint - FPosition;
        if (abs(lTstPoint.x) <= FSize.x * 0.5) and
            (abs(lTstPoint.y) <= FSize.y * 0.5) then
            exit(True);
      end;
    // Teste XZ-Ebene
    if abs(aray.Direction.y) > 1e-12 then
      begin
        HitData.Normalvec := FTriple(0, -sign(aray.Direction.y), 0);
        if lInside then
            HitData.Distance :=
                (ldist.y - HitData.Normalvec.y * 0.5 * FSize.y) / aRay.Direction.y
        else
            HitData.Distance :=
                (ldist.y + HitData.Normalvec.y * 0.5 * FSize.y) / aRay.Direction.y;
        HitData.HitPoint := aRay.RayPoint( HitData.Distance);
        lTstPoint := HitData.HitPoint - FPosition;
        if (abs(lTstPoint.x) <= FSize.x * 0.5) and
            (abs(lTstPoint.z) <= FSize.z * 0.5) then
            exit(True);
      end;
    // Teste YZ-Ebene
    if abs(aray.Direction.x) > 1e-12 then
      begin
        HitData.Normalvec := FTriple(-sign(aray.Direction.x), 0, 0);
        if lInside then
            HitData.Distance :=
                (ldist.x - HitData.Normalvec.x * 0.5 * FSize.x) / aRay.Direction.x
        else
            HitData.Distance :=
                (ldist.x + HitData.Normalvec.x * 0.5 * FSize.x) / aRay.Direction.x;
        HitData.HitPoint := aRay.RayPoint( HitData.Distance);
        lTstPoint := HitData.HitPoint - FPosition;
        if (abs(lTstPoint.y) <= FSize.y * 0.5) and
            (abs(lTstPoint.z) <= FSize.z * 0.5) then
            exit(True);
      end;
    HitData.Distance := -1.0;
    Result := False;
end;

{ TDisc }
// Basicly it's a Plane intersected with a shere
constructor TDisc.Create(const aPosition: TRenderPoint; aNormal: TRenderVector;
    aRadius: extended; aBaseColor: TRenderColor);
begin
    Create(aPosition, aNormal, aRadius, aBaseColor, FTriple(0.6, 0.4, 0));
end;

constructor TDisc.Create(const aPosition: TRenderPoint; aNormal: TRenderVector;
    aRadius: extended; aBaseColor: TRenderColor; aSurface: TFTriple);
begin
    inherited Create(aPosition, aBaseColor, aSurface);
    Fnormal := aNormal / aNormal.GLen;
    FRadius := aRadius;
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
    Result := sign(lPlaceVec * Fnormal) = lsgn;
    if Result then
      begin
        HitData.Distance := lPlaceVec * Fnormal / (Fnormal * aRay.Direction);
        HitData.HitPoint := aRay.RayPoint( HitData.Distance);
        Result := (Hitdata.HitPoint - FPosition).Glen <= FRadius;
        if Result then
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
    Result := sign(lPlaceVec * Fnormal) = lsgn;
    if Result then
      begin
        Distance := lPlaceVec * Fnormal / (Fnormal * aRay.Direction);
        lHitPoint := aRay.RayPoint( Distance);
        Result := (lHitPoint - FPosition).Glen <= FRadius;
        if not Result then
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
    inherited Create(0.5 * (aPosition + aEndPosition), aBaseColor, aSurface);
    FInnerVec := (aEndPosition - aPosition) * 0.5;
    FRadius := aRadius;
    FHHeight := FInnerVec.GLen;
    FBoundary := nil; // Todo: ggf: select a Propper Boundary
end;

function TCylinder.HitTest(aRay: TRenderRay; out HitData: THitData): boolean;
var
    lFootVec, lOrthVec, lOrtoDirVec: TRenderVector;
    lFootHitPoint, lMHitPoint, lSPFootPnt: TRenderPoint;
    lDist, lFootDistance, lMDistance, lFootvInnerVProd: extended;
    lInside: boolean;
    lSgn: TValueSign;
    lIVFaktor, lSPDist: ValReal;

begin
    lOrthVec := aray.Direction.XMul(FInnerVec / FHHeight);
    HitData.Distance := -1.0;
    result := false;
    HitData.AmbientVal := FSurface.x;
    HitData.ReflectionVal := FSurface.y;
    HitData.refraction := FSurface.z;
    lSPDist := (FPosition - aray.StartPoint) * FInnerVec / sqr(FHHeight);
    lInside := abs(lSPDist) < 1.0;
    if lInside then
      begin
        lSPFootPnt := FPosition - lSPDist * FInnerVec;
        lInside := (aray.StartPoint - lSPFootPnt).glen < Fradius;
      end;
    lSgn := sign(FInnerVec * aray.Direction);
    if lInside then
        lFootVec := FPosition - aray.StartPoint + FInnerVec * lSgn
    else
        lFootVec := FPosition - aray.StartPoint - FInnerVec * lSgn;

    if (lOrthVec.MLen <> 0) then
      begin
        lDist := (lOrthVec * lFootVec) / lOrthVec.GLen;
        if abs(lDist) > FRadius then
            exit(False);
      end;

    lFootvInnerVProd := lFootVec * FInnerVec;
    if (sign(lFootvInnerVProd) = lsgn) and (lsgn <> 0) then
      begin
        lFootDistance := lFootvInnerVProd / (FInnerVec * aRay.Direction);
        lFootHitPoint := aRay.RayPoint( lFootDistance);
        if (lFootHitPoint - aray.StartPoint - lFootVec).Glen <= FRadius then
          begin
            HitData.Distance := lFootDistance;
            HitData.HitPoint := lFootHitPoint;
            HitData.Normalvec := FInnerVec / FHHeight * -lsgn;
            exit(True);
          end;
      end;
    if lOrthVec.MLen = 0 then
        exit(False);
    lOrtoDirVec := aray.Direction - aray.Direction * FInnerVec / sqr(FHHeight) * FInnerVec;
    if lInside then
        lMDistance := lOrtoDirVec * lFootVec / sqr(lOrtoDirVec.glen) + sqrt(
            sqr(FRadius) - sqr(lDist)) / lOrtoDirVec.glen
    else
        lMDistance := lOrtoDirVec * lFootVec / sqr(lOrtoDirVec.glen) - sqrt(
            sqr(FRadius) - sqr(lDist)) / lOrtoDirVec.glen;
    if (lMDistance >= 0) and ((HitData.Distance < 0) or
        (lMDistance < HitData.Distance)) then
      begin
        lMHitPoint := aray.RayPoint( lMDistance);
        lIVFaktor := (lMHitPoint - FPosition) * FInnerVec / sqr(FHHeight);
        if abs(lIVFaktor) <= 1.0 then
          begin
            Result := True;
            HitData.Distance := lMDistance;
            HitData.HitPoint := lMHitPoint;
            if lInside then
                HitData.Normalvec :=
                    (HitData.HitPoint - FPosition - lIVFaktor * FInnerVec) / -FRadius
            else
                HitData.Normalvec := (HitData.HitPoint - FPosition - lIVFaktor * FInnerVec) / FRadius;
            HitData.AmbientVal := FSurface.x;
            HitData.ReflectionVal := FSurface.y;
            HitData.refraction := FSurface.z;
          end;
      end;
end;

function TCylinder.BoundaryTest(aRay: TRenderRay; out Distance: extended): boolean;
var
    lFootHitPoint: TRenderPoint;
    lFootVec, lOrthVec, lOrtoDirVec: TRenderVector;
    lDist, lFootvInnerVProd: extended;
    lSPDist: ValReal;
    lSgn: TValueSign;
begin
    lSgn := sign(FInnerVec * aray.Direction);
    lFootVec := FPosition - FInnerVec * lSgn - aray.StartPoint;
    lSPDist := (FPosition - aray.StartPoint) * FInnerVec / sqr(FHHeight);
    if (abs(lSPDist) < 1.0) and ((aray.StartPoint - FPosition - lSPDist *
        FInnerVec).glen < Fradius) then
      begin
        Distance := 0.0;
        exit(True);
      end;
    // Definitive outside
    lOrthVec := aray.Direction.XMul(FInnerVec / FHHeight);
    if (lOrthVec.MLen <> 0) then
      begin
        lDist := (lOrthVec * lFootVec) / lOrthVec.GLen;
        Distance := -1.0;
        if abs(lDist) > FRadius then
            exit(False);
      end;
    lFootvInnerVProd := lFootVec * FInnerVec;
    if (sign(lFootvInnerVProd) = lsgn) and (lsgn <> 0) then
      begin
        Distance := lFootvInnerVProd / (FInnerVec * aRay.Direction);
        lFootHitPoint := aRay.RayPoint(Distance);
        if (lFootHitPoint - FPosition + FInnerVec* lSgn).Glen <= FRadius then
            exit(True);
      end;
    Distance := -1;
    if (lOrthVec.MLen = 0) then
        exit(False);
    lOrtoDirVec := aray.Direction - aray.Direction * FInnerVec / sqr(FHHeight) * FInnerVec;
    Distance := lOrtoDirVec * lFootVec / sqr(lOrtoDirVec.glen) - sqrt(
        sqr(FRadius) - sqr(lDist)) / lOrtoDirVec.glen;
    if (Distance >= 0) and (abs(
        ( aray.RayPoint(Distance) - FPosition) * FInnerVec /
        sqr(FHHeight)) <= 1.0) then
        exit(True);
    Distance := -1;
    Result := False;
end;

end.
