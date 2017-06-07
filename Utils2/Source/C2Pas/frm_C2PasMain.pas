unit frm_C2PasMain;
// Project Full Name: OpenC2Pas
// CVS Server:        cvs.c2pas.sourceforge.net
// Home page:         http:/c2pas.sourceforge.net
// -----------------------------------------------------------------------------
// This GUI requires the SynEdit component (http://synedit.sourceforge.net).
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
 {$IFDEF FPC}
 {$mode delphi}
 {$ENDIF}
interface

uses

   cls_Translator, //TC2Pas
  {$IFNDEF FPC} Windows, Messages, ToolWin,ImgList, ShellAPI, {$else}LCLIntf, {$ENDIF} SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, StdCtrls, ComCtrls, ExtCtrls,  ActnList, StdActns,
  SynEditHighlighter, SynHighlighterPas, SynEdit;

type

  { TfrmC2PasMain }

  TfrmC2PasMain = class(TForm)
    actFileNew: TAction;
    Action1: TAction;
    Action2: TAction;
    Action3: TAction;
    actSearchGoto: TAction;
    actTranslate: TAction;
    ActionList1: TActionList;
    EditCopy1: TEditCopy;
    EditCut1: TEditCut;
    EditPaste1: TEditPaste;
    EditSelectAll1: TEditSelectAll;
    FileExit1: TFileExit;
    FileOpen1: TFileOpen;
    FileSaveAs1: TFileSaveAs;
    mnuC2PasMain: TMainMenu;
    File1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    PasteCodefro1: TMenuItem;
    SearchFind1: TSearchFind;
    SearchFindNext1: TSearchFindNext;
    CodeEdit: TSynEdit;
    SynPasSyn1: TSynPasSyn;
    Translation2: TMenuItem;
    New1: TMenuItem;
    LoadFromFile1: TMenuItem;
    CopytoClipboard1: TMenuItem;
    About1: TMenuItem;
//    CodeEdit: TSynMemo;
    Translate1: TMenuItem;
    Start1: TMenuItem;
    N2: TMenuItem;
    stbC2PasMain: TStatusBar;
    Splitter1: TSplitter;
    ImageList1: TImageList;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    tlbC2PasMain: TToolBar;
    btnFileNew: TToolButton;
    btnFileSep1: TToolButton;
    btnFileOpen: TToolButton;
    btnFileSave: TToolButton;
    btnFileSep2: TToolButton;
    btnEditCopy: TToolButton;
    btnEditPaste: TToolButton;
    btnEditSep2: TToolButton;
    btnTranslate: TToolButton;
    Preferences1: TMenuItem;
    PrefCopytoClipboard: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    lbxWarnings: TListBox;
    PrefSelectAll: TMenuItem;
    Colors1: TMenuItem;
    ColorDialog1: TColorDialog;
    btnEditSearch: TToolButton;
    btnEditSep1: TToolButton;
    Find1: TMenuItem;
    FindNext1: TMenuItem;
    FindDialog1: TFindDialog;
    Help1: TMenuItem;
    Search1: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    Gotoline1: TMenuItem;
    procedure Exit1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Start1Click(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure PasteCodefro1Click(Sender: TObject);
    procedure CopytoClipboard1Click(Sender: TObject);
    procedure LoadFromFile1Click(Sender: TObject);
    procedure SaveAs1Click(Sender: TObject);
    procedure lbxWarningsClick(Sender: TObject);
    procedure Colors1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PrefCopytoClipboardClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Find1Click(Sender: TObject);
    procedure FindNext1Click(Sender: TObject);
    procedure Help1Click(Sender: TObject);
    procedure CodeEditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CodeEditClick(Sender: TObject);
    procedure Gotoline1Click(Sender: TObject);
  private
    { Private declarations }
   InitialXDim:Integer; // saved in ini file
   InitialYDim:Integer; // saved in ini file
   C2Pas:TC2Pas;
   procedure DisplayHint(Sender: TObject);
   procedure LoadFile(FileToLoad:AnsiString);
  public
    { Public declarations }
    InitialDir:AnsiString;
  end;

var
  frmC2PasMain: TfrmC2PasMain;

implementation

uses frm_SynColors,Buttons;

{$IFDEF FPC}
{$R *.lfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}

resourcestring
    rsCredits = 'The OpenSource C/C++ to Pascal Translator'
      + #13'http://c2pas.sourceforge.net'
      + #13
      + #13'Translator unit:'
      + #13'%s'
      + #13
      + #13'Windows user interface:'
      + #13'Copyright (c) 2002 Alberto Berardi'
      + #13
      + #13'Special thanks to:'
      + #13'SynEdit team, SourceForge';
    rsFileLoaded = 'File loaded';

const
   // status bar panels
   SB_CARETX = 0;
   SB_CARETY = 1;
   SB_HINTS = 2;

procedure TfrmC2PasMain.LoadFile(FileToLoad:AnsiString);
var
   LoadOk:boolean;
begin
   LoadOk := true;
   try
      CodeEdit.Lines.LoadFromFile(FileToLoad);
   except
      on E: Exception do
      begin
         //[...] future version: localized error messages
         ShowMessage(E.Message);
         LoadOk := false;
      end;
   end;
   if LoadOk then
      stbC2PasMain.Panels[SB_HINTS].Text := rsFileLoaded;
end;

procedure TfrmC2PasMain.DisplayHint(Sender: TObject);
begin
  stbC2PasMain.Panels[SB_HINTS].Text := GetLongHint(Application.Hint);
end;

procedure StrToSynColor(Str:AnsiString; SynFont:TSynHighlighterAttributes);
   function SubVal(SubStrCaption{, Str}:AnsiString):Integer;
   var
      SubS:AnsiString;
      p:Integer;
   begin
      SubS := Copy(Str, AnsiPos(SubStrCaption, Str) + Length(SubStrCaption), 3200);
      p := AnsiPos(',', SubS);
      if p > 0 then
         SubS := Copy(SubS, 1, p - 1);
      Result := StrToInt(SubS);
   end;
begin
   SynFont.Background := SubVal('BKG:');
   SynFont.Foreground := SubVal('FRG:');
   SynFont.Style := [];
   if Boolean(SubVal('fsB:')) then SynFont.Style := SynFont.Style + [fsBold];
   if Boolean(SubVal('fsI:')) then SynFont.Style := SynFont.Style + [fsItalic];
   if Boolean(SubVal('fsU:')) then SynFont.Style := SynFont.Style + [fsUnderline];
   if Boolean(SubVal('fsK:')) then SynFont.Style := SynFont.Style + [fsStrikeOut];
end;

function SynColorToStr(SynFont:TSynHighlighterAttributes):AnsiString;
begin
   Result
      :=  'BKG:' + IntToStr(SynFont.Background)
      + ', FRG:' + IntToStr(SynFont.Foreground)
      + ', fsB:' + IntToStr(Integer(fsBold in SynFont.Style))
      + ', fsI:' + IntToStr(Integer(fsItalic in SynFont.Style))
      + ', fsU:' + IntToStr(Integer(fsUnderline in SynFont.Style))
      + ', fsK:' + IntToStr(Integer(fsStrikeOut in SynFont.Style))
   ;
end;

procedure TfrmC2PasMain.Exit1Click(Sender: TObject);
begin
   Close;
end;

procedure TfrmC2PasMain.About1Click(Sender: TObject);
var
   tmpForm:TForm;
   tmpImage:TImage;
   tmpLabel:TLabel;
   tmpPanel: TPanel;
   tmpBtn: TBitBtn;
begin
   tmpForm := TForm.Create(Application);
   try
   tmpForm.BorderStyle := bsDialog;
   tmpForm.Position := poScreenCenter;
   tmpForm.Caption := Caption;

   // Bottom-Panel
   tmpPanel := Tpanel.Create(tmpForm);
   with tmpPanel do
      begin
        Parent:=tmpForm;
        Align:=alBottom;
        BevelOuter:=bvNone;
        height := 54;
      end;

   tmpBtn := TBitBtn.Create(tmpForm);
   with tmpBtn do begin
      Parent := tmpPanel;
      Align:=alClient;
      BorderSpacing.Around:=6;
      kind := bkClose;
      Cancel:=true;
   end;

   // Side-Panel
   tmpPanel := Tpanel.Create(tmpForm);
   with tmpPanel do
      begin
        Parent:=tmpForm;
        Align:=alLeft;
        BevelOuter:=bvNone;
        width := 44;
      end;

   tmpImage := TImage.Create(tmpForm);
   tmpImage.Parent := tmpPanel;
   tmpImage.Top := 6;
   tmpImage.Left := 6;
   tmpImage.Width := 32;
   tmpImage.Height := 32;
   tmpImage.Canvas.Draw(0, 0, Application.Icon);

   tmpLabel := TLabel.Create(tmpForm);
   with tmpLabel do begin
   tmpLabel.Parent := tmpForm;
   tmpLabel.Align := alClient;
   tmpLabel.BorderSpacing.Around:=6;
   tmpLabel.AutoSize:=true;
   tmpLabel.Caption
      := format (rsCredits,[C2PAS_CONTRIBUTORS]);
   end;
   {$IFDEF FPC}
//   tmpForm.Height := tmpLabel.Height + 200;
//   tmpForm.Width := 300 + tmpLabel.Width;
   {$ELSE}
   tmpForm.ClientHeight := tmpLabel.Height + 56;
   tmpForm.ClientWidth := 58 + tmpLabel.Width;
   {$ENDIF}
   tmpForm.AutoSize:=true;
   tmpForm.ShowModal;

   finally
     freeandnil(tmpForm);
   end;
end;

procedure TfrmC2PasMain.Start1Click(Sender: TObject);
var
   i : Integer;
begin
   CodeEdit.Text := C2Pas.Translate(CodeEdit.Text);

   // Display messages
   lbxWarnings.Clear;
   for i:=0 to C2Pas.MsgCount-1 do
      lbxWarnings.Items.Add(C2Pas.MsgString(i));
   lbxWarnings.Visible := (C2Pas.MsgCount > 0);

   // Copy the translated code to the clipboard
   if PrefCopytoClipboard.Checked then
   begin
      CodeEdit.SelectAll;
      CopytoClipboard1Click(nil);
      if not PrefSelectAll.Checked then
         CodeEdit.SelEnd := CodeEdit.SelStart;
   end else
      if PrefSelectAll.Checked then
         CodeEdit.SelectAll;
end;

procedure TfrmC2PasMain.New1Click(Sender: TObject);
begin
   CodeEdit.Text := '';
end;

procedure TfrmC2PasMain.PasteCodefro1Click(Sender: TObject);
begin
   CodeEdit.Text := '';
   CodeEdit.PasteFromClipboard;
   CodeEdit.SelStart := 0;
end;

procedure TfrmC2PasMain.CopytoClipboard1Click(Sender: TObject);
begin
   CodeEdit.CopyToClipboard;
end;

procedure TfrmC2PasMain.LoadFromFile1Click(Sender: TObject);
begin
   if OpenDialog1.Execute then
      LoadFile(OpenDialog1.FileName);
end;

procedure TfrmC2PasMain.SaveAs1Click(Sender: TObject);
begin
   if SaveDialog1.Execute then begin
      CodeEdit.Lines.SaveToFile(SaveDialog1.FileName);
   end;
end;

procedure TfrmC2PasMain.lbxWarningsClick(Sender: TObject);
begin
   // Go to the line that contains the warning
   if lbxWarnings.ItemIndex > -1 then
   begin
      CodeEdit.SelStart := C2Pas.Msg[lbxWarnings.ItemIndex].Location;
      CodeEdit.SelEnd := CodeEdit.SelStart -1;
      CodeEdit.SetFocus;
   end;
end;

procedure TfrmC2PasMain.Colors1Click(Sender: TObject);
begin
   with Form_SynColors do
      begin
   CopyAttri(SynPasSyn1.AsmAttri,         Attri[0]);
   CopyAttri(SynPasSyn1.CommentAttri,     Attri[1]);
   CopyAttri(SynPasSyn1.IdentifierAttri,  Attri[2]);
   CopyAttri(SynPasSyn1.KeyAttri,         Attri[3]);
   CopyAttri(SynPasSyn1.NumberAttri,      Attri[4]);
   CopyAttri(SynPasSyn1.SpaceAttri,       Attri[5]);
   CopyAttri(SynPasSyn1.StringAttri,      Attri[6]);
   CopyAttri(SynPasSyn1.SymbolAttri,      Attri[7])
      end;
   if Form_SynColors.ShowModal = mrOK then
   with Form_SynColors do
     begin
   CopyAttri(Attri[0], SynPasSyn1.AsmAttri);
   CopyAttri(Attri[1], SynPasSyn1.CommentAttri);
   CopyAttri(Attri[2], SynPasSyn1.IdentifierAttri);
   CopyAttri(Attri[3], SynPasSyn1.KeyAttri);
   CopyAttri(Attri[4], SynPasSyn1.NumberAttri);
   CopyAttri(Attri[5], SynPasSyn1.SpaceAttri);
   CopyAttri(Attri[6], SynPasSyn1.StringAttri);
   CopyAttri(Attri[7], SynPasSyn1.SymbolAttri);
     end;
end;

procedure TfrmC2PasMain.FormCreate(Sender: TObject);
var
   F:TStringList;
begin
   C2Pas := TC2Pas.Create;
   InitialDir := ExtractFilePath(ParamStr(0));
   Application.OnHint := DisplayHint;

   // **** Load ini file ****
   if(FileExists(InitialDir + Application.Title + '.ini')) then
   begin
      F := TStringList.Create;
      try
         F.LoadFromFile(InitialDir + Application.Title + '.ini');
      except
         on E: Exception do
         begin
            ShowMessage(E.Message);
            F.Clear;
         end;
      end;

      try Width := StrToInt(F.Values['NormalWidth']);
      except Width := 530; end;
      InitialXDim := Width;

      try Height := StrToInt(F.Values['NormalHeight']);
      except Height:=414; end;
      InitialYDim := Height;

      try
         if F.Values['Maximized'] = 'Y' then
            WindowState:=wsMaximized
         else
            WindowState:=wsNormal;
      except WindowState:=wsNormal; end;

      // auto
      PrefCopytoClipboard.Checked := F.Values['AutoClipboard'] <> '0';
      PrefSelectAll.Checked := F.Values['AutoSelAll'] <> '0';

      // colors
      StrToSynColor(F.Values['ColorAsm'], SynPasSyn1.AsmAttri);
      StrToSynColor(F.Values['ColorRem'], SynPasSyn1.CommentAttri);
      StrToSynColor(F.Values['ColorIdn'], SynPasSyn1.IdentifierAttri);
      StrToSynColor(F.Values['ColorKey'], SynPasSyn1.KeyAttri);
      StrToSynColor(F.Values['ColorNum'], SynPasSyn1.NumberAttri);
      StrToSynColor(F.Values['ColorSpc'], SynPasSyn1.SpaceAttri);
      StrToSynColor(F.Values['ColorStr'], SynPasSyn1.StringAttri);
      StrToSynColor(F.Values['ColorSym'], SynPasSyn1.SymbolAttri);

      F.Free;
   end;

   // *** Load file (command line parameters) ***
   if ParamStr(1) <> '' then
      LoadFile(ParamStr(1));
end;

procedure TfrmC2PasMain.FormDestroy(Sender: TObject);
begin
   C2Pas.Free;
end;

procedure TfrmC2PasMain.PrefCopytoClipboardClick(Sender: TObject);
begin
   with Sender as TMenuitem do
      Checked := not Checked;
end;

procedure TfrmC2PasMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
   F:TStringList;
begin
   F := TStringList.Create;
   F.Values['Version'] := Application.Title;
   if WindowState=wsMaximized then begin
      F.Values['NormalWidth'] := IntToStr(InitialXDim);
      F.Values['NormalHeight'] := IntToStr(InitialYDim);
      F.Values['Maximized'] := 'Y';
   end else begin
      F.Values['NormalWidth'] := IntToStr(Width);
      F.Values['NormalHeight'] := IntToStr(Height);
      F.Values['Maximized'] := 'N';
   end;
   // auto
   F.Values['AutoClipboard'] := IntToStr(Integer(PrefCopytoClipboard.Checked));
   F.Values['AutoSelAll'] := IntToStr(Integer(PrefSelectAll.Checked));
   // colors
   F.Values['ColorAsm'] := SynColorToStr(SynPasSyn1.AsmAttri);
   F.Values['ColorRem'] := SynColorToStr(SynPasSyn1.CommentAttri);
   F.Values['ColorIdn'] := SynColorToStr(SynPasSyn1.IdentifierAttri);
   F.Values['ColorKey'] := SynColorToStr(SynPasSyn1.KeyAttri);
   F.Values['ColorNum'] := SynColorToStr(SynPasSyn1.NumberAttri);
   F.Values['ColorSpc'] := SynColorToStr(SynPasSyn1.SpaceAttri);
   F.Values['ColorStr'] := SynColorToStr(SynPasSyn1.StringAttri);
   F.Values['ColorSym'] := SynColorToStr(SynPasSyn1.SymbolAttri);
   try
   F.SaveToFile(InitialDir + Application.Title + '.ini');
   except end;
end;

procedure TfrmC2PasMain.Find1Click(Sender: TObject);
begin
   FindDialog1.Execute;
end;

procedure TfrmC2PasMain.FindNext1Click(Sender: TObject);
const
   WORD_CHARACTERS = '0123456789QWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnm¿¡¬√ƒ≈∆«»… ÀÃÕŒœ—“”‘’÷Ÿ⁄€‹›ﬂ‡·‚„‰ÂÊÁËÈÍÎÏÌÓÔÒ¯ÚÛÙıˆ˘˙˚¸˝ˇ';
var
   ps, SrcStr: PAnsiChar;
   MaxPos, StartPos , SrcLen, c, n : Integer;
	MatchCase, WholeWord, correspond, found : Boolean;
begin
   // Yes, you can write the code to use the SearchReplace method of SynEdit,
   // but the simple code below does the job, and, since it make use of the
   // standard Windows(tm) find dialog box, you don't have to worry
   // about possible future localizations.

   if FindDialog1.FindText='' then
   begin
      //i.e. you pressed F3 (find again), but no text was searched before
	   FindDialog1.Execute;
   end else begin

      FindDialog1.CloseDialog;

      SrcLen := Length(FindDialog1.FindText);
      MaxPos := Length(CodeEdit.Text);
      found := false;
      WholeWord := (frWholeWord in FindDialog1.Options);
      MatchCase := (frMatchCase in FindDialog1.Options);
      StartPos := CodeEdit.SelStart;
      if CodeEdit.SelEnd - CodeEdit.SelStart <= 0 then
         c := StartPos - 2
      else
         c := StartPos - 1;
      SrcStr := PChar(FindDialog1.FindText);
      ps := PChar(CodeEdit.Text);

   while (c + SrcLen < MaxPos) and (not found) do
   begin
      c := c + 1;

      if (MatchCase) then
         correspond := (ps[c] = SrcStr[0])
      else
         correspond := (0=AnsiCompareText(ps[c], SrcStr[0]));

      if correspond and (c + SrcLen < MaxPos) then begin
         found := true; //now let's verify the other characters...
         for n := 1 to SrcLen - 1 do begin
            if (MatchCase) then
               correspond := (ps[c + n] = SrcStr[n])
            else
               correspond := (0=AnsiCompareText(ps[c + n], SrcStr[n]));
            if not correspond then found := false;
         end;
         if found and WholeWord then begin
            if c > 0 then
               if AnsiPos(ps[c - 1], WORD_CHARACTERS) > 0 then
                  found := false;
               if AnsiPos(ps[c + SrcLen], WORD_CHARACTERS) > 0 then
                  found := false;
         end;
      end;
   end;//while

   if found then begin
      CodeEdit.SelStart := c;
      CodeEdit.SelEnd := CodeEdit.SelStart + Length(FindDialog1.FindText) - 1;
   end else
      ShowMessage('There are no more "' + FindDialog1.FindText + '"');
   end;
end;

procedure TfrmC2PasMain.Help1Click(Sender: TObject);
begin
   OpenDocument(InitialDir + '\docs\index.html');
end;

procedure TfrmC2PasMain.CodeEditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   CodeEditClick(Sender);
end;

procedure TfrmC2PasMain.CodeEditClick(Sender: TObject);
begin
   stbC2PasMain.Panels.Items[SB_CARETX].Text := 'C:' + IntToStr(CodeEdit.CaretX);
   stbC2PasMain.Panels.Items[SB_CARETY].Text := 'R:' + IntToStr(CodeEdit.CaretY);
end;

procedure TfrmC2PasMain.Gotoline1Click(Sender: TObject);
begin
   CodeEdit.CaretY := StrToInt(InputBox('Go to', 'Line:', IntToStr(CodeEdit.CaretY)));
end;

end.
