unit frm_TestDrawControl;

{$mode delphi}

interface

uses
    Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
    Buttons, Spin, StdCtrls;

type

    { TfrmTestDrawControl }

    TfrmTestDrawControl = class(TForm)
        btnTestCharColFkt: TBitBtn;
        btnDrawTest1: TBitBtn;
        btnCancel: TBitBtn;
        btnClose: TBitBtn;
        btnDrawLogo: TBitBtn;
        btnDrawJC: TBitBtn;
        btnDrawPlasma: TBitBtn;
        btnNormalize2: TSpeedButton;
        btnNormalize3: TSpeedButton;
        btnNormalize4: TSpeedButton;
        Memo1: TMemo;
        PaintBox1: TPaintBox;
        pnlConfig: TPanel;
        pnlBottom: TPanel;
        btnNormalize1: TSpeedButton;
        SpeedButton2: TSpeedButton;
        SpinEdit1: TSpinEdit;
        SpinEdit10: TSpinEdit;
        SpinEdit11: TSpinEdit;
        SpinEdit12: TSpinEdit;
        SpinEdit13: TSpinEdit;
        SpinEdit14: TSpinEdit;
        SpinEdit15: TSpinEdit;
        SpinEdit16: TSpinEdit;
        SpinEdit2: TSpinEdit;
        SpinEdit3: TSpinEdit;
        SpinEdit4: TSpinEdit;
        SpinEdit5: TSpinEdit;
        SpinEdit6: TSpinEdit;
        SpinEdit7: TSpinEdit;
        SpinEdit8: TSpinEdit;
        SpinEdit9: TSpinEdit;
        procedure btnDrawPlasmaClick(Sender: TObject);
        procedure btnTestCharColFct(Sender: TObject);
        procedure btnDrawJCClick(Sender: TObject);
        procedure btnDrawLogoClick(Sender: TObject);
        procedure btnDrawTest1Click(Sender: TObject);
        procedure FormCreate(Sender: TObject);
        procedure btnNormalizeClick(Sender: TObject);
        procedure SpeedButton2Click(Sender: TObject);
        procedure SpinEdit1Change(Sender: TObject);
    private
      procedure FlushScreen(Sender: Tobject);

    public

    end;

var
    frmTestDrawControl: TfrmTestDrawControl;

implementation

uses unt_TestTCol01, paszlib;

{$R *.lfm}

{ TfrmTestDrawControl }

procedure TfrmTestDrawControl.btnDrawLogoClick(Sender: TObject);
begin
    Execute(btnDrawLogo.Glyph);
end;

procedure TfrmTestDrawControl.btnDrawTest1Click(Sender: TObject);
begin
    Execute(btnDrawTest1.Glyph);
end;

procedure TfrmTestDrawControl.FormCreate(Sender: TObject);
var
    K, V: PtrInt;
    i: integer;
    lsp: TComponent;
begin
    for i := 1 to 16 do
      begin
        lsp := FindComponent('SpinEdit' + IntToStr(i));
        if assigned(lsp) then
          begin
            K := TWinControl(lsp).Tag div 5 + 1;
            V := TWinControl(lsp).Tag mod 5 - 2;
            TSpinEdit(lsp).Value := CComp[K, V];
          end;
      end;
   onFlushScreen:=FlushScreen;
end;

procedure TfrmTestDrawControl.btnNormalizeClick(Sender: TObject);
var
  Line, K, V: PtrInt;
  Summ, i: Integer;
  lsp: TComponent;
begin
  Line := TWinControl(sender).tag;
  Summ := 0;
  for i := -2 to 2 do
    summ := summ + CComp[line,i];
  for i := -2 to 2 do
    begin
    CComp[line,i] := (CComp[line,i] *255) div summ;
    lsp := FindComponent('SpinEdit' + IntToStr(line*4+ ((i-2) *4) div 5));
    if assigned(lsp) then
      begin
        K := TWinControl(lsp).Tag div 5 + 1;
        V := TWinControl(lsp).Tag mod 5 - 2;
        TSpinEdit(lsp).Value := CComp[K, V];
      end;

    end;


end;

procedure TfrmTestDrawControl.SpeedButton2Click(Sender: TObject);
var
    K, J: integer;
    Line: string;
    ts: TMemoryStream;
    Buffer:array of byte;
    complen: Cardinal;
    bb:byte;
begin
    PaintBox1.Canvas.Brush.Style := bsSolid;
    memo1.Clear;
    for K := 0 to 49 do
      begin
        Line := BoolToStr(K = 0, '((', '(');
        for J := 0 to 79 do
          begin
            Line := line + '$' + IntTohex(chh[j, k], 4) + BoolToStr(J = 79, ')', ', ');
          end;
        memo1.Append(line + BoolToStr(K = 49, ');', ','));
      end;
    ts:=TMemoryStream.create;
    setlength(Buffer,sizeof(chh));
    compress(@Buffer[0],complen,@chh[0,0],SizeOf(chh));
    setlength(Buffer,complen);
    memo1.Append('Compr. length:'+inttostr(complen));
    ts.WriteWord(word(complen));
    ts.WriteBuffer(Buffer[0],complen);
    ts.Position:=0;
    line:=#9'(';
    while ts.Position<ts.Size do
      begin
        bb:=ts.ReadByte;
        line := line + '$'+inttohex(bb,2)+',';
        if ts.Position mod 16=0 then
          begin
            memo1.Append(line);
            line :=#9' ';
          end;
      end;
    delete(line,length(line),1);
    if length(line)>2 then
      memo1.Append(line+');');
    freeandnil(ts);
end;

procedure TfrmTestDrawControl.SpinEdit1Change(Sender: TObject);
var
    K, V: PtrInt;
begin
    K := TWinControl(Sender).Tag div 5 + 1;
    V := TWinControl(Sender).Tag mod 5 - 2;
    CComp[K, V] := TSpinEdit(Sender).Value;
end;

procedure TfrmTestDrawControl.FlushScreen(Sender: Tobject);
var
  K, J: Integer;
  bmp: TBitmap;
begin
    bmp:=TBitmap.Create;
    try
    bmp.Width:=79;
    bmp.Height:=99;
    for K := 0 to 49 do
        for J := 0 to 79 do
          with bmp.Canvas do
          begin
            pen.Color := istcol[J, k].c;
            line(J   , k * 2, J , k * 2 + 2);
          end;
     PaintBox1.Canvas.StretchDraw(rect(0,0,159,199),bmp);
    finally
      freeandnil(bmp);
    end;
    Application.ProcessMessages;
end;

procedure TfrmTestDrawControl.btnDrawJCClick(Sender: TObject);
begin
    Execute(btnDrawJC.Glyph);
end;

procedure TfrmTestDrawControl.btnTestCharColFct(Sender: TObject);
var
    I, J, K: integer;
    cc: TColorKmpn;
    Line: string;
begin
    PaintBox1.Canvas.Brush.Style := bsSolid;
    for I := 0 to 15 do
        for J := 0 to 15 do
            for K := 4 downto 1 do
              begin
                cc := CalcTPxColor(i, j, CComp[K, -2], CComp[K, -1], CComp[K, 2], CComp[K, 1]);
                PaintBox1.Canvas.Brush.Color := cc.c;
                PaintBox1.Canvas.FillRect(I * 5 + ((k - 1) mod 2) * 80, j * 5 + ((k - 1) div 2) * 80, I * 5 + ((k - 1) mod 2) * 80 + 5, j * 5 + ((k - 1) div 2) * 80 + 5);
              end;
    memo1.Clear;
    for K := 1 to 4 do
      begin
        Line := BoolToStr(K = 1, '((', '(');
        for J := -2 to 2 do
            Line := line + IntToStr(CComp[K, J]) + BoolToStr(J = 2, ')', ', ');
        memo1.Append(line + BoolToStr(K = 4, ');', ','));
      end;
end;

procedure TfrmTestDrawControl.btnDrawPlasmaClick(Sender: TObject);
begin
  Execute2(false);
end;

end.
