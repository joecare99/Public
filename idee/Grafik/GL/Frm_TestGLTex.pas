Unit Frm_TestGLTex;

Interface

Uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  opengl, StdCtrls;

Type
  TfrmCube = Class(TForm)
    Procedure FormCreate(Sender: TObject);
    Procedure FormResize(Sender: TObject);
    Procedure FormPaint(Sender: TObject);
    Procedure FormDestroy(Sender: TObject);
  private
    hrc: HGLRC;
    DC: hdc;
    Procedure DrawScene;
  public
  End;

Const
  tex: Array[0..1, 0..7, 0..7] Of GLubyte =
  (((0, 0, 0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 1, 0, 0, 0),
    (0, 0, 0, 1, 1, 0, 0, 0),
    (0, 0, 0, 0, 1, 0, 0, 0),
    (0, 0, 0, 0, 1, 0, 0, 0),
    (0, 0, 0, 0, 1, 0, 0, 0),
    (0, 0, 0, 1, 1, 1, 0, 0),
    (0, 0, 0, 0, 0, 0, 0, 0)),

    ((0, 0, 0, 0, 0, 0, 0, 0),
    (0, 0, 0, 2, 2, 0, 0, 0),
    (0, 0, 2, 0, 0, 2, 0, 0),
    (0, 0, 0, 0, 0, 2, 0, 0),
    (0, 0, 0, 0, 2, 0, 0, 0),
    (0, 0, 0, 2, 0, 0, 0, 0),
    (0, 0, 2, 2, 2, 2, 0, 0),
    (0, 0, 0, 0, 0, 0, 0, 0)));

Type
  ttex = Array[0..63, 0..2] Of GLubyte;
Var
  t: Array[0..2] Of ttex;

  frmCube: TfrmCube;
  Distanz: Real;
  winkel1: Integer;
  winkel2: Integer;
  winkel3: Integer;

Implementation

{$R *.DFM}

Procedure Init_Texturen;
Var
  p, i, j: Integer;
Const
  width = 8;
  height = 8;
Begin
  For i := 0 To height - 1 Do
    Begin
      For j := 0 To width - 1 Do
        Begin
          p := i * width + j;
          t[0][p, 0] := $FF;
          t[0][p, 1] := 0;
          If tex[0][i, j] = 0 Then
            t[0][p, 2] := $FF
          Else
            t[0][p, 2] := 0;
          t[1][p, 0] := $FF;
          t[1][p, 1] := $FF;
          If tex[1][i, j] = 0 Then
            t[1][p, 2] := $FF
          Else
            t[1][p, 2] := 0;
        End;
    End;
End;

Procedure SetDCPixelFormat(Handle: HDC);
Var
  pfd: TPixelFormatDescriptor;
  nPixelFormat: Integer;
Begin
  FillChar(pfd, SizeOf(pfd), 0);
  With pfd Do
    Begin
      nSize := sizeof(pfd); // Size of this structure
      nVersion := 1; // Version number
      dwFlags := PFD_DRAW_TO_WINDOW Or PFD_SUPPORT_OPENGL Or PFD_DOUBLEBUFFER;
        // Flags
      iPixelType := PFD_TYPE_RGBA; // RGBA pixel values
      cColorBits := 24; // 24-bit color
      cDepthBits := 32; // 32-bit depth buffer
      iLayerType := PFD_MAIN_PLANE; // Layer type
    End;
  nPixelFormat := ChoosePixelFormat(Handle, @pfd);
  SetPixelFormat(Handle, nPixelFormat, @pfd);
End;

Procedure TfrmCube.DrawScene;
Begin
  glNewList(11, GL_COMPILE);
  glBegin(GL_QUADS);
  glTexCoord2f(0.0, 0.0);
  glVertex2f(-1, 1);
  glTexCoord2f(1.0, 0.0);
  glVertex2f(1, 1);
  glTexCoord2f(1.0, 1.0);
  glVertex2f(1, -1);
  glTexCoord2f(0.0, 1.0);
  glVertex2f(-1, -1);
  glEnd;
  glEndList;

  glEnable(GL_DEPTH_TEST);
  glClear(GL_COLOR_BUFFER_BIT Or GL_DEPTH_BUFFER_BIT);
  glMatrixMode(GL_MODELVIEW);
  glDepthFunc(GL_LEQUAL);

  glLoadIdentity;

  glEnable(GL_TEXTURE_2D);
  glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
  glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

  glTranslatef(0, 0, Distanz);
  glRotatef(winkel1, 1, 0, 0);
  glRotatef(winkel2, 0, 1, 0);
  glRotatef(winkel3, 0, 0, 1);

  glTranslatef(0, 0, 1.0);
  glTexImage2D(GL_TEXTURE_2D, 0, 3, 8, 8, 0, GL_RGB, GL_UNSIGNED_BYTE, @t[0]);
  glCallList(11);
  glTranslatef(0, 0, -2.0);
  glTexImage2D(GL_TEXTURE_2D, 0, 3, 8, 8, 0, GL_RGB, GL_UNSIGNED_BYTE, @t[1]);
  glCallList(11);

  SwapBuffers(DC);
End;

Procedure TfrmCube.FormCreate(Sender: TObject);
Begin
  DC := GetDC(Handle);
  Randomize;
  SetDCPixelFormat(Canvas.Handle);
  hrc := wglCreateContext(Canvas.Handle);
  Winkel1 := 30;
  Winkel2 := 30;
  Winkel3 := 30;
  Distanz := -10;
  Init_Texturen;
End;

Procedure TfrmCube.FormResize(Sender: TObject);
Begin
  wglMakeCurrent(DC, hrc);
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity;
  gluPerspective(30.0, Width / Height, 1.0, 50.0);
  glViewport(0, 0, Width, Height);
  wglMakeCurrent(0, 0);
  Invalidate;
End;

Procedure TfrmCube.FormPaint(Sender: TObject);
Begin
  wglMakeCurrent(DC, hrc);
  DrawScene;
  wglMakeCurrent(0, 0);
End;

Procedure TfrmCube.FormDestroy(Sender: TObject);
Begin
  wglDeleteContext(hrc);
  ReleaseDC(Handle, DC);
End;

End.

