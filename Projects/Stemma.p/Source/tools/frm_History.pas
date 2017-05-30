unit frm_History;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ActnList, Menus, ComCtrls;

type

  { TfrmHistory }

  TfrmHistory = class(TForm)
    actHistoryGoto: TAction;
    actHistoryClose: TAction;
    alsHistory: TActionList;
    lstHistory: TListBox;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    PopupMenu1: TPopupMenu;
    tlbHistory: TToolBar;
    btnHistoryClose: TToolButton;
    btnHistorySep1: TToolButton;
    btnHistoryGoto: TToolButton;
    procedure actHistoryCloseExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var {%H-}CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure actHistoryGotoExecute(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure lstHistoryResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lstHistoryClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  frmHistory: TfrmHistory;

implementation

uses
  frm_Main,cls_Translation, dm_GenData,FMUtils;

procedure FillListHistory(const lHList: TListBox);
var
  i: integer;
  lId: PtrInt;
  lName: String;
begin
  lHList.Clear;
  for i:=0 to frmStemmaMainForm.OldIndividu.Items.Count-1 do
    begin
      lId := Ptrint(frmStemmaMainForm.OldIndividu.Items.Objects[i]);
      lName := DecodeName(dmGenData.GetIndividuumName(lId),1);
      lHList.Items.AddObject(
         Format('%d. %s [%d]',[i+1,lName,lId]),
           TObject(PtrInt(lID)));

    end;
end;

{$R *.lfm}

{ TfrmHistory }

procedure TfrmHistory.lstHistoryResize(Sender: TObject);
begin
  // Nothing to do here
end;

procedure TfrmHistory.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  dmGenData.WriteCfgFormPosition(Sender as TForm);
end;

procedure TfrmHistory.actHistoryCloseExecute(Sender: TObject);
begin
       frmHistory.Close;
      frmHistory.ModalResult:=mrAbort;
end;

procedure TfrmHistory.FormCreate(Sender: TObject);
begin

end;

procedure TfrmHistory.actHistoryGotoExecute(Sender: TObject);

begin
  frmStemmaMainForm.iID:=PtrInt(lstHistory.Items.Objects[lstHistory.ItemIndex]);
  frmHistory.Close;
  frmHistory.ModalResult:=mrOk;
end;

procedure TfrmHistory.FormKeyPress(Sender: TObject; var Key: char);
begin
   If (Key=chr(27)) then
      begin
      actHistoryClose.Execute;
      key := #0;
   end;
end;

procedure TfrmHistory.FormShow(Sender: TObject);
var
  lHList: TListBox;
begin
  Caption:=Translation.Items[206];
  dmGenData.ReadCfgFormPosition(self,0,0,70,1000);
  lHList := lstHistory;
  FillListHistory(lHList);
end;

procedure TfrmHistory.lstHistoryClick(Sender: TObject);
begin

end;

end.

