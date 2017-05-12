(* =========================================================== *(
**  Main.Pas -- Tab control application                        **
** ........................................................... **
**  This program inserts, removes, and converts tab controls   **
**  in text files. For example, you can use Tabs to replace    **
**  tabs in a .Pas file with blank spaces; or you can replace  **
**  blanks with 8-column tabs (or any other column setting).   **
**  The program can also convert an X-column-tabbed file to    **
**  a Y-column-tabbed file--replacing 4-column tabs with 8-    **
**  column tabs, for example.                                  **
** ........................................................... **
**  WARNING: Although this program optionally saves a backup   **
**  copy of processed files, you should run it only on a copy  **
**  of sensitive source code and other text files.             **
** ........................................................... **
**  Copyright (c) 1995,1998 by Tom Swan. All rights reserved.  **
)* =========================================================== *)

unit Frm_TabsMAIN;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Buttons, StdCtrls, ExtCtrls, Menus,
  Frm_About, Frm_Options, TabsUnit;

type
  TMainForm = class(TForm)
    MainMenu1: TMainMenu;
    FileMenu: TMenuItem;
    FileOpen: TMenuItem;
    N1: TMenuItem;
    FileExit: TMenuItem;
    OptionsMenu: TMenuItem;
    OptionsSettings: TMenuItem;
    OptionsReset: TMenuItem;
    N2: TMenuItem;
    OptionsSave: TMenuItem;
    OptionsLoad: TMenuItem;
    HelpMenu: TMenuItem;
    HelpAbout: TMenuItem;
    HelpHow: TMenuItem;
    HelpSearch: TMenuItem;
    HelpContents: TMenuItem;
    N3: TMenuItem;
    ToolbarPanel: TPanel;
    ExitBitBtn: TBitBtn;
    StatusPanel: TPanel;
    OpenSB: TSpeedButton;
    ExitSB: TSpeedButton;
    OptionsSB: TSpeedButton;
    SaveSB: TSpeedButton;
    LoadSB: TSpeedButton;
    InsertSB: TSpeedButton;
    RemoveSB: TSpeedButton;
    ConvertSB: TSpeedButton;
    HelpSB: TSpeedButton;
    TabPanel: TPanel;
    TimePanel: TPanel;
    KeyPanel: TPanel;
    Timer1: TTimer;
    OpenDialog1: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure FileExitClick(Sender: TObject);
    procedure HelpAboutClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure HelpSBClick(Sender: TObject);
    procedure OptionsSettingsClick(Sender: TObject);
    procedure OptionsResetClick(Sender: TObject);
    procedure OptionsSaveClick(Sender: TObject);
    procedure OptionsLoadClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FileOpenClick(Sender: TObject);
    procedure InsertSBClick(Sender: TObject);
    procedure RemoveSBClick(Sender: TObject);
    procedure ConvertSBClick(Sender: TObject);
  private
    { Private declarations }
    procedure UpdateStatusPanel;
    procedure UpdateToolbar;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

const

{- Options dialog RadioGroup selections }
  optInsert  = 0;
  optRemove  = 1;
  optConvert = 2;

{- Update status panel settings (tab settings only) }
procedure TMainForm.UpdateStatusPanel;
begin
  with OptionsDialog do
  TabPanel.Caption := Format('Tabs: In %d  Out %d',
    [InTabEdit.Value, OutTabEdit.Value]);
end;

{- Update toolbar button states }
procedure TMainForm.UpdateToolbar;
begin
  case OptionsDialog.OperationRGroup.ItemIndex of
    optInsert:
      InsertSB.Down := True;
    optRemove:
      RemoveSB.Down := True;
    optConvert:
      ConvertSB.Down := True;
  end;
end;

{- Perform setups at form's creation }
procedure TMainForm.FormCreate(Sender: TObject);
begin
{- Steal glyph from Exit BitBtn for toolbar }
  ExitSB.Glyph := ExitBitBtn.Glyph;
end;

{- Respond to File|Exit command }
procedure TMainForm.FileExitClick(Sender: TObject);
begin
  Close;
end;

{- Display About dialog }
procedure TMainForm.HelpAboutClick(Sender: TObject);
begin
  AboutForm.ShowModal;
end;

{- Update status panel time display }
procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  TimePanel.Caption := TimeToStr(Time);
end;

{- Respond to Help command (not implemented) }
procedure TMainForm.HelpSBClick(Sender: TObject);
begin
  ShowMessage('Sorry: Not Implemented!');
end;

{- Display options dialog; update toolbar and status panel }
procedure TMainForm.OptionsSettingsClick(Sender: TObject);
begin
  if OptionsDialog.ShowModal = mrOk then
  begin
    UpdateStatusPanel;
    UpdateToolbar;
  end;
end;

{- Reset options dialog to default settings }
procedure TMainForm.OptionsResetClick(Sender: TObject);
begin
  if Yes('Reset options to default settings?') then
  begin
    OptionsDialog.InitTabOptions;
    UpdateStatusPanel;
    UpdateToolbar;
  end;
end;

{- Save options dialog settings in .Ini file }
procedure TMainForm.OptionsSaveClick(Sender: TObject);
begin
  OptionsDialog.SaveOptions;
end;

{- Load options dialog settings from .Ini file }
procedure TMainForm.OptionsLoadClick(Sender: TObject);
begin
  OptionsDialog.LoadOptions;
  UpdateStatusPanel;
  UpdateToolbar;
end;

{- Perform setups on form's activation }
procedure TMainForm.FormActivate(Sender: TObject);
begin
{ Can't do this in OnCreate because Options dialog
  object doesn't exist until after the main form is created. }
  UpdateStatusPanel;
end;

{- Respond to File|Open command; process tabs in file }
procedure TMainForm.FileOpenClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
  with OptionsDialog, OpenDialog1 do
  case OperationRGroup.ItemIndex of
    optInsert:
    begin
      if Yes('Insert tabs into ' + FileName + '?') then
        if ProcessTabs(FileName, True, BackupCheckbox.Checked) then
          MessageDlg('Tabs inserted into ' + FileName,
            mtInformation, [mbOk], 0);
    end;
    optRemove:
    begin
      if Yes('Remove tabs from ' + FileName + '?') then
        if ProcessTabs(FileName, False, BackupCheckbox.Checked) then
          MessageDlg('Tabs removed from ' + FileName,
            mtInformation, [mbOk], 0);
    end;
    optConvert:
    begin
      if Yes('Convert tabs in ' + FileName + '?') then
        if ProcessTabs(FileName, False, BackupCheckbox.Checked) then
          if ProcessTabs(FileName, True, False) then
            MessageDlg('Tabs converted in ' + FileName,
              mtInformation, [mbOk], 0);
    end;
  end;
end;

{- Clicked Insert button; update options dialog to match }
procedure TMainForm.InsertSBClick(Sender: TObject);
begin
  OptionsDialog.OperationRGroup.ItemIndex := optInsert;
end;

{- Clicked Remove button; update options dialog to match }
procedure TMainForm.RemoveSBClick(Sender: TObject);
begin
  OptionsDialog.OperationRGroup.ItemIndex := optRemove;
end;

{- Clicked Convert button; update options dialog to match }
procedure TMainForm.ConvertSBClick(Sender: TObject);
begin
  OptionsDialog.OperationRGroup.ItemIndex := optConvert;
end;

end.

(*
// ==============================================================
// Copyright (c) 1995 by Tom Swan. All rights reserved
// Revision 1.00    Date: 2/24/1991
// Revision 2.00    Date: 7/25/1995
// - Converted to Delphi from Borland Pascal Turbo Vision
*)

