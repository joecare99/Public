unit Frm_TestBWBitmap;

{$IFDEF FPC}
{$mode objfpc}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Label1: TLabel;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
    FBitmap:TBitmap;
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

uses LCLType,LCLIntf;
{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var   loc_BMP: HBITMAP;{<<---Added line}
begin
  FBitmap:= TBitmap.Create;
  FBitmap.Height:= 60;
  FBitmap.width := 60;
{ IO:
  FBitmap.PixelFormat:=pf15bit;  }
{ IO:
  FBitmap.PixelFormat:=pf4bit;  }
{ NIO:
  FBitmap.PixelFormat:=pf1bit;  }
  FBitmap.PixelFormat:=pf1bit;
  {$IFDEF UNIX}
  loc_BMP := CreateCompatibleBitmap(GetDC(GetForegroundWindow), FBitmap.Width,FBitmap.Height); {<<---Added line}
  FBitmap.Handle:=loc_BMP;{<<---Added line}
  {$ENDIF}
(*
The program 'PrjTestBWBitmap' received an X Window System error.
This probably reflects a bug in the program.
The error was 'BadMatch (invalid parameter attributes)'.
  (Details: serial 927 error_code 8 request_code 62 minor_code 0)
  (Note to programmers: normally, X errors are reported asynchronously;
   that is, you will receive the error a while after causing it.
   To debug your program, run it with the --sync command line
   option to change this behavior. You can then get a meaningful
   backtrace from your debugger if you break on the gdk_x_error() function.)
*)
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FBitmap.Free;
end;

procedure TForm1.FormPaint(Sender: TObject);
begin
  try
    Canvas.Draw(0,0,FBitmap);
    label1.Caption:='OK';
  except
    label1.Caption:='Error';
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  i: Integer;
begin
  FBitmap.Canvas.Brush.Color := clblack;
  FBitmap.Canvas.FillRect(FBitmap.Canvas.ClipRect);
  FBitmap.Canvas.Pen.Color:=clwhite;
  for i := 0 to 15 do
    FBitmap.Canvas.LineTo(random(30)+i*2,random(30)+i*2);
  Invalidate;
end;

end.

