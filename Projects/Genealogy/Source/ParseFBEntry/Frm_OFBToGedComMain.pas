unit Frm_OFBToGedComMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ActnList, StdActns,
  ExtCtrls, StdCtrls, Buttons, ComCtrls, Unt_Config, fra_OFBView, unt_FBParser,
  Cmp_GedComFile, cls_GedComHelper, fra_NavIData, cls_HejData, cls_HejHelper;

type

  { TFrmOFBToGedComMain }

  TFrmOFBToGedComMain = class(TForm)
    actDoSomething: TAction;
    actFileLoad: TAction;
    actFileOpen: TFileOpen;
    actFileSave: TAction;
    actFileSaveAs: TFileSaveAs;
    alsXMLFile: TActionList;
    btnParseDebug: TBitBtn;
    btnPrev: TBitBtn;
    btnFirst: TBitBtn;
    btnNext: TBitBtn;
    btnLast: TBitBtn;
    btnExpEntry: TBitBtn;
    btnSaveGC: TBitBtn;
    btnSaveGC1: TBitBtn;
    chbReverse: TCheckBox;
    Config1: TConfig;
    edtIDPrepos: TEdit;
    edtDefaultPlace: TEdit;
    fraNavIData1: TfraNavIData;
    Label1: TLabel;
    Label2: TLabel;
    Memo1: TMemo;
    Panel2: TPanel;
    btnParseToGed: TBitBtn;
    btnClear: TBitBtn;
    btnClose: TBitBtn;
    btnLoad: TBitBtn;
    btnOpen: TBitBtn;
    btnSave: TBitBtn;
    edtFilename: TComboBox;
    fraOFBView: TFraOFBView;
    ilsOdfFile: TImageList;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    pnlLeft2: TPanel;
    pnlLeft: TPanel;
    pnlBottom: TPanel;
    btnParseToHej: TBitBtn;
    SaveDialog1: TSaveDialog;
    btnStopParse: TSpeedButton;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    StatusBar1: TStatusBar;
    procedure actFileLoadExecute(Sender: TObject);
    procedure actFileOpenAccept(Sender: TObject);
    procedure actFileOpenBeforeExecute(Sender: TObject);
    procedure btnExpEntryClick(Sender: TObject);
    procedure btnParseDebugClick(Sender: TObject);
    procedure btnSaveGC1Click(Sender: TObject);
    procedure btnSaveGCClick(Sender: TObject);
    procedure btnStopParseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnParseToHejClick(Sender: TObject);
    procedure btnParseToGedClick(Sender: TObject);
  private
    FBreakParsing: Boolean;
    FDataPath: String;
    Fdebug: Boolean;
    fParser:TFBEntryParser;
    FGedComFile : TGedComFile;
    FgedComHelper : TGedComHelper;
    FHejHelper : THejHelper;
    FHejObj : TClsHejGenealogy;
    FState: String;
    procedure ParserError(Sender: TObject);
    procedure ParserMessage(Sender: TObject; aType: TEventType; aText: string;
      Ref: string; aMode: integer);
    procedure HelperMessage(Sender: TObject; aType: TEventType; aText: string;
      Ref: string; aMode: integer);
  public

  end;

var
  FrmOFBToGedComMain: TFrmOFBToGedComMain;

implementation

{$R *.lfm}

{ TFrmOFBToGedComMain }

procedure TFrmOFBToGedComMain.actFileLoadExecute(Sender: TObject);
var
  Section: String;
begin
  fraOFBView.LoadFile(edtFilename.Text);
  Section := 'File_'+ExtractFileName(edtFilename.Text);
  edtDefaultPlace.Caption := config1.getvalue(Section,'DefaultPlace',edtDefaultPlace.Caption);
  edtIDPrepos.Caption := config1.getvalue(Section,'IDPrepos',edtIDPrepos.Caption);
end;

procedure TFrmOFBToGedComMain.actFileOpenAccept(Sender: TObject);
var
  i: Integer;

begin
    edtFilename.Text:= actFileOpen.Dialog.FileName;
    if edtFilename.ItemIndex = -1 then
      begin
        edtFilename.Items.Insert(0,edtFilename.Text);
        config1.setvalue('System','FileCnt',edtFilename.Items.Count);
        for i := 0 to edtFilename.Items.Count-1 do
          config1.setvalue('System','File'+inttostr(i),edtFilename.Items[i]);
      end;
    config1.setvalue('System','FileIdx',edtFilename.ItemIndex);
    actFileLoad.Execute;
end;

procedure TFrmOFBToGedComMain.actFileOpenBeforeExecute(Sender: TObject);
begin
  actFileOpen.Dialog.Filter:='OpenDocument (*.odt)|*.odt|Alle Dateien (*.*)|*.*';
end;

procedure TFrmOFBToGedComMain.btnExpEntryClick(Sender: TObject);
var
  lFilename: String;
begin
  lFilename:=FDataPath+DirectorySeparator+edtIDPrepos.text+
    format('%.4d',[fraOFBView.GetActID+1])+'.entTxt';
  if Fileexists(lFilename) then
    DeleteFile(lFilename);
  fraOFBView.Lines.SaveToFile(lFilename);
end;

procedure TFrmOFBToGedComMain.btnParseDebugClick(Sender: TObject);
var
  i, lc: Integer;
begin
  Fdebug := true;
  lc:=0;
  fParser.DefaultPlace:= edtDefaultPlace.Text;

 if fraOFBView.SelCount=1 then
   begin
     FHejHelper.Citation := fraOFBView.Lines;
     fParser.Feed(fraOFBView.Data);
     fraOFBView.next;
   end
 else
   for i := 0 to fraOFBView.Count-1 do
     if fraOFBView.Selected[i] then
       begin
         FHejHelper.Citation:= fraOFBView.GetLines(i);
         fParser.Feed(FHejHelper.Citation.Text);
         inc(lc);
         if lc mod 10 = 0 then
           begin
           Label2.Caption:=inttoStr(FHejHelper.HejObj.Count);
           Application.ProcessMessages;

           end;
       end;
   Fdebug := false;
end;

procedure TFrmOFBToGedComMain.btnSaveGC1Click(Sender: TObject);
begin
  SaveDialog1.DefaultExt:='.hej';
  SaveDialog1.Filter:='AhnenWin-Sicherung (*.hej)|*.hej|Alle Dateien (*.*)|*.*';
  if SaveDialog1.Execute then
    FHejHelper.SaveToFile(SaveDialog1.FileName);
end;

procedure TFrmOFBToGedComMain.btnSaveGCClick(Sender: TObject);
begin
  SaveDialog1.DefaultExt:='.ged';
  SaveDialog1.Filter:='GedCom (*.ged)|*.ged|Alle Dateien (*.*)|*.*';
  if SaveDialog1.Execute then
    FgedComHelper.SaveToFile(SaveDialog1.FileName);
end;

procedure TFrmOFBToGedComMain.btnStopParseClick(Sender: TObject);
begin
  FBreakParsing := true;
end;

procedure TFrmOFBToGedComMain.FormCreate(Sender: TObject);
var
  lCount,i: Integer;
begin
  fraOFBView:=TFraOFBView.Create(self);
  fraOFBView.Parent := pnlLeft;
  fraOFBView.Align:=alClient;
  fraNavIData1.Data := fraOFBView;
  FDataPath := 'Data';
  for i := 0 to 2 do
    if DirectoryExists(FDataPath) then
      break
    else
      FDataPath:='..'+DirectorySeparator+FDataPath;
  FDataPath:=FDataPath+DirectorySeparator+'ParseFB';
  fParser:=TFBEntryParser.Create;
  fParser.GNameHandler.LoadGNameList(FDataPath+DirectorySeparator+'GNameFile.txt');
  fParser.onParseMessage:=@ParserMessage;
  FGedComFile:=TGedComFile.Create;
  FgedComHelper := TGedComHelper.Create;
  FgedComHelper.GedComFile := FGedComFile;
  FgedComHelper.CreateNewHeader('Dummy');
  FHejObj := TClsHejGenealogy.Create;
  FHejHelper := THejHelper.Create;
  FHejHelper.HejObj :=FHejObj;
  edtFilename.Items.Insert(0,edtFilename.Text);
  lCount := config1.Getvalue('System','FileCnt',0);
  edtFilename.Items.Clear;
  for i := 0 to lCount-1 do
    edtFilename.Items.Add(config1.getvalue('System','File'+inttostr(i),''));
  edtFilename.ItemIndex:=config1.getvalue('System','FileIdx',0);
end;

procedure TFrmOFBToGedComMain.FormDestroy(Sender: TObject);
begin
  fraNavIData1.Data := nil;
  FreeAndNil(fParser);
  FreeAndNil(FgedComHelper);
  FreeAndNil(FGedComFile);
  FHejHelper.clear;
  freeandnil(FHejHelper);
  FreeAndNil(FHejObj);
end;

procedure TFrmOFBToGedComMain.btnClearClick(Sender: TObject);
begin
  FGedComFile.Clear;
  FgedComHelper.CreateNewHeader('Dummy');
  FHejHelper.Clear;
  Memo1.Clear;
end;

procedure TFrmOFBToGedComMain.btnParseToHejClick(Sender: TObject);
  var
    i, lc: Integer;
    Section:string;
  begin
    Section := 'File_'+ExtractFileName(edtFilename.Text);
    config1.setvalue(Section,'DefaultPlace',edtDefaultPlace.Caption);
    config1.Setvalue(Section,'IDPrepos',edtIDPrepos.Caption);

    fParser.onStartFamily:=@FHejHelper.StartFamily;
     fParser.onFamilyType:=@FHejHelper.FamilyType;
     fParser.onFamilyDate:=@FHejHelper.FamilyDate;
     fParser.onFamilyPlace:=@FHejHelper.FamilyPlace;
     fParser.onFamilyIndiv:=@FHejHelper.FamilyIndiv;
     fParser.onIndiName:=@FHejHelper.IndiName;
     fParser.onIndiDate:=@FHejHelper.IndiDate;
     fParser.onIndiPlace:=@FHejHelper.IndiPlace;
     fParser.onIndiOccu:=@FHejHelper.IndiOccu;
     fParser.onIndiRel:=@FHejHelper.IndiRel;
     fParser.onIndiRef:=@FHejHelper.IndiRef;
     fParser.onIndiData:=@FHejHelper.IndiData;
     FHejHelper.CitTitle := 'Pg. ';
     FHejHelper.OsbHdr:=edtIDPrepos.text;
     lc:=0;
     fParser.DefaultPlace:= edtDefaultPlace.Text;

    if fraOFBView.SelCount=1 then
      begin
        FHejHelper.Citation := fraOFBView.Lines;
        fParser.Feed(fraOFBView.Data);
        fraOFBView.next;
      end
    else
      for i := 0 to fraOFBView.Count-1 do
        if fraOFBView.Selected[i] then
          begin
            FHejHelper.Citation:= fraOFBView.GetLines(i);
            fParser.Feed(FHejHelper.Citation.Text);
            inc(lc);
            if lc mod 10 = 0 then
              begin
              Label2.Caption:=inttoStr(FHejHelper.HejObj.Count);
              Application.ProcessMessages;

              end;
          end;
    Label2.Caption:=inttoStr(FHejHelper.HejObj.Count);
  end;


procedure TFrmOFBToGedComMain.btnParseToGedClick(Sender: TObject);
var
  i, lc: Integer;
  Section:String;

  function ParseSelEntry(i:integer):boolean;
  begin
    result := true;
    if fraOFBView.Selected[i] then
      begin
        FgedComHelper.Citation:= fraOFBView.GetLines(i);
        fParser.Feed(FgedComHelper.Citation.Text);
        inc(lc);
        if lc mod 10 = 0 then
          begin
             Label1.Caption:=inttoStr(FgedComHelper.GedComFile.Count);
             StatusBar1.Panels[1].Text:=FState;
             Application.ProcessMessages;
          end;
        if FBreakParsing then
          begin
            FBreakParsing := false;
            memo1.Append('<------------ User Break -------------->');
            result := false;
          end;
      end;
  end;

begin
  Section := 'File_'+ExtractFileName(edtFilename.Text);
  config1.setvalue(Section,'DefaultPlace',edtDefaultPlace.Caption);
  config1.Setvalue(Section,'IDPrepos',edtIDPrepos.Caption);

  fParser.onStartFamily:=@FgedComHelper.StartFamily;
   fParser.onFamilyType:=@FgedComHelper.FamilyType;
   fParser.onFamilyDate:=@FgedComHelper.FamilyDate;
   fparser.onFamilyData:=@FgedComHelper.FamilyData;
   fParser.onFamilyPlace:=@FgedComHelper.FamilyPlace;
   fParser.onFamilyIndiv:=@FgedComHelper.FamilyIndiv;
   fParser.onIndiName:=@FgedComHelper.IndiName;
   fParser.onIndiDate:=@FgedComHelper.IndiDate;
   fParser.onIndiPlace:=@FgedComHelper.IndiPlace;
   fParser.onIndiOccu:=@FgedComHelper.IndiOccu;
   fParser.onIndiRel:=@FgedComHelper.IndiRel;
   fParser.onIndiRef:=@FgedComHelper.IndiRef;
   fParser.onIndiData:=@FgedComHelper.IndiData;

   FgedComHelper.CitTitle := 'Pg. ';
   FgedComHelper.OsbHdr:=edtIDPrepos.text;
   FgedComHelper.onHlpMessage:=@HelperMessage;

   fParser.DefaultPlace := edtDefaultPlace.text;
   lc:=0;
  if fraOFBView.SelCount=1 then
    begin
      FgedComHelper.Citation := fraOFBView.Lines;
      fParser.Feed(fraOFBView.Data);
      fraOFBView.next;
    end
  else
    try
      btnParseToGed.Enabled:=false;
      FBreakParsing := false;
      if not chbReverse.Checked then
      for i := 0 to fraOFBView.Count-1 do
        if not ParseSelEntry(i) then break else
      else
      for i := fraOFBView.Count-1 downto 0 do
        if not ParseSelEntry(i) then break;
    finally
      btnParseToGed.Enabled:=true;
    end;
  Label1.Caption:=inttoStr(FgedComHelper.GedComFile.Count);
end;

procedure TFrmOFBToGedComMain.ParserError(Sender: TObject);
begin
  memo1.Append('Err: ('+fParser.MainRef+') '+fParser.LastErr);
end;

procedure TFrmOFBToGedComMain.ParserMessage(Sender: TObject; aType: TEventType;
  aText: string; Ref: string; aMode: integer);

begin
  case atype of
    etCustom: ;
    etInfo: ;
    etWarning:   memo1.Append('Warning: ('+Ref+','+inttostr(aMode)+') '+aText);
    etError:   memo1.Append('!PErr: ('+Ref+','+inttostr(aMode)+') '+aText);
    etDebug: begin FState := 'st ('+Ref+','+inttostr(aMode)+') '+aText;
         if Fdebug then
           memo1.Append(FState);
    end;
  end;
end;

procedure TFrmOFBToGedComMain.HelperMessage(Sender: TObject; aType: TEventType;
  aText: string; Ref: string; aMode: integer);
begin
  case atype of
    etCustom: ;
    etInfo: ;
    etWarning:   memo1.Append('Warning: ('+Ref+','+inttostr(aMode)+') '+aText);
    etError:   memo1.Append('!!Err: ('+Ref+','+inttostr(aMode)+') '+aText);
    etDebug: FState := 'st ('+Ref+','+inttostr(aMode)+') '+aText;
  end;
end;

end.

