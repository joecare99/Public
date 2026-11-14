unit Frm_TstHTMLParser2b;

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
    VisualHTTPClient, htmlview,  fra_HtmlImp, cls_h2gStep2,
    cls_GedComHelper,Cmp_GedComFile,cls_GenealogieHelper;

type

    { TfrmTestHtmlParsingMain }

    TfrmTestHtmlParsingMain = class(TForm)
        BitBtn1: TBitBtn;
        btnAutoEstBirth: TButton;
        btnAutoSetName: TButton;
        btnBrowseHtml: TBitBtn;
        btnBrowseSchema: TBitBtn;
        btnDoParse: TBitBtn;
        btnLoadFile: TBitBtn;
        btnLoadSchema: TBitBtn;
        btnSave: TBitBtn;
        btnSaveGC: TBitBtn;
        btnSaveSchema: TBitBtn;
        Button1: TButton;
        cbxFilename: TComboBox;
        cbxFilenameSchema: TComboBox;
        chbVerbose: TCheckBox;
        chbVisSchema: TCheckBox;
        chbVisSchema1: TCheckBox;
        chbVisSchema2: TCheckBox;
        Config1: TConfig;
        edtIDPrepos: TEdit;
        Label1: TLabel;
        Label2: TLabel;
        lblEstBirthResult: TLabel;
        lblSetNameResult: TLabel;
        ListBox1: TListBox;
        Memo1: TMemo;
        Memo2: TMemo;
        mOutput: TMemo;
        OpenDialog1: TOpenDialog;
        pnlRight3: TPanel;
        pnlBottomRight2: TPanel;
        pnlBottomRight3: TPanel;
        pnlBottomRight4: TPanel;
        pnlTopRight2: TPanel;
        pnlRight: TPanel;
        pnlBottomRight: TPanel;
        pnlTopRight: TPanel;
        pnlBottom: TPanel;
        pnlTop: TPanel;
        pnlTopRight3: TPanel;
        pnlTopRight4: TPanel;
        ptnClear: TBitBtn;
        SaveDialog1: TSaveDialog;
        Splitter1: TSplitter;
        Splitter2: TSplitter;
        splLeft: TSplitter;
        splRight: TSplitter;
        VisualHTTPClient1: TVisualHTTPClient;
        procedure BitBtn1Click(Sender: TObject);
        procedure btnAutoEstBirthClick(Sender: TObject);
        procedure btnAutoSetNameClick(Sender: TObject);
        procedure btnBrowseSchemaClick(Sender: TObject);
        procedure btnDoParseClick(Sender: TObject);
        procedure btnLoadSchemaClick(Sender: TObject);
        procedure btnSaveClick(Sender: TObject);
        procedure btnLoadFileClick(Sender: TObject);
        procedure btnBrowseHtmlClick(Sender: TObject);
        procedure btnSaveGCClick(Sender: TObject);
        procedure btnSaveSchemaClick(Sender: TObject);
        procedure Button1Click(Sender: TObject);
        procedure chbVerboseChange(Sender: TObject);
        procedure chbVisSchema1Change(Sender: TObject);
        procedure chbVisSchema2Change(Sender: TObject);
        procedure chbVisSchemaChange(Sender: TObject);
        procedure FormCreate(Sender: TObject);
        procedure FormDeactivate(Sender: TObject);
        procedure FormShow(Sender: TObject);
        procedure ListBox1DblClick(Sender: TObject);
        procedure ptnClearClick(Sender: TObject);
        procedure Splitter1CanOffset(Sender: TObject; var NewOffset: Integer;
          var Accept: Boolean);
        procedure Splitter1Moved(Sender: TObject);
        procedure splRightMoved(Sender: TObject);
    private
        { Private-Deklarationen }
      FGenealogieHelper: TGenealogyHelper;
      FraHtmlImport1: TFraHtmlImport;
        FlastTick: QWord;
        FDataPath: string;
        FH2gStep2: TH2gStep2;
        FGedComHelper: TGedComHelper;
        FGedComFile:TGedComFile;
        procedure FH2gEvent(Sender: TObject; eType, aText, Ref: string;
            dsubtype: integer);
        procedure FH2gProcessData(Sender: TObject; const aText, aRef, aKat,
          aData: string);
        procedure FHISplitterMove(Sender: TObject);
        procedure FillFileList(Data: PtrInt);
        procedure GedComLongOp(Sender: TObject);
        procedure H2gFamilyData(Sender: TObject; aText: string; Ref: string;
          dsubtype: integer);
        procedure H2gFamilyDate(Sender: TObject; aText: string; Ref: string;
          dsubtype: integer);
        procedure H2gFamilyIndiv(Sender: TObject; aText: string; Ref: string;
          dsubtype: integer);
        procedure H2gFamilyPlace(Sender: TObject; aText: string; Ref: string;
          dsubtype: integer);
        procedure H2gFamilyType(Sender: TObject; aText: string; Ref: string;
          dsubtype: integer);
        procedure H2gIndiData(Sender: TObject; aText: string; Ref: string;
          dsubtype: integer);
        procedure H2gIndiDate(Sender: TObject; aText: string; Ref: string;
          dsubtype: integer);
        procedure H2gIndiName(Sender: TObject; aText: string; Ref: string;
          dsubtype: integer);
        procedure H2gIndiOccu(Sender: TObject; aText: string; Ref: string;
          dsubtype: integer);
        procedure H2gIndiPlace(Sender: TObject; aText: string; Ref: string;
          dsubtype: integer);
        procedure H2gIndiRef(Sender: TObject; aText: string; Ref: string;
          dsubtype: integer);
        procedure H2gIndiRel(Sender: TObject; aText: string; Ref: string;
          dsubtype: integer);
        procedure H2gStartFamily(Sender: TObject; aText: string; Ref: string;
          dsubtype: integer);
        procedure H2gStartIndiv(Sender: TObject; aText: string; Ref: string;
          dsubtype: integer);
        procedure htmlNewPlainText(Sender: TObject);
        procedure LoadSchema(const lFilename: TCaption);
        procedure OnFileFound(FileIterator: TFileIterator);
    public
        { Public-Deklarationen }

        procedure ComputeFiltered(CType: byte; Text: string);
        procedure LoadFile(const lFilename: string);
    end;

var
    frmTestHtmlParsingMain: TfrmTestHtmlParsingMain;

implementation

uses Unt_FileProcs;

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

{$if FPC_FULLVERSION = 30200 }
    {$WARN 6058 OFF}
{$ENDIF}

procedure TfrmTestHtmlParsingMain.btnBrowseSchemaClick(Sender: TObject);
var
    lRelp: string;
begin
    OpenDialog1.FileName := FDatapath + cbxFilenameSchema.Text;
    if OpenDialog1.Execute then
      begin
        lRelp := ExtractRelativepath(ExpandFileName(FDatapath + DirectorySeparator),
            OpenDialog1.FileName);
        if not charinset(copy(lRelp, 2, 1)[1], ['.', ':', DirectorySeparator]) then
            cbxFilenameSchema.Text := lRelp
        else
            cbxFilenameSchema.Text := OpenDialog1.FileName;
        btnLoadSchemaClick(Sender);
      end;
end;

procedure TfrmTestHtmlParsingMain.btnDoParseClick(Sender: TObject);
begin
    FGedComHelper.CitTitle:='Pg.';
    FGedComHelper.OsbHdr:=edtIDPrepos.text;
    FGedComHelper.Citation := FraHtmlImport1.PlainText;
    FraHtmlImport1.DoParse(Sender);
    label1.Caption:= inttostr(FGedComFile.Count);
end;

procedure TfrmTestHtmlParsingMain.BitBtn1Click(Sender: TObject);
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

procedure TfrmTestHtmlParsingMain.btnAutoEstBirthClick(Sender: TObject);
begin
  FGenealogieHelper.AutoEstimateBirth;
  lblEstBirthResult.Caption:=inttostr(FGenealogieHelper.pResult)+
    ' ('+IntToStr(FGenealogieHelper.mResult)+')';
end;

procedure TfrmTestHtmlParsingMain.btnAutoSetNameClick(Sender: TObject);
begin
   FGenealogieHelper.autoSetName;
  lblSetNameResult.Caption:=inttostr(FGenealogieHelper.pResult)+
    ' ('+IntToStr(FGenealogieHelper.mResult)+')';
end;

procedure TfrmTestHtmlParsingMain.btnLoadSchemaClick(Sender: TObject);

var
    i: integer;

begin
    if cbxFilenameSchema.ItemIndex = -1 then
      begin
        cbxFilenameSchema.Items.add(cbxFilenameSchema.Text);
        Config1.Value[cbxFilenameSchema, 'ICount'] := cbxFilenameSchema.Items.Count;
        for i := 0 to cbxFilenameSchema.Items.Count - 1 do
            config1.Value[cbxFilenameSchema, IntToStr(i)] := cbxFilenameSchema.Items[i];
      end;

    LoadSchema(cbxFilenameSchema.Text);
end;

procedure TfrmTestHtmlParsingMain.btnLoadFileClick(Sender: TObject);
var
//    lEncoded: boolean;
    i: integer;
    lFilename: string;
begin
    if cbxFilename.ItemIndex = -1 then
      begin
        cbxFilename.Items.add(cbxFilename.Text);
        Config1.Value[cbxFilename, 'ICount'] := cbxFilename.Items.Count;
        for i := 0 to cbxFilename.Items.Count - 1 do
            config1.Value[cbxFilename, IntToStr(i)] := cbxFilename.Items[i];
      end;
    lFilename := cbxFilename.Text;
    LoadFile(lFilename);
    Application.QueueAsyncCall(FillFileList, 0);
end;

procedure TfrmTestHtmlParsingMain.btnBrowseHtmlClick(Sender: TObject);
begin
    OpenDialog1.FileName := cbxFilename.Text;
    if OpenDialog1.Execute then
      begin
        cbxFilename.Text := OpenDialog1.FileName;
        btnLoadFileClick(Sender);
      end;
end;

procedure TfrmTestHtmlParsingMain.btnSaveGCClick(Sender: TObject);
begin
  SaveDialog1.DefaultExt:='.ged';
  SaveDialog1.Filter:='GedCom (*.ged)|*.ged|Alle Dateien (*.*)|*.*';
  if SaveDialog1.Execute then
    savefile(FgedComHelper.SaveToFile,SaveDialog1.FileName);
end;

procedure TfrmTestHtmlParsingMain.btnSaveSchemaClick(Sender: TObject);
var
    i: integer;
    lRelp: string;
begin
    SaveDialog1.FileName := FDatapath + DirectorySeparator + cbxFilenameSchema.Text;
    if SaveDialog1.Execute then
      begin
        SaveFile(FraHtmlImport1.SchemaSaveToFile, SaveDialog1.FileName);

        lRelp := ExtractRelativepath(ExpandFileName(FDatapath + DirectorySeparator),
            SaveDialog1.FileName);
        if not charinset(copy(lRelp, 2, 1)[1], ['.', ':', DirectorySeparator]) then
            cbxFilenameSchema.Text := lRelp
        else
            cbxFilenameSchema.Text := SaveDialog1.FileName;
        if cbxFilenameSchema.ItemIndex = -1 then
          begin
            cbxFilenameSchema.Items.add(cbxFilenameSchema.Text);
            Config1.Value[cbxFilenameSchema, 'ICount'] := cbxFilenameSchema.Items.Count;
            for i := 0 to cbxFilenameSchema.Items.Count - 1 do
                config1.Value[cbxFilenameSchema, IntToStr(i)] := cbxFilenameSchema.Items[i];
          end;
      end;
end;

procedure TfrmTestHtmlParsingMain.Button1Click(Sender: TObject);
    var
        lFilename: string;
        i: Integer;
    begin
        FGedComHelper.OsbHdr:=edtIDPrepos.text;
        FraHtmlImport1.OnNewPlainText:=htmlNewPlainText;
        FGedComHelper.CitTitle:='Pg.';

        if ListBox1.SelCount = 1 then
        begin
        lFilename := ExtractFilePath(cbxFilename.Text) + ListBox1.Items[ListBox1.ItemIndex];
        LoadFile(lfilename);
        FraHtmlImport1.DoParse(Sender);

        end
        else
        for i := 0 to ListBox1.Count-1 do
        if ListBox1.Selected[i] then
          begin
            lFilename := ExtractFilePath(cbxFilename.Text) + ListBox1.Items[i];
            FraHtmlImport1.ShowHTML:=false;
            LoadFile(lfilename);
//            FGedComHelper.Citation = FraHtmlImport1.HTMLViewer1.Caption;
            FraHtmlImport1.DoParse(Sender);
            FraHtmlImport1.ShowHTML:=true;
          end;
        label2.Caption:= inttostr(FGedComFile.Count);

end;

procedure TfrmTestHtmlParsingMain.chbVerboseChange(Sender: TObject);
begin
    FraHtmlImport1.Verbose := chbVerbose.Checked;
//    btnSave.Visible:=chbVerbose.Checked;
end;

procedure TfrmTestHtmlParsingMain.chbVisSchema1Change(Sender: TObject);
begin
  mOutPut.Visible:=chbVisSchema1.Checked;
  splRight.Visible:=chbVisSchema1.Checked ;
  pnlTopRight2.Visible:=chbVisSchema1.Checked;
  pnlBottomRight2.Visible:=chbVisSchema1.Checked;
end;

procedure TfrmTestHtmlParsingMain.chbVisSchema2Change(Sender: TObject);
begin
  pnlRight.Visible:=chbVisSchema2.Checked;
  Splitter1.Visible:=chbVisSchema2.Checked;
  pnlTopRight3.Visible:=chbVisSchema2.Checked;
  pnlBottomRight3.Visible:=chbVisSchema2.Checked;
end;

procedure TfrmTestHtmlParsingMain.chbVisSchemaChange(Sender: TObject);
begin
  FraHtmlImport1.SchemaVisible:=chbVisSchema.Checked;
  btnSaveSchema.Visible:=chbVisSchema.Checked;
  btnLoadSchema.Visible:=chbVisSchema.Checked;
  btnBrowseSchema.Visible:=chbVisSchema.Checked;
  cbxFilenameSchema.Visible:=chbVisSchema.Checked;
  pnlTopRight.Visible:=chbVisSchema.Checked;
  pnlBottomRight.Visible:=chbVisSchema.Checked;
end;

procedure TfrmTestHtmlParsingMain.FormCreate(Sender: TObject);
var
  i: Integer;
begin
    FDatapath := 'Data';
    for i := 0 to 2 do
        if DirectoryExists(FDataPath) then
            Break
        else
            FDataPath := '..' + DirectorySeparator + FDataPath;

    FraHtmlImport1:= TFraHtmlImport.Create(self);
    FraHtmlImport1.Align:=alClient;
    FraHtmlImport1.Parent := self;
    FraHtmlImport1.OnComputeOutput := ComputeFiltered;
    FraHtmlImport1.OnSplitterMove:= FHISplitterMove;
    FH2gStep2 := TH2gStep2.Create;
    FH2gStep2.GNameHandler.LoadGNameList(FDataPath + DirectorySeparator + 'GNameFile.txt');
    FH2gStep2.onProcessData:=FH2gProcessData;
    FH2gStep2.onStartIndiv:=  H2gStartIndiv;
    FH2gStep2.onStartFamily:= H2gStartFamily;
    FH2gStep2.onFamilyType:=H2gFamilyType;
    FH2gStep2.onFamilyData:=H2gFamilyData;
    FH2gStep2.onFamilyDate:=H2gFamilyDate;
    FH2gStep2.onFamilyPlace:=H2gFamilyPlace;
    FH2gStep2.onFamilyIndiv:=H2gFamilyIndiv;
    FH2gStep2.onIndiName:=H2gIndiName;
    FH2gStep2.onIndiDate:=H2gIndiDate;
    FH2gStep2.onIndiPlace:=H2gIndiPlace;
    FH2gStep2.onIndiOccu:=H2gIndiOccu;
    FH2gStep2.onIndiRel:=H2gIndiRel;
    FH2gStep2.onIndiRef:=H2gIndiRef;
    FH2gStep2.onIndiData:=H2gIndiData;
    FGedComFile := TGedComFile.Create;
    FGedComHelper := TGedComHelper.Create;
    FGedComHelper.GedComFile := FGedComFile;
    FGedComHelper.CreateNewHeader('Dummy');

    FGenealogieHelper:=TGenealogyHelper.Create;
    FGenealogieHelper.OnLongOp:=GedComLongOp;
    FGenealogieHelper.GedComFile:=FGedComFile;
end;

procedure TfrmTestHtmlParsingMain.FormDeactivate(Sender: TObject);
begin
    FreeAndNil(FGedComFile);
    FreeAndNil(FGedComHelper);
end;

procedure TfrmTestHtmlParsingMain.FormShow(Sender: TObject);
var
    CBCount, i: integer;
begin
    CBCount := Config1.getValue(cbxFilename, 'ICount', 0);
    for i := 0 to CBCount - 1 do
      begin
        cbxFilename.Items.Add(Config1.getValue(cbxFilename, IntToStr(i), ''));
        if i=0 then
          begin
            cbxFilename.ItemIndex := i;
            LoadFile(cbxFilename.Text);
          end;
      end;
    CBCount := Config1.getValue(cbxFilenameSchema, 'ICount', 0);
    for i := 0 to CBCount - 1 do
      begin
        cbxFilenameSchema.Items.Add(Config1.getValue(cbxFilenameSchema, IntToStr(i), ''));
        if i=0 then
          begin
            cbxFilenameSchema.ItemIndex := i;
            LoadSchema(cbxFilenameSchema.Text);
          end;
      end;
    FH2gStep2.GNameHandler.LoadGNameList(FDataPath + DirectorySeparator+'GenData'+ DirectorySeparator + 'GNameFile.txt');
end;

procedure TfrmTestHtmlParsingMain.ListBox1DblClick(Sender: TObject);
var
    lFilename: string;
begin
    lFilename := ExtractFilePath(cbxFilename.Text) + ListBox1.Items[ListBox1.ItemIndex];
    LoadFile(lfilename);
//    FGedComHelper.Citation = FraHtmlImport1.HTMLViewer1.Caption;
    FGedComHelper.CitTitle:='Pg.';
    FGedComHelper.OsbHdr:=edtIDPrepos.text;
    FGedComHelper.Citation := FraHtmlImport1.PlainText;
    FraHtmlImport1.DoParse(Sender);
    label2.Caption:= inttostr(FGedComFile.Count);
end;

procedure TfrmTestHtmlParsingMain.ptnClearClick(Sender: TObject);
begin
  FGedComFile.Clear;
  FgedComHelper.CreateNewHeader('Dummy');
  label2.Caption:= inttostr(FGedComFile.Count);
end;

procedure TfrmTestHtmlParsingMain.Splitter1CanOffset(Sender: TObject;
  var NewOffset: Integer; var Accept: Boolean);
begin

end;

procedure TfrmTestHtmlParsingMain.Splitter1Moved(Sender: TObject);
var
  lWidth: Integer;
begin
  lWidth := pnlRight.Width+Splitter1.Width;
  pnlTopRight3.Width:=lWidth;
  pnlBottomRight3.Width:=lWidth;
  splRightMoved(sender);
end;

procedure TfrmTestHtmlParsingMain.splRightMoved(Sender: TObject);
var
  lWidth: Integer;
begin
  lWidth := mOutput.Width+Splitter1.Width;
  pnlTopRight2.Width:=lWidth;
  pnlBottomRight2.Width:=lWidth;
end;

procedure TfrmTestHtmlParsingMain.FH2gEvent(Sender: TObject; eType, aText,
  Ref: string; dsubtype: integer);
var
  lLine: String;
begin
  if pnlRight.Visible then
    begin
      lLine := Format('%s, %s, %s, %d',[eType,aText,Ref,dsubtype]);
      Memo2.Append(lLine);
    end;
//  FGedComHelper.FireEvent(sender,lLine.Split([', ']));
   if FlastTick + 500 < GetTickCount64 then
      begin
        label2.Caption:= inttostr(FGedComFile.Count);
        Application.ProcessMessages;
        FlastTick := GetTickCount64;
      end;
end;

procedure TfrmTestHtmlParsingMain.FillFileList(Data: PtrInt);
var
    lFileSearcher: TFileSearcher;
    lSearchPath, lSearchMask: string;
begin
    lFileSearcher := TFileSearcher.Create;
    ListBox1.Clear;
      try
        lFileSearcher.OnFileFound := OnFileFound;
        lSearchPath := ExtractFilePath(cbxFilename.Text) + '..';
        lSearchMask := copy(ExtractFileName(cbxFilename.Text), 1, 1) + '*' +
            ExtractFileExt(cbxFilename.Text);
        lFileSearcher.Search(lSearchPath, lSearchMask, True, False);
      finally
        FreeAndNil(lFileSearcher);
      end;
end;

procedure TfrmTestHtmlParsingMain.GedComLongOp(Sender: TObject);
begin

end;

procedure TfrmTestHtmlParsingMain.H2gFamilyData(Sender: TObject; aText: string;
  Ref: string; dsubtype: integer);
begin
  FH2gEvent(Sender, 'ParserFamilyData', aText, Ref, dSubType);
  FGedComHelper.FamilyData(sender,aText,ref,dsubtype);
end;

procedure TfrmTestHtmlParsingMain.H2gFamilyDate(Sender: TObject; aText: string;
  Ref: string; dsubtype: integer);
begin
  FH2gEvent(Sender, 'ParserFamilyDate', aText, Ref, dSubType);
  FGedComHelper.FamilyDate(sender,aText,ref,dsubtype);
end;

procedure TfrmTestHtmlParsingMain.H2gFamilyIndiv(Sender: TObject;
  aText: string; Ref: string; dsubtype: integer);
begin
  FH2gEvent(Sender, 'ParserFamilyIndiv', aText, Ref, dSubType);
  FGedComHelper.FamilyIndiv(sender,aText,ref,dsubtype);
end;

procedure TfrmTestHtmlParsingMain.H2gFamilyPlace(Sender: TObject;
  aText: string; Ref: string; dsubtype: integer);
begin
  FH2gEvent(Sender, 'ParserFamilyPlace', aText, Ref, dSubType);
  FGedComHelper.FamilyPlace(sender,aText,ref,dsubtype);
end;

procedure TfrmTestHtmlParsingMain.H2gFamilyType(Sender: TObject; aText: string;
  Ref: string; dsubtype: integer);
begin
   FH2gEvent(Sender, 'ParserFamilyType', aText, Ref, dSubType);
   FGedComHelper.FamilyType(sender,aText,ref,dsubtype);
end;

procedure TfrmTestHtmlParsingMain.H2gIndiData(Sender: TObject; aText: string;
  Ref: string; dsubtype: integer);
begin
   FH2gEvent(Sender, 'ParserIndiData', aText, Ref, dSubType);
   FGedComHelper.IndiData(sender,aText,ref,dsubtype);
end;

procedure TfrmTestHtmlParsingMain.H2gIndiDate(Sender: TObject; aText: string;
  Ref: string; dsubtype: integer);
begin
  FH2gEvent(Sender, 'ParserIndiDate', aText, Ref, dSubType);
  FGedComHelper.IndiDate(sender,aText,ref,dsubtype);
end;

procedure TfrmTestHtmlParsingMain.H2gIndiName(Sender: TObject; aText: string;
  Ref: string; dsubtype: integer);
begin
   FH2gEvent(Sender, 'ParserIndiName', aText, Ref, dSubType);
   FGedComHelper.IndiName(sender,aText,ref,dsubtype);
end;

procedure TfrmTestHtmlParsingMain.H2gIndiOccu(Sender: TObject; aText: string;
  Ref: string; dsubtype: integer);
begin
  FH2gEvent(Sender, 'ParserIndiOccu', aText, Ref, dSubType);
  FGedComHelper.IndiOccu(sender,aText,ref,dsubtype);
end;

procedure TfrmTestHtmlParsingMain.H2gIndiPlace(Sender: TObject; aText: string;
  Ref: string; dsubtype: integer);
begin
   FH2gEvent(Sender, 'ParserIndiPlace', aText, Ref, dSubType);
   FGedComHelper.IndiPlace(sender,aText,ref,dsubtype);
end;

procedure TfrmTestHtmlParsingMain.H2gIndiRef(Sender: TObject; aText: string;
  Ref: string; dsubtype: integer);
begin
   FH2gEvent(Sender, 'ParserIndiRef', aText, Ref, dSubType);
   FGedComHelper.IndiRef(sender,aText,ref,dsubtype);
end;

procedure TfrmTestHtmlParsingMain.H2gIndiRel(Sender: TObject; aText: string;
  Ref: string; dsubtype: integer);
begin
  FH2gEvent(Sender, 'ParserIndiRel', aText, Ref, dSubType);
  FGedComHelper.IndiRel(sender,aText,ref,dsubtype);
end;

procedure TfrmTestHtmlParsingMain.H2gStartFamily(Sender: TObject;
  aText: string; Ref: string; dsubtype: integer);
begin
  FH2gEvent(Sender, 'ParserStartFamily', aText, Ref, dSubType);
  FGedComHelper.StartFamily(sender,aText,ref,dsubtype);
end;

procedure TfrmTestHtmlParsingMain.H2gStartIndiv(Sender: TObject; aText: string;
  Ref: string; dsubtype: integer);
begin
    FH2gEvent(Sender, 'ParserStartIndiv', aText, Ref, dSubType);
    FGedComHelper.StartIndiv(sender,aText,ref,dsubtype);
end;

procedure TfrmTestHtmlParsingMain.htmlNewPlainText(Sender: TObject);
begin
  FGedComHelper.Citation := FraHtmlImport1.PlainText;
end;

procedure TfrmTestHtmlParsingMain.LoadSchema(const lFilename: TCaption);
var
  s: string;
  sf: TFileStream;
begin
  if not charinset(copy(lFilename, 2, 1)[1],
      ['.', ':', DirectorySeparator]) then
      sf := TFileStream.Create(FDataPath + DirectorySeparator +
          lFilename, fmOpenRead)
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

procedure TfrmTestHtmlParsingMain.FHISplitterMove(Sender: TObject);
var
  lWidth: PtrInt;
begin
  if sender.InheritsFrom(TComponent) then
    begin
      lWidth := FraHtmlImport1.Width- TComponent(Sender).Tag;
      pnlTopRight.Width:=lWidth;
      pnlBottomRight.Width:=lWidth;
    end;
end;

procedure TfrmTestHtmlParsingMain.FH2gProcessData(Sender: TObject; const aText,
  aRef, aKat, aData: string);
begin
   if pnlRight.Visible then
     Memo1.Append(Format('%s, %s, %s, %s',[aText,aRef,aKat,aData]));
   FH2gStep2.ProcessGenData2(self,aText,aRef,aKat,aData);
end;

procedure TfrmTestHtmlParsingMain.OnFileFound(FileIterator: TFileIterator);
begin
    Listbox1.AddItem(ExtractRelativepath(ExtractFilePath(cbxFilename.Text),
        FileIterator.FileName), nil);
    if FlastTick + 500 < GetTickCount64 then
      begin
        Application.ProcessMessages;
        FlastTick := GetTickCount64;
      end;
end;

procedure TfrmTestHtmlParsingMain.btnSaveClick(Sender: TObject);
begin
    SaveDialog1.FileName := cbxFilename.Text;
    if SaveDialog1.Execute then
        SaveFile(mOutput.Lines.SaveToFile, SaveDialog1.FileName);
end;

procedure TfrmTestHtmlParsingMain.ComputeFiltered(CType: byte; Text: string);
begin
    if ctype in [0, 2, 3] then
      begin
        if mOutput.Visible then
          mOutput.Lines.add(IntToStr(CType) + ': ' + Text);
        FH2gStep2.ComputeOutput(CType,Text);
      end;
end;

procedure TfrmTestHtmlParsingMain.LoadFile(const lFilename: string);
var
    s: string;
    sf: TFileStream;
begin
    if not FileExists(lFilename) then
        exit;
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
