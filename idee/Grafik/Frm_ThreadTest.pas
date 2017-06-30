Unit Frm_ThreadTest;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, OpenGL;

Type
  TForm1 = Class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Procedure Button1Click(Sender: TObject);
    Procedure FormCreate(Sender: TObject);
    Procedure FormDestroy(Sender: TObject);
    Procedure Button2Click(Sender: TObject);
    Procedure Button3Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    hrc1, hrc2, hrc3: HGLRC;
    dc1, dc2, dc3: hdc;
    Procedure SetDCPixelFormat(Handle: HDC);
  public
  End;

Type
  TFillMemoDemo = Class(TThread)
  private
    Fwinkel: Single;
    Fdc: hdc;
    Fhrc: HGLRC;
    FData: String;
    FDelay: integer;
    Procedure DrawScene;
  protected
    Procedure Execute; override;
    Procedure FillMemo;
  public
    Constructor Create(
      Const pdc: hdc;
      Const phrc: HGLRC;
      Const p_iDelay: integer);
  End;

Var
  Form1: TForm1;
  MyThread1, MyThread2, MyThread3: TFillMemoDemo;

Implementation

{$R *.dfm}

Procedure TForm1.SetDCPixelFormat(Handle: HDC);
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

Constructor TFillMemoDemo.Create;
Begin
  Inherited Create(False);
  Fwinkel := 0;
  Fdc := pdc;
  Fhrc := Phrc;
  FDelay := p_iDelay;
  FreeOnTerminate := true;
  Priority := tpNormal;
End;

Procedure TFillMemoDemo.DrawScene;
Var

  Ps: TPaintStruct;
  I:integer;
Begin
 // beginpaint(Fdc,ps);
  glLoadIdentity;
  glClear(GL_COLOR_BUFFER_BIT Or GL_DEPTH_BUFFER_BIT);
  for I := 0 to 1000 - 1 do
                begin
  glRotatef(Fwinkel, 0, 0, 1);
  glBegin(GL_TRIANGLES);
  glColor3f(1.0, 0, 0);
  glVerTex2f(-0.866*0.8, -0.4);
  glColor3f(0, 1.0, 0);
  glVerTex2f(0.866*0.8, -0.4);
  glColor3f(0, 0, 1.0);
  glVerTex2f(-0, 0.8);
  glEnd;
                end;
  SwapBuffers(fDC);
End;

Procedure TFillMemoDemo.FillMemo;
Begin
  FWinkel := FWinkel + 0.005;
  If FWinkel >= 360 Then
    FWinkel := 0;
  wglMakeCurrent(fdc, fhrc);
  DrawScene;
  wglMakeCurrent(0, 0);
End;

Procedure TFillMemoDemo.Execute;
Begin
  While Not Terminated Do
    Begin
//      Synchronize(
      FillMemo
//      )
      ;
      Sleep(FDelay);
    End;
End;

Procedure TForm1.Button1Click(Sender: TObject);
Begin
  If Button1.Caption = 'Stop' Then
    Begin
      MyThread1.Terminate;
      Button1.Caption := 'Start';
    End
  Else
    Begin
      MyThread1 := TFillMemoDemo.Create(dc1, hrc1, 1);
      Button1.Caption := 'Stop';
    End;
End;

Procedure TForm1.Button2Click(Sender: TObject);
Begin
  If Button2.Caption = 'Stop' Then
    Begin
      MyThread2.Terminate;
      Button2.Caption := 'Start';
    End
  Else
    Begin
      MyThread2 := TFillMemoDemo.Create(dc2, hrc2, 1);
      Button2.Caption := 'Stop';
    End;
End;

Procedure TForm1.Button3Click(Sender: TObject);
Begin
  If Button3.Caption = 'Stop' Then
    Begin
      MyThread3.Terminate;
      Button3.Caption := 'Start';
    End
  Else
    Begin
      MyThread3 := TFillMemoDemo.Create(dc3, hrc3, 1);
      Button3.Caption := 'Stop';
    End;
End;

Procedure TForm1.FormCreate(Sender: TObject);
var
  ldc: Hdc;
  lhrc: HglRc;
Begin
  Button1.Caption := 'Start';
  Button2.Caption := 'Start';
  Button3.Caption := 'Start';
  with panel1 do
    begin
  ldc := GetDC(Handle);
  SetDCPixelFormat(ldc);
  lhrc := wglCreateContext(ldc);
  wglMakeCurrent(ldc,lhrc);
  glViewport(0, 0, Width, Height); // Reset The Current Viewport And Perspective Transformation
//  glMatrixMode(GL_PROJECTION);
//  glLoadIdentity;
//  gluPerspective(30.0, Width / Height, 0.1, 100.0);
//  glMatrixMode(GL_MODELVIEW);
//  InvalidateRect(Handle, Nil, False); // Force window repaint
  wglMakeCurrent(0,0);
      dc1:=ldc;
      hrc1:=lhrc;

    end;

  with panel2 do
    begin
  ldc := GetDC(Handle);
  SetDCPixelFormat(ldc);
  lhrc := wglCreateContext(ldc);
//  wglMakeCurrent(ldc,lhrc);
//  glViewport(0, 0, Width, Height); // Reset The Current Viewport And Perspective Transformation
//  glMatrixMode(GL_PROJECTION);
//  glLoadIdentity;
//  gluPerspective(30.0, Width / Height, 0.1, 100.0);
//  glMatrixMode(GL_MODELVIEW);
//  InvalidateRect(Handle, Nil, False); // Force window repaint
      dc2:=ldc;
      hrc2:=lhrc;
    end;

  with panel3 do
    begin
  ldc := GetDC(Handle);
  SetDCPixelFormat(ldc);
  lhrc := wglCreateContext(ldc);
//  wglMakeCurrent(ldc,lhrc);
//  glViewport(0, 0, Width, Height); // Reset The Current Viewport And Perspective Transformation
//  glMatrixMode(GL_PROJECTION);
//  glLoadIdentity;
//  gluPerspective(30.0, Width / Height, 0.1, 100.0);
//  glMatrixMode(GL_MODELVIEW);
//  InvalidateRect(Handle, Nil, False); // Force window repaint
      dc3:=ldc;
      hrc3:=lhrc;
    end;


  End;

Procedure TForm1.FormDestroy(Sender: TObject);
Begin
  wglDeleteContext(hrc1);
  wglDeleteContext(hrc2);
  wglDeleteContext(hrc3);
End;

procedure TForm1.FormResize(Sender: TObject);
begin

  with panel1 do
    begin
    width:=form1.ClientWidth div 3;
  wglMakeCurrent(dc1,hrc1);
  glViewport(0, 0, Width, Height); // Reset The Current Viewport And Perspective Transformation
//  glMatrixMode(GL_PROJECTION);
//  glLoadIdentity;
//  gluPerspective(30.0, Width / Height, 0.1, 100.0);
//  glMatrixMode(GL_MODELVIEW);
//  InvalidateRect(Handle, Nil, False); // Force window repaint
  wglMakeCurrent(0,0);

    end;

  with panel3 do
    begin
        width:=form1.ClientWidth div 3;
  wglMakeCurrent(dc3,hrc3);
  glViewport(0, 0, Width, Height); // Reset The Current Viewport And Perspective Transformation
//  wglMakeCurrent(ldc,lhrc);
//  glViewport(0, 0, Width, Height); // Reset The Current Viewport And Perspective Transformation
//  glMatrixMode(GL_PROJECTION);
//  glLoadIdentity;
//  gluPerspective(30.0, Width / Height, 0.1, 100.0);
//  glMatrixMode(GL_MODELVIEW);
//  InvalidateRect(Handle, Nil, False); // Force window repaint
  wglMakeCurrent(0,0);
    end;

  with panel3 do
    begin
        width:=form1.ClientWidth div 3;
  wglMakeCurrent(dc2,hrc2);
  glViewport(0, 0, Width, Height); // Reset The Current Viewport And Perspective Transformation
//  wglMakeCurrent(ldc,lhrc);
//  glViewport(0, 0, Width, Height); // Reset The Current Viewport And Perspective Transformation
//  glMatrixMode(GL_PROJECTION);
//  glLoadIdentity;
//  gluPerspective(30.0, Width / Height, 0.1, 100.0);
//  glMatrixMode(GL_MODELVIEW);
//  InvalidateRect(Handle, Nil, False); // Force window repaint
  wglMakeCurrent(0,0);
    end;

end;

End.

