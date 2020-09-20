unit Frm_W2kMain;
{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}
interface

uses {$IFNDEF FPC} Windows,  {$ENDIF}Classes, Graphics, Forms, Controls, Menus,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, ImgList, StdActns,
  ActnList, ToolWin;
   // IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient
type
  TWin2kAppForm = class(TForm)
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    ActionList1: TActionList;
    FileNew1: TAction;
    FileOpen1: TAction;
    FileSave1: TAction;
    FileSaveAs1: TAction;
    FileSend1: TAction;
    FileExit1: TAction;
    EditCut1: TEditCut;
    EditCopy1: TEditCopy;
    EditPaste1: TEditPaste;
    HelpAbout1: TAction;
    StatusBar: TStatusBar;
    ImageList1: TImageList;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    FileNewItem: TMenuItem;
    FileOpenItem: TMenuItem;
    FileSaveItem: TMenuItem;
    FileSaveAsItem: TMenuItem;
    N1: TMenuItem;
    FileSendItem: TMenuItem;
    N2: TMenuItem;
    FileExitItem: TMenuItem;
    Edit1: TMenuItem;
    CutItem: TMenuItem;
    CopyItem: TMenuItem;
    PasteItem: TMenuItem;
    Help1: TMenuItem;
    HelpAboutItem: TMenuItem;
    SaveDialog1: TSaveDialog;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    PopupMenu1: TPopupMenu;
    Cut1: TMenuItem;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    RichEdit1: TMemo;
    ToolButton10: TToolButton;
 //   IdTCPClient2: TIdTCPClient;
    procedure FileNew1Execute(Sender: TObject);
    procedure FileOpen1Execute(Sender: TObject);
    procedure FileSave1Execute(Sender: TObject);
    procedure FileSaveAs1Execute(Sender: TObject);
    procedure FileSend1Execute(Sender: TObject);
    procedure FileExit1Execute(Sender: TObject);
    procedure HelpAbout1Execute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FFileName: String;
  public
    { Public-Deklarationen }
  end;

var
  Win2kAppForm: TWin2kAppForm;

implementation

uses
  SysUtils, {$IFDEF FPC} lclintf, {$ELSE} Mapi, {$ENDIF} frm_w2kabout{$IFDEF MSWINDOWS} , SHFolder {$ENDIF};

{$IFDEF FPC}
{$R *.lfm}
{$ELSE}
{$R *.dfm}
{$ENDIF}

resourcestring
  SUntitled  = 'Unbenannt';
  SOverwrite = 'Einverstanden mit Überschreiben von %s';
  SSendError = 'Fehler beim Versenden von Mail';

function DefaultSaveLocation: string;
var
  P: PChar;
begin
  {
    gibt den Speicherort von 'My Documents' zurück (sofern vorhanden), ansonsten wird 
    das aktuelle Verzeichnis zurückgegeben.
  }
  P := nil;
  try
    P := AllocMem(MAX_PATH);
    {$IFDEF MSWINDOWS}
    if SHGetFolderPath(0, CSIDL_PERSONAL, 0, 0, P) = S_OK then
      Result := P
    else
      Result := GetCurrentDir;
    {$ELSE}
      Result := '~';
    {$ENDIF}
  finally
    FreeMem(P);
  end;
end;

procedure TWin2kAppForm.FileNew1Execute(Sender: TObject);
begin
  SaveDialog.InitialDir := DefaultSaveLocation;
  FFileName := SUntitled;
  RichEdit1.Lines.Clear;
  RichEdit1.Modified := False;
end;

procedure TWin2kAppForm.FileOpen1Execute(Sender: TObject);
begin
  if OpenDialog.Execute then
  begin
    RichEdit1.Lines.LoadFromFile(OpenDialog.FileName);
    FFileName := OpenDialog.FileName;
    RichEdit1.SetFocus;
    RichEdit1.Modified := False;
    RichEdit1.ReadOnly := ofReadOnly in OpenDialog.Options;
  end;
end;

procedure TWin2kAppForm.FileSave1Execute(Sender: TObject);
begin
  if (FFileName = SUntitled) or (FFileName = '') then
    FileSaveAs1Execute(Sender)
  else
  begin
    RichEdit1.Lines.SaveToFile(FFileName);
    RichEdit1.Modified := False;
  end;
end;

procedure TWin2kAppForm.FileSaveAs1Execute(Sender: TObject);
begin
  with SaveDialog do
  begin
    FileName := FFileName;
    if Execute then
    begin
      if FileExists(FileName) then
        if MessageDlg(Format(SOverwrite, [FileName]),
          mtConfirmation, mbYesNoCancel, 0) <> mrYes then Exit;
      RichEdit1.Lines.SaveToFile(FileName);
      FFileName := FileName;
      RichEdit1.Modified := False;
    end;
  end;
end;

procedure TWin2kAppForm.FileSend1Execute(Sender: TObject);
var
  {$IFDEF FPC}
 // MapiMessage: Tfp;
  {$ELSE}
  MapiMessage: TMapiMessage;
  {$ENDIF}
  MError: Cardinal;
  subj,s:Ansistring;
begin
  if RichEdit1.Lines.Count>0 then
    subj := Ansistring(RichEdit1.Lines[0]);
  s := Ansistring(RichEdit1.Lines.Text);
  {$IFnDEF FPC}
  with MapiMessage do
  begin
    ulReserved := 0;
    lpszSubject := PAnsiChar(Subj);
    lpszNoteText := PAnsiChar(S);
    lpszMessageType := nil;
    lpszDateReceived := nil;
    lpszConversationID := nil; 
    flFlags := 0;
    lpOriginator := nil; 
    nRecipCount := 0;
    lpRecips := nil;
    nFileCount := 0;
    lpFiles := nil; 
  end;

  MError := MapiSendMail(0, Application.Handle, MapiMessage,         
    MAPI_DIALOG or MAPI_LOGON_UI or MAPI_NEW_SESSION, 0);
  {$ELSE}
     OpenDocument('mailto://?bcc=jc@jc99.de&subject='+subj.Replace(' ','%20')+'&body='+s);
   {$ENDIF}
   if MError <> 0 then MessageDlg(SSendError, mtError, [mbOK], 0);
end;

procedure TWin2kAppForm.FileExit1Execute(Sender: TObject);
begin
  Close;
end;

procedure TWin2kAppForm.HelpAbout1Execute(Sender: TObject);
begin
  AboutBox.ShowModal;
end;

procedure TWin2kAppForm.FormCreate(Sender: TObject);
begin
  FileNew1.Execute; { setzt den Standarddateinamen und leert das RichEdit-Steuerelement }
end;

end.
