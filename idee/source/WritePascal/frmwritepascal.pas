unit FrmWritePascal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Buttons, ExtDlgs;

type

  { TForm1 }

  TForm1 = class(TForm)
    btnPrintString: TButton;
    Button2: TButton;
    Button3: TButton;
    Edit1: TEdit;
    FontDialog1: TFontDialog;
    Label1: TLabel;
    Memo1: TMemo;
    OpenPictureDialog1: TOpenPictureDialog;
    PaintBox1: TPaintBox;
    PaintBox2: TPaintBox;
    SavePictureDialog1: TSavePictureDialog;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    procedure btnPrintStringClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure PaintBox2Paint(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { private declarations }
    FOrgBitmap: TBitmap;
    FDestBitmap: TBitmap;
    procedure ShowBitmap;
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.btnPrintStringClick(Sender: TObject);
begin
  if FontDialog1.Execute then
  begin
    label1.Caption := FontDialog1.Font.ToString;
    ShowBitmap;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  X, Y: integer;
  s: string;
  YEnd: integer;
  YStart: integer;
  LWb: integer;
  LWw: integer;
  bCnt: integer;
  wCnt: integer;
  b: boolean;
  dd:TBytes;
  LWx: Integer;
  i: Integer;
  j: Integer;
  i64 :int64;
const
  c: array[boolean] of string = ('0', '1');

begin
  Memo1.Clear;
  YStart := -1;
  for Y := 0 to FOrgBitmap.Height div 2 do
  begin
    for X := 0 to FOrgBitmap.Width - 1 do
      if FOrgBitmap.canvas.Pixels[x, y] = clblack then
      begin
        YStart := Y;
        break;
      end;
    if YStart >= 0 then
      break;
  end;

  YEnd := -1;
  for Y := FOrgBitmap.Height - 1 downto FOrgBitmap.Height div 2 do
  begin
    for X := 0 to FOrgBitmap.Width - 1 do
      if FOrgBitmap.canvas.Pixels[x, y] = clblack then
      begin
        YEnd := Y;
        break;
      end;
    if YEnd >= 0 then
      break;
  end;

  (*Bin-Direct*)

  memo1.Append(IntToStr(FOrgBitmap.Width) + ',' + IntToStr(YEnd - YStart + 1));
  for X := 0 to FOrgBitmap.Width - 1 do
  begin
    s := '';
    for Y := YStart to YEnd do
       s := s + ',' + c[FOrgBitmap.canvas.Pixels[x, y] = clblack];
    memo1.Append(copy(s, 2, length(s)));

  end;

  memo1.Append('Uncompressed: ' + IntToStr((FOrgBitmap.Width * (YEnd - YStart + 1) + 7) div 8));

  //  bestimme maximale laufweite
  LWb := 0;
  LWw := 0;
  LWx := 0;
  wCnt := 0;
  bCnt := 0;
  i64 :=0;
  s := '';
  setlength(dd,2);
  b := FOrgBitmap.canvas.Pixels[0, YStart] = clblack;
  for X := 0 to FOrgBitmap.Width - 1 do
    for Y := YStart to YEnd do
      begin
      if b xor (FOrgBitmap.canvas.Pixels[x, y] = clblack) then
      begin
        case b of
          true: if bCnt-1 > LWb then
              LWb := bCnt-1;
          false: if bCnt-1 > LWw then
              LWW := bCnt-1;
        end;
        b := b xor True;
        setlength(dd,high(dd)+2);
        dd[high(Dd)]:=bCnt-1;
        s := s + ',' + IntToStr(bCnt-1);
        Inc(wCnt);
        bCnt := 1;
      end
      else
        Inc(bCnt);
       i64 := i64 or ((int64(b) and 1) shl ((x mod 16)*4+y-ystart));
      end;
  memo1.Append('Uncompr.Decimal: '+inttostr(i64));
  memo1.Append('Uncompr.Hex: '+inttohex(i64,16));

  setlength(dd,high(dd)+2);
  dd[high(Dd)]:=bCnt-1;
  dd[0] := lwb;
  dd[1] := lww;
  s := s + ',' + IntToStr(bCnt-1);
  memo1.Append(copy(s, 2, length(s)));
  memo1.Append('b:'+inttostr(LWb)+', w:'+inttostr(LWw)+', c:'+inttostr(wCnt));
  j:=1;
  LWx := 0;
  for i := 2 to high(Dd) do
    if (i<high(Dd))
     and (dd[i]=0)
     and ((lwx>0)
       or (dd[i+1]=0)) then
      inc(LWx)
    else
      begin
        inc(j);
        if lwx<> 0 then
           begin
             dd[j]:=lwx+lwb;
             inc(j);
             lwx:=0;
           end;
        dd[j]:=dd[i];
      end;
  setlength(dd,j+1);
  s := inttostr(dd[0]);
  for i := 1 to high(Dd) do
    s := s + ',' + IntToStr(dd[i]);
  memo1.Append(s);
  memo1.Append('cc:'+inttostr(high(Dd)+1));

end;

procedure TForm1.Button3Click(Sender: TObject);
var
  i64: Int64;
  x: Integer;
  y: Integer;
begin
  FDestBitmap.PixelFormat := pf1bit;
  FDestBitmap.Width := 17;
  FDestBitmap.Height := 4;

  i64 := 1055120232691680095;
  for x := 0 to FOrgBitmap.Width-1 do
    for y := 0 to FOrgBitmap.Height-1 do
      if ((i64 shr ((x mod 16)*4+y)) and 1)=0 then
        FDestBitmap.canvas.Pixels[x,y]:=clWhite;
  PaintBox2.Invalidate;
end;

procedure TForm1.Edit1Change(Sender: TObject);
begin
  ShowBitmap;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FOrgBitmap := TBitmap.Create;
  FDestBitmap := TBitmap.Create;
end;

procedure TForm1.FormDestroy(Sender: TObject);

begin
  FreeAndNil(FOrgBitmap);
  FreeAndNil(FDestBitmap);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  ShowBitmap;
end;

procedure TForm1.PaintBox1Paint(Sender: TObject);
begin
  PaintBox1.Canvas.Draw(0, 0, FOrgBitmap);
end;

procedure TForm1.PaintBox2Paint(Sender: TObject);
begin
  PaintBox2.Canvas.Draw(0, 0, FdestBitmap);
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  if SavePictureDialog1.Execute then
    FOrgBitmap.SaveToFile(SavePictureDialog1.FileName);
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
  if OpenPictureDialog1.Execute then
    begin
      FOrgBitmap.LoadFromFile(OpenPictureDialog1.FileName);
      PaintBox1.Invalidate;
    end;
end;

procedure TForm1.ShowBitmap;
begin
  FOrgBitmap.PixelFormat := pf1bit;
  FOrgBitmap.Canvas.Font := FontDialog1.Font;
  FOrgBitmap.Width := FOrgBitmap.Canvas.TextWidth(edit1.Text) - 1;
  FOrgBitmap.Height := FOrgBitmap.Canvas.TextHeight(edit1.Text) - 1;
  FOrgBitmap.Canvas.TextOut(-1, -1, edit1.Text);
  PaintBox1.Invalidate;
end;

end.
