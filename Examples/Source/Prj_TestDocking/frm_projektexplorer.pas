unit frm_ProjektExplorer;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, Menus, DOM;

type
  { TfrmProjectExplorer }

  TfrmProjectExplorer = class(TForm)
    MenuItem1: TMenuItem;
    PopupMenu1: TPopupMenu;
    TreeView1: TTreeView;
    procedure FormCreate(Sender: TObject);
    procedure lbl_TitleClick(Sender: TObject);
    procedure TreeView1Click(Sender: TObject);
  private
    FProject: TDOMElement;
    FBilderNode,
    FMeldeNode:  TDOMElement;
    procedure SetProject(AValue: TDOMElement);
    { private declarations }
  public
    { public declarations }
    property Project:TDOMElement read FProject write SetProject;
  end;

var
  frmProjectExplorer: TfrmProjectExplorer;

implementation

uses frm_ViewDetails,fra_FormDesigner,fra_MeldeEintraege;
{$R *.lfm}

type
  TBildIndex = (
    biBilder = 0,
    biKommunikation = 1,
    biMeldeEintraege = 16);


{ TfrmProjectExplorer }

procedure TfrmProjectExplorer.lbl_TitleClick(Sender: TObject);
begin

end;

procedure TfrmProjectExplorer.TreeView1Click(Sender: TObject);
begin
  // beim Click auf einen Eintrag, Aktiviere zugehörigen Eintrag in Details, oder erstelle
  // neuen Reiter.
  case TBildIndex(TreeView1.Selected.ImageIndex) of
     biBilder:
       begin
         frmViewDetails.display(TFraFormDesigner,FBilderNode);
       end;
     biMeldeEintraege:
       begin
         frmViewDetails.display(TfraMeldeEintraege,FMeldeNode);
       end;
     biKommunikation:
       begin
//         frmViewDetails.display(TfraKommunikation,FKommunicationNode);
       end;

  end;
end;

procedure TfrmProjectExplorer.SetProject(AValue: TDOMElement);
begin
  if FProject=AValue then Exit;
  FProject:=AValue;

end;

procedure TfrmProjectExplorer.FormCreate(Sender: TObject);
begin

end;

end.

