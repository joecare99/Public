unit fra_MeldeEintraege;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, StdCtrls, ComCtrls, Grids,
  Int_NeedsStatusbar,cla_DomFrame;

type

  { TFraMeldeEintraege }
  TFraMeldeEintraege = class(TDomFrame,iNeedsStatusbar)
    Label1: TLabel;
    StringGrid1: TStringGrid;
    TreeView1: TTreeView;
    procedure FrameEnter(Sender: TObject);
    procedure StringGrid1SelectCell(Sender: TObject; aCol, aRow: Integer;
      var CanSelect: Boolean);
  private
    { private declarations }
     FStatusBar: TStatusBar;
    function GetStatusBar: TStatusbar;
    procedure SetStatusBar(AValue: TStatusbar);
  public
    { public declarations }
  end;

implementation

{$R *.lfm}

{ TFraMeldeEintraege }

procedure TFraMeldeEintraege.StringGrid1SelectCell(Sender: TObject; aCol,
  aRow: Integer; var CanSelect: Boolean);
begin
  if assigned(FStatusbar) then
    FStatusbar.SimpleText := format('(%d,%d) %s',[acol,arow,sender.ClassName]);
end;

procedure TFraMeldeEintraege.FrameEnter(Sender: TObject);
begin
  if assigned(FStatusbar) then
    FStatusBar.SimplePanel:=true;
end;

function TFraMeldeEintraege.GetStatusBar: TStatusbar;
begin
  result := FStatusBar
end;

procedure TFraMeldeEintraege.SetStatusBar(AValue: TStatusbar);

begin
  FStatusBar := AValue;
end;

end.

