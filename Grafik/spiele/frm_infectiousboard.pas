unit Frm_InfectiousBoard;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids,
  ComCtrls, Menus, StdCtrls,cls_InfectiousEng, Frm_Aboutbox;

type

  { TfrmInfectiousBoard }

  TfrmInfectiousBoard = class(TForm)
    AboutBox1: TAboutBox;
    btn_Comp1: TButton;
    btn_Comp3: TButton;
    btn_Comp4: TButton;
    btn_Comp5: TButton;
    btn_Comp6: TButton;
    Button2: TButton;
    btn_Comp2: TButton;
    DrawGrid1: TDrawGrid;
    ImageList1: TImageList;
    lbl_Version: TLabel;
    ListBox1: TListBox;
    MainMenu1: TMainMenu;
    StatusBar1: TStatusBar;
    ToolBar1: TToolBar;
    tlb_Blue: TToolButton;
    tlb_Green: TToolButton;
    tlb_Empty: TToolButton;
    procedure btn_Comp1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure DrawGrid1Click(Sender: TObject);
    procedure DrawGrid1DrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lbl_VersionClick(Sender: TObject);
    procedure SelectTile(Sender: TObject);
  private
    { private declarations }
    FGameEng :TInfectiousEng;
    Fmoves:array of TMoveValue;
    FSelectedTile: TGameTile;
    FGridData:array[0..6,0..6] of array of integer;
  public
    { public declarations }
  end;

var
  frmInfectiousBoard: TfrmInfectiousBoard;

implementation

{$IFDEF FPC}
{$R *.lfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}

uses unt_cdate;
{ TfrmInfectiousBoard }

procedure TfrmInfectiousBoard.FormCreate(Sender: TObject);
begin
  FGameEng:= TInfectiousEng.Create;
  lbl_Version.Caption:=format('Compiled: %s'+LineEnding+#9'on: %s',[adate,cname]);
end;

procedure TfrmInfectiousBoard.DrawGrid1DrawCell(Sender: TObject; aCol,
  aRow: Integer; aRect: TRect; aState: TGridDrawState);

var gt:TGameTile;
  blFlag: Boolean;
  grFlag: Boolean;
  Bluemax: Byte;
  Greenmax: Byte;
  Bluemin: Byte;
  Greenmin: Byte;
  i: Integer;
  morg: TSmallPoint;
  gmorg: TSmallPoint;

begin

  gt := FGameEng.PlayField[acol,arow];
  ImageList1.StretchDraw(DrawGrid1.Canvas,0,aRect);
  if ord(gt)>0 then
    ImageList1.StretchDraw(DrawGrid1.Canvas,ord(gt),aRect)
  else
    if high(FGridData[acol,arow]) >=0 then
    begin
      blFlag := false;
      grFlag := false;
      for i := 0 to high(FGridData[acol,arow]) do
        begin
        if  (Fmoves[FGridData[acol,arow][i]].gt = gt_blue) and
           (not blFlag or (bluemax-greenmax <Fmoves[FGridData[acol,arow][i]].Bluecount-Fmoves[FGridData[acol,arow][i]].greencount)) then
           begin
            Bluemax := Fmoves[FGridData[acol,arow][i]].Bluecount;
            Greenmax := Fmoves[FGridData[acol,arow][i]].GreenCount;
            morg :=          Fmoves[FGridData[acol,arow][i]].MoveOrg;
            blFlag:=true;
           end;
        if  (Fmoves[FGridData[acol,arow][i]].gt = gt_green) and
           (not grFlag or (bluemin-greenmin >Fmoves[FGridData[acol,arow][i]].Bluecount-Fmoves[FGridData[acol,arow][i]].greencount)) then
           begin
            Bluemin := Fmoves[FGridData[acol,arow][i]].Bluecount;
            Greenmin := Fmoves[FGridData[acol,arow][i]].GreenCount;
            gmorg :=          Fmoves[FGridData[acol,arow][i]].MoveOrg;
            grFlag:=true;
           end;

        end;

     DrawGrid1.Canvas.Font.Name:=lbl_Version.Font.Name;
     DrawGrid1.Canvas.Font.size:=6;
      if blFlag then
      begin
      DrawGrid1.Canvas.Font.Color:=clBlue+$8080;
      DrawGrid1.Canvas.TextOut(aRect.Left+2,arect.Top+2,inttostr( Bluemax-GreenMax));
      DrawGrid1.Canvas.TextOut(aRect.Left+2,arect.Top+14,inttostr(morg.x+1)+','+inttostr(morg.y+1));
      end;
      if grFlag then
      begin
      DrawGrid1.Canvas.Font.Color:=clLime;
      DrawGrid1.Canvas.TextOut(aRect.Left+14,arect.Top+2,inttostr( Greenmin-Bluemin));
      DrawGrid1.Canvas.TextOut(aRect.Left+14,arect.Top+14,inttostr(gmorg.x+1)+','+inttostr(gmorg.y+1));
      end;
    end;
end;

procedure TfrmInfectiousBoard.btn_Comp1Click(Sender: TObject);
var
  x: Integer;
  y: Integer;
  i: Integer;
  cd: Integer;
begin
  for x:= 0 to 6 do
    for y := 0 to 6 do
      setlength(FGridData[x,y],0);
  setlength(fMoves,0);
  ListBox1.Clear;
  Listbox1.AddItem('-',TObject(-1));
  cd :=5;
  if sender.InheritsFrom(TButton) then
    cd:= TButton(sender).tag;
  FGameEng.ComputePossibMoves(FGameEng.PlayField,Fmoves,cd,FSelectedTile);
  for i := 0 to high(Fmoves) do
    if Fmoves[i].didcalc then
    with Fmoves[i] do
    begin
      setlength(FGridData[nx,ny],high(FGridData[nx,ny])+2);
      FGridData[nx,ny,high(FGridData[nx,ny])]:=i;
      Listbox1.AddItem('('+inttostr(MoveOrg.X)+';'+inttostr(moveorg.y)+')->('
      +inttostr(nx)+';'+inttostr(ny)+'): '+inttostr(Bluecount-GreenCount),TObject(i));
    end;
  DrawGrid1.Invalidate;
end;

procedure TfrmInfectiousBoard.Button2Click(Sender: TObject);
begin
  FGameEng.Restart;
  DrawGrid1.Invalidate;
end;

procedure TfrmInfectiousBoard.DrawGrid1Click(Sender: TObject);
begin
  FGameEng.setFieldTile(DrawGrid1.Col,DrawGrid1.row,FSelectedTile);
end;

procedure TfrmInfectiousBoard.FormDestroy(Sender: TObject);
var
  x: Integer;
  y: Integer;
begin
   for x:= 0 to 6 do
    for y := 0 to 6 do
      setlength(FGridData[x,y],0);
   setlength(Fmoves,0);
  freeandnil(FGameEng);
end;

procedure TfrmInfectiousBoard.lbl_VersionClick(Sender: TObject);
begin
  AboutBox1.Show;
end;

procedure TfrmInfectiousBoard.SelectTile(Sender: TObject);

begin
  if Sender.InheritsFrom(TToolButton) then
    FSelectedTile := TGameTile(TToolButton(sender).ImageIndex);
end;

end.

