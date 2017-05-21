unit frm_ViewDetails;

{$mode delphi}{$H+}
//{$interfaces COM}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  ExtCtrls, StdCtrls, fra_FormDesigner, Int_NeedsStatusbar, DOM, cla_DomFrame;

type

  { TfrmViewDetails }
  TFrameClass=Class of TDomFrame;

  TfrmViewDetails = class(TForm,iNeedsStatusbar)
    Label1: TLabel;
    PageControl1: TPageControl;
    Panel1: TPanel;
    ScrollBox1: TScrollBox;
    procedure PageControl1Change(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject; var AllowChange: Boolean);
  private
    FStatusBar: TStatusBar;
    procedure SetStatusBar(AValue: TStatusBar);
    function GetStatusBar: TStatusbar;
    { private declarations }
  public
    { public declarations }
    Procedure Display(LFrameclass:TFrameClass;DataAnchor: TDOMElement );
    property StatusBar:TStatusBar read FStatusBar write SetStatusBar;
  end;

var
  frmViewDetails: TfrmViewDetails;

implementation

{$R *.lfm}

{ TfrmViewDetails }

procedure TfrmViewDetails.PageControl1Change(Sender: TObject);
begin
  if (PageControl1.ActivePage.ControlCount>0) and
     PageControl1.ActivePage.Controls[0].InheritsFrom(TFrame) then
       if Assigned(Tframe(PageControl1.ActivePage.Controls[0]).OnEnter) then
         Tframe(PageControl1.ActivePage.Controls[0]).OnEnter(sender);
end;

procedure TfrmViewDetails.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin

end;

procedure TfrmViewDetails.SetStatusBar(AValue: TStatusBar);
var
  i: Integer;
begin
  if FStatusBar=AValue then Exit;
  FStatusBar:=AValue;
  for i := 0 to PageControl1.PageCount -1  do
      if (PageControl1.Pages[i].ControlCount>0) and
        (PageControl1.Pages[i].Controls[0] is iNeedsStatusbar) then
        (PageControl1.Pages[i].Controls[0] as iNeedsStatusbar).StatusBar := AValue;
end;

function TfrmViewDetails.GetStatusBar: TStatusbar;
begin
  result := FStatusBar;
end;

procedure TfrmViewDetails.Display(LFrameclass: TFrameClass;
  DataAnchor: TDOMElement);
var
  i: Integer;
  lFound: Boolean;
  lFrame: TFrame;
  tint :iNeedsStatusbar;
begin
  // Suche Detailbereich nach Angegebener LFrameclass;
  lFound:=false;
  for i := 0 to PageControl1.PageCount -1  do
    begin
      if (PageControl1.Pages[i].ControlCount>0) and
        (PageControl1.Pages[i].Controls[0].InheritsFrom(LFrameclass)) then
        begin
          PageControl1.ActivePageIndex:=i;
          lFound := true;
          break;
        end;
    end;
  if not lFound then
    with PageControl1.AddTabSheet do
     begin
       Caption:=LFrameclass.ClassName;
       PageControl1.ActivePageIndex := PageControl1.PageCount-1;
       lFrame:= LFrameclass.Create(self);
       lframe.Parent := PageControl1.ActivePage as TWinControl;
       lframe.Align:=alClient;
       if lframe is iNeedsStatusbar then
         (lframe as iNeedsStatusbar).Statusbar := FStatusBar;
    end;
end;

end.

