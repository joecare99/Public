unit frm_tsthtmlparser2;

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
    Buttons, ComCtrls, ExtCtrls, DBCtrls, DBGrids, DBExtCtrls,
    VisualHTTPClient, sqldb, DB, fra_RNZTrPortImport,
    Fra_RNZAnzFilter, fra_RNZConfig, fra_PlaceEdit, fra_PdfXmlView, EditBtn,
    ActnList, DBActns, ComboEx, HtmlView;

type

    { TfrmTstHtmlParser2Main }

    TfrmTstHtmlParser2Main = class(TForm)
        actDataCopyRecord: TAction;
        actDataParseText: TAction;
        actDataSetMaidenname: TAction;
        actDataSetPlace: TAction;
        actDataDelMaidenname: TAction;
        actDataSwichNames: TAction;
        actDataOCRImport: TAction;
        actDataRefreshPlaces: TAction;
        actUpdateTS: TAction;
        actDataProcessPDF: TAction;
        actDataSetBurial: TAction;
        actDataSetBirth: TAction;
        actDataSetDeath: TAction;
        ActionList1: TActionList;
        BitBtn1: TBitBtn;
        btnDataCopyRecord1: TSpeedButton;
        btnDataSwitchNames: TSpeedButton;
        btnExportGed: TBitBtn;
        btnExportCSV: TBitBtn;
        btnLoadPng: TSpeedButton;
        btnLoadXml: TSpeedButton;
        btnOpenWeb: TBitBtn;
        btnBrowseHtml: TBitBtn;
        btnBrowseSchema: TBitBtn;
        btnDoParse: TBitBtn;
        btnLoadFile: TBitBtn;
        btnLoadSchema: TBitBtn;
        btnParseText: TSpeedButton;
        btnProcessPdf: TSpeedButton;
        btnProcessPDF2: TSpeedButton;
        btnSave: TBitBtn;
        btnSave1: TBitBtn;
        btnSaveSchema: TBitBtn;
        cbxFilename: TComboBox;
        cbxFilenameSchema: TComboBox;
        chbAppendDB: TCheckBox;
        chbAutoImage: TCheckBox;
        chbAutoText: TCheckBox;
        chbPDFFound: TCheckBox;
        chbPNGFound: TCheckBox;
        chbAutocontinue: TCheckBox;
        chbVerbose: TCheckBox;
        chbVerbose1: TCheckBox;
        chbXmlFound: TCheckBox;
        chbOnlyTAnzeigen: TCheckBox;
        cbxLinkedTo: TComboBox;
        ComboBoxEx1: TComboBoxEx;
        DataSetFirst1: TDataSetFirst;
        DataSetLast1: TDataSetLast;
        DataSetNext1: TDataSetNext;
        DataSetPrior1: TDataSetPrior;
        DataSource1: TDataSource;
        DBComboBox1: TDBComboBox;
        DBImage1: TDBImage;
        DBMemo1: TDBMemo;
        edtSetAge: TEdit;
        edtFamilyname: TDBEdit;
        edtGivenname: TDBEdit;
        edtMaidenname1: TDBEdit;
        edtMaidenname2: TDBEdit;
        FraPlaceEdit1: TFraPlaceEdit;
        fraRNZAnzFilter1: TfraRNZAnzFilter;
        fraRNZConfig1: TfraRNZConfig;
        fraTrPortImport1: TfraTrPortImport;
        lblLink: TLabel;
        lblFamilyname: TLabel;
        lblGivenname: TLabel;
        lblMaidenname1: TLabel;
        lblMaidenname2: TLabel;
        lblRCount: TLabel;
        lblRCount1: TLabel;
        lblRCount2: TLabel;
        lblRCount3: TLabel;
        lblRCount4: TLabel;
        rgSex: TDBRadioGroup;
        pbrPDFProgress: TProgressBar;
        rgRubrik: TDBRadioGroup;
        edtBirth: TDBDateEdit;
        edtBurial: TDBDateEdit;
        edtDeath: TDBDateEdit;
        DBGrid1: TDBGrid;
        DBNavigator1: TDBNavigator;
        edtMaidenname: TDBEdit;
        edtPlace: TDBComboBox;
        fraXmlView1: TfraXmlView;
        IdleTimer1: TIdleTimer;
        lblAge: TStaticText;
        lblBurial: TLabel;
        lblCompiledOn: TLabel;
        lblDataPath: TStaticText;
        lblDeath: TLabel;
        lblGeboren: TLabel;
        lblMaidenname: TLabel;
        lblPlace: TLabel;
        ListBox1: TListBox;
        PaintBox1: TPaintBox;
        pnlP2Bottom: TPanel;
        pnlBottomP1: TPanel;
        pnlP2Top: TPanel;
        OpenDialog1: TOpenDialog;
        PageControl1: TPageControl;
        pnlBottom: TPanel;
        pnlTop: TPanel;
        SaveDialog1: TSaveDialog;
        btnRefreshOrte: TSpeedButton;
        btnOCRCancel: TSpeedButton;
        btnDataCopyRecord: TSpeedButton;
        btnCopyBirthday: TSpeedButton;
        btnCopyDeath: TSpeedButton;
        btnCopyBurial: TSpeedButton;
        SpeedButton1: TSpeedButton;
        btnDelMaidenname: TSpeedButton;
        btnOCR_In: TSpeedButton;
        SpeedButton3: TSpeedButton;
        TabSheet1: TTabSheet;
        TabSheet2: TTabSheet;
        TabSheet3: TTabSheet;
        TabSheet4: TTabSheet;
        VisualHTTPClient1: TVisualHTTPClient;
        // Detail-Procedures
        procedure actDataCopyRecordExecute(Sender: TObject);
        procedure actDataDelMaidennameExecute(Sender: TObject);
        procedure actDataDelMaidennameUpdate(Sender: TObject);
        procedure actDataSwichNamesExecute(Sender: TObject);
        procedure actDataSetBirthExecute(Sender: TObject);
        procedure actDataSetBirthUpdate(Sender: TObject);
        procedure actDataSetBurialExecute(Sender: TObject);
        procedure actDataSetBurialUpdate(Sender: TObject);
        procedure actDataSetDeathExecute(Sender: TObject);
        procedure actDataSetDeathUpdate(Sender: TObject);
        procedure actDataOCRImportExecute(Sender: TObject);
        procedure actDataProcessPdfExecute(Sender: TObject);
        procedure actDataRefreshPlacesExecute(Sender: TObject);
        procedure actDataParseTextExecute(Sender: TObject);
        procedure btnLoadPngClick(Sender: TObject);
        procedure btnLoadXmlClick(Sender: TObject);
        procedure btnProcessPDF2Click(Sender: TObject);
        procedure cbxLinkedToDropDown(Sender: TObject);
        procedure cbxLinkedToExit(Sender: TObject);
        procedure cbxLinkedToSelect(Sender: TObject);
        procedure DataSource1DataChange(Sender: TObject; Field: TField);
        procedure edtHaveCustomDate(Sender: TObject; var ADate: string);
        procedure edtSetAgeExit(Sender: TObject);
        procedure edtSetAgeKeyPress(Sender: TObject; var Key: char);
        procedure lblAgeClick(Sender: TObject);
        procedure lblDataPathClick(Sender: TObject);
        procedure btnOCRCancelClick(Sender: TObject);

        procedure actUpdateTSExecute(Sender: TObject);
        procedure btnExportCSVClick(Sender: TObject);
        procedure btnBrowseSchemaClick(Sender: TObject);
        procedure btnDoParseClick(Sender: TObject);
        procedure btnExportGedClick(Sender: TObject);
        procedure btnFlushDataClick(Sender: TObject);
        procedure btnLoadSchemaClick(Sender: TObject);
        procedure btnOpenWebClick(Sender: TObject);
        procedure btnSave1Click(Sender: TObject);
        procedure btnSaveClick(Sender: TObject);
        procedure btnLoadFileClick(Sender: TObject);
        procedure btnBrowseHtmlClick(Sender: TObject);
        procedure btnSaveSchemaClick(Sender: TObject);
        procedure chbVerbose1Change(Sender: TObject);
        procedure chbVerboseChange(Sender: TObject);
        procedure FormCreate(Sender: TObject);
        procedure FormKeyDown(Sender: TObject; var Key: word;
            Shift: TShiftState);
        procedure FormKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
        procedure FormShow(Sender: TObject);
        procedure IdleTimer1StartTimer(Sender: TObject);
        procedure IdleTimer1StopTimer(Sender: TObject);
        procedure IdleTimer1Timer(Sender: TObject);
    private
        FAppended: integer;
        FIdle: boolean;
        FMaxDate: string;
        { Private-Deklarationen }
        FNewFileFlag, FNextDS, FCheckFiles: boolean;
        FNewWWWPage: boolean;
        FEncoding: string;
        FDataPath: string;
        FAutoLoadImage: boolean;
        FAutoProcPDF: boolean;
        FAutoLoadXml: boolean;
        FAutoParseTxt: boolean;
        FCancel: boolean;
        FWWWstart: integer;
        FShiftState: TShiftState;
        procedure DoOCRandCopy(Data: PtrInt);
        procedure HTMLParseOnNewFilename(Sender: TObject; st: string);
        procedure HTMLParseOnRowComplete(Sender: TObject; st: TStrings);
        procedure OnParseData(Sender: TObject; dtKind: integer; Data: string);
        procedure PutDateToControl(sDBText: string; const edtDate: TDBDateEdit;
            const aDatePos: integer; Force: boolean = False);
        function ResWebImport2(const Path, PngFile, PDFFile: string;
            const FileDate: TDateTime; out PngSuccess, PDFSuccess: boolean): string;
        procedure UpdateAge(const ds: TDataSet);
        procedure UpdateProgress(Sender: TObject; Data: PtrInt);
    protected
        procedure ResWebImport;
    public
        { Public-Deklarationen }
    end;

var
    frmTstHtmlParser2Main: TfrmTstHtmlParser2Main;

implementation

uses LConvEncoding, dm_RNZAnzeigen, FileUtil, Unt_FileProcs, unt_CDateProxy, dateutils,
    MouseAndKeyInput, unt_GetWindows, Clipbrd;

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

const
    bColor: array[boolean] of TColor = (clRed or clLtGray, clLime or clLtGray);

function GetFileSize(FileName: string): int64;

var
    sr: TRawByteSearchrec;
begin
    if FindFirst(FileName, faAnyFile - faDirectory, sr) = 0 then
        Result := sr.Size
    else
        Result := 0;
    FindClose(sr);
end;

procedure TfrmTstHtmlParser2Main.btnDoParseClick(Sender: TObject);

begin
    btnDoParse.Enabled := False;
      try
        FNewFileFlag := False;
        FMaxDate := '';
        FAppended := 0;
        fraTrPortImport1.fOnNewFilename := HTMLParseOnNewFilename;
        fraTrPortImport1.fOnRowComplete := HTMLParseOnRowComplete;
        fraTrPortImport1.DoParse;
        if chbAppendDB.Checked then
          begin
            dmRNZAnzeigen.Flush;
          end;
      finally
        btnDoParse.Enabled := True;
      end;
end;

procedure TfrmTstHtmlParser2Main.btnExportGedClick(Sender: TObject);

var
    lDatset: TDataSet;
begin
    SaveDialog1.DefaultExt := '.Ged';
    saveDialog1.Filter := rsFilterGedCom;

    if SaveDialog1.Execute then
          try
            lDatset := DataSource1.DataSet;
            DataSource1.DataSet := nil;
            dmRNZAnzeigen.ExportGedFile(lDatset, SaveDialog1.FileName,
                Ord(chbOnlyTAnzeigen.State), TStringList(rgRubrik.Items),
                UpdateProgress);
          finally
            DataSource1.DataSet := lDatset;
          end;

end;

procedure TfrmTstHtmlParser2Main.btnFlushDataClick(Sender: TObject);
begin
    dmRNZAnzeigen.Flush;
end;

procedure TfrmTstHtmlParser2Main.btnBrowseSchemaClick(Sender: TObject);
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

procedure TfrmTstHtmlParser2Main.btnExportCSVClick(Sender: TObject);
var
    lDatset: TDataSet;
begin
    SaveDialog1.FileName := changefileext(cbxFilename.Text, '.csv');
    SaveDialog1.DefaultExt := '.CSV';
    if SaveDialog1.Execute then
          try
            lDatset := DataSource1.DataSet;
            DataSource1.DataSet := nil;
            dmRNZAnzeigen.ExportCSV(lDatset, SaveDialog1.FileName, UpdateProgress);

          finally
            DataSource1.DataSet := lDatset;
          end;

end;

procedure TfrmTstHtmlParser2Main.actUpdateTSExecute(Sender: TObject);
begin
    PageControl1.ActivePageIndex := 0;
    chbVerbose1.Checked := False;
    chbAppendDB.Checked := True;
    chbAutocontinue.Checked := True;
    btnOpenWebClick(btnOpenWeb);
    btnDoParseClick(Sender);
end;

procedure TfrmTstHtmlParser2Main.btnLoadSchemaClick(Sender: TObject);

var
    sf: TFileStream;
    s: string;
    lEncoded: boolean;
    i: integer;
begin
    if cbxFilenameSchema.ItemIndex = -1 then
      begin
        cbxFilenameSchema.Items.add(cbxFilenameSchema.Text);
        dmRNZAnzeigen.ObjectValue[cbxFilenameSchema, 'ICount'] :=
            cbxFilenameSchema.Items.Count;
        for i := 0 to cbxFilenameSchema.Items.Count - 1 do
            dmRNZAnzeigen.ObjectValue[cbxFilenameSchema, IntToStr(i)] :=
                cbxFilenameSchema.Items[i];
      end;
    if not charinset(copy(cbxFilenameSchema.Text, 2, 1)[1],
        ['.', ':', DirectorySeparator]) then
        sf := TFileStream.Create(FDataPath + DirectorySeparator +
            cbxFilenameSchema.Text, fmOpenRead)
    else
        sf := TFileStream.Create(cbxFilenameSchema.Text, fmOpenRead);

      try
        setlength(s, sf.Size);
        sf.ReadBuffer(s[1], sf.Size);
        FEncoding := GuessEncoding(s);
      finally
        FreeAndNil(sf);
      end;
    fraTrPortImport1.SetSchema(ConvertEncodingToUTF8(s, EncodingCP1252, lEncoded));
end;

{------------------- Detail-procs -----------------------------}
{$Region RNZ-Details}
procedure TfrmTstHtmlParser2Main.btnLoadPngClick(Sender: TObject);
begin
    if ssShift in FShiftState then
        OpenDocument(lblDataPath.Caption + DirectorySeparator +
            DBImage1.DataSource.DataSet.FieldByName('PNG').AsString)
    else
      begin
        if DBImage1.DataSource.State <> dsEdit then
            DBImage1.DataSource.DataSet.Edit;
        if GetFileSize(lblDataPath.Caption + DirectorySeparator +
            DBImage1.DataSource.DataSet.FieldByName('PNG').AsString) < 1000000 then
            DBImage1.Picture.LoadFromFile(lblDataPath.Caption +
                DirectorySeparator + DBImage1.DataSource.DataSet.FieldByName(
                'PNG').AsString);
      end;
end;


procedure TfrmTstHtmlParser2Main.actDataSetBirthExecute(Sender: TObject);
begin
    if DBMemo1.SelLength < 4 then
        DBMemo1.SelLength := 22;
    PutDateToControl(DBMemo1.seltext, edtBirth, 1, True);
end;

procedure TfrmTstHtmlParser2Main.actDataCopyRecordExecute(Sender: TObject);
var
    lVarArray: array of variant;
    lAuftrag: int64;
    i: integer;
    lBookmark: TBookMark;
begin
    with DataSource1.DataSet do
      begin
        lBookmark := GetBookmark;
        // First Save the actual Record Data
        setlength(lVarArray, FieldCount);
        for i := 0 to FieldCount - 1 do
            lVarArray[i] := Fields[i].Value;
        // Looking for a free "Auftrag"-Number
        lAuftrag := lVarArray[1];
        Inc(lAuftrag);
        while dmRNZAnzeigen.CheckDSExists(IntToStr(lAuftrag)) do
            Inc(lAuftrag);
        lVarArray[1] := lAuftrag;
        // Create a new Record
        Insert;
        // Insert
        for i := 1 to FieldCount - 1 do
            if not Fields[i].ReadOnly then
                Fields[i].Value := lVarArray[i];
        post;
        GotoBookmark(lBookmark);
      end;
end;

procedure TfrmTstHtmlParser2Main.actDataDelMaidennameExecute(Sender: TObject);
begin
    edtMaidenname.DataSource.Edit;
    edtMaidenname.Field.Value := '';
end;

procedure TfrmTstHtmlParser2Main.actDataDelMaidennameUpdate(Sender: TObject);
var
    bWarning: boolean;
begin
    if (ActiveControl <> edtMaidenname) then
      begin
        bWarning := (rgSex.Field.AsString = 'M') and not
            edtMaidenname.Field.isnull and not (edtMaidenname.Field.AsString = '');
        if bWarning then
            edtMaidenname.Color := clYellow or clLtGray
        else
            edtMaidenname.Color := clDefault;
      end;
end;

procedure TfrmTstHtmlParser2Main.actDataSwichNamesExecute(Sender: TObject);
var
    tStrig: TCaption;
begin
    edtFamilyname.DataSource.DataSet.Edit;
    tStrig := edtFamilyname.Text;
    edtFamilyname.Text := edtGivenname.Text;
    edtGivenname.Text := tStrig;
end;

procedure TfrmTstHtmlParser2Main.actDataSetBirthUpdate(Sender: TObject);
var
    ersch: TDateTime;
    bValid: boolean;

begin
    actDataSetBirth.Enabled := DBMemo1.Text <> '';
    if (ActiveControl <> edtBirth) and not DataSource1.DataSet.FieldByName(
        'Erscheinungsdatum').isnull and not edtBirth.Field.isnull then
      begin
        ersch := DataSource1.DataSet.FieldByName('Erscheinungsdatum').AsDateTime;
        bValid := edtBirth.Field.AsDateTime < ersch;
        bValid := bValid and (edtBirth.Field.AsDateTime <> 0.0);
        if not DataSource1.DataSet.FieldByName('Rubrik').isnull and
            (DataSource1.DataSet.FieldByName('Rubrik').AsString <> '8055') and
            (DataSource1.DataSet.FieldByName('Rubrik').AsString <> '8056') then
            bValid := bValid and (YearsBetween(edtBirth.Field.AsDateTime, ersch) < 120);
        edtBirth.Color := bColor[bValid];
      end
    else
        edtBirth.Color := clWindow;
end;

procedure TfrmTstHtmlParser2Main.actDataSetBurialExecute(Sender: TObject);
begin
    if DBMemo1.SelLength < 4 then
        DBMemo1.SelLength := 22;
    PutDateToControl(DBMemo1.SelText, edtBurial, 1, True);
end;

procedure TfrmTstHtmlParser2Main.actDataSetBurialUpdate(Sender: TObject);
var
    ersch: TDateTime;
    bValid, bWarning: boolean;
begin
    actDataSetBurial.Enabled := DBMemo1.Text <> '';
    if (ActiveControl <> edtBurial) and not
        DataSource1.DataSet.FieldByName('Erscheinungsdatum').isnull and not
        edtBurial.Field.isnull then
      begin
        ersch := DataSource1.DataSet.FieldByName('Erscheinungsdatum').AsDateTime;
        bValid := (edtBurial.Field.AsDateTime > ersch - 14.0);
        bwarning := edtBurial.Field.AsDateTime < ersch;
        bValid := bValid and (edtBurial.Field.AsDateTime <> 0.0);
        if not DataSource1.DataSet.FieldByName('Rubrik').isnull and
            (DataSource1.DataSet.FieldByName('Rubrik').AsString <> '8055') and
            (DataSource1.DataSet.FieldByName('Rubrik').AsString <> '8056') then
            bValid := bValid and (YearsBetween(edtBurial.Field.AsDateTime, ersch) < 1);
        if not edtDeath.Field.isnull and (edtDeath.Color = bColor[True]) then
          begin
            bValid := bValid and (edtDeath.Field.AsDateTime <
                edtBurial.Field.AsDateTime);
            bValid := bValid and
                (MonthsBetween(edtDeath.Field.AsDateTime,
                edtBurial.Field.AsDateTime) < 4);
            bwarning := bwarning or (MonthsBetween(
                edtDeath.Field.AsDateTime, edtBurial.Field.AsDateTime) > 1);
          end;
        edtBurial.Color := bColor[bValid];
        if bValid and bWarning then
            edtBurial.Color := clYellow or clLtGray;
      end
    else
        edtBurial.Color := clWindow;
end;

procedure TfrmTstHtmlParser2Main.actDataSetDeathExecute(Sender: TObject);
begin
    if DBMemo1.SelLength < 4 then
        DBMemo1.SelLength := 22;
    PutDateToControl(DBMemo1.SelText, edtDeath, 1, True);
end;

procedure TfrmTstHtmlParser2Main.actDataSetDeathUpdate(Sender: TObject);
var
    ersch: TDateTime;
    bValid: boolean;

begin
    actDataSetDeath.Enabled := DBMemo1.Text <> '';
    if (ActiveControl <> edtDeath) and not DataSource1.DataSet.FieldByName(
        'Erscheinungsdatum').isnull and not edtDeath.Field.isnull then
      begin
        ersch := DataSource1.DataSet.FieldByName('Erscheinungsdatum').AsDateTime;
        bValid := edtDeath.Field.AsDateTime < ersch;
        bValid := bValid and (edtDeath.Field.AsDateTime <> 0.0);
        if not edtBirth.Field.isnull and (edtBirth.Color = bColor[True]) then
          begin
            bValid := bValid and (edtBirth.Field.AsDateTime < edtDeath.Field.AsDateTime);
            bValid := bValid and
                (YearsBetween(edtBirth.Field.AsDateTime,
                edtDeath.Field.AsDateTime) < 120);
          end;
        if not DataSource1.DataSet.FieldByName('Rubrik').isnull and
            (DataSource1.DataSet.FieldByName('Rubrik').AsString <> '8055') and
            (DataSource1.DataSet.FieldByName('Rubrik').AsString <> '8056') then
            bValid := bValid and (YearsBetween(edtDeath.Field.AsDateTime, ersch) < 1);
        edtDeath.Color := bColor[bValid];
      end
    else
        edtDeath.Color := clWindow;
end;

procedure TfrmTstHtmlParser2Main.btnLoadXmlClick(Sender: TObject);
begin
    if chbXmlFound.Checked then
          try
            fraXmlView1.LoadXMLFile(lblDataPath.Caption + DirectorySeparator +
                changefileext(DBMemo1.DataSource.DataSet.FieldByName(
                'PNG').AsString, '.XML'));
            if DBMemo1.Text = '' then
              begin
                DBMemo1.DataSource.DataSet.Edit;
                DBMemo1.Lines.Text := fraXmlView1.Text;
                if chbAutoText.Checked then
                    actDataParseTextExecute(Sender);
              end;
          except

          end;
end;

procedure TfrmTstHtmlParser2Main.btnOCRCancelClick(Sender: TObject);
begin
    FCancel := True;
    chbAutocontinue.Checked := False;
end;

procedure TfrmTstHtmlParser2Main.actDataOCRImportExecute(Sender: TObject);
var
    sDBText: string;
    ppSuchtext, // Position of Searchstring
    startPosSuche: SizeInt; // Start Position

const
    ReplaceText: array[0..3] of string =
        ('†', 't',
        '()', '0');

begin
    // Edit ?!
    sDBText := Clipboard.AsText;
    ppSuchtext := pos(ReplaceText[0], sDBText);
    startPosSuche := 1;
    while ppSuchtext <> 0 do
      begin
        if (ppSuchtext > 2) and (sDBText[ppSuchtext - 1] in (['A'..'Z', 'a'..'z'])) then
            sDBText := copy(sDBText, 1, ppSuchtext - 1) + ReplaceText[1] +
                copy(sDBText, ppSuchtext + length(ReplaceText[0]),
                length(sDBText) - ppSuchtext)
        else if (ppSuchtext < length(sDBText) - length(ReplaceText[0])) and
            (sDBText[ppSuchtext + length(ReplaceText[0])] in (['a'..'z'] - ['t'])) then
            sDBText := copy(sDBText, 1, ppSuchtext - 1) + ReplaceText[1] +
                copy(sDBText, ppSuchtext + length(ReplaceText[0]),
                length(sDBText) - ppSuchtext)
        else
            startPosSuche := ppSuchtext + 1;
        ppSuchtext := pos(ReplaceText[0], copy(sDBText, startPosSuche, length(sDBText)));
        if ppSuchtext <> 0 then
            ppSuchtext := ppSuchtext + startPosSuche - 1;
      end;
    DBMemo1.Text := sdbText;
end;

procedure TfrmTstHtmlParser2Main.ResWebImport;
var
    lFileDate: TDateTime;
    lbPDFLoadSuccess: boolean;
    lbPNGLoadSuccess: boolean;

    sPDFFile: string;
    sPNGFile: string;
    ds: TDataSet;

begin
    ds := DataSource1.DataSet;
    sPNGFile := '';
    if not ds.FieldByName('PNG').isnull then
        sPNGFile := ds.FieldByName('PNG').AsString;
    sPDFFile := '';
    if not ds.FieldByName('PDF').isnull then
        sPDFFile := ds.FieldByName('PDF').AsString;
    lFileDate := ds.FieldByName('Erscheinungsdatum').AsDateTime;

    lbPDFLoadSuccess := False;
    lbPNGLoadSuccess := False;

    ResWebImport2(ds.FieldByName('Pfad').AsString, sPNGFile, sPDFFile, lFileDate,
        lbPNGLoadSuccess, lbPDFLoadSuccess);

    chbPNGFound.Checked := lbPNGLoadSuccess;
    chbPDFFound.Checked := lbPDFLoadSuccess;
    if chbAutoImage.Checked then
        FAutoLoadImage := True;
    if chbAutoText.Checked and chbPDFFound.Checked then
        FAutoProcPDF := True;
end;

procedure TfrmTstHtmlParser2Main.PutDateToControl(sDBText: string;
    const edtDate: TDBDateEdit; const aDatePos: integer; Force: boolean = False);
var
    sDate: string;
begin
    if (aDatePos <> 0) and (edtDate.Field.IsNull or
        (edtDate.Field.AsString = '30.12.1899') or Force) then
      begin
        sDate := dmRNZAnzeigen.ExtractDate(sDBText, aDatePos);
        edtDate.DataSource.DataSet.Edit;
        edtDate.Text := sDate;
      end;
end;

function TfrmTstHtmlParser2Main.ResWebImport2(const Path, PngFile, PDFFile: string;
    const FileDate: TDateTime; out PngSuccess, PDFSuccess: boolean): string;
var
    lURL: string;
    sHTMLPath: string;
    sBasepath, lFilename: string;
begin
    Result := '';
    PDFSuccess := False;
    PngSuccess := False;
    if dmRNZAnzeigen.GetFileAndHtmlPath(Path, sBasepath, sHTMLPath) then
      begin
        if not DirectoryExists(sBasepath + copy(sHTMLPath, 1, 2) +
            DirectorySeparator + sHTMLPath) then
            CreateDir(sBasepath + copy(sHTMLPath, 1, 2) +
                DirectorySeparator + sHTMLPath);
        if not DirectoryExists(sBasepath + copy(sHTMLPath, 1, 2) +
            DirectorySeparator + sHTMLPath + DirectorySeparator +
            '$FIL' + 'E') then
            CreateDir(sBasepath + copy(sHTMLPath, 1, 2) +
                DirectorySeparator + sHTMLPath + DirectorySeparator +
                '$' + 'FILE');

        if (PngFile <> '') then
          begin
            lURL := rsHttpCloudHdDURL + '/' + sHTMLPath +
                '/$FILE/' + PngFile;
            lFilename :=
                sBasepath + copy(sHTMLPath, 1, 2) + DirectorySeparator +
                sHTMLPath + DirectorySeparator + '$FILE' + DirectorySeparator +
                PngFile;
            // load PNG
            PngSuccess := DownloadFile(lURL, lFilename, FileDate);
          end;
        Application.ProcessMessages();

        if (PDFFile <> '') then
          begin
            lURL := rsHttpCloudHdDURL + '/' + sHTMLPath +
                '/$FILE/' + PDFFile;
            Result :=
                sBasepath + copy(sHTMLPath, 1, 2) + DirectorySeparator +
                sHTMLPath + DirectorySeparator + '$FILE' + DirectorySeparator +
                PDFFile;
            PDFSuccess := DownloadFile(lURL, Result, FileDate);
          end;
        Application.ProcessMessages();
      end;
end;

procedure TfrmTstHtmlParser2Main.actDataParseTextExecute(Sender: TObject);

begin
    dmRNZAnzeigen.ParseAnzeigenText(Sender, DBMemo1.Text, DBMemo1.DataSource.dataset,
        edtPlace.Items, OnParseData);
end;

procedure TfrmTstHtmlParser2Main.btnProcessPDF2Click(Sender: TObject);
var
    lPDFFile: string;
begin
    btnProcessPDF2.Enabled := False;
      try
        lPDFFile := lblDataPath.Caption + DirectorySeparator +
            DBImage1.DataSource.DataSet.FieldByName('PDF').AsString;
        ExecuteProcess(Utf8ToAnsi(cPDF2XMLConv),
            Utf8ToAnsi(lPDFFile), []);
        chbXmlFound.Checked :=
            FileExists(changefileext(lPDFFile, '.XML'));
        FAutoLoadXml := chbAutoContinue.Checked and chbXmlFound.Checked;
      finally
        btnProcessPDF2.Enabled := True;
      end;
end;

procedure TfrmTstHtmlParser2Main.actDataProcessPdfExecute(Sender: TObject);
begin
    if not actDataProcessPDF.Enabled then
        exit;
    if ssShift in FShiftState then
        OpenDocument(lblDataPath.Caption + DirectorySeparator +
            DBImage1.DataSource.DataSet.FieldByName('PDF').AsString)
    else
      begin
        actDataProcessPDF.Enabled := False;
        OpenDocument(lblDataPath.Caption + DirectorySeparator +
            DBImage1.DataSource.DataSet.FieldByName('PDF').AsString);
        Application.QueueAsyncCall(DoOCRandCopy, 0);
      end;
end;

procedure TfrmTstHtmlParser2Main.actDataRefreshPlacesExecute(Sender: TObject);
begin
    dmRNZAnzeigen.FillUpdOrte(edtPlace.Items);
end;

procedure TfrmTstHtmlParser2Main.cbxLinkedToDropDown(Sender: TObject);
begin
    if cbxLinkedTo.tag <> DataSource1.DataSet.FieldByName(rsAnzeigenID).AsInteger then
      begin
        cbxLinkedTo.tag := DataSource1.DataSet.FieldByName(rsAnzeigenID).AsInteger;
        dmRNZAnzeigen.FillLinkList(cbxLinkedTo.tag, cbxLinkedTo.Items);
      end;
end;

procedure TfrmTstHtmlParser2Main.cbxLinkedToExit(Sender: TObject);
var
    lInt: int64;
    lID: integer;
begin
    if cbxLinkedTo.ItemIndex = -1 then
      begin
        if (cbxLinkedTo.Text = '') and not DataSource1.DataSet.FieldByName(
            'LinkID').isnull then
          begin
            DataSource1.DataSet.Edit;
            DataSource1.DataSet.FieldByName('LinkID').Clear;
          end;
        if TryStrToInt64(cbxLinkedTo.Text, lInt) then
          begin
            lID := dmRNZAnzeigen.getidAnzeige(cbxLinkedTo.Text);
            if lid >= 0 then
              begin
                DataSource1.DataSet.Edit;
                DataSource1.DataSet.FieldByName('LinkID').AsInteger := lID;
              end;
          end;
      end;
end;

procedure TfrmTstHtmlParser2Main.cbxLinkedToSelect(Sender: TObject);
begin
    if (cbxLinkedTo.ItemIndex > -1) and
        (Ptrint(cbxLinkedTo.Items.Objects[cbxLinkedTo.ItemIndex]) > 0) then
      begin
        DataSource1.DataSet.Edit;
        DataSource1.DataSet.FieldByName('LinkID').AsInteger :=
            Ptrint(cbxLinkedTo.Items.Objects[cbxLinkedTo.ItemIndex]);
      end;
end;

procedure TfrmTstHtmlParser2Main.edtSetAgeExit(Sender: TObject);
begin
    edtSetAge.Visible := False;
end;

procedure TfrmTstHtmlParser2Main.edtSetAgeKeyPress(Sender: TObject; var Key: char);
var
    lAge: longint;
    lErsDate: TDateTime;
begin
    if key = #13 then
      begin
        // Set Age
        edtSetAge.Visible := False;
        lblAge.Caption := edtSetAge.Text;
        if trystrtoint(lblAge.Caption, lAge) then
          begin
            lErsDate := DataSource1.DataSet.FieldByName('Erscheinungsdatum').AsDateTime;
            if (edtBirth.Text = '') then
              begin
                edtBirth.DataSource.DataSet.Edit;
                DBComboBox1.ItemIndex := 3;    // Calculated.
                DBComboBox1.Field.AsString := DBComboBox1.Text;
                edtBirth.Text := '1.1.' + IntToStr(yearof(lErsDate) - lAge);
              end;
            if (edtDeath.Text = '') then
              begin
                edtDeath.DataSource.DataSet.Edit;
                edtDeath.Text :=
                    '1.' + IntToStr(monthof(lErsDate)) + '.' +
                    IntToStr(yearof(lErsDate));
              end;
          end;
      end;
    if key = #27 then
      begin
        // exit
        edtSetAge.Visible := False;
      end;
end;

procedure TfrmTstHtmlParser2Main.DataSource1DataChange(Sender: TObject; Field: TField);
var
    sBasepath, sHTMLPath: string;
    ds: TDataSet;

begin
    if Sender.InheritsFrom(TDataSource) then
      begin
        ds := TDataSource(Sender).DataSet;
        if TDataSource(Sender).State in [dsBrowse] then
          begin
            fraRNZAnzFilter1.SubjectTextHint := ds.FieldByName('Stichwort').AsString;
            fraRNZAnzFilter1.TaskTextHint := ds.FieldByName('Auftrag').AsString;

            UpdateAge(ds);

            if not ds.FieldByName('LinkID').isNull and
                (ds.FieldByName('LinkID').AsInteger > 0) then
              begin
                cbxLinkedTo.Enabled := True;
                cbxLinkedTo.Text :=
                    dmRNZAnzeigen.GetPersionBescr(ds.FieldByName('LinkID').AsInteger);
              end
            else if (rgRubrik.Field.AsString < '8055') or
                (rgRubrik.Field.AsString > '8080') then
              begin
                cbxLinkedTo.Enabled := False;
                cbxLinkedTo.Text := 'No Link';
              end
            else
              begin
                cbxLinkedTo.Enabled := True;
                cbxLinkedTo.Text := '<-->';
              end;

            if dmRNZAnzeigen.GetFileAndHtmlPath(ds.FieldByName('Pfad').AsString,
                sBasepath, sHTMLPath) then
              begin
                sBasepath := sBasepath + Copy(sHTMLPath, 1, 2) +
                    DirectorySeparator + sHTMLPath + DirectorySeparator + '$FILE';
                lblDataPath.Caption := sBasepath;
                if DirectoryExists(sBasepath) then
                  begin
                    chbPDFFound.Checked :=
                        fileexists(sBasepath + DirectorySeparator +
                        ds.FieldByName('PDF').AsString) and
                        (GetFileSize(sBasepath + DirectorySeparator +
                        ds.FieldByName('PDF').AsString) > 0);
                    chbXmlFound.Checked :=
                        fileexists(sBasepath + DirectorySeparator +
                        changefileext(ds.FieldByName('PNG').AsString, '.xml'));

                    if not ds.FieldByName('text').IsNull and
                        chbAutoText.Checked and
                        (((ds.FieldByName(edtPlace.DataField).IsNull and
                        ds.FieldByName(edtBurial.DataField).IsNull)) or
                        (ds.FieldByName(rgSex.DataField).IsNull and
                        (rgRubrik.Field.AsString < '8090')) or
                        (ds.FieldByName(edtBurial.DataField).IsNull and
                        (rgRubrik.Field.AsString = '8050'))) then
                        FAutoParseTxt := True
                    else if chbXmlFound.Checked and chbAutoText.Checked and
                        ds.FieldByName('text').IsNull then
                        FAutoLoadXml := True
                    else if chbPDFFound.Checked and chbAutoText.Checked and
                        ds.FieldByName('text').IsNull then
                        FAutoProcPDF := True;

                    chbPNGFound.Checked :=
                        fileexists(sBasepath + DirectorySeparator +
                        ds.FieldByName('PNG').AsString) and
                        (GetFileSize(sBasepath + DirectorySeparator +
                        ds.FieldByName('PNG').AsString) > 0);
                    if chbAutoImage.Checked and chbPNGFound.Checked and
                        ds.FieldByName('bild').IsNull then
                        FAutoLoadImage := True;
                  end
                else
                  begin
                    chbPDFFound.Checked := False;
                    chbXmlFound.Checked := False;
                    chbPNGFound.Checked := False;
                  end;
              end
            else
              begin
                chbPDFFound.Checked := False;
                chbXmlFound.Checked := False;
                chbPNGFound.Checked := False;
              end;
          end;
      end;
end;


procedure TfrmTstHtmlParser2Main.edtHaveCustomDate(Sender: TObject; var ADate: string);
var
    lDate: TDateTime;

begin
    // MonthNames to Number
    dmRNZAnzeigen.edtHaveCustomDate(DataSource1.DataSet.FieldByName(
        'Erscheinungsdatum').AsDateTime, Adate);

    if TryStrToDate(ADate, lDate) then
      begin
        // Update Age - Field
        if (Sender = edtBirth) and (not edtDeath.Field.IsNull) then
            lblAge.Caption :=
                IntToStr(YearsBetween(lDate - 0.2, edtDeath.Field.AsDateTime))
        else if (Sender = edtDeath) and (not edtBirth.Field.IsNull) then
            lblAge.Caption :=
                IntToStr(YearsBetween(edtBirth.Field.AsDateTime, lDate + 0.2));
      end;

end;

{$EndRegion RNZ-Details}

procedure TfrmTstHtmlParser2Main.btnOpenWebClick(Sender: TObject);
var
    sHTML: string;
begin
      try
        btnOpenWeb.Enabled := False;
        if PageControl1.ActivePageIndex = 0 then
          begin
            if Sender = btnOpenWeb then
                FWWWstart := 1;
            sHTML := VisualHTTPClient1.Get(rsHttpCloudHdDURL +
                '?OpenView&Count=' + IntToStr(100) + '&Start=' +
                IntToStr(FWWWstart) + '&ResortDescending=0');
            fraTrPortImport1.SetHtmlText(
                sHTML, rsHttpCloudHdDURL);
          end
        else if PageControl1.ActivePageIndex = 1 then
          begin
            ResWebImport;
          end;
      finally
        btnOpenWeb.Enabled := True;
      end;
end;

procedure TfrmTstHtmlParser2Main.btnSave1Click(Sender: TObject);
begin
    SaveDialog1.FileName := changefileext(cbxFilename.Text, '.csv');
    SaveDialog1.DefaultExt := '.CSV';
    if SaveDialog1.Execute then
      begin
        if fileexists(SaveDialog1.FileName) then
            RenameFile(SaveDialog1.FileName,
                ChangeFileExt(SaveDialog1.FileName, '.bak'));
        fraTrPortImport1.SaveToCSVFile(SaveDialog1.FileName, #9);
      end;
end;

procedure TfrmTstHtmlParser2Main.btnLoadFileClick(Sender: TObject);
var
    sf: TFileStream;
    s: string;
    i: integer;
begin
    if not FileExists(cbxFilename.Text) then
      begin
        MessageDlg('Datei kann nicht geladen werden', Format(
            'Datei "%s" nicht gefunden', [cbxFilename.Text]), mtError, [mbOK], 0);
        FNewFileFlag := False;
        chbAutocontinue.Checked := False;
        exit; (* !!!!!!!!!!!!! *)
      end;
      try
        btnLoadFile.Enabled := False;
        if not FNewFileFlag and (cbxFilename.ItemIndex = -1) then
          begin
            cbxFilename.Items.add(cbxFilename.Text);
            dmRNZAnzeigen.ObjectValue[cbxFilename, 'ICount'] := cbxFilename.Items.Count;
            for i := 0 to cbxFilename.Items.Count - 1 do
                dmRNZAnzeigen.ObjectValue[cbxFilename, IntToStr(i)] :=
                    cbxFilename.Items[i];
          end;
        sf := TFileStream.Create(cbxFilename.Text, fmOpenRead);
          try
            setlength(s, sf.Size);
            sf.ReadBuffer(s[1], sf.Size);
          finally
            FreeAndNil(sf);
          end;
        fraTrPortImport1.SetHtmlText(s, '');
        //  IpHtmlPanel1.OpenURL('file://'+cbxFilename.Text);
      finally
        btnLoadFile.Enabled := True;
      end;
end;

procedure TfrmTstHtmlParser2Main.btnBrowseHtmlClick(Sender: TObject);
begin
    OpenDialog1.FileName := cbxFilename.Text;
    if OpenDialog1.Execute then
      begin
        cbxFilename.Text := OpenDialog1.FileName;
        btnLoadFileClick(Sender);
      end;
end;

procedure TfrmTstHtmlParser2Main.btnSaveSchemaClick(Sender: TObject);
begin
    SaveDialog1.FileName := cbxFilenameSchema.Text;
    if SaveDialog1.Execute then
      begin
        if fileexists(SaveDialog1.FileName) then
            RenameFile(SaveDialog1.FileName,
                ChangeFileExt(SaveDialog1.FileName, '.bak'));
        fraTrPortImport1.mSchema.Lines.SaveToFile(SaveDialog1.FileName);
      end;
end;


procedure TfrmTstHtmlParser2Main.chbVerbose1Change(Sender: TObject);
begin
    fraTrPortImport1.SetVerbosity(chbVerbose1.Checked);
end;

procedure TfrmTstHtmlParser2Main.chbVerboseChange(Sender: TObject);
begin
    fraTrPortImport1.mLog.Visible := chbVerbose.Checked;
end;

procedure TfrmTstHtmlParser2Main.FormCreate(Sender: TObject);
begin
    lblCompiledOn.Caption := format(lblCompiledOn.Caption, [CDate, CName]);
    fraRNZAnzFilter1 := TfraRNZAnzFilter.Create(self);
    fraRNZAnzFilter1.Parent := pnlP2Top;
    fraRNZAnzFilter1.Align := alClient;
    fraRNZAnzFilter1.DataSource := DataSource1;
end;

procedure TfrmTstHtmlParser2Main.FormKeyDown(Sender: TObject;
    var Key: word; Shift: TShiftState);
begin
    FShiftState := Shift;
end;

procedure TfrmTstHtmlParser2Main.FormKeyUp(Sender: TObject; var Key: word;
    Shift: TShiftState);
begin
    FShiftstate := Shift;
end;

procedure TfrmTstHtmlParser2Main.FormShow(Sender: TObject);
var
    CBCount, i: integer;
begin
    CBCount := dmRNZAnzeigen.GetObjectValue(cbxFilename, 'ICount', 0);
    for i := 0 to CBCount - 1 do
      begin
        cbxFilename.Items.Add(dmRNZAnzeigen.GetObjectValue(cbxFilename,
            IntToStr(i), ''));
        if cbxFilename.Text = cbxFilename.Items[i] then
            cbxFilename.ItemIndex := i;
      end;
    CBCount := dmRNZAnzeigen.GetObjectValue(cbxFilenameSchema, 'ICount', 0);
    for i := 0 to CBCount - 1 do
      begin
        cbxFilenameSchema.Items.Add(dmRNZAnzeigen.GetObjectValue(
            cbxFilenameSchema, IntToStr(i), ''));
        if cbxFilenameSchema.Text = cbxFilenameSchema.Items[i] then
            cbxFilenameSchema.ItemIndex := i;
      end;
    if (cbxFilenameSchema.ItemIndex = -1) and (cbxFilenameSchema.Items.Count > 0) then
        cbxFilenameSchema.ItemIndex := 0;
    FDatapath := 'Data';
    for i := 0 to 2 do
        if DirectoryExists(FDataPath) then
            Break
        else
            FDataPath := '..' + DirectorySeparator + FDataPath;
    dmRNZAnzeigen.Flush;
    dmRNZAnzeigen.FillUpdOrte(edtPlace.Items);
end;

procedure TfrmTstHtmlParser2Main.IdleTimer1StartTimer(Sender: TObject);
begin
    FIdle := True;

end;

procedure TfrmTstHtmlParser2Main.IdleTimer1StopTimer(Sender: TObject);
begin
    FIdle := False;
{  try
  dmRNZAnzeigen.sqlconMySQL57Connection1.Close();
  dmRNZAnzeigen.sqlconMySQL57Connection1.Open;
  Except
  end;   }
end;

procedure TfrmTstHtmlParser2Main.IdleTimer1Timer(Sender: TObject);
begin
    if not dmRNZAnzeigen.qryTableAnzeigen.Active then
        dmRNZAnzeigen.qryTableAnzeigen.Active :=
            not FIdle and dmRNZAnzeigen.sqlconMySQL57Connection1.Connected;
    if chbAutocontinue.Checked and FNewFileFlag and btnDoParse.Enabled and
        (PageControl1.ActivePageIndex = 0) then
          try
            IdleTimer1.Enabled := False;
            btnLoadFileClick(Sender);
            btnDoParseClick(Sender);
          finally
            IdleTimer1.Enabled := True;
          end
    else if chbAutocontinue.Checked and FNewWWWPage and btnDoParse.Enabled and
        (PageControl1.ActivePageIndex = 0) then
          try
            IdleTimer1.Enabled := False;
            btnOpenWebClick(Sender);
            btnDoParseClick(Sender);
          finally
            IdleTimer1.Enabled := True;
          end;
    if chbAutocontinue.Checked and (PageControl1.ActivePageIndex = 1) then
      begin
        if FCheckFiles then
          begin
            FCheckFiles := False;
            if chbPNGFound.Checked or chbPDFFound.Checked then
                Fnextds := True
            else if btnOpenWeb.Enabled then
                btnOpenWebClick(Sender)
            else
                FCheckFiles := True;
          end
        else
        if FNextDS and (not FAutoLoadXml) and (btnLoadxml.Enabled) and
            (not FAutoProcPDF) and (btnProcessPDF2.Enabled) and
            (not FAutoParseTxt) and (btnParseText.Enabled) and
            (actDataProcessPDF.Enabled) and ((pbrPDFProgress.Position = 0) or
            (pbrPDFProgress.Position = 150)) then
          begin
            Fnextds := False;
            DataSource1.DataSet.Next;
            FCheckFiles := True;
          end;
      end;
    if FAutoParseTxt then
      begin
        FAutoParseTxt := False;
        actDataParseTextExecute(Sender);
        FNextDS := chbAutocontinue.Checked and not FAutoLoadImage;
      end
    else
    if FAutoLoadImage and btnOpenWeb.Enabled then
      begin
        FAutoLoadImage := False;
        btnLoadPngClick(Sender);
        FNextDS := chbAutocontinue.Checked and not FAutoLoadXml;
      end
    else
    if FAutoLoadXml then
      begin
        FAutoLoadXml := False;
        btnLoadxmlClick(Sender);
        if (DBMemo1.Text = '') and chbAutocontinue.Checked then
            actDataProcessPdfExecute(Sender)
        else
            FNextDS := chbAutocontinue.Checked and not FAutoLoadImage;
      end
    else
    if FAutoProcPDF then
      begin
        FAutoProcPDF := False;
        btnProcessPDF2Click(Sender);
        //        FNextDS := chbAutocontinue.Checked and not FAutoLoadImage;
      end;
end;

procedure TfrmTstHtmlParser2Main.lblAgeClick(Sender: TObject);
begin
    edtSetAge.Text := lblAge.Caption;
    edtSetage.Visible := True;
    ActiveControl := edtSetAge;
end;

procedure TfrmTstHtmlParser2Main.UpdateAge(const ds: TDataSet);
begin
    if not ds.FieldByName(rsAnzeigenGeburt).IsNull and not
        ds.FieldByName(rsAnzeigenTod).IsNull then
        lblAge.Caption := IntToStr(
            YearsBetween(ds.FieldByName(rsAnzeigenGeburt).AsDateTime,
            ds.FieldByName(rsAnzeigenTod).AsDateTime))
    else
        lblAge.Caption := 'NA';
end;

procedure TfrmTstHtmlParser2Main.lblDataPathClick(Sender: TObject);
begin
    OpenDocument(lblDataPath.Caption);
end;

procedure TfrmTstHtmlParser2Main.DoOCRandCopy(Data: PtrInt);
var
    i: integer;
    PdfVHandle: THandle;
    Auftrag: string;
begin
    PdfVHandle := FindWindow('DSUI:PDFXCViewer');
    FCancel := False;
    Auftrag := DataSource1.dataset.FieldByName('Auftrag').AsString;
    pbrPDFProgress.Position := 0;
      try
        for i := 0 to 39 do
          begin
            sleep(100);
            pbrPDFProgress.Position := i div 2;
            if copy(GetWindowName(PdfVHandle), 1, length(Auftrag)) = Auftrag then
                break;
            if FCancel then
                exit;
            Application.ProcessMessages;
          end;
        ActivateWindow(PdfVHandle);
        if copy(GetWindowName(PdfVHandle), 1, length(Auftrag)) <> Auftrag then
            exit;
        pbrPDFProgress.Position := 10;
        Application.ProcessMessages;
        KeyInput.Apply([ssCtrl, ssShift]);
        KeyInput.Press(VK_C);
        KeyInput.unApply([ssCtrl, ssShift]);
        sleep(500);
        pbrPDFProgress.Position := 20;
        KeyInput.Press(VK_RETURN);
        for i := 0 to 120 do
          begin
            sleep(100);
            pbrPDFProgress.Position := 22 + i;
            if copy(GetWindowName(PdfVHandle), length(Auftrag) + 1, 1) = '*' then
                break;
            if FCancel then
                exit;
            Application.ProcessMessages;
          end;
        ActivateWindow(PdfVHandle);
        if copy(GetWindowName(PdfVHandle), length(Auftrag) + 1, 1) <> '*' then
          begin
            KeyInput.Press(VK_ESCAPE);
            sleep(100);
            KeyInput.Press(VK_W);
            exit;
          end;
        KeyInput.Apply([ssCtrl]);
        KeyInput.Press(VK_A);
        sleep(200);
        Clipboard.Clear;
        KeyInput.Press(VK_C);
        sleep(200);
        KeyInput.Press(VK_W);
        KeyInput.unApply([ssCtrl]);
        pbrPDFProgress.Position := 145;
        sleep(400);
        KeyInput.Press(VK_RIGHT);
        sleep(100);
        KeyInput.Press(VK_RETURN);
        pbrPDFProgress.Position := 149;
        //DBMemo1.Clear;
        if Clipboard.AsText <> '' then
          begin
            actDataOCRImportExecute(nil);
            actDataParseTextExecute(nil);
          end;
        if not DataSource1.dataset.EOF then
            FNextDS := chbAutocontinue.Checked and not FAutoLoadImage;
      finally
        actDataProcessPDF.Enabled := True;
        pbrPDFProgress.Position := 150;

      end;
end;

procedure TfrmTstHtmlParser2Main.HTMLParseOnNewFilename(Sender: TObject; st: string);
var
    NewFile, sFilepath: string;
begin
    NewFile := st;
    lblRCount4.Caption := format('(%0:d) %1:s', [FAppended, FMaxDate]);
    sFilepath := CleanPath(ExtractFilePath(cbxFilename.Text));
    if (copy(NewFile, 1, 1) <> '/') then
      begin
        if (copy(sFilepath, length(sFilepath) - 3, 1) = DirectorySeparator) and
            (copy(NewFile, 1, 2) <> '..') then
            if copy(Newfile, length(NewFile) - length(ExtractFileExt(NewFile)) -
                1, 1) <> '-' then
                cbxFilename.Text :=
                    copy(sFilepath, 1, length(sFilepath) - 3) +
                    copy(Newfile, length(NewFile) -
                    length(ExtractFileExt(NewFile)) - 3, 2) +
                    DirectorySeparator + NewFile
            else
                cbxFilename.Text :=
                    copy(sFilepath, 1, length(sFilepath) - 3) +
                    copy(Newfile, length(NewFile) -
                    length(ExtractFileExt(NewFile)) - 5, 2) +
                    DirectorySeparator + NewFile
        else
            cbxFilename.Text :=
                sFilepath + StringReplace(NewFile, '/', DirectorySeparator,
                [rfReplaceAll]);
        FNewFileFlag := True;
      end
    else
      begin
        // www
        FWWWstart := FWWWstart + 100;
        FNewWWWPage := True;
      end;
end;

procedure TfrmTstHtmlParser2Main.HTMLParseOnRowComplete(Sender: TObject; st: TStrings);
var
    lFilename, lPath, lPngFile, lPDFFile: string;
    lFileDate: TDateTime;
    lPDFSuccess, lPngSuccess: boolean;

begin
    if chbAppendDB.Checked then
      begin
        if dmRNZAnzeigen.AppendDBData(st) then
          begin
            Inc(FAppended);
            lPath := ST[2];
            TryStrToDateTime(ST[10], lFileDate);
            lPngFile := ST[14];
            lPDFFile := ST[13];

            lFilename := ResWebImport2(lPath, lPngFile, lPDFFile,
                lFileDate, lPngSuccess, lPDFSuccess);
            if lPDFSuccess then
              begin
                // Todo: Convert PDF to XML
                ExecuteProcess(Utf8ToAnsi(cPDF2XMLConv),
                    Utf8ToAnsi(lFilename), []);
                // Todo: XML 2 Text
                //  if  FileExists(changefileext(lPDFFile, '.XML')) then

                // Todo: Parse Text
              end;

          end;
        if (FMaxDate = '') or (ST[10] > FmaxDate) then
            FMaxDate := ST[10];
      end;
end;

procedure TfrmTstHtmlParser2Main.OnParseData(Sender: TObject;
    dtKind: integer; Data: string);
var
    lDS: TDataSet;
begin
    lDS := DataSource1.DataSet;
    case TEnumDataKind(dtKind) of
        dkMaidenname:
          begin
            lDS.Edit;
            edtMaidenname.Text := Data;

          end;

        dkBirth: PutDateToControl(Data, edtBirth, 1);

        dkDeath: PutDateToControl(Data, edtDeath, 1);

        // Ort Eintragen
        dkPlace:
          begin
            lDS.Edit;
            lDS.FieldByName(rsAnzeigenOrt).AsString := Data;
          end;

        dkBurial: PutDateToControl(Data, edtBurial, 1);

        dkGeschlecht:
          begin
            lds.edit;
            lds.FieldByName(rsAnzeigenGeschlecht).AsString := Data;
          end;
      end;

end;

procedure TfrmTstHtmlParser2Main.UpdateProgress(Sender: TObject; Data: PtrInt);
begin
    if Data >= 0 then
        pbrPDFProgress.Position := Data mod pbrPDFProgress.Max
    else if Data = -1 then
        pbrPDFProgress.Position := pbrPDFProgress.Max;
    Application.ProcessMessages;
end;


procedure TfrmTstHtmlParser2Main.btnSaveClick(Sender: TObject);
begin
    SaveDialog1.FileName := cbxFilename.Text;
    if SaveDialog1.Execute then
      begin
        if fileexists(SaveDialog1.FileName) then
            RenameFile(SaveDialog1.FileName,
                ChangeFileExt(SaveDialog1.FileName, '.bak'));
        fraTrPortImport1.mOutput.Lines.SaveToFile(SaveDialog1.FileName);
      end;
end;

end.
