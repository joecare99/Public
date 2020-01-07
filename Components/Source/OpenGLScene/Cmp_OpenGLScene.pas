Unit Cmp_OpenGLScene;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

Interface
Uses
{$IFnDEF FPC}
  windows, OpenGL,
{$ELSE}
  LCLIntf, LCLType, gl,glu, GLext,OpenGLContext,
{$ENDIF}
  Classes, Controls, Sysutils;

{$IFNDEF LCLQT}
  {$define HasRGBBits}
{$endif}
Type
  TUVPoint = Record
    U, V: Single;
  End;

  { TPointF }

  TPointF = record
    public
      function Rotxm90: TpointF;
      function Rotym90: TpointF;
      function Rotzm90: TpointF;
      function Neg:TPointF;
      function Add(aPnt:TPointF):TPointF;
      function SMult(fak:TGLdouble):TPointF;
    public
              case boolean of
              false: (x,y,z:TGLdouble);
              true: (d:array[0..2] of TGLdouble);
            end;

  {$IFDEF FPC}
    TGLArrayf3 =array[0..2] of TGLfloat;
    TGLArrayf4 =array[0..3] of TGLfloat;
    HGLRC = integer;
  {$ENDIF}

const
  CGLArrayf4_0:TGLArrayf4=(0,0,0,0);
  CGLArrayf3_0:TGLArrayf3=(0,0,0);

type
  TMaterialBaseDef = Record
    AmbColor: TGLArrayf4;
    DiffColor: TGLArrayf4;
    ShinyNess: Glfloat;
  End;


  { T3DBasisObject }

  T3DBasisObject = Class(TWinControl)
  public
    Rotation: TGLArrayf4;
    Translation: TGLArrayf3;
{    FOnMouseMove:TMouseMoveEvent;
    FOnMouseDown:TMouseEvent;
    FOnMouseUp:TMouseEvent; }
    Constructor Create(Aowner: TComponent); override;
    Procedure Draw; virtual; abstract;
    Procedure MoveTo(aPnt:TPointF); virtual;abstract;overload;
    Procedure MoveTo(x, y, z: Extended); virtual; overload;
    Procedure Rotate(Amount, x, y, z: Extended); virtual;
  published
{    property Parent:T
    property onMouseDown:TMouseEvent read FOnMouseDown write FOnMouseDown;
    property onMouseUp:TMouseEvent read FOnMouseUp write FOnMouseUp;
    property onMouseMove:TMouseMoveEvent read FOnMouseMove write FOnMouseMove;
}  End;


  {$IFDEF FPC}

  { TO3DCanvas }
  TO3DCanvas = Class(TCustomOpenGLControl)
  {$ELSE}
  TO3DCanvas = Class(TWinControl)
  {$ENDIF}
  private
    FClickpoint: TPoint;
    {$IFNDEF FPC}
    HRC: HGLRC;
    {$ENDIF}
    Finitialized: Boolean;
    FAntiAliase: Boolean;
    FCulling: Boolean;
    FObjectHandling: Boolean;
    FOnSelectionChange: TNotifyEvent;
    FPreSelected: T3DBasisObject;
    FSelected: T3DBasisObject;
    FmouseOverObject: Boolean;
    Speed: Double;
    cube_rotationx, cube_rotationy, cube_rotationz: GLfloat;

    {$IFNDEF FPC}
    Procedure SetDCPixelFormat;
    {$ENDIF}
    procedure DoPaint(Sender: TObject);
    Function SelectObject(xsel, ysel: integer): cardinal;
    procedure SetOnSelectionChange(AValue: TNotifyEvent);
    procedure SetSelected(AValue: T3DBasisObject);
  protected
    {$IFNDEF FPC}
    Procedure PaintWindow({%H-}DC: HDC); override;
    {$ENDIF}
    Procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer); override;
    Procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
      override;
    Procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    Procedure DrawSceneInt;
  public
    FViewDistance: single;
    DC: Cardinal;
    arx, ary: single;
    Constructor Create(AOwner: TComponent); override;
    Destructor Destroy; override;
    Procedure DrawScene;
    Property Selected: T3DBasisObject read FSelected write SetSelected;
    Procedure FormResize(Sender: TObject);
  published
    Property Align;
    Property ViewDistance: Single read FViewDistance write FViewDistance;
    Property AntiAliasie: boolean read FAntiAliase write FAntiAliase;
    Property Culling: boolean read FCulling write FCulling;
    Property ObjectHandling: Boolean read FObjectHandling write FObjectHandling;
    property Anchors;
    {$ifdef FPC}
    property AutoResizeViewport;
    property BorderSpacing;
    property Enabled;
    {$IFDEF HasRGBBits}
    property RedBits;
    property GreenBits;
    property BlueBits;
    {$ENDIF}
    property OpenGLMajorVersion;
    property OpenGLMinorVersion;
    property MultiSampling;
    property AlphaBits;
    property DepthBits;
    property StencilBits;
    property AUXBuffers;
    property OnChangeBounds;
    property OnMakeCurrent;
    property OnPaint;
    property OnShowHint;
    {$ENDIF}
    property OnClick;
    property OnConstrainedResize;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
    Property OnSelectionChange:TNotifyEvent read FOnSelectionChange write SetOnSelectionChange;
    property PopupMenu;
    property ShowHint;
    property Visible;

  End;

  { TO3DGroup }

  TO3DGroup = Class(T3DBasisObject)

  private
    FTranslVector: TPointF;
    function getTranslAmount: Extended;
    procedure SetTranslAmount(AValue: Extended);
  public
    Procedure Draw; override;
    Procedure MoveTo(nPnt: TPointF); override;
    Property TranslVector:TPointF read FTranslVector write FTranslVector;
    Property TranslAmount:Extended read getTranslAmount write SetTranslAmount;
  End;

Const
  Zero : TPointF=(x:0;y:0;z:0);
  eX : TPointF=(x:1;y:0;z:0);
  eY : TPointF=(x:0;y:1;z:0);
  eZ : TPointF=(x:0;y:0;z:1);

  MaterialColorGreen: TGLArrayf4 = (0.0, 1.0, 0.0, 0.0);
  MaterialColorTest: TGLArrayf4 = (0.1, 0.2, 0.2, 0.0);
  MaterialColorBlack: TGLArrayf4 = (0.01, 0.01, 0.01, 0.0);
  MaterialColorRed: TGLArrayf4 = (1.0, 0.0, 0.0, 1.0);
  MaterialColorBlue: TGLArrayf4 = (0.0, 0.0, 1.5, 0.0);
  MaterialColorYellow: TGLArrayf4 = (1.0, 1.0, 0.0, 0.0);
  MaterialColorDkGray: TGLArrayf4 = (0.25, 0.25, 0.25, 0.0);
  MaterialColorGray: TGLArrayf4 = (0.5, 0.5, 0.5, 0.0);
  MaterialColorWhite: TGLArrayf4 = (1.0, 1.0, 1.0, 0.0);
  MaterialColorWhiteGlass: TGLArrayf4 = (1.0, 1.0, 1.0, 0.9);
  MaterialColorBlackGlass: TGLArrayf4 = (0.01, 0.01, 0.01, 0.9);
  MaterialColorGreenGlass: TGLArrayf4 = (0.0, 1.0, 0.0, 0.9);

  MaterialGreenPlastic: TMaterialBaseDef =
  (AmbColor: (0.0, 0.2, 0.0, 0.0);
    DiffColor: (0.0, 1.0, 0.0, 0.0);
    ShinyNess: 0.3);

// Hilfsfunktionen
  Function UVPoint(u,v:Single):TUVPoint;inline;
  Function PointF(nx,ny,nz:TGLdouble):TPointF;inline;

// Point-GL-Procedure

Procedure glNormal(aPnt:TPointF);
Procedure glVertex(aPnt:TPointF);

Implementation
{$IFDEF FPC}
{$R registerOpenGLScene.res}
{$ENDIF}
const
  fovy = 20.0;
  zNear = 0.1;
  zFar = 60.0;

function UVPoint(U, V: Single): TUVPoint;inline;
Begin
  Result.U := u;
  Result.v := v;
End;

function PointF(nx, ny, nz: TGLdouble): TPointF;inline;
begin
  Result.x:=nx;
  Result.y:=ny;
  Result.z:=nz;
end;

procedure glNormal(aPnt: TPointF);
begin
  glNormal3dv(PGLdouble(@aPnt.d[0]));
end;

procedure glVertex(aPnt: TPointF);
begin
  glVertex3dv(PGLdouble(@aPnt.d[0]));
end;

{ TPointF }

function TPointF.Rotxm90: TpointF;
begin
  result.x:= x;
  result.y:= z;
  result.z:=-y;
end;

function TPointF.Rotym90: TpointF;
begin
  result.x:=-z;
  result.y:= y;
  result.z:= x;
end;

function TPointF.Rotzm90: TpointF;
begin
  result.x:= y;
  result.y:=-x;
  result.z:= z;
end;

function TPointF.Neg: TPointF;
begin
  result.x:=-x;
  result.y:=-y;
  result.z:=-z;
end;

function TPointF.Add(aPnt: TPointF): TPointF;
begin
  result.x:=x+aPnt.x;
  result.y:=y+aPnt.y;
  result.z:=z+aPnt.z;
end;

function TPointF.SMult(fak: TGLdouble): TPointF;
begin
  result.x:=x*fak;
  result.y:=y*fak;
  result.z:=z*fak;
end;

constructor TO3DCanvas.Create(AOwner: TComponent);

{$ifdef unused}
Const
  LightAmbient: Array[0..3] Of GLfloat = (0.05, 0.05, 0.05, 1.0);
  LightDiffuse: Array[0..3] Of GLfloat = (0.5, 0.7, 0.5, 1.0);
  LightSpecular: Array[0..3] Of GLfloat = (0.7, 0.5, 0.5, 1.0);
  LightPosition: Array[0..3] Of GLfloat = (-14.0, 14.0, 0.0, 1.0);
{$endif}

Begin
  Finitialized:=false;
{$ifdef FPC}
      RGBA := true;
      RedBits:=8;
      GreenBits:=8;
      BlueBits:=8;
  sleep(10);
 {$endif}
  Inherited;
  //  If Aowner.inheritsfrom(TWincontrol) Then
  //    Parent := Twincontrol(Aowner);

  If csDesigning In ComponentState Then
    Begin

    End
  Else
    Begin
      {$IFNDEF FPC}
      DC := GetDC(Handle); // Initialize the rendering context
      SetDCPixelFormat;
      HRC := wglCreateContext(DC); // Make a GL Context
      wglMakeCurrent(DC, HRC);

      glClearColor(0.0, 0.0, 0.5, 1.0); // Clear background color to black
      glClearDepth(1.0); // Clear the depth buffer
      glDepthFunc(GL_GREATER); // Type of depth test
      glEnable(GL_DEPTH_TEST); // enables depth testing
      glEnable(GL_TEXTURE_2D); // Aktiviert Texture Mapping
      glShadeModel(GL_SMOOTH); // Smooth color shading

      glMatrixMode(GL_PROJECTION);
      glLoadIdentity; // Reset projection matrix
      gluPerspective(fovy, Width / Height, zNear, zFar);
      // Aspect ratio of the viewport
      glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);
      glMatrixMode(GL_MODELVIEW);

       If FCulling Then
        Begin
          glEnable(GL_CULL_FACE);
          glCullface(GL_BACK);
        End;
      If true Then
        Begin
          glEnable(GL_POLYGON_SMOOTH);
          glEnable(GL_LINE_SMOOTH);
          glEnable(GL_SMOOTH);
          glEnable(GL_BLEND);
        End;
      {$Else}
      AutoResizeViewport := true;
      OnPaint:=DoPaint;
      {$ENDIF}
    End

End;

destructor TO3DCanvas.Destroy;
Begin
  {$IFNDEF FPC}
  Try
    wglMakeCurrent(0, 0);
    wglDeleteContext(HRC);
    ReleaseDC(0, DC);
  Finally

  End;
  {$ENDIF}
  Inherited;
End;

function TO3DCanvas.SelectObject(xsel, ysel: integer): cardinal;
Var
  Puffer: Array[0..512] Of GLuint;
  Viewport: Array[0..3] Of Integer;
  Treffer, i: Integer;
  Z_Wert: GLuint;
  Getroffen: GLuint;

Begin
  glGetIntegerv(GL_VIEWPORT, @viewport); //Die Sicht speichern
  glSelectBuffer(512, @Puffer); //Den Puffer zuordnen
  glRenderMode(GL_SELECT); //In den Selectionsmodus schalten
  glmatrixmode(gl_projection); //In den Projektionsmodus
  glPushMatrix; //Um unsere Matrix zu sichern
  glLoadIdentity; //Und dieselbige wieder zurückzusetzen

  gluPickMatrix(xsel, viewport[3] - ysel, 0.2, 0.2, @viewport);
//  gluPerspective(fovy, Width / Height, zNear, zFar);

  DoPaint(nil); //Die Szene zeichnen

  glMatrixMode(GL_PROJECTION); //Wieder in den Projektionsmodus
  glPopMatrix; //um unsere alte Matrix wiederherzustellen

  treffer := glRenderMode(GL_RENDER); //Anzahl der Treffer auslesen

  Getroffen := 0; //Höchsten möglichen Wert annehmen
  Z_Wert := High(GLUInt); //Höchsten Z - Wert
  For i := 0 To Treffer - 1 Do
    If Puffer[(i * 4) + 1] < Z_Wert Then
      Begin
        getroffen := Puffer[(i * 4) + 3];
        Z_Wert := Puffer[(i * 4) + 1];
      End;

 // glViewport(0, 0, Width, Height);
  // Reset The Current Viewport And Perspective Transformation
//  glLoadIdentity;
//  gluPerspective(30.0, Width / Height, 0.1, 100.0);
 //  glMatrixMode(GL_MODELVIEW);

  Result := getroffen;
End;

procedure TO3DCanvas.SetOnSelectionChange(AValue: TNotifyEvent);
begin
  if @FOnSelectionChange=@AValue then Exit;
  FOnSelectionChange:=AValue;
end;

procedure TO3DCanvas.SetSelected(AValue: T3DBasisObject);
begin
  if FSelected=AValue then Exit;
  FSelected:=AValue;
  if assigned(FOnSelectionChange) then
    FOnSelectionChange(self)
end;

procedure TO3DCanvas.DoPaint(Sender: TObject);

var
  Ps: TPaintStruct;
  I: Integer;
  c: Cardinal;

Const
  LightAmbient: Array[0..3] Of GLfloat = (0.05, 0.05, 0.05, 1.0);
  LightDiffuse: Array[0..3] Of GLfloat = (0.7, 0.7, 0.7, 1.0);
  LightSpecular: Array[0..3] Of GLfloat = (0.8, 0.7, 0.5, 1.0);
  LightPosition: Array[0..3] Of GLfloat = (-14.0, 14.0, 0.0, 1.0);

Const
  mat_specular: Array[0..3] Of GlFloat = (1.2, 1.2, 1.2, 1.0);
  mat_shininess: Array[0..0] Of GlFloat = (50.0);

begin
//  DrawSceneInt;
//  exit;
  BeginPaint(Handle, Ps{%H-}); {out}
if assigned(Sender) then
  begin
  glMatrixMode(GL_PROJECTION);
{
 } glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
 glLoadIdentity();
  end;
 gluPerspective(fovy, Width / Height, zNear, zFar);
// glFrustum(-Width / height*1.0,-width / height*1.0,-1.0,1.0,zNear,zFar);
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity;

  glDepthFunc(GL_LEQUAL); // Type of depth test
      glEnable(GL_DEPTH_TEST); // enables depth testing
      glEnable(GL_TEXTURE_2D); // Aktiviert Texture Mapping
      glShadeModel(GL_SMOOTH); // Smooth color shading

  glLightfv(GL_LIGHT0, GL_AMBIENT,  {$IFNDEF FPC}@{$endif}LightAmbient); // Create light
  glLightfv(GL_LIGHT0, GL_DIFFUSE, {$IFNDEF FPC}@{$endif}LightDiffuse);
      glLightfv(GL_LIGHT0, GL_SPECULAR, {$IFNDEF FPC}@{$endif}LightSpecular);
      glLightfv(GL_LIGHT0, GL_POSITION, {$IFNDEF FPC}@{$endif}LightPosition); // Light position
      glEnable(GL_LIGHTING);
      glEnable(GL_LIGHT0);
      glEnable(GL_DEPTH_TEST);
      glEnable(GL_LINE_SMOOTH);
      glEnable(GL_SMOOTH);
      glEnable(GL_BLEND);

  glinitnames;
  glpushname(0);

  glTranslatef(0.0, 0.0, -FViewDistance); // Polygon depth

  glMaterialfv(GL_FRONT, GL_SPECULAR, @mat_specular[0]);
   glMaterialfv(GL_FRONT, GL_SHININESS, @mat_shininess[0]);

//  glRotatef(cube_rotationx, cube_rotationy, cube_rotationz, 0.0);
  glRotatef(ary, 1.0, 0.0, 0.0);
  glRotatef(arx, 0.0, 1.0, 0.0);

  For I := 0 To ComponentCount - 1 Do
    If Components[i].InheritsFrom(T3DBasisObject) Then
      With T3DBasisObject(Components[i]) Do
        Begin
          c := cardinal(self.Components[i]);
          glloadname(c); //cardinal(Components[i]));
          glPushMatrix;
          if Visible then
            Draw;
          glPopMatrix;
        End;

  SwapBuffers;
   EndPaint(Handle, Ps);
end;

{$IFNDEF FPC}
Procedure TO3DCanvas.SetDCPixelFormat;

{$IFNDEF FPC}
type
  TPIXELFORMATDESCRIPTOR =PIXELFORMATDESCRIPTOR;
{$ENDIF}

const
  pfdsize=SizeOf(TPIXELFORMATDESCRIPTOR);
  PFD: TPIXELFORMATDESCRIPTOR = (

    nSize: pfdsize;
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
  PFDescriptor: TPIXELFORMATDESCRIPTOR;
  PixelFormat: Integer;

Begin
  PFDescriptor := Pfd;
  PixelFormat := ChoosePixelFormat(DC, @PFDescriptor);
  If PixelFormat = 0 Then
    RaiseLastOSError;
  If GetPixelFormat(DC) <> PixelFormat Then
    If Not SetPixelFormat(DC, PixelFormat, @PFDescriptor) Then
      RaiseLastOSError;
  DescribePixelFormat(DC, PixelFormat, SizeOf(PFDescriptor), PFDescriptor);
End;
{$ENDIF}

procedure TO3DCanvas.DrawSceneInt;

Const
  LightAmbient: Array[0..3] Of GLfloat = (0.05, 0.05, 0.05, 1.0);
  LightDiffuse: Array[0..3] Of GLfloat = (0.5, 0.5, 0.4, 1.0);
  LightSpecular: Array[0..3] Of GLfloat = (0.7, 0.6, 0.5, 1.0);
  LightPosition: Array[0..3] Of GLfloat = (-14.0, 14.0, 0.0, 1.0);

Var
  Ps: TPaintStruct;
  I: Integer;
  c: cardinal;
  //  QColor: PGLFloat;

Const
  mat_specular: Array[0..3] Of GlFloat = (1.2, 1.2, 1.2, 1.0);
  mat_shininess: Array[0..0] Of GlFloat = (50.0);

Begin
  BeginPaint(Handle, Ps{%H-}); {out}
  glMatrixMode(GL_PROJECTION);
  glClearColor(0, 0, 0.0, 1.0);
  glClear(GL_COLOR_BUFFER_BIT Or GL_DEPTH_BUFFER_BIT);
  // Clear color & depth buffers
  glFrustum(-TGLfloat(width) / height,TGLfloat(width) / height,-1,1,1.5,100);
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity;

  glDepthFunc(GL_LEQUAL); // Type of depth test
      glEnable(GL_DEPTH_TEST); // enables depth testing
      glEnable(GL_TEXTURE_2D); // Aktiviert Texture Mapping
      glShadeModel(GL_SMOOTH); // Smooth color shading

   glLightfv(GL_LIGHT0, GL_AMBIENT,  {$IFNDEF FPC}@{$endif}LightAmbient); // Create light
   glLightfv(GL_LIGHT0, GL_DIFFUSE, {$IFNDEF FPC}@{$endif}LightDiffuse);
   glLightfv(GL_LIGHT0, GL_SPECULAR, {$IFNDEF FPC}@{$endif}LightSpecular);
   glLightfv(GL_LIGHT0, GL_POSITION, {$IFNDEF FPC}@{$endif}LightPosition); // Light position
   glEnable(GL_LIGHTING);
   glEnable(GL_LIGHT0);
   glEnable(GL_DEPTH_TEST);

  glinitnames;
  glpushname(0);

  glTranslatef(0.0, 0.0, -FViewDistance); // Polygon depth

  glMaterialfv(GL_FRONT, GL_SPECULAR, @mat_specular[0]);
  glMaterialfv(GL_FRONT, GL_SHININESS, @mat_shininess[0]);


  glRotatef(ary, 1.0, 0.0, 0.0);
  glRotatef(arx, 0.0, 1.0, 0.0);

  For I := 0 To ComponentCount - 1 Do
    If Components[i].InheritsFrom(T3DBasisObject) Then
      With T3DBasisObject(Components[i]) Do
        Begin
          c := cardinal(self.Components[i]);
          glloadname(c); //cardinal(Components[i]));
          glPushMatrix;
          Draw;
          glPopMatrix;
        End;

  SwapBuffers{$IFNDEF FPC} (DC) {$ENDIF};

  EndPaint(Handle, Ps);

End;

{$Ifndef FPC}
procedure TO3DCanvas.PaintWindow(DC: HDC);
Begin
  if csDesigning in ComponentState then
    exit;
{  If Not Finitialized Then
    Begin
      FormResize(self);
      Finitialized := true
    End;
  DrawScene;     }
End;
{$ENDIF}

procedure TO3DCanvas.FormResize(Sender: TObject);
Begin
{  glMatrixMode(GL_PROJECTION);
  glClearColor(0, 0, 0.0, 1.0);
  glLoadIdentity();
 }

  glViewport(0, 0, Width, Height);
  // Reset The Current Viewport And Perspective Transformation
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity;
  glMatrixMode(GL_MODELVIEW);

  InvalidateRect(Handle, Nil, False); // Force window repaint
End;

procedure TO3DCanvas.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
Var
  so: TObject;
Begin
  If FObjectHandling Then
    Try
      so := Tobject(SelectObject(x, y));
      if (integer(so) <> -1) and assigned(so) and so.InheritsFrom(T3DBasisObject)
        then
        Begin
          if @FSelected <> @T3DBasisObject(so) then
            begin
              FPreSelected := T3DBasisObject(so);
              FClickpoint := Point(x,y);
            end;
          if assigned(T3DBasisObject(so).OnMouseDown) then
            T3DBasisObject(so).onMouseDown(so, button, shift, x, y)
          else
            inherited
        End
      Else
        begin
          Inherited;
          if assigned(FOnSelectionChange) and Assigned(FSelected) then
            FOnSelectionChange(Self);
          FSelected := nil;
        end;
    Except
      Inherited;
    End
  Else
    Inherited;
End;

procedure TO3DCanvas.MouseMove(Shift: TShiftState; X, Y: Integer);
Var
  so: TObject;
Begin
  If FObjectHandling Then
    Try
      if (shift = []) and FmouseOverObject then
      begin
      so := Tobject(SelectObject(x, y));
          if (integer(so) <> -1) and assigned(so) and
            so.InheritsFrom(T3DBasisObject) then
        Begin
          if assigned(T3DBasisObject(so).OnMouseMove) then
                T3DBasisObject(so).onMouseMove(so, shift, x, y)
          else
            inherited
        End
      Else
        begin
          Inherited;
        end;
      end
      else begin if assigned(FPreSelected) and assigned(FPreSelected.OnMouseMove) then
        FPreSelected.OnMouseMove(fselected, shift, x, y)
      else
        begin
          if assigned(FPreSelected) and (point(x,y).Distance(FClickpoint)>10) then
            FPreSelected := nil;
         inherited
        end;end;
    Except
      Inherited;
    End
  Else
    Inherited;
End;

procedure TO3DCanvas.DrawScene;
begin
  invalidate;
end;

procedure TO3DCanvas.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
Var
  so: TObject;
Begin
  If FObjectHandling Then
    Try
      if assigned(FPreSelected) and (point(x,y).Distance(FClickpoint)<=10) then
        begin
          SetSelected(FPreSelected);
          FPreSelected:=nil;
        end;
      so := Tobject(SelectObject(x, y));
      if (integer(so) <> -1) and assigned(so) and so.InheritsFrom(T3DBasisObject)
        then
        Begin
          if assigned(T3DBasisObject(so).OnMouseUp) then
            T3DBasisObject(so).onMouseUp(so, Button, shift, x, y)
          else
            inherited
        End
      Else
        begin
          Inherited;
        end;
    Except
      Inherited;
    End
  Else
    Inherited;
End;

//-----------------------------------------------------------------------

constructor T3DBasisObject.Create(Aowner: TComponent);
Begin
  Inherited;
  If Aowner.inheritsfrom(TWincontrol) Then
    Parent := TWincontrol(Aowner);
End;

procedure T3DBasisObject.MoveTo(x, y, z: Extended);
begin
  MoveTo(PointF(x,y,z));
end;

procedure T3DBasisObject.Rotate(Amount, x, y, z: Extended);
Begin
  Rotation[0] := Amount;
  Rotation[1] := x;
  Rotation[2] := y;
  Rotation[3] := z;
End;

//----------------------------------------------------------------------------

function TO3DGroup.getTranslAmount: Extended;
begin
  if abs(TranslVector.x) > abs(TranslVector.y) then
    if abs(TranslVector.x) > abs(TranslVector.z) then
      result := Translation[0] / TranslVector.x
    else
      result := Translation[2] / TranslVector.z
  else
    if abs(TranslVector.y) > abs(TranslVector.z) then
      result := Translation[1] / TranslVector.y
    else
      result := Translation[2] / TranslVector.z
end;

procedure TO3DGroup.SetTranslAmount(AValue: Extended);
begin
  MoveTo(FTranslVector.SMult(AValue));
end;

procedure TO3DGroup.Draw;
Var
  I: Integer;
Begin
  glTranslatef(Translation[0], Translation[1], Translation[2]);
  glRotatef(rotation[0], rotation[1], rotation[2], rotation[3]);
  For I := 0 To ComponentCount - 1 Do
    If Components[i].InheritsFrom(T3DBasisObject) Then
      With T3DBasisObject(Components[i]) Do
        Begin
          glloadname(cardinal(self.Components[i]));
          glPushMatrix;
          if Visible then
            Draw;
          glPopMatrix;
        End;
End;

procedure TO3DGroup.MoveTo(nPnt: TPointF);
Begin
  Translation[0] := nPnt.x;
  Translation[1] := nPnt.y;
  Translation[2] := nPnt.z;
End;

End.

