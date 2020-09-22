unit frm_laby4b;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

{ $define ShowLabyCreation}

interface

uses
{$IFnDEF FPC}
    Windows,
{$ELSE}
    LCLIntf, LCLType,
{$ENDIF}
    SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, ExtCtrls, Buttons, StdCtrls, Spin, PrintersDlgs, unt_Laby4;

type

    { TFrmLaby4 }

    TFrmLaby4 = class(TForm)
        btnPrint: TBitBtn;
        btnGenerate: TBitBtn;
        btnDraw: TBitBtn;
        lblLabySize: TLabel;
        pbxResult: TPaintBox;
        pbxPreview: TPaintBox;
        pnlRight: TPanel;
        pnlRightCl2: TPanel;
        PrintDialog1: TPrintDialog;
        edtLabySize: TSpinEdit;
        procedure btnGenerateClick(Sender: TObject);
        procedure btnDrawClick(Sender: TObject);
        procedure btnPrintClick(Sender: TObject);
        procedure FormCreate(Sender: TObject);
        procedure FormDestroy(Sender: TObject);
        procedure FormResize(Sender: TObject);
        procedure pbxPreviewPaint(Sender: TObject);
        procedure edtLabySizeChange(Sender: TObject);
    private
        FHLaby: THeightLaby;
        Clen :integer;
        FMargin: Integer;
        lastCell: TPoint;
        procedure Drawbox(Canvas: TCanvas; x, y, z: integer; DrawHead: boolean);
        procedure LabyUpdateCell(Sender: TObject; Cell: TPoint);
        procedure PaintField(x, y: integer; mark: boolean = False);
        procedure UpdateGField;
        { Private-Deklarationen }
    public
        { Public-Deklarationen }
    end;

var
    FrmLaby4: TFrmLaby4;



implementation

uses unt_Point2d, Printers;

{$IFnDEF FPC}
  {$R *.lfm}

{$ELSE}
  {$R *.lfm}
{$ENDIF}

const
    c:integer = 3;

procedure TFrmLaby4.PaintField(x, y: integer; mark: boolean = False);
var
    yy, xx: integer;
begin
    with pbxPreview do
      begin
        if mark then
            Canvas.Brush.Color :=
                rgb(63 + (FHLaby[x, y] * 192) div (Clen * 2 + 5),
                0 + (FHLaby[x, y] * 192) div (Clen * 2 + 5),
                (FHLaby[x, y] * 192) div (Clen * 2 + 5))
        else
            Canvas.Brush.Color :=
                rgb((FHLaby[x, y] * 196) div (Clen * 2 + 5),
                (FHLaby[x, y] * 196) div (Clen * 2 + 5),
                (FHLaby[x, y] * 255) div (Clen * 2 + 5));
        yy := clen - y - 1;
        xx := clen - x - 1;
        Canvas.FillRect(Rect(xx * c * 2, yy * c * 2, (xx + 1) *
            c * 2, (yy + 1) * c * 2));
        if (x >= 1) and (abs(FHLaby[x, y] - FHLaby[x - 1, y]) < 2) then
          begin
            Canvas.pen.Color := clwhite;
            Canvas.moveto(xx * c * 2 + c, yy * c * 2 + c);
            Canvas.Lineto(xx * c * 2 + c * 3, yy * c * 2 + c);

          end;
        if (y >= 1) and (abs(FHLaby[x, y] - FHLaby[x, y - 1]) < 2) then
          begin
            Canvas.pen.Color := clwhite;
            Canvas.moveto(xx * c * 2 + c, yy * c * 2 + c);
            Canvas.Lineto(xx * c * 2 + c, yy * c * 2 + c * 3);
          end;
      end;
end;

procedure TFrmLaby4.UpdateGField;
var
  y: integer;
  x: integer;
begin
  for x := 0 to FHLaby.Dimension.Width - 1 do
      for y := 0 to FHLaby.Dimension.Height - 1 do
          PaintField(x, y);
end;


procedure TFrmLaby4.btnGenerateClick(Sender: TObject);

begin
    pnlRight.Width := CLen * c * 2 + 2;
    pbxPreview.Width := CLen * c * 2;
    FHLaby.Dimension := rect(0, 0, Clen, Clen);
    pbxPreview.Height := CLen * c * 2;
    Application.ProcessMessages;
{$ifdef DEBUG}
   FHLaby.OnUpdateCell:=LabyUpdateCell;
{$endif }
    FHLaby.Generate;
    UpdateGField;
end;

procedure TFrmLaby4.Drawbox(Canvas: TCanvas; x, y, z: integer; DrawHead: boolean);
var
    x2, y2, L, H, s, s2, d: integer;
    pts: array of TPoint;

begin

    L := Canvas.ClipRect.Right div (Clen * 2);
    H := Canvas.ClipRect.Height div (Clen * 4 + FHLaby.Baselevel(Clen - 1, Clen - 1)+4);
    x2 := (Clen - x + y) * L;
    y2 := Canvas.ClipRect.bottom - (x * 2 + y * 2 + z + 2) * H;
    setlength(pts{%H-}, 4);
    pts[0] := point(x2, y2);

    if (x = 0) or (FHLaby[x - 1, y] < z) then
      begin
        // pbxResult.Canvas.pen.Color := pbxResult.Canvas.Brush.Color;
        pts[1] := point(x2 + L, y2 - H * 2);
        pts[2] := point(x2 + L, y2 - H);
        pts[3] := point(x2, y2 + H);
        Canvas.pen.Color := clBlack;
        Canvas.Brush.Color := clDkGray;
        Canvas.Polygon(pts);
      end;

    if (y = 0) or (FHLaby[x, y - 1] < z) then
      begin
        Canvas.Brush.Color := clLtGray;
        Canvas.pen.Color := clWhite;
        pts[1] := point(x2 - L, y2 - H * 2);
        pts[2] := point(x2 - L, y2 - H);
        pts[3] := point(x2, y2 + H);
        Canvas.Polygon(pts);

        if (x < clen - 1) and (y > 0) and (FHLaby[x + 1, y - 1] - z >= 0) then
          begin
            d := FHLaby[x + 1, y - 1];
            s := trunc((d - z) * L / 8);
            s2 := trunc((d - z + 1) * L / 8);
            if s2 <= L then
              begin
                pts[0] := point(x2 + s - L, y2 - H * 2 + trunc(s * H / L * 2));
                pts[3] := point(x2 + s2 - L, y2 - H * 1 + trunc(s2 * H / L * 2 + 0.5));
                Canvas.pen.Color := clDkGray;
                Canvas.Brush.Color := clDkGray;
                Canvas.Polygon(pts);
                Canvas.pen.Color := clBlack;
                Canvas.Line(pts[1], pts[2]);
                Canvas.Line(pts[2], pts[3]);
                pts[0] := point(x2, y2);
              end;
          end;
      end;
    // pbxResult.Canvas.PolyLine(pts);
    // pbxResult.Canvas.pen.Color := pbxResult.Canvas.Brush.Color;
    if DrawHead then
      begin
        pts[1] := point(x2 + L, y2 - H * 2);
        pts[2] := point(x2, y2 - H * 4);
        pts[3] := point(x2 - L, y2 - H * 2);
        Canvas.Brush.Color := clwhite;
        Canvas.pen.Color := clLtGray;
        Canvas.Polygon(pts);
        // pbxResult.Canvas.PolyLine(pts);
        if (x < clen - 1) and (FHLaby[x + 1, y] - z > 0) then
          begin
            s := trunc((FHLaby[x + 1, y] - z) * L / 8);
            pts[1] := point(x2 + s, y2 - H * 4 + trunc(s * H / L * 2));
            pts[0] := point(x2 + s - L, y2 - H * 2 + trunc(s * H / L * 2));
            Canvas.pen.Color := clltGray;
            Canvas.Brush.Color := clDkGray;
            Canvas.Polygon(pts);
          end;
      end;
end;

procedure TFrmLaby4.LabyUpdateCell(Sender: TObject; Cell: TPoint);
var
  i: Integer;
begin
  for i := 0 to 8 do
    if FHLaby.Dimension.Contains(lastcell.add(point(i mod 3,i div 3) )) then
        PaintField(lastcell.x+(i mod 3), lastcell.y+(i div 3),false);
  PaintField(cell.x, cell.y,true);
  lastCell := cell;
  Application.ProcessMessages;
  sleep(100);
end;

procedure TFrmLaby4.btnDrawClick(Sender: TObject);

var
    x, y, z: integer;

begin
    if FHLaby.Dimension.Width < Clen then
        btnGenerateClick(Sender);
    pbxResult.Canvas.Brush.Color := Color;
    pbxResult.Canvas.FillRect(pbxResult.Canvas.ClipRect);
    FMargin:=10;
    for z := 0 to (Clen * 2 + 4) do
        for x := Clen - 1 downto 0 do
            for y := Clen - 1 downto 0 do
                if (FHLaby[x, y] >= z) and ((x = 0) or (y = 0) or
                    (z > FHLaby.baselevel(x, y) - 6)) then
                    Drawbox(pbxResult.Canvas, x, y, z, FHLaby[x, y] = z);

end;

procedure TFrmLaby4.btnPrintClick(Sender: TObject);
var
    x, y, z: integer;
    cl: TRect;
    pr: TPaperRect;
begin
    if FHLaby.Dimension.Width < Clen then
        btnGenerateClick(Sender);
    if PrintDialog1.Execute then
      begin
        printer.Orientation := poLandscape;
        printer.Title := 'Laby #4 ' + DateToStr(now());
        Printer.BeginDoc;
        for z := 0 to (Clen * 2 + 4) do
            for x := Clen - 1 downto 0 do
                for y := Clen - 1 downto 0 do
                    if (FHLaby[x, y] >= z) and
                        ((x = 0) or (y = 0) or (z > FHLaby.baselevel(x, y) - 6)) then
                        Drawbox(printer.Canvas, x, y, z, FHLaby[x, y] = z);
        Printer.EndDoc;
      end;
end;

procedure TFrmLaby4.FormCreate(Sender: TObject);
begin
    FHLaby := THeightLaby.Create;
    Clen:=21;
end;

procedure TFrmLaby4.FormDestroy(Sender: TObject);
begin
    FreeAndNil(FHLaby);
end;

procedure TFrmLaby4.pbxPreviewPaint(Sender: TObject);
begin
  UpdateGField;
end;

procedure TFrmLaby4.edtLabySizeChange(Sender: TObject);
begin
  with sender as TSpinEdit do
    begin
       Clen := Value;
       c := 100 div clen +1
    end;
end;

end.
