unit frm_MultiPopUp;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Menus, StdCtrls;

type

  { TfrmMultiPopUp }

  TfrmMultiPopUp = class(TForm)
    CheckBox1: TCheckBox;
    Edit1: TEdit;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    mnuPanel1_1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    mnuPanel1_2: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    PopupMenu1: TPopupMenu;
    PopupMenu2: TPopupMenu;
    PopupMenu3: TPopupMenu;
    PopupMenu4: TPopupMenu;
    PopupMenu5: TPopupMenu;
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure mnuPanel1_1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmMultiPopUp: TfrmMultiPopUp;

implementation

{$R *.lfm}

{ TfrmMultiPopUp }

procedure TfrmMultiPopUp.mnuPanel1_1Click(Sender: TObject);
begin
  if sender
end;

procedure TfrmMultiPopUp.PopupMenu1Popup(Sender: TObject);
//  
var
  Item: TMenuItem;
  i: Integer;
  pp:TPopupMenu;
begin
  pp := TPopupMenu(Sender);
  pp.Items.Clear;  // <-- Maybe, just to be sure
  for i := 0 to 5 do
  begin
    Item := TMenuItem.Create(pp); // <--- here
    Item.Caption := 'Item ' + IntToStr(i)+' (' + IntToStr(random(9))+')';
    item.tag := i;
    Item.OnClick := @mnuPanel1_1Click;
    pp.Items.Add(Item);
  end;
//  pp.PopUp; // <-- here
end;

procedure TfrmMultiPopUp.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if CheckBox1.Checked then
  begin
    Panel1.PopupMenu := PopupMenu1;
    Panel2.PopupMenu := PopupMenu2;
  end
  else
  begin
    Panel1.PopupMenu := PopupMenu3;
    Panel2.PopupMenu := PopupMenu4;
  end;
end;

end.

