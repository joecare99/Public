unit frm_SelectDialog;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ButtonPanel;

type

  { TfrmSelectDialog }

  TfrmSelectDialog = class(TForm)
    ButtonPanel1: TButtonPanel;
    ComboBox1: TComboBox;
    StaticText1: TStaticText;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmSelectDialog: TfrmSelectDialog;

function SelectDialog(const ACaption, APrompt : String;const List:TStrings; var Value : String) : Boolean;overload;
function SelectDialog(const ACaption, APrompt : String;const List:TStrings; var Value : integer) : Boolean;overload;

implementation

function SelectDialog(const ACaption, APrompt: String; const List: TStrings;
  var Value: String): Boolean;
begin
  frmSelectDialog.Caption:=ACaption;
  frmSelectDialog.StaticText1.Caption:=APrompt;
  frmSelectDialog.ComboBox1.Items:=List;
  frmSelectDialog.ComboBox1.Text:=Value;
  if frmSelectDialog.ShowModal = mrOK then
    begin
      result := true;
      Value:=frmSelectDialog.ComboBox1.Text;
    end;
end;

function SelectDialog(const ACaption, APrompt: String; const List: TStrings;
  var Value: integer): Boolean;
begin
  frmSelectDialog.Caption:=ACaption;
  frmSelectDialog.StaticText1.Caption:=APrompt;
  frmSelectDialog.ComboBox1.Items:=List;
  frmSelectDialog.ComboBox1.ItemIndex:=frmSelectDialog.ComboBox1.Items.IndexOfObject(TObject(ptrint(Value)));
  if frmSelectDialog.ShowModal = mrOK then
    begin
      result := true;
      Value:=ptrint(frmSelectDialog.ComboBox1.Items.Objects[frmSelectDialog.ComboBox1.ItemIndex]);
    end;
end;

{$R *.lfm}

{ TfrmSelectDialog }


end.

