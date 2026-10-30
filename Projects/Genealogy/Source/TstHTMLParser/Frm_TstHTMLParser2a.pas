unit Frm_TstHTMLParser2a;

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
  SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
  Buttons, ComCtrls, ExtCtrls, Unt_Config, FileUtil,
  VisualHTTPClient, htmlview,  fra_HtmlImp;

type

  { TfrmTestHtmlParsingMain }

  TfrmTestHtmlParsingMain = class(TForm)
    btnBrowseSchema: TBitBtn;
    btnLoadSchema: TBitBtn;
    btnSave: TBitBtn;
    btnSaveSchema: TBitBtn;
    btnWWW: TBitBtn;
    btnBrowseHtml: TBitBtn;
    btnDoParse: TBitBtn;
    btnLoadFile: TBitBtn;
    cbxFilename: TComboBox;
    cbxFilenameSchema: TComboBox;
    chbVerbose: TCheckBox;
    Config1: TConfig;
    FraHtmlImport1: TFraHtmlImport;
    ListBox1: TListBox;
    mOutput: TMemo;
    OpenDialog1: TOpenDialog;
    pnlBottomRight: TPanel;
    pnlBottomRight2: TPanel;
    pnlTopRight2: TPanel;
    pnlTopRight: TPanel;
    pnlBottom: TPanel;
    pnlTop: TPanel;
    SaveDialog1: TSaveDialog;
    splLeft: TSplitter;
    splRight: TSplitter;
    VisualHTTPClient1: TVisualHTTPClient;
    procedure btnWWWClick(Sender: TObject);
    procedure btnBrowseSchemaClick(Sender: TObject);
    procedure btnDoParseClick(Sender: TObject);
    procedure btnLoadSchemaClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnLoadFileClick(Sender: TObject);
    procedure btnBrowseHtmlClick(Sender: TObject);
    procedure btnSaveSchemaClick(Sender: TObject);
    procedure chbVerboseChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure splRightMoved(Sender: TObject);
  private
    { Private-Deklarationen }
    FlastTick: QWord;
    FDataPath: String;
    procedure FillFileList(Data: PtrInt);
    procedure HTMLImPSplitterMove(Sender: TObject);
    procedure LoadSchema(const lFilename: string);
    procedure OnFileFound(FileIterator: TFileIterator);
  public
    { Public-Deklarationen }

    Procedure ComputeFiltered(CType:byte;Text:String);
    procedure LoadFile(const lFilename: String);
  end;

var
  frmTestHtmlParsingMain: TfrmTestHtmlParsingMain;

implementation

uses Unt_FileProcs;

{$IFnDEF FPC}
  {$R *.lfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

{$if FPC_FULLVERSION = 30200 }
    {$WARN 6058 OFF}
{$ENDIF}

procedure TfrmTestHtmlParsingMain.btnBrowseSchemaClick(Sender: TObject);
var
  lRelp: String;
begin
  OpenDialog1.FileName:=FDatapath+cbxFilenameSchema.text;
  if OpenDialog1.Execute then
    begin
      lRelp:= ExtractRelativepath(ExpandFileName(FDatapath+DirectorySeparator),OpenDialog1.FileName);
      if not charinset(copy(lRelp,2,1)[1],['.',':',DirectorySeparator]) then
        cbxFilenameSchema.text:=lRelp
      else
        cbxFilenameSchema.text:=OpenDialog1.FileName;
      btnLoadSchemaClick(sender);
    end;
end;

procedure TfrmTestHtmlParsingMain.btnDoParseClick(Sender: TObject);
begin
  FraHtmlImport1.DoParse(sender);
end;

procedure TfrmTestHtmlParsingMain.btnWWWClick(Sender: TObject);
var
  sHTML: TCaption;
begin
          try
              sHTML := VisualHTTPClient1.Get(cbxFilename.Text);
              FraHtmlImport1.SetHtmlText(
                  sHTML, cbxFilename.Text);
        finally
end;
end;

procedure TfrmTestHtmlParsingMain.btnLoadSchemaClick(Sender: TObject);

  var
    i: Integer;

  begin
   if cbxFilenameSchema.ItemIndex > -1 then
     cbxFilenameSchema.Items.Delete(cbxFilenameSchema.ItemIndex);
   cbxFilenameSchema.Items.Insert(0,cbxFilenameSchema.Text);

   Config1.Value[cbxFilenameSchema, 'ICount'] := cbxFilenameSchema.Items.count;
   For i := 0 To cbxFilenameSchema.Items.count - 1 Do
     config1.Value[cbxFilenameSchema, inttostr(i)] := cbxFilenameSchema.Items[i];

   LoadSchema(cbxFilenameSchema.text);
end;

procedure TfrmTestHtmlParsingMain.btnLoadFileClick(Sender: TObject);
var
  i: Integer;
  lFilename: String;
begin
 if cbxFilename.ItemIndex = -1 then
   begin
   cbxFilename.Items.add(cbxFilename.Text);
   Config1.Value[cbxFilename, 'ICount'] := cbxFilename.Items.count;
   For i := 0 To cbxFilename.Items.count - 1 Do
     config1.Value[cbxFilename, inttostr(i)] := cbxFilename.Items[i];
   end;
  lFilename := cbxFilename.Text;
  LoadFile(lFilename);
  Application.QueueAsyncCall(FillFileList,0);
end;

procedure TfrmTestHtmlParsingMain.btnBrowseHtmlClick(Sender: TObject);
begin
  OpenDialog1.FileName:=cbxFilename.text;
  if OpenDialog1.Execute then
    begin
      cbxFilename.text:=OpenDialog1.FileName;
      btnLoadFileClick(sender);
    end;
end;

procedure TfrmTestHtmlParsingMain.btnSaveSchemaClick(Sender: TObject);
var
  i: Integer;
  lRelp: String;
begin
  if not charinset(copy(cbxFilenameSchema.Text,2,1)[1],['.',':',DirectorySeparator]) then
    SaveDialog1.FileName := FDataPath+DirectorySeparator+ cbxFilenameSchema.Text
  else
    SaveDialog1.FileName := cbxFilenameSchema.Text;

  SaveDialog1.DefaultExt:='.txt';
  if SaveDialog1.Execute then
  begin
    SaveFile(FraHtmlImport1.SchemaSaveToFile,SaveDialog1.FileName);

    lRelp:= ExtractRelativepath(ExpandFileName(FDatapath+DirectorySeparator),SaveDialog1.FileName);
      if not charinset(copy(lRelp,2,1)[1],['.',':',DirectorySeparator]) then
        cbxFilenameSchema.text:=lRelp
      else
        cbxFilenameSchema.text:=SaveDialog1.FileName;
    if cbxFilenameSchema.ItemIndex = -1 then
      begin
    cbxFilenameSchema.Items.add(cbxFilenameSchema.Text);
    Config1.Value[cbxFilenameSchema, 'ICount'] := cbxFilenameSchema.Items.count;
    For i := 0 To cbxFilenameSchema.Items.count - 1 Do
      config1.Value[cbxFilenameSchema, inttostr(i)] := cbxFilenameSchema.Items[i];
      end;
    end;
end;

procedure TfrmTestHtmlParsingMain.chbVerboseChange(Sender: TObject);
begin
  FraHtmlImport1.Verbose := chbVerbose.Checked;
end;

procedure TfrmTestHtmlParsingMain.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  FraHtmlImport1.OnComputeOutput:=ComputeFiltered;
  FraHtmlImport1.OnSplitterMove:=HTMLImPSplitterMove;
  FDatapath := 'Data';
  for i := 0 to 2 do
    if DirectoryExists(FDataPath) then
      Break
    else
      FDataPath:='..'+DirectorySeparator+FDataPath;
end;

procedure TfrmTestHtmlParsingMain.FormDeactivate(Sender: TObject);
begin

end;

procedure TfrmTestHtmlParsingMain.FormShow(Sender: TObject);
Var
   CBCount, i: Integer;
 Begin
   CBCount := Config1.getValue(cbxFilename, 'ICount', 0);
   For i := 0 To CBCount - 1 Do
     begin
       cbxFilename.Items.Add(Config1.getValue(cbxFilename, inttostr(i), ''));
       if i=0 then
         begin
           cbxFilename.ItemIndex :=i;
           LoadFile(cbxFilename.text);
         end
     end;
   CBCount := Config1.getValue(cbxFilenameSchema, 'ICount', 0);
   For i := 0 To CBCount - 1 Do
     begin
       cbxFilenameSchema.Items.Add(Config1.getValue(cbxFilenameSchema, inttostr(i), ''));
       if i=0 then
         begin
           cbxFilenameSchema.ItemIndex :=i;
           LoadSchema(cbxFilenameSchema.text);
         end
     end;
end;

procedure TfrmTestHtmlParsingMain.ListBox1DblClick(Sender: TObject);
var
  lFilename: string;
begin
  lFilename := ExtractFilePath(cbxFilename.text)+ListBox1.Items[ListBox1.ItemIndex];
  LoadFile(lfilename);
  FraHtmlImport1.DoParse(Sender);
end;

procedure TfrmTestHtmlParsingMain.splRightMoved(Sender: TObject);
begin
  pnlTopRight2.Width:=mOutput.Width+splRight.width div 2;
  pnlBottomRight2.Width:=mOutput.Width+splRight.width div 2;
end;

procedure TfrmTestHtmlParsingMain.FillFileList(Data: PtrInt);
var
  lFileSearcher: TFileSearcher;
  lSearchPath, lSearchMask: string;
begin
  lFileSearcher:= TFileSearcher.Create ;
  ListBox1.Clear;
  try
  lFileSearcher.OnFileFound:=OnFileFound;
  lSearchPath := ExtractFilePath(cbxFilename.Text)+'..' ;
  lSearchMask := copy(ExtractFileName(cbxFilename.Text),1,1)+'*'+ExtractFileExt(cbxFilename.Text);
  lFileSearcher.Search( lSearchPath, lSearchMask , true, false);
  finally
    freeandnil(lFileSearcher);
  end;
end;

procedure TfrmTestHtmlParsingMain.HTMLImPSplitterMove(Sender: TObject);
begin
  pnlTopRight.Width:=FraHtmlImport1.mSchema.Width+2;
  pnlBottomRight.Width:=FraHtmlImport1.mSchema.Width+2;
end;

procedure TfrmTestHtmlParsingMain.LoadSchema(const lFilename: string);
var
  s: string = '';
  sf: TFileStream;

begin
  if not charinset(copy(lFilename,2,1)[1],['.',':',DirectorySeparator]) then
     sf := TFileStream.Create( FDataPath+DirectorySeparator+ lFilename , fmOpenRead)
   else
     sf := TFileStream.Create(lFilename, fmOpenRead);

   try
     setlength(s, sf.Size);
     sf.ReadBuffer(s[1], sf.Size);
   finally
     FreeAndNil(sf);
   end;
   FraHtmlImport1.SetSchema(s);
end;

procedure TfrmTestHtmlParsingMain.OnFileFound(FileIterator: TFileIterator);
begin
  Listbox1.AddItem(ExtractRelativepath(ExtractFilePath(cbxFilename.Text), FileIterator.FileName),nil);
  if FlastTick+500<  GetTickCount64 then
    begin
      Application.ProcessMessages;
      FlastTick := GetTickCount64;
    end;
end;

procedure TfrmTestHtmlParsingMain.btnSaveClick(Sender: TObject);
begin
  SaveDialog1.FileName := cbxFilename.Text;
  if SaveDialog1.Execute then
  begin
    if fileexists(SaveDialog1.FileName) then
      RenameFile(SaveDialog1.FileName, ChangeFileExt(SaveDialog1.FileName,
        '.bak'));
    mOutput.Lines.SaveToFile(SaveDialog1.FileName);
  end;
end;

procedure TfrmTestHtmlParsingMain.ComputeFiltered(CType: byte; Text: String);
begin
  if ctype in [0,2,3] then
    mOutput.Lines.add(inttostr(CType)+': '+text);
end;

procedure TfrmTestHtmlParsingMain.LoadFile(const lFilename: String);
var
  s: string = '';
  sf: TFileStream;
begin
  if not FileExists(lFilename) then exit;
  sf := TFileStream.Create(lFilename, fmOpenRead);
  try
    setlength(s, sf.Size);
    sf.ReadBuffer(s[1], sf.Size);

  finally
    FreeAndNil(sf);
  end;
  FraHtmlImport1.SetHtmlText(s, lFilename);
end;

end.
