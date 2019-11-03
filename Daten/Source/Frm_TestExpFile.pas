UNIT Frm_TestExpFile;

INTERFACE

USES
  SysUtils,
  SysConst,
  Types,
  Classes,
  Variants,
{$IFNDEF Osx}
  windows,
{$ENDIF}
  Controls,
  Forms,
  Dialogs,
{$IFNDEF FMx}

    ComCtrls, StdCtrls, ExtCtrls, Buttons,
{$ELSE}
  Memo,
  Edit,
  ListBox,
  {$ENDIF}
  Menus,
  Rtti,
  unt_Cdate;

TYPE
  TForm4 = CLASS(TForm)
    Memo1: TMemo;
    OpenDialog1: TOpenDialog;
    StatusBar1: TStatusBar;
    Memo2: TMemo;
    MenuBar1: TMainMenu;
    mniFile: TMenuItem;
    mniEdit: TMenuItem;
    mniHelp: TMenuItem;

    mniFileNew: TMenuItem;
    mniFileOpen: TMenuItem;
    mniFileSave: TMenuItem;
    mniFileClose: TMenuItem;
    mniFileSaveAs: TMenuItem;
    mniBreaker: TMenuItem;
    mniFileExit: TMenuItem;
    SaveDialog1: TSaveDialog;


    Label1: TLabel;

    mniOptions: TMenuItem;
    mniLang: TMenuItem;
    mniLang_en: TMenuItem;
    mniEditFormat: TMenuItem;
    PopupMenu1: TPopupMenu;

    mniTestForm: TMenuItem;
    Panel1: TPanel;
    btnFileOpen: TSpeedButton;
    Edit1: TEdit;
    btnFileSaveAs: TSpeedButton;
    btnExecute: TSpeedButton;
    ListBox1: TListBox;
    PROCEDURE btnFileOpenClick(Sender: TObject);
    PROCEDURE mniFileExitClick(Sender: TObject);
    PROCEDURE mniFileSaveAsClick(Sender: TObject);
    PROCEDURE Memo1Change(Sender: TObject);
    PROCEDURE mniFileSaveClick(Sender: TObject);
    PROCEDURE FormActivate(Sender: TObject);
    PROCEDURE mniFileNewClick(Sender: TObject);
    PROCEDURE btnExecuteClick(Sender: TObject);
    PROCEDURE FormCreate(Sender: TObject);
    PROCEDURE mniLang_enClick(Sender: TObject);
    PROCEDURE FormCloseQuery(Sender: TObject; VAR CanClose: Boolean);
    procedure mniTestFormClick(Sender: TObject);
  PRIVATE
    { Private-Deklarationen }
    FMemoChanged: Boolean;
    FFileDate:    TDateTime;
    Filehandle:   NativeUInt;
    PROCEDURE SetMemo1Changed(NewVal: Boolean);
    FUNCTION CheckSaved: Boolean;
  PUBLIC
    { Public-Deklarationen }
    PROPERTY Memo1Changed: Boolean READ FMemoChanged WRITE SetMemo1Changed;

  END;

VAR
  Form4: TForm4;

IMPLEMENTATION

{$R *.dfm}

USES unt_fileProcs,
  Frm_TestExpFileInt,
  cmp_sewFile;

RESOURCESTRING
  strUntitled = 'Untitled';
  strReloadQuestion = 'File %0:s has been changed. Reload ?';
  strSaveQuestion = 'File %0:s has been changed. Save ?';
  strCompileInfo = 'Compiled: %0:s'#10#13'on: %1:s';
  strFileExists = '%0:s'#10#13'already exists, replace existing file ?';

PROCEDURE TForm4.btnExecuteClick(Sender: TObject);
BEGIN
  SEWFile.LoadfromStrings(Memo1.Lines);
  SEWFile.AutoFormat;
  Memo1.Lines := SEWFile.Lines;
END;

PROCEDURE TForm4.btnFileOpenClick(Sender: TObject);
VAR
  FDate: Integer;
BEGIN
  IF CheckSaved THEN
    BEGIN
      OpenDialog1.FileName := Edit1.Text;
      OpenDialog1.Filter := SEWFile.FileOpenFilter;
      IF OpenDialog1.Execute THEN
        IF FileExists(OpenDialog1.FileName) THEN
          BEGIN
            Edit1.Text := OpenDialog1.FileName;
            Memo1.Lines.LoadFromFile(Edit1.Text);
            Memo2.Lines.Text := getFileInfo(Edit1.Text, false);
            Filehandle := Fileopen(Edit1.Text, fmOpenRead OR fmShareDenyNone);
            FDate := FileGetDate(Filehandle);
            FileClose(Filehandle);
            FFileDate := filedatetoDatetime(FDate);
            Memo1Changed := false;
          END;
    END;
END;

PROCEDURE TForm4.FormActivate(Sender: TObject);
VAR
  NewFileDate: TDateTime;

BEGIN
  IF FileExists(Edit1.Text) THEN
    BEGIN
      Filehandle := Fileopen(Edit1.Text, fmOpenRead OR fmShareDenyNone);
      NewFileDate := filedatetoDatetime(FileGetDate(Filehandle));
      FileClose(Filehandle);
      IF NewFileDate <> FFileDate THEN
        BEGIN
          FFileDate := NewFileDate;
          IF MessageDlg(format(strReloadQuestion, [Edit1.Text]), TMsgDlgType(3), mbYesNo,
            0) = mryes THEN
            BEGIN
              Memo1.Lines.LoadFromFile(Edit1.Text);
              Memo2.Lines.Text := getFileInfo(Edit1.Text, false);
              Memo1Changed := false;
            END
        END;
    END;
END;

PROCEDURE TForm4.FormCloseQuery(Sender: TObject; VAR CanClose: Boolean);

BEGIN
  CanClose := CheckSaved;
END;

PROCEDURE TForm4.FormCreate(Sender: TObject);
VAR
  i:    Integer;
  Item: TMenuItem;
BEGIN
  ListBox1.Items := SEWFile.Options;
  Label1.Caption := format(strCompileInfo, [cdate, cname]);
  {
  FOR i := 1 TO vgLang1.Resources.Count - 1 DO
    IF vgLang1.Resources[i] <> '' THEN
      BEGIN
        Item := TMenuItem.Create(Self);
        Item.Parent := mniLang;
        Item.Text := vgLang1.Resources[i];
        Item.AutoTranslate := false;
        Item.OnClick := mniLang_en.OnClick;
      END;        }
  FMemoChanged := false;
  mniFileNewClick(Sender);
END;

PROCEDURE TForm4.Memo1Change(Sender: TObject);
BEGIN
  Memo1Changed := true;
END;

PROCEDURE TForm4.mniFileExitClick(Sender: TObject);
BEGIN
  close;
END;

PROCEDURE TForm4.mniFileNewClick(Sender: TObject);
BEGIN
  IF CheckSaved THEN
    BEGIN
      Edit1.Text := strUntitled;
      Memo1.Lines.clear;
      Memo2.Lines.clear;
      Memo1Changed := false;
    END;
END;

PROCEDURE TForm4.mniFileSaveAsClick(Sender: TObject);
BEGIN
  SaveDialog1.FileName := Edit1.Text;
  SaveDialog1.Filter := SEWFile.FileOpenFilter;
  IF SaveDialog1.Execute THEN
    BEGIN
      IF ExtractFileExt(SaveDialog1.FileName) = '' THEN
        BEGIN
          SaveDialog1.FileName := SaveDialog1.FileName + SEWFile.Extensions[1];
        END;
      IF FileExists(SaveDialog1.FileName) AND
        (MessageDlg(format(strFileExists, [SaveDialog1.FileName]),
        TMsgDlgType.mtConfirmation, mbYesNo, 0) = mrNo) THEN
        exit;
      Edit1.Text := SaveDialog1.FileName;
      mniFileSaveClick(Sender);
    END;
END;

PROCEDURE TForm4.mniFileSaveClick(Sender: TObject);
VAR
  bakFile: STRING;
BEGIN
  IF (Edit1.Text = '') OR (Edit1.Text = strUntitled) THEN
    mniFileSaveAsClick(Sender)
  ELSE
    BEGIN
      IF FileExists(Edit1.Text) THEN
        TRY
          bakFile := ChangeFileExt(Edit1.Text, '.BAK');
          IF FileExists(bakFile) THEN
            DeleteFile(@bakFile);
          RenameFile(Edit1.Text, bakFile)
        FINALLY
        END;
      Memo1.Lines.SaveToFile(Edit1.Text);
      Filehandle := Fileopen(Edit1.Text, fmOpenRead OR fmShareDenyNone);
      FFileDate := filedatetoDatetime(FileGetDate(Filehandle));
      FileClose(Filehandle);
      Memo1Changed := false;
    END;
END;

PROCEDURE TForm4.mniLang_enClick(Sender: TObject);
BEGIN
 { IF Sender.InheritsFrom(TMenuItem) THEN
    vgLang1.Lang := TMenuItem(Sender).Text;  }
END;

procedure TForm4.mniTestFormClick(Sender: TObject);
begin
  frmTestExpComp.Show;
end;

PROCEDURE TForm4.SetMemo1Changed(NewVal: Boolean);
BEGIN
  IF NewVal <> FMemoChanged THEN
    BEGIN
      FMemoChanged := NewVal;
      mniFileSave.Enabled := FMemoChanged;
    END;
END;

FUNCTION TForm4.CheckSaved: Boolean;
VAR
  mr: Integer;
BEGIN
  result := true;
  IF Memo1Changed THEN
    BEGIN
      mr := MessageDlg(format(strSaveQuestion, [Edit1.Text]), TMsgDlgType.mtConfirmation,
        mbYesNoCancel, 0);
      IF mr = mryes THEN
        mniFileSaveClick(Self)
      ELSE IF mr = mrCancel THEN
        result := false;
    END;
END;

END.
