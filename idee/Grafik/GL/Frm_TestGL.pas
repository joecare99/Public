// This code was developed by MAD Software 2000 - Rosario, Argentina

// http://mad666.da.ru
// mail: mad666@antisocial.com

// Visit my page for updates and/or help. Send me your comments...

Unit Frm_TestGL;

Interface

Uses

  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OpenGL, ExtCtrls, StdCtrls, jpeg;

Type

  TPrincipal = Class(TForm)
    Timer1: TTimer;
    Panel1: TPanel;
    ScrollBar1: TScrollBar;
    ScrollBar2: TScrollBar;

    Procedure FormCreate(Sender: TObject);
    Procedure FormResize(Sender: TObject);
    Procedure FormDestroy(Sender: TObject);
    Procedure FormDblClick(Sender: TObject);
    Procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    Procedure Timer1Timer(Sender: TObject);

  protected { Protected declarations }

    Procedure WMPaint(Var Msg: TWMPaint);

  private { Private declarations }

    FDC: HDC;
    FHRC: HGLRC;
    arx, ary: real;

    Procedure SetDCPixelFormat;
    procedure GLQuader(X: Extended; Y: Extended; Z: Extended; QWidth: Extended; QLength: Extended; Qheight: Extended; QColor: PGLfloat);
    procedure GLQuader2(X: Extended; Y: Extended; Z: Extended; QWidth: Extended; QLength: Extended; Qheight: Extended; QColor: PGLfloat);
    procedure GLtest(X: Extended; Y: Extended; Z: Extended; QWidth: Extended; QLength: Extended; Qheight: Extended; QColor: PGLfloat);
   procedure GLCone(X: Extended; Y: Extended; Z: Extended; QWidth: Extended; QLength: Extended; Qheight: Extended; QColor: PGLfloat);
   procedure GLSphere(X: Extended; Y: Extended; Z: Extended; QWidth: Extended; QLength: Extended; Qheight: Extended; QColor: PGLfloat);
//   procedure GLCylinder(X1, Y1, Z1: Extended;X2, Y2, Z2: Extended; QWidth: Extended; QLength: Extended; Qheight: Extended; QColor: PGLfloat);

  public { Public declarations }

  End;

Var

  Principal: TPrincipal;
  FPS, Angle: GLFloat;
  NewCount, LastCount, FrameCount: Integer;

Implementation

{$R *.DFM}

Procedure TPrincipal.SetDCPixelFormat;

Const

  Pfd: PIXELFORMATDESCRIPTOR = (

    nSize: SizeOf(PIXELFORMATDESCRIPTOR);
    nVersion: 1;
    dwFlags: PFD_DRAW_TO_WINDOW Or PFD_SUPPORT_OPENGL Or PFD_DOUBLEBUFFER;
    iPixelType: PFD_TYPE_RGBA;
    cColorBits: 32;
    cRedBits: 0;
    cRedShift: 0;
    cGreenBits: 0;
    cBlueBits: 0;
    cBlueShift: 0;
    cAlphaBits: 0;
    cAlphaShift: 0;
    cAccumBits: 0;
    cAccumRedBits: 0;
    cAccumGreenBits: 0;
    cAccumBlueBits: 0;
    cAccumAlphaBits: 8;
    cDepthBits: 32;
    cStencilBits: 0;
    cAuxBuffers: 0;
    iLayerType: PFD_MAIN_PLANE;
    bReserved: 0;
    dwLayerMask: 0;
    dwVisibleMask: 0;
    dwDamageMask: 0);

Var

  PixelFormat: Integer;

Begin

  PixelFormat := ChoosePixelFormat(FDC, @Pfd);
  SetPixelFormat(FDC, PixelFormat, @Pfd);

End;

const GLPrim=GL_Polygon ;

procedure TPrincipal.GLQuader(X: Extended; Y: Extended; Z: Extended; QWidth: Extended; QLength: Extended; Qheight: Extended; QColor: PGLfloat);
begin
  glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, QColor);
  // Reflective properties
  glBegin(GLPrim);
  glNormal3f(0, 0, 1);
  glVertex3f(X + QLength *0.5, Y + QHeight *0.5, Z + QWidth *0.5);
  glVertex3f(X - QLength *0.5, Y + QHeight *0.5, Z + QWidth *0.5);
  glVertex3f(X - QLength *0.5, Y - QHeight *0.5, Z + QWidth *0.5);
  glVertex3f(X + QLength *0.5, Y - QHeight *0.5, Z + QWidth *0.5);
  glEnd;
  glBegin(GLPrim);
  glNormal3f(0, 0, -1);
  glVertex3f(X + QLength *0.5, Y + QHeight *0.5, Z - QWidth *0.5);
  glVertex3f(X - QLength *0.5, Y + QHeight *0.5, Z - QWidth *0.5);
  glVertex3f(X - QLength *0.5, Y - QHeight *0.5, Z - QWidth *0.5);
  glVertex3f(X + QLength *0.5, Y - QHeight *0.5, Z - QWidth *0.5);
  glEnd;
  glBegin(GLPrim);
  glNormal3f(-1, 0, 0);
  glVertex3f(X - QLength *0.5, Y + QHeight *0.5, Z + QWidth *0.5);
  glVertex3f(X - QLength *0.5, Y + QHeight *0.5, Z - QWidth *0.5);
  glVertex3f(X - QLength *0.5, Y - QHeight *0.5, Z - QWidth *0.5);
  glVertex3f(X - QLength *0.5, Y - QHeight *0.5, Z + QWidth *0.5);
  glEnd;
  glBegin(GLPrim);
  glNormal3f(1, 0, 0);
  glVertex3f(X + QLength *0.5, Y + QHeight *0.5, Z + QWidth *0.5);
  glVertex3f(X + QLength *0.5, Y - QHeight *0.5, Z + QWidth *0.5);
  glVertex3f(X + QLength *0.5, Y - QHeight *0.5, Z - QWidth *0.5);
  glVertex3f(X + QLength *0.5, Y + QHeight *0.5, Z - QWidth *0.5);
  glEnd;
  glBegin(GLPrim);
  glNormal3f(0, 1, 0);
  glVertex3f(X - QLength *0.5, Y + QHeight *0.5, Z - QWidth *0.5);
  glVertex3f(X - QLength *0.5, Y + QHeight *0.5, Z + QWidth *0.5);
  glVertex3f(X + QLength *0.5, Y + QHeight *0.5, Z + QWidth *0.5);
  glVertex3f(X + QLength *0.5, Y + QHeight *0.5, Z - QWidth *0.5);
  glEnd;
  glBegin(GLPrim);
  glNormal3f(0, -1, 0);
  glVertex3f(X - QLength *0.5, Y - QHeight *0.5, Z - QWidth *0.5);
  glVertex3f(X + QLength *0.5, Y - QHeight *0.5, Z - QWidth *0.5);
  glVertex3f(X + QLength *0.5, Y - QHeight *0.5, Z + QWidth *0.5);
  glVertex3f(X - QLength *0.5, Y - QHeight *0.5, Z + QWidth *0.5);
  glEnd;
end;

procedure TPrincipal.GLQuader2(X: Extended; Y: Extended; Z: Extended; QWidth: Extended; QLength: Extended; Qheight: Extended; QColor: PGLfloat);
begin
  glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, QColor);
  // Reflective properties
  glBegin(GLPrim);
  glNormal3f(0, 0, 1);
  glVertex3f(X , Y , Z + QWidth *0.5);
  glNormal3f(0.5, 0.5, 1);
  glVertex3f(X + QLength *0.5, Y + QHeight *0.5, Z + QWidth *0.5);
  glNormal3f(-0.5, 0.5, 1);
  glVertex3f(X - QLength *0.5, Y + QHeight *0.5, Z + QWidth *0.5);
  glNormal3f(-0.5, -0.5, 1);
  glVertex3f(X - QLength *0.5, Y - QHeight *0.5, Z + QWidth *0.5);
  glNormal3f(0.5, -0.5, 1);
  glVertex3f(X + QLength *0.5, Y - QHeight *0.5, Z + QWidth *0.5);
  glNormal3f(0.5, 0.5, 1);
  glVertex3f(X + QLength *0.5, Y + QHeight *0.5, Z + QWidth *0.5);
  glEnd;
  glBegin(GLPrim);
  glNormal3f(0, 0, -1);
  glVertex3f(X , Y , Z - QWidth *0.5);
  glNormal3f(0.5, 0.5, -1);
  glVertex3f(X + QLength *0.5, Y + QHeight *0.5, Z - QWidth *0.5);
  glNormal3f(-0.5, 0.5, -1);
  glVertex3f(X - QLength *0.5, Y + QHeight *0.5, Z - QWidth *0.5);
  glNormal3f(-0.5,- 0.5, -1);
  glVertex3f(X - QLength *0.5, Y - QHeight *0.5, Z - QWidth *0.5);
  glNormal3f(0.5, -0.5, -1);
  glVertex3f(X + QLength *0.5, Y - QHeight *0.5, Z - QWidth *0.5);
  glNormal3f(0.5, 0.5, -1);
  glVertex3f(X + QLength *0.5, Y + QHeight *0.5, Z - QWidth *0.5);
  glEnd;
  glBegin(GLPrim);
  glNormal3f(-1, 0, 0);
  glVertex3f(X - QLength *0.5, Y , Z);
  glNormal3f(-1, 0.5, 0.5);
  glVertex3f(X - QLength *0.5, Y + QHeight *0.5, Z + QWidth *0.5);
  glNormal3f(-1, 0.5, -0.5);
  glVertex3f(X - QLength *0.5, Y + QHeight *0.5, Z - QWidth *0.5);
  glNormal3f(-1, -0.5, -0.5);
  glVertex3f(X - QLength *0.5, Y - QHeight *0.5, Z - QWidth *0.5);
  glNormal3f(-1, -0.5, 0.5);
  glVertex3f(X - QLength *0.5, Y - QHeight *0.5, Z + QWidth *0.5);
  glNormal3f(-1, 0.5, 0.5);
  glVertex3f(X - QLength *0.5, Y + QHeight *0.5, Z + QWidth *0.5);
  glEnd;
  glBegin(GLPrim);
  glNormal3f(1, 0, 0);
  glVertex3f(X + QLength *0.5, Y , Z);
  glNormal3f(1, 0.5, 0.5);
  glVertex3f(X + QLength *0.5, Y + QHeight *0.5, Z + QWidth *0.5);
  glNormal3f(1, -0.5, 0.5);
  glVertex3f(X + QLength *0.5, Y - QHeight *0.5, Z + QWidth *0.5);
  glNormal3f(1, -0.5, -0.5);
  glVertex3f(X + QLength *0.5, Y - QHeight *0.5, Z - QWidth *0.5);
  glNormal3f(1, 0.5, -0.5);
  glVertex3f(X + QLength *0.5, Y + QHeight *0.5, Z - QWidth *0.5);
  glNormal3f(1, 0.5, 0.5);
  glVertex3f(X + QLength *0.5, Y + QHeight *0.5, Z + QWidth *0.5);
  glEnd;
  glBegin(GLPrim);
  glNormal3f(-0.5, 1, -0.5);
  glVertex3f(X - QLength *0.5, Y + QHeight *0.5, Z - QWidth *0.5);
  glNormal3f(-0.5, 1, 0.5);
  glVertex3f(X - QLength *0.5, Y + QHeight *0.5, Z + QWidth *0.5);
  glNormal3f(0.5, 1, 0.5);
  glVertex3f(X + QLength *0.5, Y + QHeight *0.5, Z + QWidth *0.5);
  glNormal3f(0.5, 1, -0.5);
  glVertex3f(X + QLength *0.5, Y + QHeight *0.5, Z - QWidth *0.5);
  glEnd;
  glBegin(GLPrim);
  glNormal3f(-0.5, -1, -0.5);
  glVertex3f(X - QLength *0.5, Y - QHeight *0.5, Z - QWidth *0.5);
  glNormal3f(+0.5, -1, -0.5);
  glVertex3f(X + QLength *0.5, Y - QHeight *0.5, Z - QWidth *0.5);
  glNormal3f(+0.5, -1, +0.5);
  glVertex3f(X + QLength *0.5, Y - QHeight *0.5, Z + QWidth *0.5);
  glNormal3f(-0.5, -1, +0.5);
  glVertex3f(X - QLength *0.5, Y - QHeight *0.5, Z + QWidth *0.5);
  glEnd;
end;

procedure TPrincipal.GLTest(X: Extended; Y: Extended; Z: Extended; QWidth: Extended; QLength: Extended; Qheight: Extended; QColor: PGLfloat);
var
  I: Integer;
  xx,yy,zz: GLFloat;
begin
  glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, QColor);
  // Reflective properties
  glBegin(GLPrim);
  glNormal3f(0, 0, 0);
  glVertex3f(X , Y , Z );
  for I := 0 to 200 do
    begin
      xx:=sin((i/200)*20*pi)*0.5;
      yy:=Cos((i/200)*20*pi)*0.5;
      zz:=(i/200)-0.5;
  glNormal3f(xx, yy, zz);
  glVertex3f(X + QLength *xx, Y + QHeight *yy, Z + QWidth *zz);
    end;
  glEnd;
end;

procedure TPrincipal.GLCone(X: Extended; Y: Extended; Z: Extended; QWidth: Extended; QLength: Extended; Qheight: Extended; QColor: PGLfloat);
var
  I: Integer;
  xx,yy,zz: GLFloat;
begin
  glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, QColor);
  // Reflective properties
  glBegin(GLPrim);
  glNormal3f(0, -1, 0);
  glVertex3f(X , Y-QHeight *0.5 , Z );
  for I := 0 to 40 do
    begin
      xx:=sin((i/40)*2*pi)*0.5;
      zz:=Cos((i/40)*2*pi)*0.5;
  glNormal3f(xx, 0, zz);
  glVertex3f(X + QLength *xx, Y + QHeight *0.5, Z + QWidth *zz);
    end;
  glEnd;

  glBegin(GLPrim);
  glNormal3f(0, 1, 0);
  glVertex3f(X , Y+QHeight *0.5 , Z );
  for I := 0 to 40 do
    begin
      xx:=sin((i/40)*2*pi)*0.5;
      zz:=Cos((i/40)*2*pi)*0.5;
  glNormal3f(xx*0.3, 1, zz*0.3);
  glVertex3f(X + QLength *xx, Y + QHeight *0.5, Z + QWidth *zz);
    end;
  glEnd;
end;


procedure TPrincipal.GLSphere(X: Extended; Y: Extended; Z: Extended; QWidth: Extended; QLength: Extended; Qheight: Extended; QColor: PGLfloat);
var
  I,J,J0,J01,M0: Integer;
  x0,x1,xx,xx0,xx01,xx1,yy,yy0,zz,zz0,zz01,zz1: GLFloat;
begin
  glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, QColor);
  // Reflective properties
  for I := 1 to 10 do    //  10 Schritte für die Virtelkugel
    begin
      x0:=sin(((i-1)/20)*pi);
      X1:=sin((i/20)*pi);
      yy0:=Cos(((i-1)/20)*pi)*0.5;
      yy:=cos((i/20)*pi)*0.5;
      for J := 0 to trunc(x1*40+1)  do
        begin
          if x0=0 then
            begin
            xx0:=0;
            zz0:=0;
            end
          else
            begin
              M0:=trunc(x0*40+1);
              J0:=Round((J/trunc(x1*40+1))*M0);
              J01:=Round(((J+1)/trunc(x1*40+1))*M0);
              xx0:=sin(J0/M0*2*pi)*x0*0.5;
              zz0:=cos(J0/M0*2*pi)*x0*0.5;
              xx01:=sin(J01/M0*2*pi)*x0*0.5;
              zz01:=cos(J01/M0*2*pi)*x0*0.5;
            end;
          xx:=sin((J/trunc(x1*40+1))*2*pi)*x1*0.5;
          zz:=Cos((J/trunc(x1*40+1))*2*pi)*x1*0.5;
          xx1:=sin(((J+1)/trunc(x1*40+1))*2*pi)*x1*0.5;
          zz1:=Cos(((J+1)/trunc(x1*40+1))*2*pi)*x1*0.5;
          glBegin(GLPrim);
          if J0<>J01 then
            begin
              glNormal3f(xx01, yy0, zz01);
              glVertex3f(X + QLength *xx01, Y + QHeight *yy0, Z + QWidth *zz01);
            end;
          glNormal3f(xx0, yy0, zz0);
          glVertex3f(X + QLength *xx0, Y + QHeight *yy0, Z + QWidth *zz0);
          glNormal3f(xx, yy, zz);
          glVertex3f(X + QLength *xx, Y + QHeight *yy, Z + QWidth *zz);
          glNormal3f(xx1, yy, zz1);
          glVertex3f(X + QLength *xx1, Y + QHeight *yy, Z + QWidth *zz1);
          glEnd;
          glBegin(GLPrim);
          if J0<>J01 then
            begin
              glNormal3f(xx01, -yy0, zz01);
              glVertex3f(X + QLength *xx01, Y - QHeight *yy0, Z + QWidth *zz01);
            end;
          glNormal3f(xx0, -yy0, zz0);
          glVertex3f(X + QLength *xx0, Y - QHeight *yy0, Z + QWidth *zz0);
          glNormal3f(xx, -yy, zz);
          glVertex3f(X + QLength *xx, Y - QHeight *yy, Z + QWidth *zz);
          glNormal3f(xx1, -yy, zz1);
          glVertex3f(X + QLength *xx1, Y - QHeight *yy, Z + QWidth *zz1);
          glEnd;
        end;
    end;
end;

Procedure TPrincipal.FormCreate(Sender: TObject);

Const

  LightAmbient: Array[0..3] Of GLfloat = (0.05, 0.05, 0.05, 1.0);
  LightDiffuse: Array[0..3] Of GLfloat = (0.5, 0.7, 0.5, 1.0);
  LightSpecular: Array[0..3] Of GLfloat = (0.0, 0.0, 1.0, 1.0);
  LightPosition: Array[0..3] Of GLfloat = (-1.0, 0.0, 2.0, 1.0);

Begin
  arX := 0;
  ary := 0;

  FDC := GetDC(panel1.Handle); // Initialize the rendering context
  SetDCPixelFormat;
  FHRC := wglCreateContext(FDC); // Make a GL Context
  wglMakeCurrent(FDC, FHRC);

  glClearColor(0.0, 0.0, 0.0, 0.0); // Clear background color to black
  glClearDepth(1.0); // Clear the depth buffer
  glDepthFunc(GL_LESS); // Type of depth test
  glShadeModel(GL_SMOOTH); // Smooth color shading
  glEnable(GL_DEPTH_TEST); // Depth test
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity; // Reset projection matrix
  gluPerspective(45.0, Width / Height, 0.1, 100.0); // Aspect ratio of the viewport
  glMatrixMode(GL_PROJECTION);

  glLightfv(GL_LIGHT0, GL_AMBIENT, @LightAmbient); // Create light
  glLightfv(GL_LIGHT0, GL_DIFFUSE, @LightDiffuse);
  glLightfv(GL_LIGHT0, GL_SPECULAR, @LightSpecular);
  glLightfv(GL_LIGHT0, GL_POSITION, @LightPosition); // Light position
  glEnable(GL_LIGHTING);
  glEnable(GL_LIGHT0);

  Angle := 0;

End;

Procedure TPrincipal.FormResize(Sender: TObject);

Begin

  glViewport(0, 0, Width, Height); // Reset The Current Viewport And Perspective Transformation
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity;
  gluPerspective(30.0, Width / Height, 0.1, 100.0);
  glMatrixMode(GL_MODELVIEW);

  InvalidateRect(Handle, Nil, False); // Force window repaint

End;

Procedure TPrincipal.WMPaint(Var Msg: TWMPaint);

Begin
  //
End;

Procedure TPrincipal.FormDestroy(Sender: TObject);

Begin

  wglMakeCurrent(0, 0);
  wglDeleteContext(FHRC);
  ReleaseDC(Handle, FDC);

End;

Procedure TPrincipal.FormDblClick(Sender: TObject);
Begin
  close
End;

Procedure TPrincipal.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
Begin
  If byte(shift) <> 0 Then
    Begin
      arx := (x - (width / 2));
      ary := (y - (height / 2));
    End;
End;

Procedure TPrincipal.Timer1Timer(Sender: TObject);
Type TGLFloatVec = Array[0..4] Of GLFloat;

Var

  Ps: TPaintStruct;
  X, Y, Z,
    Qheight, QWidth, QLength: GLFloat;

  QColor: PGLFloat;

Const MaterialColorRed: Array[0..3] Of GLfloat = (1.0, 0.0, 0.0, 1.0);
  MaterialColorGreen: Array[0..3] Of GLfloat = (0.0, 1.0, 0.0, 0.5);
  MaterialColorBlue: Array[0..3] Of GLfloat = (0.0, 0.0, 1.5, 0.0);
  MaterialColorYellow: Array[0..3] Of GLfloat = (1.0, 1.0, 0.0, 0.0);
  MaterialColorWhite: Array[0..3] Of GLfloat = (1.0, 1.0, 1.0, 0.0);

Begin

  BeginPaint(Handle, Ps);

  NewCount := GetTickCount;
  Inc(FrameCount);

  If (NewCount - LastCount) > 1000 Then

    Begin

      Caption := Format('MAD GLcube - %f fps', [FrameCount * 1000 / (NewCount - LastCount)]);
      LastCount := NewCount;
      FrameCount := 0;

    End;

  glClear(GL_COLOR_BUFFER_BIT Or GL_DEPTH_BUFFER_BIT); // Clear color & depth buffers
  glLoadIdentity;
  glTranslatef(0.0, 0.0, -scrollbar1.Position); // Polygon depth

  X := 0;
  Y := 0;
  Z := 0;
  QWidth := 1;
  QLength := scrollbar2.Position * 0.05;
  QHeight := 1;


  glRotatef(ary, 1.0, 0.0, 0.0);
  glRotatef(arx, 0.0, 1.0, 0.0);

  GLQuader(X, Y, Z+Angle, QWidth+Angle, QLength, Qheight, @MaterialColorred);

  glRotatef(-arx, 0.0, 1.0, 0.0);
  glRotatef(-ary, 1.0, 0.0, 0.0);

  glRotatef(Angle*36, 0.0, 1.0, 0.0);
  glRotatef(arx, 1.0, 0.0, 0.0);

  GLQuader2(X, Y, Z, 2, 2, 2, @MaterialColorGreen);

  glRotatef(-arx, 1.0, 0.0, 0.0);
  glRotatef(-Angle*36, 0.0, 1.0, 0.0);

  glRotatef(Angle*18, 1.0, 0.0, 1.0);
  glRotatef(-Angle*36, 0.0, 1.0, 0.0);

  GLTest(3,0,0,2,2,2,@MaterialColorBlue);
  GLCone(-3,0,0,2,2,2,@MaterialColorYellow);
  GLSphere(0,-3,0,2,2,2,@MaterialColorWhite);

  SwapBuffers(FDC);
  glRotatef(-Angle*36, 0.0, 1.0, 0.0);
  glRotatef(Angle*18, 1.0, 0.0, 1.0);

  If Angle > 10.0 Then
    Angle := -10.0;

  Angle := Angle + 0.1;

  EndPaint(Handle, Ps);

  InvalidateRect(Handle, Nil, False); // Force window repaint

End;

End.

