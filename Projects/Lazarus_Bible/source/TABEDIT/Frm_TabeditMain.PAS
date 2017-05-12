unit Frm_TabeditMain;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, Tabs, Menus, Frm_AboutTabedit,
  Clipbrd;

type
  TfrmMainForm = class(TForm)
    MainMenu1: TMainMenu;
    FileMenu: TMenuItem;
    FileExit: TMenuItem;
    N1: TMenuItem;
    FilePrintSetup: TMenuItem;
    FilePrint: TMenuItem;
    N2: TMenuItem;
    FileSaveAs: TMenuItem;
    FileSave: TMenuItem;
    N3: TMenuItem;
    FileClose: TMenuItem;
    FileOpen: TMenuItem;
    FileNew: TMenuItem;
    EditMenu: TMenuItem;
    EditPaste: TMenuItem;
    EditCopy: TMenuItem;
    EditCut: TMenuItem;
    HelpMenu: TMenuItem;
    HelpAbout: TMenuItem;
    TabSet1: TTabSet;
    Memo1: TMemo;
    OptionsMenu: TMenuItem;
    OptionsFont: TMenuItem;
    OptionsBackground: TMenuItem;
    FileOpenDialog: TOpenDialog;
    FileSaveDialog: TSaveDialog;
    FontDialog1: TFontDialog;
    ColorDialog1: TColorDialog;
    FindDialog: TFindDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FileOpenClick(Sender: TObject);
    procedure FileSaveClick(Sender: TObject);
    procedure FileSaveAsClick(Sender: TObject);
    procedure FileExitClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject;
      var CanClose: Boolean);
    procedure FileNewClick(Sender: TObject);
    procedure TabSet1Change(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure TabSet1Click(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure FileCloseClick(Sender: TObject);
    procedure EditCutClick(Sender: TObject);
    procedure EditCopyClick(Sender: TObject);
    procedure EditPasteClick(Sender: TObject);
    procedure OptionsFontClick(Sender: TObject);
    procedure OptionsBackgroundClick(Sender: TObject);
    procedure HelpAboutClick(Sender: TObject);
    procedure FileMenuClick(Sender: TObject);
    procedure EditMenuClick(Sender: TObject);
  private
    procedure EnableFileMenu;
    procedure EnableEditMenu;
    procedure SetFilename(const Path: String);
    procedure LoadFile(const Path: String);
    procedure SaveFile(Index: Integer);
    function AllFilesSaved: Boolean;
  public
  end;

var
  frmMainForm: TfrmMainForm;

implementation

{$R *.DFM}

const
  maxPages = 8;
  untitledName = '[untitled]';

type
  TPageRec = record
    Filename: String;
    Dirty: Boolean;
    Page: TStringList;
  end;

var
  Pages: array[0 .. maxPages - 1] of TPageRec;

{ Enable / disable File menu commands }
procedure TfrmMainForm.EnableFileMenu;
var
  I: Integer;
begin
  with FileMenu do
    for I := 0 to Count - 1 do     { Enable all File commands }
      Items[I].Enabled := True;
  with TabSet1, Pages[TabIndex] do
    if (not Dirty) or (Filename = untitledName) then
      FileSave.Enabled := False;     { Must use Save as }
end;

{ Enable / disable Edit menu commands }
procedure TfrmMainForm.EnableEditMenu;
var
  I: Integer;
begin
  with EditMenu do
  begin
    for I := 0 to Count - 1 do     { Enable all Edit commands }
      Items[I].Enabled := True;
    with TabSet1, Pages[TabIndex] do
    begin
      if Memo1.SelLength = 0 then
      begin
        EditCut.Enabled := False;      { No selected text }
        EditCopy.Enabled := False;
      end;
      if not Clipboard.HasFormat(cf_Text) then
        EditPaste.Enabled := False;
    end;
  end;
end;

{ Save path as current filename and page tab label }
procedure TfrmMainForm.SetFilename(const Path: String);
var
  S: String[12];  { Filename.ext }
begin
  with TabSet1, Pages[TabIndex] do
  begin
    Filename := Lowercase(Path);
    S := ExtractFilename(Filename);
    S[1] := UpCase(S[1]);
    Tabs[TabIndex] := S;
  end;
end;

{ Read file from disk }
procedure TfrmMainForm.LoadFile(const Path: String);
begin
  with Pages[TabSet1.TabIndex] do
  try
    Memo1.Lines.LoadFromFile(Path);
    Dirty := False;
    Page.Clear;
    SetFilename(Path);
  except on e: EReadError do
    MessageDlg('Error reading file', mtError, [mbOk], 0);
  end;
end;

{ Write current file to disk }
procedure TfrmMainForm.SaveFile(Index: Integer);
begin
  with TabSet1, Pages[Index] do
  begin
    try
      Memo1.Lines.SaveToFile(Filename);
      Dirty := False;
    except on e:EWriteError do
      MessageDlg('Error writing file', mtError, [mbOk], 0);
    end;
  end;
end;

{ Return true if all files are saved }
function TfrmMainForm.AllFilesSaved: Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to maxPages - 1 do with Pages[I] do
    if Dirty then Exit;
  Result := True;
end;

{ Initialize variables }
procedure TfrmMainForm.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to maxPages - 1 do with Pages[I] do
  begin
    Filename := '';
    Dirty := False;
    Page := nil;
  end;
  with Pages[0] do
  begin
    Page := TStringList.Create;
    Filename := untitledName;
  end;
  FontDialog1.Font := Memo1.Font;
end;

{ Last chance to clean up before program ends }
procedure TfrmMainForm.FormDestroy(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to maxPages - 1 do with Pages[I] do
    if Page <> nil then
      Page.Free;
end;

{ File|New command }
procedure TfrmMainForm.FileNewClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to maxPages - 1 do with TabSet1, Pages[I] do
  if Page = nil then
  begin
    Page := TStringList.Create;
    Filename := untitledName;
    Dirty := False;
    Tabs.Add(Filename);
    Exit;
  end;
end;

{ File|Open command }
procedure TfrmMainForm.FileOpenClick(Sender: TObject);
begin
  with Pages[TabSet1.TabIndex] do
  begin
    if Dirty then FileSaveClick(Sender);
    if {still} Dirty then Exit;  { File not saved }
    if FileOpenDialog.Execute then
      LoadFile(FileOpenDialog.Filename);
  end;
end;

{ File|Close command }
procedure TfrmMainForm.FileCloseClick(Sender: TObject);
var
  W: Word;
begin
  with TabSet1, Pages[TabIndex] do
  begin
    if Dirty then
    begin
      W := MessageDlg('Save changes to ' + Tabs[TabIndex] + '?',
      mtWarning, [mbYes, mbNo, mbCancel], 0);
      case W of
        mrYes: FileSaveClick(Sender);
        mrNo: Dirty := False;
        mrCancel: Exit;
      end;
    end;
    if {still} Dirty then Exit;  { File not saved }
    Page.Clear;
    Memo1.Clear;
    Filename := untitledName;
    Tabs[TabIndex] := Filename;
  end;
end;

{ File|Save command }
procedure TfrmMainForm.FileSaveClick(Sender: TObject);
begin
  with TabSet1, Pages[TabIndex] do
  if Filename = untitledName then
    FileSaveAsClick(Sender)
  else
    SaveFile(TabIndex);
end;

{ File|Save As command }
procedure TfrmMainForm.FileSaveAsClick(Sender: TObject);
begin
  with TabSet1, Pages[TabIndex] do                               
  if FileSaveDialog.Execute then
  begin
    SetFilename(FileSaveDialog.Filename);
    SaveFile(TabIndex);
  end;
end;

{ File|Exit command }
procedure TfrmMainForm.FileExitClick(Sender: TObject);
begin
  Close;
end;

{ Check for unsaved files and prompt user before program ends }
procedure TfrmMainForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  I: Integer;
  W: Word;
begin
  CanClose := True;
  for I := 0 to maxPages - 1 do with TabSet1, Pages[I] do
  if Dirty then
  begin
    W := MessageDlg('Save changes to ' + Tabs[I] + '?',
      mtWarning, [mbYes, mbNo, mbCancel], 0);
    case W of
      mrYes: SaveFile(I);
      mrNo: Dirty := False;
      mrCancel: CanClose := False;
    end;
  end;
  if CanClose then
    CanClose := AllFilesSaved;
end;

{ A tab is changing. Save Memo's text in a TStringList object }
procedure TfrmMainForm.TabSet1Change(Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
begin
  with TabSet1, Pages[TabIndex] do
  begin
    Page.Clear;
    Page.Assign(Memo1.Lines);
  end;
end;

{ A tab has changed. Assign a TStringList object to Memo }
procedure TfrmMainForm.TabSet1Click(Sender: TObject);
begin
  with TabSet1 do
    Memo1.Lines.Assign(Pages[TabIndex].Page);
end;

procedure TfrmMainForm.Memo1Change(Sender: TObject);
begin
  Pages[TabSet1.TabIndex].Dirty := True;
end;

procedure TfrmMainForm.EditCutClick(Sender: TObject);
begin
  Memo1.CutToClipboard;
end;

procedure TfrmMainForm.EditCopyClick(Sender: TObject);
begin
  Memo1.CopyToClipboard;
end;

procedure TfrmMainForm.EditPasteClick(Sender: TObject);
begin
  Memo1.PasteFromClipboard;
end;

procedure TfrmMainForm.OptionsFontClick(Sender: TObject);
begin
  if FontDialog1.Execute then
    Memo1.Font := FontDialog1.Font;
end;

procedure TfrmMainForm.OptionsBackgroundClick(Sender: TObject);
begin
  if ColorDialog1.Execute then
    Memo1.Color := ColorDialog1.Color;
end;

procedure TfrmMainForm.HelpAboutClick(Sender: TObject);
begin
  frmAboutForm.ShowModal;
end;

procedure TfrmMainForm.FileMenuClick(Sender: TObject);
begin
  EnableFileMenu;
end;

procedure TfrmMainForm.EditMenuClick(Sender: TObject);
begin
  EnableEditMenu;
end;

end.
