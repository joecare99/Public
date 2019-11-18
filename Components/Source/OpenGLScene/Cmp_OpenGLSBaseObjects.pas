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

  T3DZObject = Class(T3DBasisObject)
  public
    Pnt: TPointF;
    QColor: TGLArrayf4;
    Procedure MoveTo(nPnt: TPointF); override;
  protected
    FDisplaylist:Cardinal;
  End;

  { T3DDimObject }

  T3DDimObject = Class(T3DZObject)
  public
    QWidth, QLength, QHeight: Extended;
    procedure SetDimension(aDim:TPointF);virtual;
  public
  End;

  T3DQuader = Class(T3DDimObject)
  public
    Procedure Draw; override;
  End;

  T3DQuader2 = Class(T3DDimObject)
  public
    Procedure Draw; override;
  End;

  T3DSphere = Class(T3DDimObject)
  public
    Procedure Draw; override;
  End;

  T3DCylinder = Class(T3DDimObject)
  private
     Fsteps:integer;
  public
    Procedure Draw; override;
  published
    property Steps:integer read Fsteps write Fsteps;
  End;

  { T3DTorus }

  T3DTorus = Class(T3DDimObject)
  public
    RadiusOuter, RadiusInner: Extended;
  public
    Procedure Draw; override;
  End;

  T3DPrism = Class(T3DDimObject)
  private
  public
    QWidth, QLength, QHeight: Extended;
    MaterialDef:TMaterialBaseDef;
  protected
    procedure DrawDeckel;virtual;
  public
    PDef: Array Of TUVPoint;

    Procedure Draw; override;
  End;

  T3DPrism2 = Class(T3DPrism)
  public
    FillDef: Array Of Integer;
    FillType: Cardinal;
  protected
    Procedure DrawDeckel; override;
  End;

  T3DCone = Class(T3DZObject)
  public
    QWidth, QLength, QHeight: Extended;
  public
    Procedure Draw; override;
  End;


Function CreateQuader(aBase:T3DBasisObject; aPnt:TPointF;aDim:TPointF;aColor: TGLArrayf4):T3DQuader;
Function CreateQuader2(aBase:T3DBasisObject;aPnt:TPointF;aDim:TPointF;aColor: TGLArrayf4):T3DQuader2;
Function CreateSphere(aBase:T3DBasisObject;aPnt:TPointF;aDim:TPointF;aColor: TGLArrayf4):T3DSphere;
Function CreateCylinderZ(aBase:T3DBasisObject;aPnt:TPointF;aDim:TPointF;aColor: TGLArrayf4):T3DCylinder;
Function CreateCylinderY(aBase:T3DBasisObject;aPnt:TPointF;aDim:TPointF;aColor: TGLArrayf4):T3DCylinder;
{Function CreateQuader(pnt:TPointF;Dim:TPointF):T3DQuader;
Function CreateQuader(pnt:TPointF;Dim:TPointF):T3DQuader;
}
implementation

function CreateQuader(aBase: T3DBasisObject; aPnt: TPointF; aDim: TPointF;
  aColor: TGLArrayf4): T3DQuader;
begin
  result := T3DQuader.Create(aBase);
  result.Pnt := aPnt;
  Result.SetDimension(aDim);
  Result.QColor := aColor;
end;

function CreateQuader2(aBase: T3DBasisObject; aPnt: TPointF; aDim: TPointF;
  aColor: TGLArrayf4): T3DQuader2;
begin
  result := T3DQuader2.Create(aBase);
  result.Pnt := aPnt;
  Result.SetDimension(aDim);
  Result.QColor := aColor;
end;

function CreateSphere(aBase: T3DBasisObject; aPnt: TPointF; aDim: TPointF;
  aColor: TGLArrayf4): T3DSphere;
begin
  result := T3DSphere.Create(aBase);
  result.Pnt := aPnt;
  Result.SetDimension(aDim);
  Result.QColor := aColor;
end;

function CreateCylinderZ(aBase: T3DBasisObject; aPnt: TPointF; aDim: TPointF;
  aColor: TGLArrayf4): T3DCylinder;
begin
  result := T3DCylinder.Create(aBase);
  result.Pnt := aPnt;
  Result.SetDimension(aDim);

  Result.Steps:=20;
  Result.QColor := aColor;
end;

function CreateCylinderY(aBase: T3DBasisObject; aPnt: TPointF; aDim: TPointF;
  aColor: TGLArrayf4): T3DCylinder;
begin
  result := T3DCylinder.Create(aBase);
  result.Pnt := aPnt.Rotxm90;
  Result.SetDimension(aDim.Rotxm90);
  result.Rotate(-90,1,0,0);
  Result.Steps:=20;
  Result.QColor := aColor;

end;

function CreateCylinder(aBase: T3DBasisObject; aPnt: TPointF; aDim: TPointF;
  aColor: TGLArrayf4): T3DCylinder;
begin
end;

{ T3DDimObject }

procedure T3DDimObject.SetDimension(aDim: TPointF);
begin
  QLength:=aDim.x;
  QHeight:=aDim.y;
  QWidth:=aDim.z;
end;

{ T3DTorus }

procedure T3DTorus.Draw;
begin
  // Todo: Generate a Draw Methode
  // Circle through outer
  //   Circle through inner
  //      Generatevertex
end;

Procedure T3DCone.Draw;
Var
  I: Integer;
  xx, zz: GLFloat;
Begin
  glTranslatef(Translation[0], Translation[1], Translation[2]);
  glRotatef(rotation[0], rotation[1], rotation[2], rotation[3]);
  glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, {$IFNDEF FPC}@{$ENDIF}QColor);
  // Reflective properties
  glFrontFace(GL_CW);       // Counter Clock-Wise
  glBegin(GL_TRIANGLE_FAN);
//  glColor3fv(QColor);
  glNormal3f(0, -1, 0);
  glVertex3f(pnt.X, pnt.Y - QHeight * 0.5, pnt.Z);
  For I := 0 To 40 Do
    Begin
      xx := sin((i / 40) * 2 * pi) * 0.5;
      zz := Cos((i / 40) * 2 * pi) * 0.5;
      glNormal3f(xx, 0, zz);
      glVertex3f(pnt.X + QLength * xx, pnt.Y + QHeight * 0.5, pnt.Z + QWidth * zz);
    End;
  glEnd;

  glFrontFace(GL_CCW);       // Counter Clock-Wise
  glBegin(GL_TRIANGLE_FAN);

  glNormal3f(0, 1, 0);
  glVertex3f(pnt.X, pnt.Y + QHeight * 0.5, pnt.Z);
  For I := 0 To 40 Do
    Begin
      xx := sin((i / 40) * 2 * pi) * 0.5;
      zz := Cos((i / 40) * 2 * pi) * 0.5;
      glNormal3f(xx * 0.3, 1, zz * 0.3);
      glVertex3f(pnt.X + QLength * xx, pnt.Y + QHeight * 0.5, pnt.Z + QWidth * zz);
    End;
  glEnd;
End;

procedure T3DZObject.MoveTo(nPnt: TPointF);
Begin
  Pnt := nPnt;
End;

Const Wdef: Array[0..7] Of TGLArrayf3 =
  ((1, 1, 1), (-1, 1, 1), (-1, -1, 1), (1, -1, 1), (1, -1, -1), (1, 1, -1), (-1, 1, -1), (-1, 1, 1));

Procedure T3DQuader.Draw;

Var
  I: Integer;
  J: Integer;
  P: Integer;
  Nv0: TGLArrayf4;

Begin
  glTranslatef(Translation[0], Translation[1], Translation[2]);
  glRotatef(rotation[0], rotation[1], rotation[2], rotation[3]);
{$IFDEF FPC}
    glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, QColor);
{$ELSE}
    glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, @QColor);
{$ENDIF}
  // Reflective properties

  For J := 0 To 2 Do
    Begin
      nv0[0] := (Wdef[0, 0] + Wdef[2 + J * 2, 0]) * 0.5;
      nv0[1] := (Wdef[0, 1] + Wdef[2 + J * 2, 1]) * 0.5;
      nv0[2] := (Wdef[0, 2] + Wdef[2 + J * 2, 2]) * 0.5;
      glFrontFace(GL_CCW);       // Counter Clock-Wise
      glBegin(GL_TRIANGLE_FAN);
      For I := 0 To 3 Do
        Begin
          If I = 0 Then
            P := 0
          Else
            P := J * 2 + I;

          glNormal3f(nv0[0] * 0.99 + Wdef[p, 0] * 0.02, nv0[1] * 0.99 + Wdef[p, 1] * 0.02, nv0[2] * 0.99 + Wdef[p, 2] * 0.02);
          glVertex3f(pnt.X + QLength * Wdef[P, 0] * 0.5, pnt.Y + QHeight * Wdef[P, 1] * 0.5, pnt.Z + QWidth * Wdef[P, 2] * 0.5);
        End;
      glend;

    glFrontFace(GL_CW);       // Clock-Wise
      glBegin(GL_TRIANGLE_FAN);
      For I := 0 To 3 Do
        Begin
          If I = 0 Then
            P := 0
          Else
            P := J * 2 + I;

          glNormal3f(-nv0[0] * 0.99 - Wdef[p, 0] * 0.02, -nv0[1] * 0.99 - Wdef[p, 1] * 0.02, -nv0[2] * 0.99 - Wdef[p, 2] * 0.02);
          glVertex3f(pnt.X - QLength * Wdef[P, 0] * 0.5, pnt.Y - QHeight * Wdef[P, 1] * 0.5, pnt.Z - QWidth * Wdef[P, 2] * 0.5);
        End;
      glend;
    End;
End;

Procedure T3DQuader2.Draw;
Var
//  NN: Extended;
  nv0: TGLArrayf3;
  J: Integer;
  I: Integer;
  P: Integer;
Begin
  glTranslatef(Translation[0], Translation[1], Translation[2]);
  glRotatef(rotation[0], rotation[1], rotation[2], rotation[3]);
  glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, {$IFNDEF FPC}@{$ENDIF}QColor);
  // Reflective properties

  For J := 0 To 2 Do
    Begin
      nv0[0] := (Wdef[0, 0] + Wdef[2 + J * 2, 0]) * 0.5;
      nv0[1] := (Wdef[0, 1] + Wdef[2 + J * 2, 1]) * 0.5;
      nv0[2] := (Wdef[0, 2] + Wdef[2 + J * 2, 2]) * 0.5;
       glFrontFace(GL_CCW);       // Counter Clock-Wise
      glBegin(GL_TRIANGLE_FAN);

      glNormal3f(nv0[0] * 1.01, nv0[1] * 1.01, nv0[2] * 1.01);
      glVertex3f(pnt.X + QLength * nv0[0] * 0.5, pnt.Y + QHeight * nv0[1] * 0.5, pnt.Z + QWidth * nv0[2] * 0.5);

      For I := 0 To 4 Do
        Begin
          If I Mod 4 = 0 Then
            P := 0
          Else
            P := J * 2 + I;

          glNormal3f(nv0[0] * 0.99 + Wdef[p, 0] * 0.02, nv0[1] * 0.99 + Wdef[p, 1] * 0.02, nv0[2] * 0.99 + Wdef[p, 2] * 0.02);
          glVertex3f(pnt.X + QLength * Wdef[P, 0] * 0.5, pnt.Y + QHeight * Wdef[P, 1] * 0.5, pnt.Z + QWidth * Wdef[P, 2] * 0.5);
        End;
      glend;

      glFrontFace(GL_CW);       // Clock-Wise
      glBegin(GL_TRIANGLE_FAN);
      glNormal3f(-nv0[0] * 1.01, -nv0[1] * 1.01, -nv0[2] * 1.01);
      glVertex3f(pnt.X - QLength * nv0[0] * 0.5, pnt.Y - QHeight * nv0[1] * 0.5, pnt.Z - QWidth * nv0[2] * 0.5);
      For I := 0 To 4 Do
        Begin
          If I Mod 4 = 0 Then
            P := 0
          Else
            P := J * 2 + I;

          glNormal3f(-nv0[0] * 0.99 - Wdef[p, 0] * 0.02, -nv0[1] * 0.99 - Wdef[p, 1] * 0.02, -nv0[2] * 0.99 - Wdef[p, 2] * 0.02);
          glVertex3f(pnt.X - QLength * Wdef[P, 0] * 0.5, pnt.Y - QHeight * Wdef[P, 1] * 0.5, pnt.Z - QWidth * Wdef[P, 2] * 0.5);
        End;
      glend;
    End;
End;

Procedure T3DSphere.Draw;
Var
  I, J, J0, M0: Integer;
  x0, x1, xx, xx0, yy, yy0, zz, zz0: GLFloat;

Const steps = 8;

Var P1: Array[0..Steps * 4 + 1] Of TGLArrayf3;
  P2: Array[0..Steps * 4 + 1] Of TGLArrayf3;

Begin
  glTranslatef(Translation[0], Translation[1], Translation[2]);
  glRotatef(rotation[0], rotation[1], rotation[2], rotation[3]);
  glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE, @QColor[0]);
  //glColor3fv(@QColor);
  // Reflective properties
  For I := 1 To Steps Do //  Steps Schritte für die Viertelkugel
    Begin
      x0 := sin(((i - 1) / (Steps * 2)) * pi);
      X1 := sin((i / (Steps * 2)) * pi);
      yy0 := Cos(((i - 1) / (Steps * 2)) * pi) * 0.5;
      yy := cos((i / (Steps * 2)) * pi) * 0.5;
      For J := 0 To trunc(x1 * (Steps * 4) + 1) Do
        Begin
          If x0 = 0 Then
            Begin
              xx0 := 0;
              zz0 := 0;
            End
          Else
            Begin
              M0 := trunc(x0 * (Steps * 4) + 1);
              J0 := trunc((J / trunc(x1 * (Steps * 4) + 1)) * M0);
              xx0 := sin(J0 / M0 * 2 * pi) * x0 * 0.5;
              zz0 := cos(J0 / M0 * 2 * pi) * x0 * 0.5;
            End;
          xx := sin((J / trunc(x1 * (Steps * 4) + 1)) * 2 * pi) * x1 * 0.5;
          zz := Cos((J / trunc(x1 * (Steps * 4) + 1)) * 2 * pi) * x1 * 0.5;

          p1[J][0] := xx0;
          p1[J][1] := yy0;
          p1[J][2] := zz0;

          p2[J][0] := xx;
          p2[J][1] := yy;
          p2[J][2] := zz;

        End;

       glFrontFace(GL_CCW);       // Counter Clock-Wise
      glBegin(GL_TRIANGLE_STRIP);
      For J := 0 To trunc(x1 * (Steps * 4) + 1) Do
        Begin
          glNormal3f(p1[j][0] * 2, p1[j][1] * 2, p1[j][2] * 2);
          glVertex3f(pnt.X + QLength * p1[j][0], pnt.Y + QHeight * p1[j][1], pnt.Z + QWidth * p1[j][2]);
          glNormal3f(p2[j][0] * 2, p2[j][1] * 2, p2[j][2] * 2);
          glVertex3f(pnt.X + QLength * p2[j][0], pnt.Y + QHeight * p2[j][1], pnt.Z + QWidth * p2[j][2]);

        End;
      glEnd;

      glFrontFace(GL_CW);       // Counter Clock-Wise
      glBegin(GL_TRIANGLE_STRIP);
      For J := 0 To trunc(x1 * (Steps * 4) + 1) Do
        Begin
          glNormal3f(p1[j][0] * 2, -p1[j][1] * 2, p1[j][2] * 2);
          glVertex3f(pnt.X + QLength * p1[j][0], pnt.Y - QHeight * p1[j][1], pnt.Z + QWidth * p1[j][2]);
          glNormal3f(p2[j][0] * 2, -p2[j][1] * 2, p2[j][2] * 2);
          glVertex3f(pnt.X + QLength * p2[j][0], pnt.Y - QHeight * p2[j][1], pnt.Z + QWidth * p2[j][2]);

        End;
      glEnd;
    End;
End;


Procedure T3DCylinder.Draw;
Var
  I: Integer;
  xx, yy, zz: GLFloat;

Begin
  glTranslatef(Translation[0], Translation[1], Translation[2]);
  glRotatef(rotation[0], rotation[1], rotation[2], rotation[3]);
  glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, {$IFNDEF FPC}@{$ENDIF}QColor);

  // Reflective properties
  glFrontFace(GL_CCW);       // Counter Clock-Wise
  glBegin(GL_TRIANGLE_STRIP);
  For I := 0 To Fsteps * 2 + 1 Do
    Begin
      xx := sin((i / Fsteps) * pi) * 0.5;
      yy := Cos((i / Fsteps) * pi) * 0.5;
      zz := {(i / 400) +}((i Mod 2) {/ 10} - 0.5);
      glNormal3f(xx * 2, yy * 2, zz * 0.4);
      //      glColor3fv(QColor);
      glVertex3f(pnt.X + QLength * xx, pnt.Y + QHeight * yy, pnt.Z + QWidth * zz);
    End;
  glEnd;

  // Deckel1
  glBegin(GL_TRIANGLE_FAN);
  glNormal3f(0, 0, -1);
  glVertex3f(pnt.X, pnt.Y, pnt.Z - QWidth * 0.5);
  For I := 0 To Fsteps Do
    Begin
      xx := sin((i / Fsteps) * 2 * pi) * 0.5;
      yy := Cos((i / Fsteps) * 2 * pi) * 0.5;
      glNormal3f(xx * 0.1, yy * 0.1, -0.9);
      glVertex3f(pnt.X + QLength * xx, pnt.Y + QHeight * yy, pnt.Z - QWidth * 0.5);
    End;
  glEnd;

  // Deckel1
  glFrontFace(GL_CW);       // Clock-Wise
  glBegin(GL_TRIANGLE_FAN);

  glNormal3f(0, 0, 1);
  glVertex3f(pnt.X, pnt.Y, pnt.Z + QWidth * 0.5);
  For I := 0 To Fsteps Do
    Begin
      xx := sin(((i + 0.5) / Fsteps) * 2 * pi) * 0.5;
      yy := Cos(((i + 0.5) / Fsteps) * 2 * pi) * 0.5;
      glNormal3f(xx * 0.1, yy * 0.1, 0.9);
      glVertex3f(pnt.X + QLength * xx, pnt.Y + QHeight * yy, pnt.Z + QWidth * 0.5);
    End;
  glEnd;

End;

Procedure T3DPrism.Draw;
Var
  I: Integer;
  nn1: Extended;
  Li: Integer;
  I2: Integer;
  //  xx, yy, zz: GLFloat;
Begin
  glTranslatef(Translation[0], Translation[1], Translation[2]);
  glRotatef(rotation[0], rotation[1], rotation[2], rotation[3]);

  glMaterialfv(GL_FRONT, GL_AMBIENT, {$IFNDEF FPC}@{$ENDIF}MaterialDef.AmbColor);
  glMaterialfv(GL_FRONT, GL_DIFFUSE, {$IFNDEF FPC}@{$ENDIF}MaterialDef.DiffColor);
//  glMaterialfv(GL_FRONT, GL_SHININESS, {$IFNDEF FPC}@{$ENDIF}MaterialDef.ShinyNess);

  // Reflective properties
  If high(pdef) >= 0 Then
    Begin
  glFrontFace(GL_CW);       // Clock-Wise
  glBegin(GL_TRIANGLE_STRIP);
  //  glNormal3f(0, 0, 0);
  //  glVertex3f(X, Y, Z);
      For Li := 0 To High(PDef)+1 Do
        Begin
          I:= LI mod (High(PDef)+1);
          I2:=(LI+1) mod (High(PDef)+1);
          nn1:=sqrt(sqr(Pdef[I2].u-Pdef[I].u)+ sqr( Pdef[I2].v -Pdef[I].v ));
          if nn1>0 then
            glNormal3f((Pdef[I].v-Pdef[I2].v) / nn1+Pdef[I].u*0.02, -0.02, (Pdef[I2].u-Pdef[I].u) /nn1+Pdef[I].v*0.02);
          glVertex3f(pnt.X + QLength * Pdef[I].u, pnt.Y - QHeight * 0.5, pnt.Z + QWidth * Pdef[I].v);
          if nn1>0 then
            glNormal3f((Pdef[I].v-Pdef[I2].v) / nn1+Pdef[I].u*0.02, 0.02, (Pdef[I2].u-Pdef[I].u) /nn1+Pdef[I].v*0.02);
          glVertex3f(pnt.X + QLength * Pdef[I].u, pnt.Y + QHeight * 0.5, pnt.Z + QWidth * Pdef[I].v);
          if nn1>0 then
            glNormal3f((Pdef[I].v-Pdef[I2].v) / nn1+Pdef[I2].u*0.02, -0.02, (Pdef[I2].u-Pdef[I].u) /nn1+Pdef[I2].v*0.02);
          glVertex3f(pnt.X + QLength * Pdef[I2].u, pnt.Y - QHeight * 0.5, pnt.Z + QWidth * Pdef[I2].v);
          if nn1>0 then
            glNormal3f((Pdef[I].v-Pdef[I2].v) / nn1+Pdef[I2].u*0.02, 0.02, (Pdef[I2].u-Pdef[I].u) /nn1+Pdef[I2].v*0.02);
          glVertex3f(pnt.X + QLength * Pdef[I2].u, pnt.Y + QHeight * 0.5, pnt.Z + QWidth * Pdef[I2].v);
        End;
      glEnd;

      DrawDeckel;

    End;
End;

procedure T3DPrism.DrawDeckel;
var
  I: Integer;

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
  glVertex3f(pnt.X + QLength * Pdef[I].u, pnt.Y + QHeight * 0.5, pnt.Z + QWidth * Pdef[I].v);
  end;
  I := 0;
  glNormal3f(Pdef[I].u * 0.1, 0.9, Pdef[I].v * 0.1);
  glVertex3f(pnt.X + QLength * Pdef[I].u, pnt.Y + QHeight * 0.5, pnt.Z + QWidth * Pdef[I].v);
  glEnd;
  // Deckel1
  glFrontFace(GL_CW);       // Clock-Wise
  glBegin(GL_TRIANGLE_FAN);
  glNormal3f(0, -1, 0);
  glVertex3f(pnt.X, pnt.Y - QHeight * 0.5, pnt.Z);
  for I := 0 to High(PDef) do
  begin
  glNormal3f(Pdef[I].u * 0.1, -0.9, Pdef[I].v * 0.1);
  glVertex3f(pnt.X + QLength * Pdef[I].u, pnt.Y - QHeight * 0.5, pnt.Z + QWidth * Pdef[I].v);
  end;
  I := 0;
  glNormal3f(Pdef[I].u * 0.1, -0.9, Pdef[I].v * 0.1);
  glVertex3f(pnt.X + QLength * Pdef[I].u, pnt.Y - QHeight * 0.5, pnt.Z + QWidth * Pdef[I].v);
  glEnd;
end;

Procedure T3DPrism2.DrawDeckel;
Var
  I: Integer;
  //  xx, yy, zz: GLFloat;
Begin
  If high(pdef) >= 0 Then
    Begin
  //{
      glFrontFace(GL_CW);       //Counter Clock-Wise
      glBegin(FillType);
      For I := 0 To High(FillDef) Do
        If FillDef[I] >= 0 Then
          Begin
            glNormal3f(Pdef[FillDef[I]].u * 0.1, 0.9, Pdef[FillDef[I]].v * 0.1);
            glVertex3f(pnt.X + QLength * Pdef[FillDef[I]].u, pnt.Y + QHeight * 0.5, pnt.Z + QWidth * Pdef[FillDef[I]].v);
          End
        Else
          Begin
            glEnd;
            glBegin(FillType);
          End;
      glEnd;

      // Deckel2
      glFrontFace(GL_CCW);       // Clock-Wise
      glBegin(FillType);
      For I := 0 To High(FillDef) Do
        If FillDef[I] >= 0 Then
          Begin
            glNormal3f(Pdef[FillDef[I]].u * 0.1,-0.9, Pdef[FillDef[I]].v * 0.1);
            glVertex3f(pnt.X + QLength * Pdef[FillDef[I]].u, pnt.Y - QHeight * 0.5, pnt.Z + QWidth * Pdef[FillDef[I]].v);
          End
        Else
          Begin
            glEnd;
            glBegin(FillType);
          End;
      glEnd;

      glFrontFace(GL_CW);       // Clock-Wise
    End;
End;

end.
