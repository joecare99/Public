unit frm_c2pasMiniMain;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

// Project Full Name: OpenC2Pas
// CVS Server:        cvs.c2pas.sourceforge.net
// Home page:         http:/c2pas.sourceforge.net
// -----------------------------------------------------------------------------
// OpenC2Pas - Mini Interface
// -----------------------------------------------------------------------------
// This is a basic interface that can be rewritten with C++Builder or Kylix in
// a pair of minutes.
// It is also useful if you don't want to install SynEdit and you are interested
// only in the developement of translator.pas
// -----------------------------------------------------------------------------
//
// Copyright (C) 2002 Alberto Berardi
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
// more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
interface

uses
{$IFnDEF FPC}
  System.ImageList, Windows,
{$ELSE}
  LCLIntf, LCLType, LMessages,
{$ENDIF}
  cls_Translator, //TC2Pas
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, StdCtrls, ComCtrls, ToolWin, ExtCtrls, ImgList;

type
  TfrmC2PasMiniMain = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    PasteCodefro1: TMenuItem;
    Translation2: TMenuItem;
    New1: TMenuItem;
    LoadFromFile1: TMenuItem;
    CopytoClipboard1: TMenuItem;
    About1: TMenuItem;
    edtC2PasCode: TMemo;
    Translate1: TMenuItem;
    Start1: TMenuItem;
    N2: TMenuItem;
    stbC2PasMain: TStatusBar;
    splC2PasBottom: TSplitter;
    ImageList1: TImageList;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    tlbC2PadTop: TToolBar;
    ToolButton6: TToolButton;
    ToolButton3: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton2: TToolButton;
    ToolButton9: TToolButton;
    ToolButton1: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    Preferences1: TMenuItem;
    PrefCopytoClipboard: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    Warnings: TListBox;
    PrefSelectAll: TMenuItem;
    N5: TMenuItem;
    procedure Exit1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Start1Click(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure PasteCodefro1Click(Sender: TObject);
    procedure CopytoClipboard1Click(Sender: TObject);
    procedure LoadFromFile1Click(Sender: TObject);
    procedure SaveAs1Click(Sender: TObject);
    procedure WarningsClick(Sender: TObject);
    procedure PrefSelectAllClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edtC2PasCodeClick(Sender: TObject);
    procedure edtC2PasCodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtC2PasCodeKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    C2Pas:Tc2Pas;
    procedure DisplayHint(Sender: TObject);
  public
    { Public declarations }
  end;

var
  frmC2PasMiniMain: TfrmC2PasMiniMain;

implementation

{$IFnDEF FPC}
  {$R *.lfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

const
   // status bar panels
   SB_XY    = 0;
   SB_HINTS = 1;

procedure TfrmC2PasMiniMain.DisplayHint(Sender: TObject);
begin
  stbC2PasMain.Panels[SB_HINTS].Text := GetLongHint(Application.Hint);
end;

procedure TfrmC2PasMiniMain.Exit1Click(Sender: TObject);
begin
   Close;
end;

procedure TfrmC2PasMiniMain.About1Click(Sender: TObject);
begin
   ShowMessage(
      'The OpenSource C/C++ to Pascal Translator' + Chr(13) +
      '(minimalist interface)' + Chr(13) +
      Chr(13) +
      C2PAS_CONTRIBUTORS + Chr(13) +
      Chr(13) +
      'http://c2pas.sourceforge.net'
   );
end;

procedure TfrmC2PasMiniMain.Start1Click(Sender: TObject);
var
   n : Integer;
   MsgStr: AnsiString;
begin
   edtC2PasCode.Text := C2Pas.Translate(edtC2PasCode.Text);

   // Display messages
   Warnings.Clear;
   for n:=0 to C2Pas.MsgCount-1 do
      Warnings.Items.Add(C2Pas.MsgString(n));
   Warnings.Visible := (C2Pas.MsgCount > 0);

   // Copy the translated code to clipboard
   if PrefCopytoClipboard.Checked then
   begin
      edtC2PasCode.SelectAll;
      CopytoClipboard1Click(nil);
      if not PrefSelectAll.Checked then
         edtC2PasCode.SelLength := 0;
   end else
      if PrefSelectAll.Checked then
         edtC2PasCode.SelectAll;
end;

procedure TfrmC2PasMiniMain.New1Click(Sender: TObject);
begin
   edtC2PasCode.Clear;
end;

procedure TfrmC2PasMiniMain.PasteCodefro1Click(Sender: TObject);
begin
   edtC2PasCode.Clear;
   edtC2PasCode.PasteFromClipboard;
end;

procedure TfrmC2PasMiniMain.CopytoClipboard1Click(Sender: TObject);
begin
   edtC2PasCode.CopyToClipboard;
end;

procedure TfrmC2PasMiniMain.LoadFromFile1Click(Sender: TObject);
begin
   if OpenDialog1.Execute then begin
      edtC2PasCode.Lines.LoadFromFile(OpenDialog1.FileName);
   end;
end;

procedure TfrmC2PasMiniMain.SaveAs1Click(Sender: TObject);
begin
   if SaveDialog1.Execute then begin
      edtC2PasCode.Lines.SaveToFile(SaveDialog1.FileName);
   end;
end;

procedure SetMemoCaret(Memo: TCustomMemo; Row, Col:Integer);
begin
  Memo.SelStart := SendMessage(Memo.Handle, EM_LINEINDEX, Row, 0) + Col;
end;

procedure TfrmC2PasMiniMain.WarningsClick(Sender: TObject);
begin
   // Go to the line that contains the warning
   if Warnings.ItemIndex > -1 then
   begin
      edtC2PasCode.SelLength := 0;
      edtC2PasCode.SelStart := C2Pas.Msg[Warnings.ItemIndex].Location;
      edtC2PasCode.SetFocus;
      Application.ProcessMessages;
      // scroll to make the cursor visible
      edtC2PasCode.Perform(EM_SCROLLCARET, 0, 0);
   end;
end;

procedure TfrmC2PasMiniMain.PrefSelectAllClick(Sender: TObject);
begin
   with Sender as TMenuitem do
      Checked := not Checked;
end;

procedure TfrmC2PasMiniMain.FormCreate(Sender: TObject);
begin
   C2Pas := TC2Pas.Create;
   Application.OnHint := DisplayHint;
end;

procedure TfrmC2PasMiniMain.FormDestroy(Sender: TObject);
begin
   C2Pas.Free;
end;

procedure TfrmC2PasMiniMain.edtC2PasCodeClick(Sender: TObject);
var
   CurrLine:Integer;
   dwEnd: DWORD;
begin
   CurrLine := SendMessage(edtC2PasCode.Handle, EM_LINEFROMCHAR, WPARAM(edtC2PasCode.SelStart), 0);
   SendMessage(edtC2PasCode.Handle,  EM_GETSEL, 0, LPARAM(@dwEnd));
   stbC2PasMain.Panels.Items[SB_XY].Text :=
      'R:' + IntToStr(CurrLine + 1) +
      ' C:' + IntToStr(dwEnd - SendMessage(edtC2PasCode.Handle, EM_LINEINDEX, WPARAM(CurrLine), 0) + 1);
end;

procedure TfrmC2PasMiniMain.edtC2PasCodeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   edtC2PasCodeClick(Sender);
end;

procedure TfrmC2PasMiniMain.edtC2PasCodeKeyPress(Sender: TObject; var Key: Char);
begin
   edtC2PasCodeClick(Sender);
end;

end.
