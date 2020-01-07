unit Cmp_OpenGLSBaseObjects;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
    openGL,
{$ELSE}
    gl,
{$ENDIF}
    Cmp_OpenGLScene;

type

    { T3DZObject }

    T3DZObject = class(T3DBasisObject)
    public
        Pnt: TPointF;
        QColor: TGLArrayf4;
        procedure MoveTo(nPnt: TPointF); override;
    protected
        FDisplaylist: cardinal;
    end;

    { T3DDimObject }

    T3DDimObject = class(T3DZObject)
    public
        QWidth, QLength, QHeight: extended;
        procedure SetDimension(aDim: TPointF); virtual;
    public
    end;

    T3DQuader = class(T3DDimObject)
    public
        procedure Draw; override;
    end;

    T3DQuader2 = class(T3DDimObject)
    public
        procedure Draw; override;
    end;

    T3DSphere = class(T3DDimObject)
    public
        procedure Draw; override;
    end;

    T3DCylinder = class(T3DDimObject)
    private
        Fsteps: integer;
    published
        property Steps: integer read Fsteps write Fsteps;
    end;

    { T3DCylinderX }

    T3DCylinderX = class(T3DCylinder)
    public
        procedure Draw; override;
    end;

    { T3DCylinderY }

    T3DCylinderY = class(T3DCylinder)
    public
        procedure Draw; override;
    end;

    { T3DCylinderZ }

    T3DCylinderZ = class(T3DCylinder)
    public
        procedure Draw; override;
    end;

    { T3DTorus }

    T3DTorus = class(T3DDimObject)
    public
        RadiusOuter, RadiusInner: extended;
    public
        procedure Draw; override;
    end;

    { T3DPrismBase }

    T3DPrismBase = class(T3DDimObject)
    private
    public
        MaterialDef: TMaterialBaseDef;
    protected
        procedure DrawDeckel; virtual;Abstract;
    public
        PDef: array of TUVPoint;
    end;

    { T3DPrism }
    T3DPrism = class(T3DPrismBase)
    private
    public
        MaterialDef: TMaterialBaseDef;
    protected
        procedure DrawDeckel; override;
    public
        PDef: array of TUVPoint;
        procedure Draw; override;
    end;

    T3DPrismX = class(T3DPrism)

    end;

    T3DPrismY = class(T3DPrism)

    end;

    T3DPrismZ = class(T3DPrism)

    end;

    { T3DPrism2 }

    T3DPrism2 = class(T3DPrism)
    public
        FillDef: array of integer;
        FillType: cardinal;
    protected
        procedure DrawDeckel; override;
    end;

    { T3DConeX }

    T3DConeX = class(T3DDimObject)
    public
        procedure Draw; override;
    end;

    { T3DConeY }

    T3DConeY = class(T3DDimObject)
    public
        procedure Draw; override;
    end;

    { T3DConeZ }

    T3DConeZ = class(T3DDimObject)
    public
        procedure Draw; override;
    end;


function CreateQuader(aBase: T3DBasisObject; aPnt: TPointF; aDim: TPointF;
    aColor: TGLArrayf4): T3DQuader;
function CreateQuader2(aBase: T3DBasisObject; aPnt: TPointF; aDim: TPointF;
    aColor: TGLArrayf4): T3DQuader2;
function CreateSphere(aBase: T3DBasisObject; aPnt: TPointF; aDim: TPointF;
    aColor: TGLArrayf4): T3DSphere;
function CreateCylinderZ(aBase: T3DBasisObject; aPnt: TPointF; aDim: TPointF;
    aColor: TGLArrayf4): T3DCylinder;
function CreateCylinderY(aBase: T3DBasisObject; aPnt: TPointF; aDim: TPointF;
    aColor: TGLArrayf4): T3DCylinder;
function CreateCylinderX(aBase: T3DBasisObject; aPnt: TPointF; aDim: TPointF;
    aColor: TGLArrayf4): T3DCylinder;
function CreatePrismX(aBase: T3DBasisObject; aPnt: TPointF; aHeight: TGLfloat;
    const aPnts: array of TUVPoint; aMaterial: TMaterialBaseDef): T3DPrism;
function CreatePrismY(aBase: T3DBasisObject; aPnt: TPointF; aHeight: TGLfloat;
    const aPnts: array of TUVPoint; aMaterial: TMaterialBaseDef): T3DPrism;
function CreatePrismZ(aBase: T3DBasisObject; aPnt: TPointF; aHeight: TGLfloat;
    const aPnts: array of TUVPoint; aMaterial: TMaterialBaseDef): T3DPrism;
function CreateConeX(aBase: T3DBasisObject; aPnt: TPointF; aDim: TPointF;
    aColor: TGLArrayf4): T3DConeX;
function CreateConeY(aBase: T3DBasisObject; aPnt: TPointF; aDim: TPointF;
    aColor: TGLArrayf4): T3DConeY;
function CreateConeZ(aBase: T3DBasisObject; aPnt: TPointF; aDim: TPointF;
    aColor: TGLArrayf4): T3DConeZ;



implementation

function CreateQuader(aBase: T3DBasisObject; aPnt: TPointF; aDim: TPointF;
    aColor: TGLArrayf4): T3DQuader;
begin
    Result := T3DQuader.Create(aBase);
    Result.Pnt := aPnt;
    Result.SetDimension(aDim);
    Result.QColor := aColor;
end;

function CreateQuader2(aBase: T3DBasisObject; aPnt: TPointF; aDim: TPointF;
    aColor: TGLArrayf4): T3DQuader2;
begin
    Result := T3DQuader2.Create(aBase);
    Result.Pnt := aPnt;
    Result.SetDimension(aDim);
    Result.QColor := aColor;
end;

function CreateSphere(aBase: T3DBasisObject; aPnt: TPointF; aDim: TPointF;
    aColor: TGLArrayf4): T3DSphere;
begin
    Result := T3DSphere.Create(aBase);
    Result.Pnt := aPnt;
    Result.SetDimension(aDim);
    Result.QColor := aColor;
end;

function CreateCylinderZ(aBase: T3DBasisObject; aPnt: TPointF;
    aDim: TPointF; aColor: TGLArrayf4): T3DCylinder;
begin
    Result := T3DCylinderZ.Create(aBase);
    Result.Pnt := aPnt;
    Result.SetDimension(aDim);
    Result.Steps := 40;
    Result.QColor := aColor;
end;

function CreateCylinderY(aBase: T3DBasisObject; aPnt: TPointF;
    aDim: TPointF; aColor: TGLArrayf4): T3DCylinder;
begin
    Result := T3DCylinderY.Create(aBase);
    Result.Pnt := aPnt;
    Result.SetDimension(aDim);
    Result.Steps := 40;
    Result.QColor := aColor;

end;

function CreateCylinderX(aBase: T3DBasisObject; aPnt: TPointF; aDim: TPointF;
  aColor: TGLArrayf4): T3DCylinder;
begin
    Result := T3DCylinderX.Create(aBase);
    Result.Pnt := aPnt;
    Result.SetDimension(aDim);
    Result.Steps := 40;
    Result.QColor := aColor;
end;

function CreatePrismX(aBase: T3DBasisObject; aPnt: TPointF; aHeight: TGLfloat;
  const aPnts: array of TUVPoint; aMaterial: TMaterialBaseDef): T3DPrism;
var
  i: Integer;
begin
    Result := T3DPrismX.Create(aBase);
    Result.Pnt := aPnt.Rotym90;
    Result.QHeight := aHeight;
    Result.QWidth := 1.0;
    Result.QLength := 1.0;
    result.Rotate(-90,0,1,0);
    setlength(Result.PDef, Length(aPnts));
    for i := 0 to high(aPnts) do
        Result.PDef[i] := aPnts[i];
    Result.MaterialDef := aMaterial;
end;

function CreatePrismY(aBase: T3DBasisObject; aPnt: TPointF; aHeight: TGLfloat;
    const aPnts: array of TUVPoint; aMaterial: TMaterialBaseDef): T3DPrism;
var
    i: integer;
begin
    Result := T3DPrismY.Create(aBase);
    Result.Pnt := aPnt;
    Result.QHeight := aHeight;
    Result.QWidth := 1.0;
    Result.QLength := 1.0;
    setlength(Result.PDef, Length(aPnts));
    for i := 0 to high(aPnts) do
        Result.PDef[i] := aPnts[i];
    Result.MaterialDef := aMaterial;
end;

function CreatePrismZ(aBase: T3DBasisObject; aPnt: TPointF; aHeight: TGLfloat;
    const aPnts: array of TUVPoint; aMaterial: TMaterialBaseDef): T3DPrism;
var
  i: Integer;
begin
    Result := T3DPrismZ.Create(aBase);
    Result.Pnt := aPnt.Rotxm90;
    Result.QHeight := aHeight;
    Result.QWidth := 1.0;
    Result.QLength := 1.0;
    result.Rotate(-90,1,0,0);
    setlength(Result.PDef, Length(aPnts));
    for i := 0 to high(aPnts) do
        Result.PDef[i] := aPnts[i];
    Result.MaterialDef := aMaterial;
end;

function CreateConeX(aBase: T3DBasisObject; aPnt: TPointF; aDim: TPointF;
    aColor: TGLArrayf4): T3DConeX;
begin
    Result := T3DConeX.Create(aBase);
    Result.Pnt := aPnt;
    Result.SetDimension(aDim);
    Result.QColor := aColor;
end;

function CreateConeY(aBase: T3DBasisObject; aPnt: TPointF; aDim: TPointF;
    aColor: TGLArrayf4): T3DConeY;
begin
    Result := T3DConeY.Create(aBase);
    Result.Pnt := aPnt;
    Result.SetDimension(aDim);
    Result.QColor := aColor;

end;

function CreateConeZ(aBase: T3DBasisObject; aPnt: TPointF; aDim: TPointF;
  aColor: TGLArrayf4): T3DConeZ;
begin
    Result := T3DConeZ.Create(aBase);
    Result.Pnt := aPnt;
    Result.SetDimension(aDim);
    Result.QColor := aColor;
end;

{ T3DCylinderX }

procedure T3DCylinderX.Draw;
var
    I: integer;
    xx, yy, zz: GLFloat;

begin
    glTranslatef(Translation[0], Translation[1], Translation[2]);
    glRotatef(rotation[0], rotation[1], rotation[2], rotation[3]);
    glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE,
{$IFNDEF FPC}
        @QColor
        {$ELSE}
      QColor
{$ENDIF}
        );
    // Reflective properties
    glFrontFace(GL_CCW);       // Counter Clock-Wise
    glBegin(GL_TRIANGLE_STRIP);
    for I := 0 to Fsteps * 2 + 1 do
      begin
        xx := {(i / 400) +}((i mod 2) {/ 10} - 0.5);
        yy := cos((i / Fsteps) * pi) * 0.5;
        ZZ := sin((i / Fsteps) * pi) * 0.5;
        glNormal3f(xx * 0.1, yy * 2, zz * 2);
        //      glColor3fv(QColor);
        glVertex3f(pnt.X + QLength * xx, pnt.Y + QHeight * yy, pnt.Z + QWidth * zz);
      end;
    glEnd;

    // Deckel1
    glBegin(GL_TRIANGLE_FAN);
    // Mittelpunkt Unten
    glNormal3f(-1, 0, 0);
    xx:= -0.5;
    glVertex3f(pnt.X+ QLength * xx, pnt.Y, pnt.Z );
    for I := 0 to Fsteps do
      begin
        yy := cos((i / Fsteps) * 2 * pi) * 0.5;
        zz := sin((i / Fsteps) * 2 * pi) * 0.5;
        glNormal3f(- 0.9, yy*0.1, zz*0.1);
        glVertex3f(pnt.X + QLength * xx, pnt.Y + QHeight * yy, pnt.Z - QWidth * zz);
      end;
    glEnd;

    // Deckel2
    glFrontFace(GL_CW);       // Clock-Wise
    glBegin(GL_TRIANGLE_FAN);
    // Mittelpunkt Oben
    glNormal3f(1, 0, 0);
    xx:= 0.5;
    glVertex3f(pnt.X+QLength*xx, pnt.Y, pnt.Z );
    for I := 0 to Fsteps do
      begin
        yy := cos(((i + 0.5) / Fsteps) * 2 * pi) * 0.5;
        zz := sin(((i + 0.5) / Fsteps) * 2 * pi) * 0.5;
        glNormal3f(0.9, yy * 0.1, zz*0.1);
        glVertex3f(pnt.X + QLength * xx, pnt.Y + QHeight * yy, pnt.Z + QWidth * zz);
      end;
    glEnd;
end;

{ T3DCylinderY }

procedure T3DCylinderY.Draw;
var
    I: integer;
    xx, yy, zz: GLFloat;

begin
    glTranslatef(Translation[0], Translation[1], Translation[2]);
    glRotatef(rotation[0], rotation[1], rotation[2], rotation[3]);
    glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE,
{$IFNDEF FPC}
        @QColor
        {$ELSE}
      QColor
{$ENDIF}
        );

    // Reflective properties
    glFrontFace(GL_CCW);       // Counter Clock-Wise
    glBegin(GL_TRIANGLE_STRIP);
    for I := 0 to Fsteps * 2 + 1 do
      begin
        xx := sin((i / Fsteps) * pi) * 0.5;
        yy := {(i / 400) +}((i mod 2) {/ 10} - 0.5);
        ZZ := Cos((i / Fsteps) * pi) * 0.5;
        glNormal3f(xx * 2, yy * 0.1, zz * 2);
        //      glColor3fv(QColor);
        glVertex3f(pnt.X + QLength * xx, pnt.Y + QHeight * yy, pnt.Z + QWidth * zz);
      end;
    glEnd;

    // Deckel1
    glBegin(GL_TRIANGLE_FAN);
    // Mittelpunkt Unten
    glNormal3f(0, -1, 0);
    yy:= -0.5;
    glVertex3f(pnt.X, pnt.Y+ QHeight * yy, pnt.Z );
    for I := 0 to Fsteps do
      begin
        xx := sin((i / Fsteps) * 2 * pi) * 0.5;
        zz := Cos((i / Fsteps) * 2 * pi) * 0.5;
        glNormal3f(xx * 0.1, -0.9, zz*0.1);
        glVertex3f(pnt.X + QLength * xx, pnt.Y + QHeight * yy, pnt.Z - QWidth * zz);
      end;
    glEnd;

    // Deckel2
    glFrontFace(GL_CW);       // Clock-Wise
    glBegin(GL_TRIANGLE_FAN);
    // Mittelpunkt Oben
    glNormal3f(0, 1, 0);
    yy:= 0.5;
    glVertex3f(pnt.X, pnt.Y+ QHeight * yy, pnt.Z );
    for I := 0 to Fsteps do
      begin
        xx := sin(((i + 0.5) / Fsteps) * 2 * pi) * 0.5;
        zz := Cos(((i + 0.5) / Fsteps) * 2 * pi) * 0.5;
        glNormal3f(xx * 0.1, 0.9, zz*0.1);
        glVertex3f(pnt.X + QLength * xx, pnt.Y + QHeight * yy, pnt.Z + QWidth * zz);
      end;
    glEnd;

end;


{ T3DConeZ }

procedure T3DConeZ.Draw;
var
    I: integer;
    xx, yy: GLFloat;
begin
    glTranslatef(Translation[0], Translation[1], Translation[2]);
    glRotatef(rotation[0], rotation[1], rotation[2], rotation[3]);
    glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE,
{$IFNDEF FPC}
        @
{$ENDIF}
        QColor);
    // Reflective properties
    glFrontFace(GL_CW);       // Counter Clock-Wise
    glBegin(GL_TRIANGLE_FAN);
    //  glColor3fv(QColor);
    glNormal3f(0, 0, -1);
    glVertex3f(pnt.X, pnt.Y , pnt.Z - abs(QWidth) * 0.5);
    for I := 0 to 40 do
      begin
        xx := sin((i / 40) * 2 * pi) * 0.5;
        yy := Cos((i / 40) * 2 * pi) * 0.5;
        glNormal3f(xx, yy, 0);
        glVertex3f(pnt.X + QLength * xx, pnt.Y + QHeight * yy, pnt.Z + QWidth * 0.5);
      end;
    glEnd;

    glFrontFace(GL_CCW);       // Counter Clock-Wise
    glBegin(GL_TRIANGLE_FAN);

    glNormal3f(0, 0, 1);
    glVertex3f(pnt.X, pnt.Y , pnt.Z+abs(QWidth)*0.5);
    for I := 0 to 40 do
      begin
        xx := sin((i / 40) * 2 * pi) * 0.5;
        yy := Cos((i / 40) * 2 * pi) * 0.5;
        glNormal3f(xx * 0.1,  yy * 0.1,0.9);
        glVertex3f(pnt.X + QLength * xx, pnt.Y + QHeight * yy, pnt.Z + QWidth * 0.5);
      end;
    glEnd;
end;

{ T3DDimObject }

procedure T3DDimObject.SetDimension(aDim: TPointF);
begin
    QLength := aDim.x;
    QHeight := aDim.y;
    QWidth := aDim.z;
end;

{ T3DTorus }

procedure T3DTorus.Draw;
begin
    // Todo: Generate a Draw Methode
    // Circle through outer
    //   Circle through inner
    //      Generatevertex
end;


{ T3DConeX }

procedure T3DConeX.Draw;
var
    I: integer;
    yy, zz: GLFloat;
begin
    glTranslatef(Translation[0], Translation[1], Translation[2]);
    glRotatef(rotation[0], rotation[1], rotation[2], rotation[3]);
    glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE,
{$IFNDEF FPC}
        @QColor
        {$else} QColor
{$ENDIF}
        );
    // Reflective properties
    glFrontFace(GL_CW);       // Counter Clock-Wise
    glBegin(GL_TRIANGLE_FAN);
    //  glColor3fv(QColor);
    glNormal3f(-1, 0, 0);
    glVertex3f(pnt.X+ abs(QLength) * 0.5, pnt.Y , pnt.Z);
    for I := 0 to 40 do
      begin
        yy := sin((i / 40) * 2 * pi) * 0.5;
        zz := Cos((i / 40) * 2 * pi) * 0.5;
        glNormal3f(0, yy, zz);
        glVertex3f(pnt.X - QLength * 0.5, pnt.Y + QHeight * yy, pnt.Z + QWidth * zz);
      end;
    glEnd;

    glFrontFace(GL_CCW);       // Counter Clock-Wise
    glBegin(GL_TRIANGLE_FAN);

    glNormal3f(1, 0, 0);
    glVertex3f(pnt.X- abs(QLength) * 0.5, pnt.Y , pnt.Z);
    for I := 0 to 40 do
      begin
        yy := sin((i / 40) * 2 * pi) * 0.5;
        zz := Cos((i / 40) * 2 * pi) * 0.5;
        glNormal3f(0.9,yy * 0.1, zz * 0.1);
        glVertex3f(pnt.X - QLength * 0.5, pnt.Y + QHeight * yy, pnt.Z + QWidth * zz);
      end;
    glEnd;
end;

{ T3DConeY }

procedure T3DConeY.Draw;
var
    I: integer;
    xx, zz: GLFloat;
begin
    glTranslatef(Translation[0], Translation[1], Translation[2]);
    glRotatef(rotation[0], rotation[1], rotation[2], rotation[3]);
    glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE,
{$IFNDEF FPC}
        @
{$ENDIF}
        QColor);
    // Reflective properties
    glFrontFace(GL_CW);       // Counter Clock-Wise
    glBegin(GL_TRIANGLE_FAN);
    //  glColor3fv(QColor);
    glNormal3f(0, -1, 0);
    glVertex3f(pnt.X, pnt.Y - QHeight * 0.5, pnt.Z);
    for I := 0 to 40 do
      begin
        xx := sin((i / 40) * 2 * pi) * 0.5;
        zz := Cos((i / 40) * 2 * pi) * 0.5;
        glNormal3f(xx, 0, zz);
        glVertex3f(pnt.X + QLength * xx, pnt.Y - QHeight * 0.5, pnt.Z + QWidth * zz);
      end;
    glEnd;

    glFrontFace(GL_CCW);       // Counter Clock-Wise
    glBegin(GL_TRIANGLE_FAN);

    glNormal3f(0, 1, 0);
    glVertex3f(pnt.X, pnt.Y + QHeight * 0.5, pnt.Z);
    for I := 0 to 40 do
      begin
        xx := sin((i / 40) * 2 * pi) * 0.5;
        zz := Cos((i / 40) * 2 * pi) * 0.5;
        glNormal3f(xx * 0.1, 0.9, zz * 0.1);
        glVertex3f(pnt.X + QLength * xx, pnt.Y - QHeight * 0.5, pnt.Z + QWidth * zz);
      end;
    glEnd;
end;

procedure T3DZObject.MoveTo(nPnt: TPointF);
begin
    Pnt := nPnt;
end;

const
    Wdef: array[0..7] of TGLArrayf3 =
        ((1, 1, 1), (-1, 1, 1), (-1, -1, 1), (1, -1, 1), (1, -1, -1), (1, 1, -1),
        (-1, 1, -1), (-1, 1, 1));

procedure T3DQuader.Draw;

var
    I: integer;
    J: integer;
    P: integer;
    Nv0: TGLArrayf4;

begin
    glTranslatef(Translation[0], Translation[1], Translation[2]);
    glRotatef(rotation[0], rotation[1], rotation[2], rotation[3]);
{$IFDEF FPC}
    glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, QColor);
{$ELSE}
    glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @QColor);
{$ENDIF}
    // Reflective properties

    for J := 0 to 2 do
      begin
        nv0[0] := (Wdef[0, 0] + Wdef[2 + J * 2, 0]) * 0.5;
        nv0[1] := (Wdef[0, 1] + Wdef[2 + J * 2, 1]) * 0.5;
        nv0[2] := (Wdef[0, 2] + Wdef[2 + J * 2, 2]) * 0.5;
        glFrontFace(GL_CCW);       // Counter Clock-Wise
        glBegin(GL_TRIANGLE_FAN);
        for I := 0 to 3 do
          begin
            if I = 0 then
                P := 0
            else
                P := J * 2 + I;

            glNormal3f(nv0[0] * 0.99 + Wdef[p, 0] * 0.02, nv0[1] *
                0.99 + Wdef[p, 1] * 0.02, nv0[2] * 0.99 + Wdef[p, 2] * 0.02);
            glVertex3f(pnt.X + QLength * Wdef[P, 0] * 0.5, pnt.Y +
                QHeight * Wdef[P, 1] * 0.5, pnt.Z + QWidth * Wdef[P, 2] * 0.5);
          end;
        glend;

        glFrontFace(GL_CW);       // Clock-Wise
        glBegin(GL_TRIANGLE_FAN);
        for I := 0 to 3 do
          begin
            if I = 0 then
                P := 0
            else
                P := J * 2 + I;

            glNormal3f(-nv0[0] * 0.99 - Wdef[p, 0] * 0.02, -nv0[1] *
                0.99 - Wdef[p, 1] * 0.02, -nv0[2] * 0.99 - Wdef[p, 2] * 0.02);
            glVertex3f(pnt.X - QLength * Wdef[P, 0] * 0.5, pnt.Y -
                QHeight * Wdef[P, 1] * 0.5, pnt.Z - QWidth * Wdef[P, 2] * 0.5);
          end;
        glend;
      end;
end;

procedure T3DQuader2.Draw;
var
    //  NN: Extended;
    nv0: TGLArrayf3;
    J: integer;
    I: integer;
    P: integer;
begin
    glTranslatef(Translation[0], Translation[1], Translation[2]);
    glRotatef(rotation[0], rotation[1], rotation[2], rotation[3]);
    glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE,
{$IFNDEF FPC}
        @QColor
        {$ELSE}
        QColor
{$ENDIF}
        );
    // Reflective properties

    for J := 0 to 2 do
      begin
        nv0[0] := (Wdef[0, 0] + Wdef[2 + J * 2, 0]) * 0.5;
        nv0[1] := (Wdef[0, 1] + Wdef[2 + J * 2, 1]) * 0.5;
        nv0[2] := (Wdef[0, 2] + Wdef[2 + J * 2, 2]) * 0.5;
        glFrontFace(GL_CCW);       // Counter Clock-Wise
        glBegin(GL_TRIANGLE_FAN);

        glNormal3f(nv0[0] * 1.01, nv0[1] * 1.01, nv0[2] * 1.01);
        glVertex3f(pnt.X + QLength * nv0[0] * 0.5, pnt.Y + QHeight *
            nv0[1] * 0.5, pnt.Z + QWidth * nv0[2] * 0.5);

        for I := 0 to 4 do
          begin
            if I mod 4 = 0 then
                P := 0
            else
                P := J * 2 + I;

            glNormal3f(nv0[0] * 0.99 + Wdef[p, 0] * 0.02, nv0[1] *
                0.99 + Wdef[p, 1] * 0.02, nv0[2] * 0.99 + Wdef[p, 2] * 0.02);
            glVertex3f(pnt.X + QLength * Wdef[P, 0] * 0.5, pnt.Y +
                QHeight * Wdef[P, 1] * 0.5, pnt.Z + QWidth * Wdef[P, 2] * 0.5);
          end;
        glend;

        glFrontFace(GL_CW);       // Clock-Wise
        glBegin(GL_TRIANGLE_FAN);
        glNormal3f(-nv0[0] * 1.01, -nv0[1] * 1.01, -nv0[2] * 1.01);
        glVertex3f(pnt.X - QLength * nv0[0] * 0.5, pnt.Y - QHeight *
            nv0[1] * 0.5, pnt.Z - QWidth * nv0[2] * 0.5);
        for I := 0 to 4 do
          begin
            if I mod 4 = 0 then
                P := 0
            else
                P := J * 2 + I;

            glNormal3f(-nv0[0] * 0.99 - Wdef[p, 0] * 0.02, -nv0[1] *
                0.99 - Wdef[p, 1] * 0.02, -nv0[2] * 0.99 - Wdef[p, 2] * 0.02);
            glVertex3f(pnt.X - QLength * Wdef[P, 0] * 0.5, pnt.Y -
                QHeight * Wdef[P, 1] * 0.5, pnt.Z - QWidth * Wdef[P, 2] * 0.5);
          end;
        glend;
      end;
end;

procedure T3DSphere.Draw;
var
    I, J, J0, M0: integer;
    x0, x1, xx, xx0, yy, yy0, zz, zz0: GLFloat;

const
    steps = 8;

var
    P1: array[0..Steps * 4 + 1] of TGLArrayf3;
    P2: array[0..Steps * 4 + 1] of TGLArrayf3;

begin
    glTranslatef(Translation[0], Translation[1], Translation[2]);
    glRotatef(rotation[0], rotation[1], rotation[2], rotation[3]);
    glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE, @QColor[0]);
    //glColor3fv(@QColor);
    // Reflective properties
    for I := 1 to Steps do //  Steps Schritte für die Viertelkugel
      begin
        x0 := sin(((i - 1) / (Steps * 2)) * pi);
        X1 := sin((i / (Steps * 2)) * pi);
        yy0 := Cos(((i - 1) / (Steps * 2)) * pi) * 0.5;
        yy := cos((i / (Steps * 2)) * pi) * 0.5;
        for J := 0 to trunc(x1 * (Steps * 4) + 1) do
          begin
            if x0 = 0 then
              begin
                xx0 := 0;
                zz0 := 0;
              end
            else
              begin
                M0 := trunc(x0 * (Steps * 4) + 1);
                J0 := trunc((J / trunc(x1 * (Steps * 4) + 1)) * M0);
                xx0 := sin(J0 / M0 * 2 * pi) * x0 * 0.5;
                zz0 := cos(J0 / M0 * 2 * pi) * x0 * 0.5;
              end;
            xx := sin((J / trunc(x1 * (Steps * 4) + 1)) * 2 * pi) * x1 * 0.5;
            zz := Cos((J / trunc(x1 * (Steps * 4) + 1)) * 2 * pi) * x1 * 0.5;

            p1[J][0] := xx0;
            p1[J][1] := yy0;
            p1[J][2] := zz0;

            p2[J][0] := xx;
            p2[J][1] := yy;
            p2[J][2] := zz;

          end;

        glFrontFace(GL_CCW);       // Counter Clock-Wise
        glBegin(GL_TRIANGLE_STRIP);
        for J := 0 to trunc(x1 * (Steps * 4) + 1) do
          begin
            glNormal3f(p1[j][0] * 2, p1[j][1] * 2, p1[j][2] * 2);
            glVertex3f(pnt.X + QLength * p1[j][0], pnt.Y + QHeight *
                p1[j][1], pnt.Z + QWidth * p1[j][2]);
            glNormal3f(p2[j][0] * 2, p2[j][1] * 2, p2[j][2] * 2);
            glVertex3f(pnt.X + QLength * p2[j][0], pnt.Y + QHeight *
                p2[j][1], pnt.Z + QWidth * p2[j][2]);

          end;
        glEnd;

        glFrontFace(GL_CW);       // Counter Clock-Wise
        glBegin(GL_TRIANGLE_STRIP);
        for J := 0 to trunc(x1 * (Steps * 4) + 1) do
          begin
            glNormal3f(p1[j][0] * 2, -p1[j][1] * 2, p1[j][2] * 2);
            glVertex3f(pnt.X + QLength * p1[j][0], pnt.Y - QHeight *
                p1[j][1], pnt.Z + QWidth * p1[j][2]);
            glNormal3f(p2[j][0] * 2, -p2[j][1] * 2, p2[j][2] * 2);
            glVertex3f(pnt.X + QLength * p2[j][0], pnt.Y - QHeight *
                p2[j][1], pnt.Z + QWidth * p2[j][2]);

          end;
        glEnd;
      end;
end;


procedure T3DCylinderZ.Draw;
var
    I: integer;
    xx, yy, zz: GLFloat;

begin
    glTranslatef(Translation[0], Translation[1], Translation[2]);
    glRotatef(rotation[0], rotation[1], rotation[2], rotation[3]);
    glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE,
{$IFNDEF FPC}
        @QColor
        {$ELSE}
      QColor
{$ENDIF}
        );

    // Reflective properties
    glFrontFace(GL_CCW);       // Counter Clock-Wise
    glBegin(GL_TRIANGLE_STRIP);
    for I := 0 to Fsteps * 2 + 1 do
      begin
        xx := sin((i / Fsteps) * pi) * 0.5;
        yy := Cos((i / Fsteps) * pi) * 0.5;
        zz := {(i / 400) +}((i mod 2) {/ 10} - 0.5);
        glNormal3f(xx * 2, yy * 2, zz * 0.4);
        //      glColor3fv(QColor);
        glVertex3f(pnt.X + QLength * xx, pnt.Y + QHeight * yy, pnt.Z + QWidth * zz);
      end;
    glEnd;

    // Deckel1
    glBegin(GL_TRIANGLE_FAN);
    glNormal3f(0, 0, -1);
    glVertex3f(pnt.X, pnt.Y, pnt.Z - QWidth * 0.5);
    for I := 0 to Fsteps do
      begin
        xx := sin((i / Fsteps) * 2 * pi) * 0.5;
        yy := Cos((i / Fsteps) * 2 * pi) * 0.5;
        glNormal3f(xx * 0.1, yy * 0.1, -0.9);
        glVertex3f(pnt.X + QLength * xx, pnt.Y + QHeight * yy, pnt.Z - QWidth * 0.5);
      end;
    glEnd;

    // Deckel1
    glFrontFace(GL_CW);       // Clock-Wise
    glBegin(GL_TRIANGLE_FAN);

    glNormal3f(0, 0, 1);
    glVertex3f(pnt.X, pnt.Y, pnt.Z + QWidth * 0.5);
    for I := 0 to Fsteps do
      begin
        xx := sin(((i + 0.5) / Fsteps) * 2 * pi) * 0.5;
        yy := Cos(((i + 0.5) / Fsteps) * 2 * pi) * 0.5;
        glNormal3f(xx * 0.1, yy * 0.1, 0.9);
        glVertex3f(pnt.X + QLength * xx, pnt.Y + QHeight * yy, pnt.Z + QWidth * 0.5);
      end;
    glEnd;

end;

procedure T3DPrism.Draw;
var
    I: integer;
    nn1: extended;
    Li: integer;
    I2: integer;
    //  xx, yy, zz: GLFloat;
begin
    glTranslatef(Translation[0], Translation[1], Translation[2]);
    glRotatef(rotation[0], rotation[1], rotation[2], rotation[3]);

    glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE,{$IFNDEF FPC}
        @QColor
        {$ELSE}
      QColor
{$ENDIF}       );

(*    glMaterialfv(GL_FRONT, GL_AMBIENT,
{$IFNDEF FPC}
        @MaterialDef.AmbColor
        {$ELSE}    MaterialDef.AmbColor
{$ENDIF}
        );
    glMaterialfv(GL_FRONT, GL_DIFFUSE,
{$IFNDEF FPC}
        @MaterialDef.DiffColor
        {$ELSE}  MaterialDef.DiffColor
{$ENDIF}
        );  *)
    //  glMaterialfv(GL_FRONT, GL_SHININESS, {$IFNDEF FPC}@{$ENDIF}MaterialDef.ShinyNess);

    // Reflective properties
    if high(pdef) >= 0 then
      begin
        glFrontFace(GL_CW);       // Clock-Wise
        glBegin(GL_TRIANGLE_STRIP);
        //  glNormal3f(0, 0, 0);
        //  glVertex3f(X, Y, Z);
        for Li := 0 to High(PDef) + 1 do
          begin
            I := LI mod (High(PDef) + 1);
            I2 := (LI + 1) mod (High(PDef) + 1);
            nn1 := sqrt(sqr(Pdef[I2].u - Pdef[I].u) + sqr(Pdef[I2].v - Pdef[I].v));
            if nn1 > 0 then
                glNormal3f((Pdef[I].v - Pdef[I2].v) / nn1 + Pdef[I].u * 0.02,
                    -0.02, (Pdef[I2].u - Pdef[I].u) / nn1 + Pdef[I].v * 0.02);
            glVertex3f(pnt.X + QLength * Pdef[I].u, pnt.Y - QHeight *
                0.5, pnt.Z + QWidth * Pdef[I].v);
            if nn1 > 0 then
                glNormal3f((Pdef[I].v - Pdef[I2].v) / nn1 + Pdef[I].u * 0.02,
                    0.02, (Pdef[I2].u - Pdef[I].u) / nn1 + Pdef[I].v * 0.02);
            glVertex3f(pnt.X + QLength * Pdef[I].u, pnt.Y + QHeight *
                0.5, pnt.Z + QWidth * Pdef[I].v);
            if nn1 > 0 then
                glNormal3f((Pdef[I].v - Pdef[I2].v) / nn1 + Pdef[I2].u * 0.02,
                    -0.02, (Pdef[I2].u - Pdef[I].u) / nn1 + Pdef[I2].v * 0.02);
            glVertex3f(pnt.X + QLength * Pdef[I2].u, pnt.Y - QHeight *
                0.5, pnt.Z + QWidth * Pdef[I2].v);
            if nn1 > 0 then
                glNormal3f((Pdef[I].v - Pdef[I2].v) / nn1 + Pdef[I2].u * 0.02,
                    0.02, (Pdef[I2].u - Pdef[I].u) / nn1 + Pdef[I2].v * 0.02);
            glVertex3f(pnt.X + QLength * Pdef[I2].u, pnt.Y + QHeight *
                0.5, pnt.Z + QWidth * Pdef[I2].v);
          end;
        glEnd;

        DrawDeckel;

      end;
end;

procedure T3DPrism.DrawDeckel;
var
    I: integer;

begin
    //  exit;
    // Deckel1
    glFrontFace(GL_CCW);       //Counter Clock-Wise
    glBegin(GL_TRIANGLE_FAN);
    glNormal3f(0, 1, 0);
    glVertex3f(pnt.X, pnt.Y + QHeight * 0.5, pnt.Z);
    for I := 0 to High(PDef) do
      begin
        glNormal3f(Pdef[I].u * 0.1, 0.9, Pdef[I].v * 0.1);
        glVertex3f(pnt.X + QLength * Pdef[I].u, pnt.Y + QHeight * 0.5,
            pnt.Z + QWidth * Pdef[I].v);
      end;
    I := 0;
    glNormal3f(Pdef[I].u * 0.1, 0.9, Pdef[I].v * 0.1);
    glVertex3f(pnt.X + QLength * Pdef[I].u, pnt.Y + QHeight * 0.5,
        pnt.Z + QWidth * Pdef[I].v);
    glEnd;
    // Deckel1
    glFrontFace(GL_CW);       // Clock-Wise
    glBegin(GL_TRIANGLE_FAN);
    glNormal3f(0, -1, 0);
    glVertex3f(pnt.X, pnt.Y - QHeight * 0.5, pnt.Z);
    for I := 0 to High(PDef) do
      begin
        glNormal3f(Pdef[I].u * 0.1, -0.9, Pdef[I].v * 0.1);
        glVertex3f(pnt.X + QLength * Pdef[I].u, pnt.Y - QHeight * 0.5,
            pnt.Z + QWidth * Pdef[I].v);
      end;
    I := 0;
    glNormal3f(Pdef[I].u * 0.1, -0.9, Pdef[I].v * 0.1);
    glVertex3f(pnt.X + QLength * Pdef[I].u, pnt.Y - QHeight * 0.5,
        pnt.Z + QWidth * Pdef[I].v);
    glEnd;
end;

procedure T3DPrism2.DrawDeckel;
var
    I: integer;
    //  xx, yy, zz: GLFloat;
begin
    if high(pdef) >= 0 then
      begin
        //{
        glFrontFace(GL_CW);       //Counter Clock-Wise
        glBegin(FillType);
        for I := 0 to High(FillDef) do
            if FillDef[I] >= 0 then
              begin
                glNormal3f(Pdef[FillDef[I]].u * 0.1, 0.9, Pdef[FillDef[I]].v * 0.1);
                glVertex3f(pnt.X + QLength * Pdef[FillDef[I]].u, pnt.Y +
                    QHeight * 0.5, pnt.Z + QWidth * Pdef[FillDef[I]].v);
              end
            else
              begin
                glEnd;
                glBegin(FillType);
              end;
        glEnd;

        // Deckel2
        glFrontFace(GL_CCW);       // Clock-Wise
        glBegin(FillType);
        for I := 0 to High(FillDef) do
            if FillDef[I] >= 0 then
              begin
                glNormal3f(Pdef[FillDef[I]].u * 0.1, -0.9, Pdef[FillDef[I]].v * 0.1);
                glVertex3f(pnt.X + QLength * Pdef[FillDef[I]].u, pnt.Y -
                    QHeight * 0.5, pnt.Z + QWidth * Pdef[FillDef[I]].v);
              end
            else
              begin
                glEnd;
                glBegin(FillType);
              end;
        glEnd;

        glFrontFace(GL_CW);       // Clock-Wise
      end;
end;

end.
