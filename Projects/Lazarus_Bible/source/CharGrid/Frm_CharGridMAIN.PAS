unit Frm_CharGridMAIN;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, Grids, StdCtrls, Buttons, ExtCtrls, Menus,
  Frm_CharGridABOUT;

type

  { TMainForm }

  TMainForm = class(TForm)
    CheckBox1: TCheckBox;
    StringGrid1: TStringGrid;
    FontCB: TComboBox;
    FontLabel: TLabel;
    CloseBitBtn: TBitBtn;
    CopyEdit: TEdit;
    CopyLabel: TLabel;
    SelectBitBtn: TBitBtn;
    ClipBitBtn: TBitBtn;
    CharLabel: TLabel;
    Bevel1: TBevel;
    ClearBitBtn: TBitBtn;
    MainMenu1: TMainMenu;
    FileMenu: TMenuItem;
    FileExit: TMenuItem;
    HelpMenu: TMenuItem;
    HelpAbout: TMenuItem;
    procedure CheckBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FontCBChange(Sender: TObject);
    procedure FontCBKeyDown(Sender: TObject; var Key: Word;
      {%H-}Shift: TShiftState);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure StringGrid1KeyDown(Sender: TObject;
      var Key: Word; {%H-}Shift: TShiftState);
    procedure StringGrid1SelectCell(Sender: TObject;
      Col, Row: Longint; var CanSelect: Boolean);
    procedure FileExitClick(Sender: TObject);
    procedure HelpAboutClick(Sender: TObject);
    procedure SelectBitBtnClick(Sender: TObject);
    procedure ClipBitBtnClick(Sender: TObject);
    procedure ClearBitBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

{ Initialize controls }
procedure TMainForm.FormCreate(Sender: TObject);
var
  Ascii, IRow, ICol: Integer;
begin
{ Initialize FontCB ComboBox with font names }
  FontCB.Items := Screen.Fonts;
{ Show current StringGrid font in FontCB's edit box }
  FontCB.ItemIndex :=
    FontCB.Items.IndexOf(StringGrid1.Font.Name);
{ Insert characters into grid }
  Ascii := 0;
  with StringGrid1 do
  for IRow := 0 to RowCount-1 do
    for ICol := 0 to ColCount-1 do
    begin
      Cells[ICol, IRow] := {$IFDEF FPC}ansiToUtf8{$ENDIF}(ansichar ( Ascii) );
      Inc(Ascii);
    end;
{ Assign sample character and font }
  with StringGrid1 do
    CharLabel.Caption := Cells[Row, Col];
  CharLabel.Font.Name := StringGrid1.Font.Name;
end;

procedure TMainForm.CheckBox1Change(Sender: TObject);
var
  Ascii, IRow, ICol: Integer;
 // AscStr,ansi:String;
begin
  Ascii := 0;
//  setlength(ansi,1);
//  StringGrid1.Font.CharSet:=0;
  with StringGrid1 do
  for IRow := 0 to RowCount-1 do
    for ICol := 0 to ColCount-1 do
    begin
//      AscStr := ansichar ( Ascii);
      if CheckBox1.Checked then
      begin

      Cells[ICol, IRow] :=  ansistring(WideChar(Ascii));
      end
      else
      Cells[ICol, IRow] := {$IFDEF FPC} AnsiToUtf8 {$ENDIF} (ansichar ( Ascii) );
      Inc(Ascii);
    end;
end;

{ Change grid, edit box, and sample to selected font }
procedure TMainForm.FontCBChange(Sender: TObject);
begin
  StringGrid1.Font.Name := FontCB.Text;
  CopyEdit.Text := '';  { Optional: Erase current entries }
  CopyEdit.Font := StringGrid1.Font;
  CharLabel.Font.Name := StringGrid1.Font.Name;
end;

{ Close FontCB drop-down list on pressing Enter or Esc }
procedure TMainForm.FontCBKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key in [vk_Return, vk_Escape] then
  begin
    FontCB.DroppedDown := False;
    Key := 0;
  end;
end;

{ Grid double-click event handler }
procedure TMainForm.StringGrid1DblClick(Sender: TObject);
begin
  with CopyEdit, StringGrid1 do
    Text := Text + Cells[Col, Row];
end;

{ Select character on pressing Enter or Space }
procedure TMainForm.StringGrid1KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key in [vk_Return, vk_Space] then
    StringGrid1DblClick(Sender);  // Same as double-click grid
end;

{ Show selected character }
procedure TMainForm.StringGrid1SelectCell(Sender: TObject; Col,
  Row: Longint; var CanSelect: Boolean);
begin
  CharLabel.Caption := StringGrid1.Cells[Col, Row];
  CanSelect := true;
end;

{ File|Exit menu command }
procedure TMainForm.FileExitClick(Sender: TObject);
begin
  Close;
end;

{ Help|About menu command }
procedure TMainForm.HelpAboutClick(Sender: TObject);
begin
  AboutForm.ShowModal;
end;

{ Select button click handler }
procedure TMainForm.SelectBitBtnClick(Sender: TObject);
begin
  StringGrid1DblClick(Sender);  // Same as double-clicking grid
end;

{ Copy selected characters to clipboard }
procedure TMainForm.ClipBitBtnClick(Sender: TObject);
begin
  with CopyEdit do
  begin
    if SelLength = 0 then
      SelectAll;       { Select all text if none selected }
    CopyToClipboard;   { Copy selected text to clipboard }
  end;
end;

{ Clear text in copy-to edit box }
procedure TMainForm.ClearBitBtnClick(Sender: TObject);
begin
  CopyEdit.Text := '';
end;

end.
