unit frm_laby4;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
    Windows,
{$ELSE}
    LCLIntf, LCLType,
{$ENDIF}
    SysUtils, Variants, Classes, Graphics, Controls, Forms,
    Dialogs, ExtCtrls, Buttons, StdCtrls;

type

    { TFrmLaby4 }

    TFrmLaby4 = class(TForm)
      btnGenerate: TBitBtn;
      btnDraw: TBitBtn;
        PaintBox1: TPaintBox;
        PaintBox2: TPaintBox;
        pnlRight: TPanel;
        pnlRightCl2: TPanel;
        procedure btnGenerateClick(Sender: TObject);
        procedure btnDrawClick(Sender: TObject);
    private
        FZValues: array of array of integer;
        { Private-Deklarationen }
    public
        { Public-Deklarationen }
    end;

var
    FrmLaby4: TFrmLaby4;


const     Clen = 61;

implementation

uses unt_Point2d;

{$IFnDEF FPC}
  {$R *.dfm}

{$ELSE}
  {$R *.lfm}
{$ENDIF}

Type TPosArray = array[0..3] of TPoint;

const //{-1}prest:String='010011020101111010020201031210000021010020013000111211112010';
      //{-2}prest:String='1011100100121100000101020001000012131121100020031100011110000000020';
      //{-2}prest:String='111102010111101001020301102100010001112201210011103101010010211112';
        {-2}prest:String='111102010111101001020301102100010001112201210011103101010010211112';
                                       //    102100010001112201
      //{-3}prest:String='01100020110100010100112100000012131011120100011003001111200101101211';
      sstr:string='';
      SPre=$123456789ABCDEFF;
      sInt1:QWord=$0;
      sInt2:QWord=$0;

function GetRndDir(cnt:Integer;PosibDir:TPosArray):TPoint;

var st:byte;

begin
    if length(sstr)=0 then
      exit(PosibDir[random(cnt)])
    else
      begin
        st := ord(sstr[1])-ord('0');
        delete(sstr,1,1);
      end;
    if (st<=cnt) then
      exit(PosibDir[st])
    else
      exit(PosibDir[random(cnt)])
end;

   function Baselevel(x,y:integer):integer;
  begin
    result := (x div 2)+(y div 2)+ 3
  end;


procedure TFrmLaby4.btnGenerateClick(Sender: TObject);

const c = 3 ;

    procedure PaintField(x,y:integer;mark:boolean=false);
    var
      yy, xx: Integer;
    begin
      if mark then
      PaintBox2.Canvas.Brush.Color :=
          rgb(63+(FZValues[x, y] * 192) div (Clen*2+5),
          0+(FZValues[x, y] * 192) div (Clen*2+5),
          (FZValues[x, y] * 192) div (Clen*2+5))
      else
      PaintBox2.Canvas.Brush.Color :=
          rgb((FZValues[x, y] * 196) div (Clen*2+5),
          (FZValues[x, y] * 196) div (Clen*2+5),
          (FZValues[x, y] * 255) div (Clen*2+5));
      yy := clen-y-1;
      xx := clen-x-1;
      PaintBox2.Canvas.FillRect(Rect(xx * c*2, yy * c*2, (xx + 1) *
          c*2, (yy + 1) * c*2));
      if (x >= 1) and (abs(FZValues[x, y] - FZValues[x - 1, y]) < 2) then
        begin
          PaintBox2.Canvas.pen.Color := clwhite;
          PaintBox2.Canvas.moveto(xx * c*2 + c, yy * c*2 + c);
          PaintBox2.Canvas.Lineto(xx * c*2 + c*3, yy * c*2 + c);

        end;
      if (y >= 1) and (abs(FZValues[x, y] - FZValues[x, y - 1]) < 2) then
        begin
          PaintBox2.Canvas.pen.Color := clwhite;
          PaintBox2.Canvas.moveto(xx * c*2 + c, yy * c*2 + c);
          PaintBox2.Canvas.Lineto(xx * c*2 + c, yy * c*2 + c*3);

        end;
    end;

var
    x, y, rr, DirCount,FifoPushIdx,FifoPopIdx, i: integer;
    ActCell ,Accu : T2DPoint;
    ActDir, StoredCell,t: T2DPoint;
    Fifo:array of TPoint;
    PosibDir:TPosArray;



begin
  sstr := prest;
    pnlRight.Width:=CLen*c*2+2;
    PaintBox2.Width:=CLen*c*2;

    PaintBox2.Height:=CLen*c*2;
    Application.ProcessMessages;
    Randomize;
    setlength(FZValues, Clen, Clen);
    // rohdaten -Init
    for x := 0 to Clen - 1 do
       for y := 0 to Clen - 1 do
          FZValues[x, y] := 0;
    // Laby-Algoritmus
    ActCell := Point2D(2,0);
    StoredCell := Point2D(ActCell.AsPoint);
    FZValues[ActCell.x,ActCell.y] :=
    Baselevel(ActCell.x,ActCell.y);
    FifoPushIdx:=0;
    FifoPopIdx:=0;
    Accu := T2DPoint.Create;
    SetLength(Fifo,Clen*Clen);
    Dircount := 1;
    while (DirCount <> 0) or (FifoPushIdx >= FifoPopIdx) do
      begin
        // Switch
        t:= ActCell;
        ActCell:=StoredCell;
        StoredCell := t;
    // Calculate Valid directions and store them in PosibDir
//    PaintField(actcell.x,actcell.y,true);
    Dircount := 0;
    for ActDir in dir4 do
       begin
         if dircount <=2 then
           PosibDir[DirCount+1] := Point(0,0);
         Accu.copy(ActDir).SMult(-2).add(ActCell);
         if Accu.IsIn(rect(0,0,Clen,clen)) and (FZValues[Accu.X,Accu.y] = 0) then
           begin
             PosibDir[DirCount]:=ActDir.asPoint;
             inc(Dircount);
           end;
       end;
    if Dircount >0 then
      begin
        ActDir := Accu.Copy(GetRndDir(Dircount,PosibDir));
      End;
    if (DirCount > 0) and (not ActDir.Equals(dir4[0])) then
      begin
//      ActDir := GetRndDir(Dircount,PosibDir);  // Calc Destination Cell
      if dircount>1 then
        begin
          Fifo[FifoPushIdx] := ActCell.AsPoint;
          inc(FifoPushIdx);
        end;
      ActCell.Subtr(ActDir);
      FZValues[ActCell.x,ActCell.y] := Baselevel(ActCell.x+1,ActCell.y);
      ActCell.Subtr(ActDir);
      FZValues[ActCell.x,ActCell.y] := Baselevel(ActCell.x,ActCell.y);
      // Push Cell to the Fifo
    end
    else
    begin
      // Pop Cell from the Fifo
      if FifoPushIdx >= FifoPopIdx then
        begin
         ActCell.copy(Fifo[FifoPopIdx]);
         inc(FifoPopIdx);
        end;
    end;
  (*  if (FifoPushIdx mod Clen =0) {or (length(sstr)>0)} then
      begin
    for x := 0 to Clen - 1 do
         for y := 0 to Clen - 1 do
           begin
             PaintField(x,y);
           end;
    Application.ProcessMessages;
    sleep(1);
       end; *)
      end;

    FreeAndNil(accu);
    Freeandnil(ActCell);
    FreeAndNil(StoredCell);
    SetLength(Fifo,0);

    // nicht besetzte Zellen
    for x := 0 to Clen - 1 do
       for y := 0 to Clen - 1 do
          if FZValues[x,y] = 0 then
            if (x=0) or (x=clen-1) or
               (y=0) or (y=clen-1) then
               FZValues[x,y]:= Baselevel(x,y)-2+((x+y)mod 2)
          else
            FZValues[x,y]:= Baselevel(x,y)-2+((x+y)mod 2);
    // nicht verbundene zellen
 (*   for x := 0 to Clen - 1 do
        for y := 0 to Clen - 1 do
          begin
            //    c := 0;
            if (x >= 1) and (abs(FZValues[x, y] - FZValues[x - 1, y]) < 2) and
                (x < Clen - 1) and (abs(FZValues[x, y] - FZValues[x + 1, y]) <
                2) and (y >= 1) and (abs(FZValues[x, y] - FZValues[x, y - 1]) < 2) and
                (y < Clen - 1) and (abs(FZValues[x, y] - FZValues[x, y]) < 2) then
              begin
                if abs(x - (Clen div 2)) > abs(y - (Clen div 2)) then
                    if x > Clen div 2 then
                        FZValues[x, y] := FZValues[x - 1, y] + 1
                    else
                        FZValues[x, y] := FZValues[x + 1, y] - 1
                else if y > Clen div 2 then
                    FZValues[x, y] := FZValues[x, y - 1] + 1
                else
                    FZValues[x, y] := FZValues[x, y + 1] - 1;

              end;

          end;
   *)
    for x := 0 to Clen - 1 do
        for y := 0 to Clen - 1 do
          begin
            PaintField(x,y);
          end;
end;

procedure TFrmLaby4.btnDrawClick(Sender: TObject);

    procedure Drawbox(x, y, z: integer; DrawHead: boolean);
    var
        x2, y2, L,H, s: integer;
        pts: array of TPoint;
    begin
        L := PaintBox1.Canvas.ClipRect.Right div (Clen*2);
        H := PaintBox1.Canvas.ClipRect.Height div (Clen*4+FZValues[Clen-1,Clen-1]);
        x2 := (Clen - x + y) * L;
        y2 := PaintBox1.Canvas.ClipRect.bottom - (x*2 + y*2 + z + 2) * H;
        setlength(pts, 4);
        pts[0] := point(x2, y2);

        // PaintBox1.Canvas.pen.Color := PaintBox1.Canvas.Brush.Color;
        pts[1] := point(x2 + L, y2 - H*2);
        pts[2] := point(x2 + L, y2-H);
        pts[3] := point(x2, y2 + H);
        PaintBox1.Canvas.pen.Color := clBlack;
        PaintBox1.Canvas.Brush.Color := clDkGray;
        PaintBox1.Canvas.Polygon(pts);

        PaintBox1.Canvas.Brush.Color := clLtGray;
        PaintBox1.Canvas.pen.Color := clWhite;
        pts[1] := point(x2 - L, y2 - H*2);
        pts[2] := point(x2 - L, y2-H);
        pts[3] := point(x2, y2 + H);
        PaintBox1.Canvas.Polygon(pts);
        // PaintBox1.Canvas.PolyLine(pts);
        // PaintBox1.Canvas.pen.Color := PaintBox1.Canvas.Brush.Color;
        if DrawHead then
          begin
            pts[1] := point(x2 + L, y2 - H*2);
            pts[2] := point(x2, y2 - H*4 );
            pts[3] := point(x2 - L, y2 - H*2);
            PaintBox1.Canvas.Brush.Color := clwhite;
            PaintBox1.Canvas.pen.Color := clLtGray;
            PaintBox1.Canvas.Polygon(pts);
            // PaintBox1.Canvas.PolyLine(pts);
            if (x <clen-1) and (FZValues[x+1,y]-z>0 ) then
              begin
                s := trunc((FZValues[x+1,y]-z)*L /8) ;
                pts[1] := point(x2+s, y2 - H*4 +trunc(s*H/L*2));
                pts[0] := point(x2+s - L, y2 - H*2+trunc(s*H/L*2));
                PaintBox1.Canvas.pen.Color := clLtGray;
                PaintBox1.Canvas.Brush.Color := clLtGray;
                PaintBox1.Canvas.Polygon(pts);
              end
          end;
    end;

var
    x, y, z: integer;

begin
    PaintBox1.Canvas.Brush.Color := Color;
    PaintBox1.Canvas.FillRect(PaintBox1.Canvas.ClipRect);
    if Length(FZValues) <Clen then
      btnGenerateClick(sender);
    for z := 0 to (Clen*2+4) do
        for x := Clen - 1 downto 0 do
            for y := Clen - 1 downto 0 do
                if (FZValues[x, y] >= z) and ((x = 0) or (y = 0) or
                    (z > baselevel(x , y) - 4)) then
                    Drawbox(x, y, z,FZValues[x, y] = z);

end;

end.
