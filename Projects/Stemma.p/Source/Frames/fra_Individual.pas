unit fra_Individual;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, StdCtrls, Spin, ExtCtrls, Menus,
  ActnList;

type

  { TfraIndividualwithRole }

  TfraIndividualwithRole = class(TFrame)
    actIndividualSelect: TAction;
    actIndividualEdit: TAction;
    actIndividualUnlink: TAction;
    actIndividualNew: TAction;
    alsIndividual: TActionList;
    edtIndividId: TSpinEdit;
    cbxIndividName: TComboBox;
    lblIndividRole: TLabel;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    pnlLeft: TPanel;
    mnuIndividual: TPopupMenu;
    procedure edtIndividIdEditingDone(Sender: TObject);
  private
    function GetIdInd: integer;
    function GetIndName: TCaption;
    function GetRole: TCaption;
    procedure SetIdInd(AValue: integer);
    procedure SetIndName(AValue: TCaption);
    procedure SetRole(AValue: TCaption);

  public
    Property Role:TCaption Read GetRole write SetRole;
    Property idInd:integer read GetIdInd write SetIdInd;
    Property IndName:TCaption read GetIndName write SetIndName;
  end;

implementation

{$R *.lfm}

uses dm_GenData,FMUtils;
{ TfraIndividualwithRole }

procedure TfraIndividualwithRole.edtIndividIdEditingDone(Sender: TObject);

begin
   cbxIndividName.Text:=
     DecodeName(dmGenData.GetIndividuumName(edtIndividId.Value),1);
end;

function TfraIndividualwithRole.GetIdInd: integer;
begin
  result := edtIndividId.Value;
end;

function TfraIndividualwithRole.GetIndName: TCaption;
begin
  result := cbxIndividName.Text;
end;

function TfraIndividualwithRole.GetRole: TCaption;
begin
  Result:=lblIndividRole.Caption;
end;

procedure TfraIndividualwithRole.SetIdInd(AValue: integer);
begin
  if (AValue > 0) and (AValue=edtIndividId.Value) then exit ;
  edtIndividId.Value:=AValue;
  if AValue>0 then
     cbxIndividName.Text:=
       DecodeName(dmGenData.GetIndividuumName(edtIndividId.Value),1)
  else
    cbxIndividName.Text:='';
end;


procedure TfraIndividualwithRole.SetIndName(AValue: TCaption);
begin
  if cbxIndividName.Text=AValue then exit;
  cbxIndividName.Text := AValue;
  edtIndividId.Value:=0; // Check if this is necessary
end;

procedure TfraIndividualwithRole.SetRole(AValue: TCaption);
begin
  if AValue = lblIndividRole.Caption then exit;
  lblIndividRole.Caption := AValue;
end;

end.

