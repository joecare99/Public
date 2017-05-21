unit Frm_MainDynamicPopup;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, Menus, LCLType;

type

  { TDynamicPopup }
  TDynamicPopup = class(TPopupMenu)
    //constructor Create(AOwner: TComponent); override; //if you do not plan on adding code in the constructor then don't override it.
    procedure FillItems;
    procedure PopupClicked(Sender: TObject); //why class?? class methods do not have access to class variables.
  end;

  { TForm1 }

  TForm1 = class(TForm)
    Edit1: TEdit;
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure HandleCommand;
  private
    { private declarations }
    FDynamicPopup : TDynamicPopup; //since it is to be used from form1 define it here.
  public
    { public declarations }
  end;

var
  Form1: TForm1;
  //DynamicPopup : TDynamicPopup; // why public as a generic rule avoid public variables.

implementation

{$R *.lfm}

{ TDynamicPopup }
//constructor TDynamicPopup.Create(AOwner: TComponent);
//begin
//  inherited  Create(AOwner);
//end;

procedure TDynamicPopup.PopupClicked(Sender: TObject);
begin
  ShowMessage('Testing Popup :'+TMenuItem(Sender).Caption);
end;

procedure TDynamicPopup.FillItems;
var
  Item: TMenuItem;
  i: Integer;
begin
  for i := 0 to 5 do begin
    Item := TMenuItem.Create(Self);
    Item.Caption := 'Item ' + IntToStr(i);
    Item.OnClick := @PopupClicked;
    //DynamicPopup.Items.Add(Item); ///erm what happens if dynamicpopup menu points to a different instance than the one this code runs?
    Items.Add(Item); //<-- this instance and this instance only call.
  end;
  //DynamicPopup.PopUp;
  PopUp;
end;

procedure TForm1.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  {If key = VK_ESCAPE and DynamicPopup is clicked, run destroy it.}
  if key =  VK_RETURN then HandleCommand;
end;

procedure TForm1.HandleCommand;
begin
  case Edit1.Text of
    'Dynamic' : begin
       if Assigned(FDynamicPopup) then FreeAndNil(FDynamicPopup);// this is must otherwise you have a memmory leak
       FDynamicPopup := TDynamicPopup.Create(Self);
       FDynamicPopup.FillItems;
    end;
  else begin
      ShowMessage('Invalid Command');// Showmessage should be enough.
      Edit1.Text:='';//<-- bad choice! what happens if some one has typed Dynamik instead of Dynamic why force him to retype everything?
    end;
  end;
end;

end.

