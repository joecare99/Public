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

  {$IFDEF FPC}
    TGLArrayf3 =array[0..2] of TGLfloat;
    TGLArrayf4 =array[0..3] of TGLfloat;
    HGLRC = integer;
  {$ENDIF}

  TMaterialBaseDef = Record
    AmbColor: TGLArrayf4;
    DiffColor: TGLArrayf4;
    ShinyNess: Glfloat;
  End;

  T3DBasisObject = Class(TWinControl)
  public
    Rotation: TGLArrayf4;
    Translation: TGLArrayf3;

    Constructor Create(Aowner: TComponent); override;
    Procedure Draw; virtual; abstract;
    Procedure MoveTo(x, y, z: Extended); virtual; abstract;
    Procedure Rotate(Amount, x, y, z: Extended); virtual;
  End;

  {$IFDEF FPC}

  { TO3DCanvas }

  TO3DCanvas = Class(TCustomOpenGLControl)
  {$ELSE}
  TO3DCanvas = Class(TWinControl)
  {$ENDIF}
  private
    {$IFNDEF FPC}
    HRC: HGLRC;
    {$ENDIF}
    Finitialized: Boolean;
    FAntiAliase: Boolean;
    FCulling: Boolean;
    FObjectHandling: Boolean;
    FSelected: T3DBasisObject;
    FmouseOverObject: Boolean;
    {$IFNDEF FPC}
    Procedure SetDCPixelFormat;
    {$ENDIF}
    Function SelectObject(xsel, ysel: integer): cardinal;
  protected
    Procedure PaintWindow({%H-}DC: HDC); override;
    Procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer); override;
    Procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
      override;
    Procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
  public
    FViewDistance: single;
    DC: Cardinal;
    arx, ary: single;
    Constructor Create(AOwner: TComponent); override;
    Destructor Destroy; override;
    Procedure DrawScene;
    Property Selected: T3DBasisObject read FSelected;
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
    property PopupMenu;
    property ShowHint;
    property Visible;

  End;

  TO3DGroup = Class(T3DBasisObject)
  public
    Procedure Draw; override;
    Procedure MoveTo(nx, ny, nz: Extended); override;
  End;

Const
  MaterialColorGreen: TGLArrayf4 = (0.0, 1.0, 0.0, 0.5);
  MaterialColorTest: TGLArrayf4 = (0.1, 0.2, 0.2, 0.0);
  MaterialColorBlack: TGLArrayf4 = (0.1, 0.1, 0.1, 0.0);
  MaterialColorRed: TGLArrayf4 = (1.0, 0.0, 0.0, 1.0);
  MaterialColorBlue: TGLArrayf4 = (0.0, 0.0, 1.5, 0.0);
  MaterialColorYellow: TGLArrayf4 = (1.0, 1.0, 0.0, 0.0);
  MaterialColorWhite: TGLArrayf4 = (1.0, 1.0, 1.0, 0.0);

  MaterialGreenPlastic: TMaterialBaseDef =
  (AmbColor: (0.0, 0.2, 0.0, 0.0);
    DiffColor: (0.0, 1.0, 0.0, 0.0);
    ShinyNess: 0.3);

function UVPoint(U, V: Single): TUVPoint; inline;

Implementation
{$IFDEF FPC}
{$R registerOpenGLScene.res}
{$ENDIF}
const
  fovy = 60.0;
  zNear = 0.1;
  zFar = 50.0;

Function UVPoint(u, V: Single): TUVPoint;
Inline;
Begin
  result.U := u;
  result.v := v;
End;

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
      {$ENDIF}


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
      glMatrixMode(GL_PROJECTION);

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
      OnResize := FormResize;
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

  gluPickMatrix(xsel, viewport[3] - ysel, 1.0, 1.0, @viewport);
  gluPerspective(fovy, Width / Height, zNear, zFar);

  DrawScene; //Die Szene zeichnen

  glmatrixmode(gl_projection); //Wieder in den Projektionsmodus
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

procedure TO3DCanvas.DrawScene;

Const
  LightAmbient: Array[0..3] Of GLfloat = (0.05, 0.05, 0.05, 1.0);
  LightDiffuse: Array[0..3] Of GLfloat = (0.5, 0.7, 0.5, 1.0);
  LightSpecular: Array[0..3] Of GLfloat = (0.7, 0.5, 0.5, 1.0);
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
  glMatrixMode(GL_MODELVIEW);
  glClearColor(0, 0, 0.0, 1.0);
  glClear(GL_COLOR_BUFFER_BIT Or GL_DEPTH_BUFFER_BIT);
  // Clear color & depth buffers
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

  //  InvalidateRect(Handle, Nil, False); // Force window repaint

End;

procedure TO3DCanvas.PaintWindow(DC: HDC);
Begin
  if csDesigning in ComponentState then
    exit;
  If Not Finitialized Then
    Begin
      FormResize(self);
      Finitialized := true
    End;
  DrawScene;
End;

procedure TO3DCanvas.FormResize(Sender: TObject);
Begin

  glViewport(0, 0, Width, Height);
  // Reset The Current Viewport And Perspective Transformation
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity;
  gluPerspective(fovy, Width / Height, zNear, zFar);
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
          FSelected := T3DBasisObject(so);
          if assigned(T3DBasisObject(so).OnMouseDown) then
            T3DBasisObject(so).onMouseDown(so, button, shift, x, y)
          else
            inherited
        End
      Else
        begin
          Inherited;
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
      else if assigned(Fselected) and assigned(Fselected.OnMouseMove) then
        fselected.OnMouseMove(fselected, shift, x, y)
      else
       inherited
    Except
      Inherited;
    End
  Else
    Inherited;
End;

procedure TO3DCanvas.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
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

Constructor T3DBasisObject.create;
Begin
  Inherited;
  If Aowner.inheritsfrom(TWincontrol) Then
    Parent := Twincontrol(Aowner);
End;

Procedure T3DBasisObject.Rotate(Amount, x, y, z: Extended);
Begin
  Rotation[0] := Amount;
  Rotation[1] := x;
  Rotation[2] := y;
  Rotation[3] := z;
End;

//----------------------------------------------------------------------------

Procedure TO3DGroup.Draw;
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
          Draw;
          glPopMatrix;
        End;
End;

Procedure TO3DGroup.MoveTo(nx, ny, nz: Extended);
Begin
  Translation[0] := nx;
  Translation[1] := ny;
  Translation[2] := nz;
End;

End.

