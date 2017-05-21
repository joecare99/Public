unit frmMaindynamicpopups;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Menus, ExtCtrls, ButtonPanel, Dialogs,
  StdCtrls;

const
  maxPopups = 6; // change to suit

type
  TPopArray = array[1..maxPopups] of TPopupMenu;

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
  private
    Fpa: TPopArray;
    function NewPopup(anID, anItemCount: integer): TPopupMenu;
    procedure CreateDynamicPopups;
    procedure PopupClick(Sender: TObject);
  end;

  { TWhichPopDlg }

  TWhichPopDlg = class(TForm)
  strict private
    FRadioGroup: TRadioGroup;
    FBPanel: TButtonPanel;
    function GetPopIndex: integer;
    procedure RadioGroupSelectionChanged(Sender: TObject);
  public
    constructor CreateNew(AOwner: TComponent; Num: integer = 0); override;
    property PopIndex: integer read GetPopIndex;
  end;

function DlgPopupWasChosen: boolean;

var
  Form1: TForm1;

implementation

function DlgPopupWasChosen: boolean;
var
  dlg: TWhichPopDlg;
begin
  dlg := TWhichPopDlg.CreateNew(nil);
  try
    if (dlg.ShowModal = mrOk) then
    begin
      Form1.PopupMenu := Form1.Fpa[dlg.PopIndex];
      Result := True;
    end
    else
      Result := False;
  finally
    dlg.Free;
  end;
end;

{$R *.lfm}

{ TWhichPopDlg }

procedure TWhichPopDlg.RadioGroupSelectionChanged(Sender: TObject);
begin
  FBPanel.OKButton.Enabled := True;
end;

function TWhichPopDlg.GetPopIndex: integer;
begin
  Result := Succ(FRadioGroup.ItemIndex);
end;

constructor TWhichPopDlg.CreateNew(AOwner: TComponent; Num: integer);
var
  i: integer;
begin
  inherited CreateNew(AOwner, Num);
  BorderStyle := bsDialog;
  Position := poMainFormCenter;
  SetInitialBounds(0, 0, 200, 200);
  Caption := 'Choose popup menu to show';
  FRadioGroup := TRadioGroup.Create(Self);
  FRadioGroup.Align := alTop;
  FRadioGroup.BorderSpacing.Around := 6;
  for i := 0 to Pred(maxPopups) do
    FRadioGroup.Items.Add(Format('Popup #%d', [i]));
  FRadioGroup.AutoSize := True;
  FRadioGroup.Parent := Self;
  FRadioGroup.OnSelectionChanged := @RadioGroupSelectionChanged;
  FBPanel := TButtonPanel.Create(Self);
  FBPanel.Align := alTop;
  FBPanel.Top := 1;
  FBPanel.BorderSpacing.Around := 6;
  FBPanel.ShowButtons := [pbOK, pbCancel];
  FBPanel.OKButton.Enabled := False;
  FBPanel.Parent := Self;
  AutoSize := True;
end;

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  Randomize;
  CreateDynamicPopups;
end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
var
  pt: TPoint;
begin
  if (Button = mbRight) then
    if DlgPopupWasChosen then
    begin
      pt := Point(X, Y);
      ScreenToClient(pt);
      PopupMenu.PopUp(pt.X + 150, pt.Y + 150);
    end;
end;

procedure TForm1.PopupClick(Sender: TObject);
var
  mi: TMenuItem absolute Sender;
begin
  if (Sender is TMenuItem) then
    ShowMessage(Format('You clicked Popup #%d, item #%d', [mi.Tag, mi.MenuIndex]));
end;

function TForm1.NewPopup(anID, anItemCount: integer): TPopupMenu;
var
  arr: array of TMenuItem;
  i: integer;
begin
  SetLength(arr, anItemCount);
  for i := 0 to High(arr) do
  begin
    arr[i] := NewItem(Format('Popup%d - Item # %d', [anID, i]), 0, False,
      True, @PopupClick, 0, '');
    arr[i].Tag := anID;
  end;
  Result := NewPopupMenu(Self, '', paLeft, True, arr);
end;

procedure TForm1.CreateDynamicPopups;
var
  i, c: integer;
begin
  for i := Low(TPopArray) to High(TPopArray) do
  begin
    c := Random(11);
    if (c = 0) then
      Inc(c);
    Fpa[i] := NewPopup(Pred(i), c);
  end;
end;

end.
