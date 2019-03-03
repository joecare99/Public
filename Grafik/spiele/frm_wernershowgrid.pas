unit Frm_WernerShowGrid;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, {$IFDEF FPC} FileUtil,{$ELSE}Types,{$ENDIF} Forms, Controls, Graphics, Dialogs, Grids,WernerEng,
  ImgList;

type

  { TFrmWernerShowGrid }

  TFrmWernerShowGrid = class(TForm)
    DrawGrid1: TDrawGrid;
    ImageList1: TImageList;

    procedure DrawGrid1DrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
  private
     FEdBild : TBildData;
    procedure SetBildData(AValue: TBildData);
    { private declarations }
  public
    { public declarations }
    property BildData :TBildData read FEdBild write SetBildData;
  end;

var
  FrmWernerShowGrid: TFrmWernerShowGrid;

implementation

{$ifdef FPC}
{$R *.lfm}
{$ELSE}
{$R *.dfm}
{$endIF}
{ TFrmWernerShowGrid }

procedure TFrmWernerShowGrid.DrawGrid1DrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
var
  lTile: Byte;
begin
   lTile := FEdBild[acol,arow];
   if lTile = 10 then ltile := 5;
   if lTile in [7,8,9] then ltile := 6;
  {$IFDEF FPC}
  ImageList1.StretchDraw(DrawGrid1.canvas,lTile,aRect);
  {$else}
  ImageList1.Draw(DrawGrid1.canvas,aRect.left,arect.top,lTile);
  {$ENDIF}
end;

procedure TFrmWernerShowGrid.SetBildData(AValue: TBildData);
begin
  FEdBild:=AValue;
  DrawGrid1.Invalidate;
end;

end.

