unit tst_HtmlParse1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, fra_HtmlImp;

type

  { TTestHtmlParse1 }

  TTestHtmlParse1= class(TTestCase)
  private
    FDatapath: String;
    FFilename: String;
    FHtmlImp: TFraHtmlImport;
    FOutput: TStringList;
    FExpOutput:TStringlist;
    FActLine:Integer;
    procedure HtmlComputeOutput(CType: byte; Text: String);
    procedure HTMLNewPlainText(Sender: TObject);
  protected
    procedure SetUp; override;
    procedure TearDown; override;
    procedure TestFile(aFilename, aSchema: String);
  published
    procedure TestSetUp;
    Procedure TestVieser_I5;
    Procedure TestVieser_I12;
    Procedure TestVieser_I23;
    Procedure TestVieser_I31;
    Procedure TestVieser_I42;
    Procedure TestVieser_I50;
    Procedure TestVieser_I61;
    Procedure TestVieser_I80;
    Procedure TestVieser_I134;
    Procedure TestVieser_I255;
    procedure TestVieser_I12577;
  public
    constructor Create; override;
  end;

implementation

uses Forms, Unt_FileProcs;

procedure TTestHtmlParse1.TestSetUp;
begin
  CheckNotNull(FHtmlImp,'Class is initialized');
  CheckIs(FHtmlImp,TFraHtmlImport,'Class is right type');
end;

procedure TTestHtmlParse1.TestVieser_I5;

const CFilename = 'vieser\I5.html';
      CSchema  = 'vieser_schema.txt';
begin
  TestFile(CFilename,CSchema);
end;

procedure TTestHtmlParse1.TestVieser_I12;
const CFilename = 'vieser\I12.html';
      CSchema  = 'vieser_schema.txt';
begin
  TestFile(CFilename,CSchema);
end;

procedure TTestHtmlParse1.TestVieser_I23;
const CFilename = 'vieser\I23.html';
      CSchema  = 'vieser_schema.txt';
begin
  TestFile(CFilename,CSchema);
end;

procedure TTestHtmlParse1.TestVieser_I31;
const CFilename = 'vieser\I31.html';
      CSchema  = 'vieser_schema.txt';
begin
  TestFile(CFilename,CSchema);
end;

procedure TTestHtmlParse1.TestVieser_I42;
const CFilename = 'vieser\I42.html';
      CSchema  = 'vieser_schema.txt';
begin
  TestFile(CFilename,CSchema);
end;

procedure TTestHtmlParse1.TestVieser_I50;
const CFilename = 'vieser\I50.html';
      CSchema  = 'vieser_schema.txt';
begin
  TestFile(CFilename,CSchema);
end;

procedure TTestHtmlParse1.TestVieser_I61;
const CFilename = 'vieser\I61.html';
      CSchema  = 'vieser_schema.txt';
begin
  TestFile(CFilename,CSchema);
end;

procedure TTestHtmlParse1.TestVieser_I80;
const CFilename = 'vieser\I80.html';
      CSchema  = 'vieser_schema.txt';
begin
  TestFile(CFilename,CSchema);
end;

procedure TTestHtmlParse1.TestVieser_I134;
const CFilename = 'vieser\I134.html';
      CSchema  = 'vieser_schema.txt';
begin
  TestFile(CFilename,CSchema);
end;

procedure TTestHtmlParse1.TestVieser_I255;
const CFilename = 'vieser\I255.html';
      CSchema  = 'vieser_schema.txt';
begin
  TestFile(CFilename,CSchema);
end;

procedure TTestHtmlParse1.TestVieser_I12577;
const CFilename = 'vieser\I12577.html';
      CSchema  = 'vieser_schema.txt';
begin
  TestFile(CFilename,CSchema);
end;


constructor TTestHtmlParse1.Create;
var
  i: Integer;
begin
  inherited Create;
  FDatapath := 'Data';
   for i := 0 to 2 do
     if DirectoryExists(FDataPath) then
       Break
     else
       FDataPath:='..'+DirectorySeparator+FDataPath;
   FDataPath:=FDataPath+DirectorySeparator+'GenData';
end;

procedure TTestHtmlParse1.HtmlComputeOutput(CType: byte; Text: String);
var
  Line: String;
begin
   Line := format('%d: %s',[Ctype,Text.Replace('\','\\').Replace(#10,'\n').replace(#13,'\r')]);
   if FExpOutput.Count >0 then
     begin
       CheckEquals(FExpOutput[FActLIne],Line,FFilename+'.Line['+inttostr(FActLIne)+']');
       inc(FActLine);
     end;
   FOutput.Append(Line);
end;

procedure TTestHtmlParse1.HTMLNewPlainText(Sender: TObject);
begin

end;

procedure TTestHtmlParse1.SetUp;
begin
  FHtmlImp := TFraHtmlImport.Create(nil);
  FHtmlImp.OnNewPlainText:=@HTMLNewPlainText;
  FOutput := TStringList.Create;
  FExpOutput := TStringList.Create;
  FActLine:= 0;
end;

procedure TTestHtmlParse1.TearDown;
begin
  freeandnil(FExpOutput);
  freeandnil(FOutput);
  freeandnil(FHtmlImp);
end;

procedure TTestHtmlParse1.TestFile(aFilename,aSchema:String);
var
  s: string;
  sf: TFileStream;
begin
  Checktrue(FileExists(FDatapath + DirectorySeparator+aSchema), 'Schema Exists:'
    +FDatapath + DirectorySeparator+aSchema);
  sf := TFileStream.Create(FDatapath + DirectorySeparator+aSchema, fmOpenRead);
  try
    setlength(s, sf.Size);
    sf.ReadBuffer(s[1], sf.Size);

  finally
    FreeAndNil(sf);
  end;
    FHtmlImp.SetSchema(s);

  Checktrue(FileExists(FDatapath + DirectorySeparator+aFilename), 'File Exists:'
    +FDatapath + DirectorySeparator+aFilename);
  sf := TFileStream.Create(FDatapath + DirectorySeparator+aFilename, fmOpenRead
    );
  try
    setlength(s, sf.Size);
    sf.ReadBuffer(s[1], sf.Size);

  finally
    FreeAndNil(sf);
  end;
  FFilename := aFilename;
  FHtmlImp.SetHtmlText(s, FDatapath + DirectorySeparator+aFilename);
  FHtmlImp.OnComputeOutput:=@HtmlComputeOutput;

  If FileExists(ChangeFileExt(FDatapath + DirectorySeparator+aFilename, '.'
    +'Exp')) then
      begin
    sf := TFileStream.Create(ChangeFileExt(FDatapath + DirectorySeparator+aFilename, '.'
    +'Exp'), fmOpenRead );
    try
      setlength(s, sf.Size);
      sf.ReadBuffer(s[1], sf.Size);
      FExpOutput.text := s;
    finally
      FreeAndNil(sf);
    end;
   end
  else
    FExpOutput.Clear;
  FHtmlImp.DoParse(self);
  if (FExpOutput.Count=0) and (FOutput.Count>0) then
    begin
      SaveFile(@FOutput.SaveToFile,ChangeFileExt(FDatapath + DirectorySeparator+aFilename, '.'
        +'Exp.new'));
    end;
  If FileExists(ChangeFileExt(FDatapath + DirectorySeparator+aFilename, '.txt')) then
      begin
    sf := TFileStream.Create(ChangeFileExt(FDatapath + DirectorySeparator+aFilename, '.txt'), fmOpenRead );
    try
      setlength(s, sf.Size);
      sf.ReadBuffer(s[1], sf.Size);
    finally
      FreeAndNil(sf);
    end;
        CheckEquals(s,FHtmlImp.PlainText.text,'PlainText');
      end
  else if  (FHtmlImp.PlainText.Count>0) then
    begin
      SaveFile(@FHtmlImp.PlainText.SaveToFile,ChangeFileExt(FDatapath + DirectorySeparator+aFilename,
      '.txt.new'));
    end;
end;

initialization

  RegisterTest(TTestHtmlParse1);
end.

