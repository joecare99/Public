unit fra_Citations;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Menus, Grids, StdCtrls,
  ExtCtrls, ActnList;

type

  { TfraEdtCitations }

  TfraEdtCitations = class(TFrame)
    actEdtCitationAdd: TAction;
    actEdtCitationEdit: TAction;
    actEdtCitationDelete: TAction;
    ActionList1: TActionList;
    mniCitationAdd: TMenuItem;
    lblCitations: TLabel;
    mniCitationEdit: TMenuItem;
    pnlCitationLeft: TPanel;
    PopupMenu2: TPopupMenu;
    mniCitationDelete: TMenuItem;
    TableauCitations: TStringGrid;
    procedure actEdtCitationAddExecute(Sender: TObject);
    procedure FrameResize(Sender: TObject);
    procedure mniCitationAddClick(Sender: TObject);
    procedure mniCitationDeleteClick(Sender: TObject);
    procedure mniCitationEditClick(Sender: TObject);
  private
    { private declarations }
    FOnSaveData:TNotifyEvent;
    FCType:String;
    FLinkID:integer;
    procedure FillCitationTable;
    procedure SetCType(AValue: String);
    procedure SetLinkID(AValue: integer);
    procedure SetOnSaveData(AValue: TNotifyEvent);
  public
    { public declarations }
    Procedure Clear;
    Property OnSaveData:TNotifyEvent read FOnSaveData write SetOnSaveData;
    Property CType:String read FCType write SetCType;
    Property LinkID:integer read FLinkID write SetLinkID;
  end;

implementation

{$R *.lfm}

uses cls_Translation,frm_EditCitations,dm_GenData,dialogs;

{ TfraEdtCitations }

procedure TfraEdtCitations.FrameResize(Sender: TObject);
begin
   TableauCitations.Cells[1,0]:=Translation.Items[138];
  TableauCitations.Cells[2,0]:=Translation.Items[155];
  TableauCitations.Cells[3,0]:=Translation.Items[177];
end;

procedure TfraEdtCitations.actEdtCitationAddExecute(Sender: TObject);
begin

end;

procedure TfraEdtCitations.mniCitationAddClick(Sender: TObject);
begin
    if assigned(FOnSaveData) and (FLinkID=0) then
      FOnSaveData(sender);

    if FLinkID=0 then exit;
    EditCitations.TypeCode:=FCType;
    EditCitations.idLink:=FLinkID;
    EditCitations.EditType:=eCET_New;
    if EditCitations.Showmodal = mrOk then
      FillCitationTable;
end;

procedure TfraEdtCitations.mniCitationDeleteClick(Sender: TObject);
var
  lidCitation: Integer;
begin
  if TableauCitations.Row > 0 then
    if MessageDlg(SConfirmation,format(SAreYouSureToDelX,[SCitation,TableauCitations.Cells[1, TableauCitations.Row]]),mtConfirmation,mbYesNo,0)=mrYes then
    begin
      lidCitation:=ptrint(TableauCitations.Objects[0, TableauCitations.Row]);
      dmGenData.DeleteCitation(lidCitation);
      TableauCitations.DeleteRow(TableauCitations.Row);
    end;
end;

procedure TfraEdtCitations.mniCitationEditClick(Sender: TObject);
begin
    if TableauCitations.Row > 0 then
  begin
    EditCitations.TypeCode:=FCType;
    EditCitations.idlink:=FLinkID;
    EditCitations.idCitation:=ptrint(TableauCitations.Objects[0, TableauCitations.Row]);
    EditCitations.EditType:=eCET_EditExisting;
    if EditCitations.Showmodal = mrOk then
      FillCitationTable;
  end;
end;

procedure TfraEdtCitations.SetOnSaveData(AValue: TNotifyEvent);
begin
  if FOnSaveData=AValue then Exit;
  FOnSaveData:=AValue;
end;

procedure TfraEdtCitations.Clear;
begin
  TableauCitations.RowCount:=1;
  TableauCitations.Cells[1,0]:=Translation.Items[138];
  TableauCitations.Cells[2,0]:=Translation.Items[155];
  TableauCitations.Cells[3,0]:=Translation.Items[177];

end;

procedure TfraEdtCitations.SetCType(AValue: String);
begin
  if FCType=AValue then Exit;
  FCType:=AValue;
  if (FCType<>'') and (FLinkID>0) then
    FillCitationTable;
end;

procedure TfraEdtCitations.FillCitationTable;
begin
  dmGenData.PopulateCitations(TableauCitations, FCType, FLinkID);
end;

procedure TfraEdtCitations.SetLinkID(AValue: integer);
begin
  if FLinkID=AValue then Exit;
  FLinkID:=AValue;
  if (FCType<>'') and (FLinkID>0) then
    FillCitationTable;
end;

end.

