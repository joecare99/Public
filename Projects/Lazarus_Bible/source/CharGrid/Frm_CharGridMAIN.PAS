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

  { TfrmCharGridMain }

  TfrmCharGridMain = class(TForm)
    cbxFonts: TComboBox;
    chbANSI: TCheckBox;
    edtCopy: TEdit;
    FlowPanel1: TFlowPanel;
    grdChars: TStringGrid;
    btnClose: TBitBtn;
    btnSelect: TBitBtn;
    btnCopy: TBitBtn;
    lblCharView: TLabel;
    bvlCharView: TBevel;
    btnClear: TBitBtn;
    lblCopy: TLabel;
    lblFont: TLabel;
    mnuMainMenu1: TMainMenu;
    mniFileMenu: TMenuItem;
    mniFileExit: TMenuItem;
    mniHelpMenu: TMenuItem;
    mniHelpAbout: TMenuItem;
    Panel1: TPanel;
    pnlBottom: TPanel;
    procedure chbANSIChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbxFontsChange(Sender: TObject);
    procedure cbxFontsKeyDown(Sender: TObject; var Key: Word;
      {%H-}Shift: TShiftState);
    procedure grdCharsDblClick(Sender: TObject);
    procedure grdCharsKeyDown(Sender: TObject;
      var Key: Word; {%H-}Shift: TShiftState);
    procedure grdCharsSelectCell(Sender: TObject;
      Col, Row: Longint; var CanSelect: Boolean);
    procedure mniFileExitClick(Sender: TObject);
    procedure mniHelpAboutClick(Sender: TObject);
    procedure btnSelectClick(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCharGridMain: TfrmCharGridMain;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

{ Initialize controls }
procedure TfrmCharGridMain.FormCreate(Sender: TObject);
var
  Ascii, IRow, ICol: Integer;
begin
{ Initialize cbxFonts ComboBox with font names }
  cbxFonts.Items := Screen.Fonts;
{ Show current StringGrid font in cbxFonts's edit box }
  cbxFonts.ItemIndex :=
    cbxFonts.Items.IndexOf(grdChars.Font.Name);
{ Insert characters into grid }
  Ascii := 0;
  with grdChars do
  for IRow := 0 to RowCount-1 do
    for ICol := 0 to ColCount-1 do
    begin
      Cells[ICol, IRow] := {$IFDEF FPC}ansiToUtf8{$ENDIF}(ansichar ( Ascii) );
      Inc(Ascii);
    end;
{ Assign sample character and font }
  with grdChars do
    lblCharView.Caption := Cells[Row, Col];
  lblCharView.Font.Name := grdChars.Font.Name;
end;

procedure TfrmCharGridMain.chbANSIChange(Sender: TObject);
var
  Ascii, IRow, ICol: Integer;
 // AscStr,ansi:String;
begin
  Ascii := 0;
//  setlength(ansi,1);
//  grdChars.Font.CharSet:=0;
  with grdChars do
  for IRow := 0 to RowCount-1 do
    for ICol := 0 to ColCount-1 do
    begin
//      AscStr := ansichar ( Ascii);
      if chbANSI.Checked then
      begin

      Cells[ICol, IRow] :=  ansistring(WideChar(Ascii));
      end
      else
      Cells[ICol, IRow] := {$IFDEF FPC} AnsiToUtf8 {$ENDIF} (ansichar ( Ascii) );
      Inc(Ascii);
    end;
end;

{ Change grid, edit box, and sample to selected font }
procedure TfrmCharGridMain.cbxFontsChange(Sender: TObject);
begin
  grdChars.Font.Name := cbxFonts.Text;
  edtCopy.Text := '';  { Optional: Erase current entries }
  edtCopy.Font := grdChars.Font;
  lblCharView.Font.Name := grdChars.Font.Name;
end;

{ Close cbxFonts drop-down list on pressing Enter or Esc }
procedure TfrmCharGridMain.cbxFontsKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key in [vk_Return, vk_Escape] then
  begin
    cbxFonts.DroppedDown := False;
    Key := 0;
  end;
end;

{ Grid double-click event handler }
procedure TfrmCharGridMain.grdCharsDblClick(Sender: TObject);
begin
  with edtCopy, grdChars do
    Text := Text + Cells[Col, Row];
end;

{ Select character on pressing Enter or Space }
procedure TfrmCharGridMain.grdCharsKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key in [vk_Return, vk_Space] then
    grdCharsDblClick(Sender);  // Same as double-click grid
end;

{ Show selected character }
procedure TfrmCharGridMain.grdCharsSelectCell(Sender: TObject; Col,
  Row: Longint; var CanSelect: Boolean);
begin
  lblCharView.Caption := grdChars.Cells[Col, Row];
  CanSelect := true;
end;

{ File|Exit menu command }
procedure TfrmCharGridMain.mniFileExitClick(Sender: TObject);
begin
  Close;
end;

{ Help|About menu command }
procedure TfrmCharGridMain.mniHelpAboutClick(Sender: TObject);
begin
  AboutForm.ShowModal;
end;

{ Select button click handler }
procedure TfrmCharGridMain.btnSelectClick(Sender: TObject);
begin
  grdCharsDblClick(Sender);  // Same as double-clicking grid
end;

{ Copy selected characters to clipboard }
procedure TfrmCharGridMain.btnCopyClick(Sender: TObject);
begin
  with edtCopy do
  begin
    if SelLength = 0 then
      SelectAll;       { Select all text if none selected }
    CopyToClipboard;   { Copy selected text to clipboard }
  end;
end;

{ Clear text in copy-to edit box }
procedure TfrmCharGridMain.btnClearClick(Sender: TObject);
begin
  edtCopy.Text := '';
end;

end.
