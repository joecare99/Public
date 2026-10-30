unit fra_HtmlImp;

{$mode delphi}

interface

uses
  Classes, SysUtils, Forms, Controls, ExtCtrls, StdCtrls,
  HtmlView, cmp_filter;

type
  TCoumputeOutput=procedure(CType: byte; Text: String) of Object;

  { TFraHtmlImport }

  TFraHtmlImport = class(TFrame)
    HTMLViewer1: THtmlViewer;
    lblCaret: TLabel;
    mHTML: TMemo;
    mLog: TMemo;
    mSchema: TMemo;
    pnlClient: TPanel;
    pnlT1Left: TPanel;
    Splitter1: TSplitter;
    splRight2: TSplitter;
    splRight1: TSplitter;
    procedure FrameResize(Sender: TObject);
    procedure mSchemaClick(Sender: TObject);
    procedure mSchemaKeyPress(Sender: TObject; var {%H-}Key: char);
    procedure mSchemaKeyUp(Sender: TObject; var {%H-}Key: Word; {%H-}Shift: TShiftState);
    procedure splRight2Moved(Sender: TObject);
  private
    Acttag: String;
    FFilter: TBaseFilter;
    FOnNewPlainText: TNotifyEvent;
    FOnSplitterMove: TNotifyEvent;
    FPlainLine: String;
    FPlainText: TStringList;
    FSchemaVisible: boolean;
    FShowHTML: boolean;
    FVerbose: boolean;
    FComputeOutput:TCoumputeOutput;
    FTagMark,TagPath: String;
    OldTestline: Integer;
    procedure FilterLineChange(Sender: TObject);
    procedure LogParseTag(s: String);
    procedure Parse2OnStdText(Sender: TObject; Text: string);
    procedure Parse2OnStartTag(Sender: TObject; Text: string);
    procedure Parse2OnEndTag(Sender: TObject; Text: string);
    procedure ParseOnStdText(Sender: TObject; Text: string);
    procedure ParseOnStartTag(Sender: TObject; Text: string);
    procedure ParseOnTagMod(Sender: TObject; Text: string);
    procedure ParseOnEndTag(Sender: TObject; Text: string);
    procedure ParseOnComment(Sender: TObject; Text: string);
    procedure ParseOnScript(Sender: TObject; Text: string);
    Procedure ComputeFiltered(CType: byte; Text: String);
    procedure SetComputeOutput(AValue: TCoumputeOutput);
    procedure SetOnNewPlainText(AValue: TNotifyEvent);
    procedure SetOnSplitterMove(AValue: TNotifyEvent);
    procedure SetSchemaVisible(AValue: boolean);
    procedure SetShowHTML(AValue: boolean);
    procedure SetVerbose(AValue: boolean);
    procedure UpdateCaret({%H-}Data: PtrInt);
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetHtmlText(sHTML, sRef: string);
    Procedure SetSchema(s:String);
    procedure SchemaSaveToFile(const FileName:string);
    Procedure DoParse(Sender:Tobject);
    property PlainText:TStringList read FPlainText;
    property Verbose:boolean read FVerbose write SetVerbose;
    property SchemaVisible:boolean read FSchemaVisible write SetSchemaVisible;
    property ShowHTML:boolean read FShowHTML write SetShowHTML;
    property OnComputeOutput:TCoumputeOutput read FComputeOutput write SetComputeOutput;
    property OnNewPlainText:TNotifyEvent read FOnNewPlainText write SetOnNewPlainText;
    property OnSplitterMove:TNotifyEvent read FOnSplitterMove write SetOnSplitterMove;
  end;

implementation

uses LConvEncoding, cmp_Parser, Unt_StringProcs,HtmlGlobals;

{$R *.lfm}

{ TFraHtmlImport }

procedure TFraHtmlImport.ParseOnStdText(Sender: TObject; Text: string);

begin
  if FFilter.TestFilter('S: ' + Text,ComputeFiltered) then
  begin
    if FTagMark <> '' then
    begin
      ComputeFiltered(2,FTagMark);
      FTagMark := '';
    end;
    LogParseTag('S: ' + Text);
    ComputeFiltered(3,Text);
  end
  else
    LogParseTag('! S: ' + Text);
end;

procedure TFraHtmlImport.ParseOnStartTag(Sender: TObject; Text: string);
var
  lLastTag: String;
begin
  if FFilter.FilterMode and (FTagMark <> '') then
  begin
    ComputeFiltered(2,FTagMark);
    FTagMark := '';
  end;
  if FFilter.TestFilter('TS: ' + uppercase(Text),ComputeFiltered) then
  begin

    LogParseTag('TS: ' + Text + ', ' + TagPath);
    FTagMark := '<' + Text + '>';
  end
  else
  begin
    LogParseTag('! TS: ' + Text + ', ' + TagPath);
    FTagMark := '';
  end;
  lLastTag := ExtractFileName(Tagpath);
  Acttag := uppercase(Text);
  // Exclude singleton Tags
  if (Acttag <> 'P') and (Acttag <> 'BR') and (Acttag <> 'LI') and
    (Acttag <> 'META') and (Acttag <> 'IMG') and (Acttag <> '!DOCTYPE')
    and ((Acttag <> 'FONT') or (lLastTag <> ActTag)) then
  Tagpath := TagPath + '\' + Acttag;
end;

procedure TFraHtmlImport.ParseOnTagMod(Sender: TObject; Text: string);
 var
   lLastFlt: Boolean;
 begin
   lLastFlt :=FFilter.FilterMode;
   if FFilter.TestFilter('TM: ' + Acttag + ',' + Text,ComputeFiltered) then
   begin
     LogParseTag('TM: ' + Text);
     if FTagMark <> '' then
       FTagMark := copy(FTagMark, 1, length(FTagMark) - 1) + ' ' + Text + '>'
     else
       FTagMark:=  '<' + Acttag + ' ' + Text + '>' ;
   end
   else
   begin
     if lLastFlt and (FTagMark<>'') then
       ComputeFiltered(2,FTagMark);
     LogParseTag('! TM: ' + Text);
     FTagMark:='';
   end;
 end;

procedure TFraHtmlImport.ParseOnEndTag(Sender: TObject; Text: string);
 begin
   if FFilter.TestFilter('TE: ' + uppercase(Text),ComputeFiltered) then
   begin
     if (FTagMark <> '') and (Text = '') then
       FTagMark := copy(FTagMark, 1, length(FTagMark) - 1) + ' />';
     if (FTagMark <> '') then
     begin
       ComputeFiltered(2,FTagMark);
       FTagMark := '';
     end;
     LogParseTag('TE: ' + Text);
     if text <> '' then
        ComputeFiltered(4,'</' + text + '>');
   end
   else
   begin
     FTagMark := '';
     LogParseTag('! TE: ' + Text);
   end;
   if Acttag = uppercase(Text) then
   begin
     tagpath := ExtractFilePath(Tagpath);
     tagpath := copy(TagPath,1,length(TagPath)-1);
     Acttag := ExtractFileName(Tagpath);
   end
   else
   if pos('\'+uppercase(Text)+'\', tagpath) <> 0 then
   begin
     while (ExtractFileName(Tagpath) <> uppercase(Text))  do
     begin
       tagpath := ExtractFilePath(Tagpath);
       tagpath := copy(TagPath,1,length(TagPath)-1);
       Acttag := ExtractFileName(Tagpath);
       if acttag = '' then
         tagpath := copy(TagPath,1,length(TagPath)-1);
     end;
     tagpath := ExtractFilePath(Tagpath);
     tagpath := copy(TagPath,1,length(TagPath)-1);
     Acttag := ExtractFileName(Tagpath);
   end;
 end;

procedure TFraHtmlImport.ParseOnComment(Sender: TObject; Text: string);
 begin
   if FFilter.FilterMode then
   begin
     if FTagMark <> '' then
     begin
       ComputeFiltered(2,FTagMark);
       FTagMark := '';
     end;
     LogParseTag('C: ' + Text);
     ComputeFiltered(5,'<!-' + Text + '->');
   end;
 end;

procedure TFraHtmlImport.ParseOnScript(Sender: TObject; Text: string);
 begin
   if FFilter.FilterMode then
   begin
     if FTagMark <> '' then
     begin
       ComputeFiltered(2,FTagMark);
       FTagMark := '';
     end;
     LogParseTag('Sc: ' + Text);
     ComputeFiltered(6,Text);
   end;

 end;

procedure TFraHtmlImport.ComputeFiltered(CType: byte; Text: String);
begin
  if assigned(FComputeOutput) then
    FComputeOutput(CType,Text);
end;

procedure TFraHtmlImport.SetComputeOutput(AValue: TCoumputeOutput);
begin
  if @FComputeOutput=@AValue then Exit;
  FComputeOutput:=AValue;
end;

procedure TFraHtmlImport.SetOnNewPlainText(AValue: TNotifyEvent);
begin
  if @FOnNewPlainText=@AValue then Exit;
  FOnNewPlainText:=AValue;
end;

procedure TFraHtmlImport.SetOnSplitterMove(AValue: TNotifyEvent);
begin
  if @FOnSplitterMove=@AValue then Exit;
  FOnSplitterMove:=AValue;
end;

procedure TFraHtmlImport.SetSchemaVisible(AValue: boolean);
begin
  if FSchemaVisible=AValue then Exit;
  FSchemaVisible:=AValue;
  pnlClient.Visible := AValue;
  splRight2.Visible:=AValue;
  FFilter.Verbose:=AValue;
end;

procedure TFraHtmlImport.SetShowHTML(AValue: boolean);
begin
  if FShowHTML=AValue then Exit;
  FShowHTML:=AValue;
end;

procedure TFraHtmlImport.SetVerbose(AValue: boolean);
begin
  if FVerbose=AValue then Exit;
  FVerbose:=AValue;
  mLog.Visible := AValue;
  splRight1.Visible:=AValue;
end;

procedure TFraHtmlImport.UpdateCaret(Data: PtrInt);
begin
  lblCaret.Caption:=format('(%d;%d)',[mSchema.CaretPos.x,mSchema.CaretPos.y]);
end;

procedure TFraHtmlImport.LogParseTag(s: String);
begin
  if FVerbose then
    mLog.Lines.add(s);
end;

procedure TFraHtmlImport.Parse2OnStdText(Sender: TObject; Text: string);
begin
  FPlainLine:=FPlainLine+Text;
end;

procedure TFraHtmlImport.Parse2OnStartTag(Sender: TObject; Text: string);
var
  lfound: integer;
begin
  if TryParseStr(text,['P','BR','LI','H1','H2','H3'],psm_Full,lfound) and (FPlainLine <> '') then
    begin
      FPlaintext.append(FPlainLine);
      FPlainLine:= '';
    end;
end;

procedure TFraHtmlImport.Parse2OnEndTag(Sender: TObject; Text: string);
var
  lfound: integer;
begin
  if TryParseStr(text,['BODY','H1','H2','H3','P','OL','UL'],psm_Full,lfound) and (FPlainLine <> '') then
    begin
      FPlaintext.append(FPlainLine);
      FPlainLine:= '';
    end;
end;

procedure TFraHtmlImport.mSchemaClick(Sender: TObject);
begin
  Application.QueueAsyncCall(UpdateCaret,0);
end;

procedure TFraHtmlImport.FrameResize(Sender: TObject);
begin

end;

procedure TFraHtmlImport.mSchemaKeyPress(Sender: TObject; var Key: char);
begin
  Application.QueueAsyncCall(UpdateCaret,0);
end;

procedure TFraHtmlImport.mSchemaKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Application.QueueAsyncCall(UpdateCaret,0);
end;

procedure TFraHtmlImport.splRight2Moved(Sender: TObject);
begin
  splRight2.Tag:=splRight2.Left;
  if assigned(FonSplitterMove) then
    FonSplitterMove(sender);
end;

procedure TFraHtmlImport.FilterLineChange(Sender: TObject);
var
  SelStart, i: Integer;
begin
    if Ffilter.testline = 0 then
        SelStart := 0
    else if Ffilter.testline = 1 then
        SelStart := length(mSchema.Lines[0]) + 2
    else if Ffilter.testline = OldTestline+1 then
        SelStart := mSchema.SelStart + length(mSchema.Lines[Ffilter.TestLine - 1]) + 2
    else
      begin
        SelStart:=0;
        for i := 0 to Ffilter.testline-1 do
            SelStart:=SelStart+length(mSchema.Lines[i]) + 2;
      end;
    OldTestline:=Ffilter.testline;
    mSchema.SelStart := Selstart;
    mSchema.SelLength := length(mSchema.Lines[Ffilter.TestLine]);
    UpdateCaret(0);
    if mSchema.Visible then
      mSchema.SetFocus;
end;

constructor TFraHtmlImport.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  FSchemaVisible := true;
  FShowHTML:=true;
  FFilter := TBaseFilter.Create(self);
  FFilter.OnLineChange:=FilterLineChange;
  FPlainText := TStringList.Create;
end;

destructor TFraHtmlImport.Destroy;
begin
  FreeAndNil(FPlainText);
  FreeAndNil(FFilter);
  inherited Destroy;
end;

procedure TFraHtmlImport.SetHtmlText(sHTML, sRef: string);
var
    FEncoding: string;
    lEncoded: boolean;
begin
   FEncoding := GuessEncoding(sHtml);
    mHTML.Lines.Text := ConvertEncodingToUTF8(sHTML, FEncoding, lEncoded);
    if assigned(Parent) and FShowHTML then
      HTMLViewer1.LoadFromString(ThtString (sHTML), ThtString (sRef));
end;

procedure TFraHtmlImport.SetSchema(s: String);
var
  FEncoding: String;
  lEncoded: boolean;
begin
    FEncoding := GuessEncoding(s);
    mSchema.Lines.Text := ConvertEncodingToUTF8(s, FEncoding, lEncoded);
end;

procedure TFraHtmlImport.SchemaSaveToFile(const FileName: string);
begin
  mSchema.Lines.SaveToFile(FileName);
end;

procedure TFraHtmlImport.DoParse(Sender: Tobject);

 var
  p: ThtmlParser;
begin
  mLog.Clear;
  FFilter.Schema := mSchema.Lines;
  p := ThtmlParser.Create;
  try
  FPlainText.Clear;
  p.OnStartTag:=Parse2OnStartTag;
  p.OnEndTag:=Parse2OnEndTag;
  p.OnStdText:=Parse2OnStdText;
  p.Feed(mHTML.Text);
  if assigned(FOnNewPlainText) then
    FOnNewPlainText(p);
  p.reset;
  p.onStdText := ParseOnStdText;
  p.OnStartTag := ParseOnStartTag;
  p.OnTagMod := ParseOnTagMod;
  p.OnEndTag := ParseOnEndTag;
  p.OnComment := ParseOnComment;
  p.OnScript := ParseOnScript;
  FFilter.TestLine := 0;
  FFilter.FilterMode := True;
  FFilter.Verbose:=pnlClient.Visible and assigned(Parent);
  Tagpath := '';
  p.Feed(mHTML.Text);
  finally
    freeandnil(p);
  end;
end;

end.

