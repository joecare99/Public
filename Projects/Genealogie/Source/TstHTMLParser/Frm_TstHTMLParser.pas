unit Frm_TstHTMLParser;

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
  Buttons, ComCtrls, IpHtml, Ipfilebroker, Unt_Config, htmlview, Cmp_Parser;

type

  { TForm2 }

  TForm2 = class(TForm)
    BitBtn1: TBitBtn;
    btnBrowseHtml: TBitBtn;
    btnBrowseSchema: TBitBtn;
    btnLoadSchema: TBitBtn;
    btnSaveSchema: TBitBtn;
    cbxFilenameSchema: TComboBox;
    chbVerbose: TCheckBox;
    cbxFilename: TComboBox;
    btnDoParse: TBitBtn;
    Config1: TConfig;
    HTMLViewer1: THTMLViewer;
    mHTML: TMemo;
    btnLoadFile: TBitBtn;
    mLog: TMemo;
    mSchema: TMemo;
    mOutput: TMemo;
    btnSave: TBitBtn;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    procedure btnBrowseSchemaClick(Sender: TObject);
    procedure btnDoParseClick(Sender: TObject);
    procedure btnLoadSchemaClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnLoadFileClick(Sender: TObject);
    procedure btnBrowseHtmlClick(Sender: TObject);
    procedure btnSaveSchemaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure IpHtmlPanel1ControlClick(Sender: TIpHtmlCustomPanel;
      Frame: TIpHtmlFrame; Html: TIpHtml; Node: TIpHtmlNodeControl);
    procedure IpHtmlPanel1ControlClick2(Sender: TIpHtmlCustomPanel;
      Frame: TIpHtmlFrame; Html: TIpHtml; Node: TIpHtmlNodeControl;
      var cancel: boolean);
    procedure IpHtmlPanel1DocumentOpen(Sender: TObject);
    procedure IpHtmlPanel1HotClick(Sender: TObject);
  private
    { Private-Deklarationen }
    Acttag, TagMark, TagPath: string;
    FilterMode: boolean;
    TestLine: integer;
    FEncoding: string;
    FDataPath: String;
    function TestFilter(s: string): boolean;
  public
    { Public-Deklarationen }
    Procedure LogParseTag(s:String);
    Procedure ComputeFiltered(CType:byte;Text:String);
  published
    procedure ParseOnStdText(Sender: TObject; Text: string);
    procedure ParseOnStartTag(Sender: TObject; Text: string);
    procedure ParseOnTagMod(Sender: TObject; Text: string);
    procedure ParseOnEndTag(Sender: TObject; Text: string);
    procedure ParseOnComment(Sender: TObject; Text: string);
    procedure ParseOnScript(Sender: TObject; Text: string);
  end;

var
  Form2: TForm2;

implementation

uses LConvEncoding;

{$IFnDEF FPC}
  {$R *.dfm}

{$ELSE}
  {$R *.lfm}
{$ENDIF}

procedure TForm2.btnDoParseClick(Sender: TObject);
var
  p: ThtmlParser;
begin
  mLog.Clear;
  p := ThtmlParser.Create;
  p.onStdText := ParseOnStdText;
  p.OnStartTag := ParseOnStartTag;
  p.OnTagMod := ParseOnTagMod;
  p.OnEndTag := ParseOnEndTag;
  p.OnComment := ParseOnComment;
  p.OnScript := ParseOnScript;
  TestLine := 0;
  FilterMode := True;
  mOutput.Clear;
  Tagpath := '';
  p.Feed(mHTML.Text);
  p.Done;
end;

procedure TForm2.btnBrowseSchemaClick(Sender: TObject);
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

procedure TForm2.btnLoadSchemaClick(Sender: TObject);

  var
    sf: TFileStream;
    s: string;
    lEncoded: boolean;
    i: Integer;
  begin
   if cbxFilenameSchema.ItemIndex = -1 then
     begin
     cbxFilenameSchema.Items.add(cbxFilenameSchema.Text);
     Config1.Value[cbxFilenameSchema, 'ICount'] := cbxFilenameSchema.Items.count;
     For i := 0 To cbxFilenameSchema.Items.count - 1 Do
       config1.Value[cbxFilenameSchema, inttostr(i)] := cbxFilenameSchema.Items[i];
     end;
     if not charinset(copy(cbxFilenameSchema.Text,2,1)[1],['.',':',DirectorySeparator]) then
    sf := TFileStream.Create(FDataPath+DirectorySeparator+ cbxFilenameSchema.Text, fmOpenRead)
    else
    sf := TFileStream.Create( cbxFilenameSchema.Text, fmOpenRead);

    try
      setlength(s, sf.Size);
      sf.ReadBuffer(s[1], sf.Size);
      FEncoding := GuessEncoding(s);
    finally
      FreeAndNil(sf);
    end;
    mSchema.Lines.Text := ConvertEncodingToUTF8(s, EncodingCP1252, lEncoded);
end;

procedure TForm2.btnLoadFileClick(Sender: TObject);
var
  sf: TFileStream;
  s: string;
  lEncoded: boolean;
  i: Integer;
begin
 if cbxFilename.ItemIndex = -1 then
   begin
   cbxFilename.Items.add(cbxFilename.Text);
   Config1.Value[cbxFilename, 'ICount'] := cbxFilename.Items.count;
   For i := 0 To cbxFilename.Items.count - 1 Do
     config1.Value[cbxFilename, inttostr(i)] := cbxFilename.Items[i];
   end;
  sf := TFileStream.Create(cbxFilename.Text, fmOpenRead);
  try
    setlength(s, sf.Size);
    sf.ReadBuffer(s[1], sf.Size);
    FEncoding := GuessEncoding(s);
  finally
    FreeAndNil(sf);
  end;
  mHTML.Lines.Text := ConvertEncodingToUTF8(s, EncodingCP1252, lEncoded);
  HTMLViewer1.LoadFromString(mHTML.Lines.Text,'');
//  IpHtmlPanel1.OpenURL('file://'+cbxFilename.Text);
end;

procedure TForm2.btnBrowseHtmlClick(Sender: TObject);
begin
  OpenDialog1.FileName:=cbxFilename.text;
  if OpenDialog1.Execute then
    begin
      cbxFilename.text:=OpenDialog1.FileName;
      btnLoadFileClick(sender);
    end;
end;

procedure TForm2.btnSaveSchemaClick(Sender: TObject);
begin
  SaveDialog1.FileName := cbxFilenameSchema.Text;
  if SaveDialog1.Execute then
  begin
    if fileexists(SaveDialog1.FileName) then
      RenameFile(SaveDialog1.FileName, ChangeFileExt(SaveDialog1.FileName,
        '.bak'));
    mSchema.Lines.SaveToFile(SaveDialog1.FileName);
  end;
end;

procedure TForm2.FormShow(Sender: TObject);
Var
   CBCount, i: Integer;
 Begin
   CBCount := Config1.getValue(cbxFilename, 'ICount', 0);
   For i := 0 To CBCount - 1 Do
     begin
       cbxFilename.Items.Add(Config1.getValue(cbxFilename, inttostr(i), ''));
       if cbxFilename.text = cbxFilename.Items[i] then
         cbxFilename.ItemIndex :=i;
     end;
   CBCount := Config1.getValue(cbxFilenameSchema, 'ICount', 0);
   For i := 0 To CBCount - 1 Do
     begin
       cbxFilenameSchema.Items.Add(Config1.getValue(cbxFilenameSchema, inttostr(i), ''));
       if cbxFilenameSchema.text = cbxFilenameSchema.Items[i] then
         cbxFilenameSchema.itemindex :=i;
     end;
   FDatapath := 'Data';
   for i := 0 to 2 do
     if DirectoryExists(FDataPath) then
       Break
     else
       FDataPath:='..'+DirectorySeparator+FDataPath;
end;

procedure TForm2.IpHtmlPanel1ControlClick(Sender: TIpHtmlCustomPanel;
  Frame: TIpHtmlFrame; Html: TIpHtml; Node: TIpHtmlNodeControl);
begin

end;

procedure TForm2.IpHtmlPanel1ControlClick2(Sender: TIpHtmlCustomPanel;
  Frame: TIpHtmlFrame; Html: TIpHtml; Node: TIpHtmlNodeControl;
  var cancel: boolean);
begin
  cancel := true;
end;

procedure TForm2.IpHtmlPanel1DocumentOpen(Sender: TObject);
begin

end;

procedure TForm2.IpHtmlPanel1HotClick(Sender: TObject);
begin

end;

procedure TForm2.btnSaveClick(Sender: TObject);
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

procedure TForm2.ParseOnStdText(Sender: TObject; Text: string);
begin
  if TestFilter('S: ' + Text) then
  begin
    if TagMark <> '' then
    begin
      ComputeFiltered(2,TagMark);
      TagMark := '';
    end;
    LogParseTag('S: ' + Text);
    ComputeFiltered(3,Text);
  end
  else
    LogParseTag('! S: ' + Text);
end;

procedure TForm2.ParseOnStartTag(Sender: TObject; Text: string);
begin
  if FilterMode and (TagMark <> '') then
  begin
    ComputeFiltered(2,TagMark);
    TagMark := '';
  end;
  if TestFilter('TS: ' + uppercase(Text)) then
  begin

    LogParseTag('TS: ' + Text + ', ' + TagPath);
    TagMark := '<' + Text + '>';
  end
  else
  begin
    LogParseTag('! TS: ' + Text + ', ' + TagPath);
    TagMark := '<' + Text + '>';
  end;
  Acttag := uppercase(Text);
  // Exclude singleton Tags
  if (Acttag <> 'P') and (Acttag <> 'BR') and
    (Acttag <> 'META') and (Acttag <> 'IMG') and (Acttag <> '!DOCTYPE') then
  Tagpath := TagPath + '\' + Acttag;
end;

procedure TForm2.ParseOnTagMod(Sender: TObject; Text: string);
begin
  if TestFilter('TM: ' + Acttag + ',' + Text) then
  begin
    LogParseTag('TM: ' + Text);
    if TagMark <> '' then
      TagMark := copy(TagMark, 1, length(TagMark) - 1) + ' ' + Text + '>';
  end
  else
  begin
    LogParseTag('! TM: ' + Text);
    TagMark := '';
  end;
end;

procedure TForm2.ParseOnEndTag(Sender: TObject; Text: string);
begin
  if TestFilter('TE: ' + uppercase(Text)) then
  begin
    if (TagMark <> '') and (Text = '') then
      TagMark := copy(TagMark, 1, length(TagMark) - 1) + ' />';
    if (TagMark <> '') then
    begin
      ComputeFiltered(2,TagMark);
      TagMark := '';
    end;
    LogParseTag('TE: ' + Text);
    if text <> '' then
       ComputeFiltered(4,'</' + text + '>');
  end
  else
  begin
    TagMark := '';
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

procedure TForm2.ParseOnComment(Sender: TObject; Text: string);
begin
  if FilterMode then
  begin
    if TagMark <> '' then
    begin
      ComputeFiltered(2,TagMark);
      TagMark := '';
    end;
    LogParseTag('C: ' + Text);
    ComputeFiltered(5,'<!-' + Text + '->');
  end;
end;

procedure TForm2.ParseOnScript(Sender: TObject; Text: string);
begin
  if FilterMode then
  begin
    if TagMark <> '' then
    begin
      ComputeFiltered(2,TagMark);
      TagMark := '';
    end;
    LogParseTag('Sc: ' + Text);
    ComputeFiltered(6,Text);
  end;

end;

function TForm2.TestFilter(s: string): boolean;
begin
  if uppercase(copy(mSchema.Lines[TestLine], 2, length(s) + 1)) = uppercase(s) then
  begin
    FilterMode := copy(mSchema.Lines[TestLine], 1, 1) = '[';
    if testline = 0 then
       mSchema.SelStart:=length(mSchema.Lines[TestLine])+2
    else
      mSchema.SelStart:=mSchema.SelStart+length(mSchema.Lines[TestLine])+2;
    Inc(TestLine);
    mSchema.SelLength:=length(mSchema.Lines[TestLine]);
    mSchema.SetFocus;
    if (testline < mSchema.Lines.Count) and (copy(mSchema.Lines[TestLine], 1, 1) = '+') then
    begin
      ComputeFiltered(0,copy(mSchema.Lines[TestLine], 2, 255));
      mSchema.SelStart:=mSchema.SelStart+length(mSchema.Lines[TestLine])+2;
      Inc(TestLine);
      mSchema.SelLength:=length(mSchema.Lines[TestLine]);
    end;
  end;
  Result := FilterMode;
end;

procedure TForm2.LogParseTag(s: String);
begin
  if chbVerbose.Checked then
    mLog.Lines.add(s);
end;

procedure TForm2.ComputeFiltered(CType: byte; Text: String);
begin
  if ctype in [0,2,3] then
    mOutput.Lines.add(inttostr(CType)+': '+text);
end;

end.
