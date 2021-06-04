unit TestCShScanner;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry, CShScanner, unt_CShTestData, FileUtil;

type

  { TTestCSScanner }

  TTestCSScanner= class(TTestCase)
  private
    FDataPath: String;
    FFileRes: TBaseFileResolver;
    FRCounter: Integer;
    FScanner: TCSharpScanner;
    ExpResults,
    FResult:TResultTypeArray;
    FTestName: String;
    procedure AddExpResult(Data: array of variant);
    procedure FSFileFound(FileIterator: TFileIterator);
    procedure ParserTestEvent(Sender: TObject; const eType: TToken;
      const aText, Ref: string; dsubtype: integer);
    procedure ScannerLog(Sender: TObject; const Msg: String);
    procedure TestOneFile(aFilename: String; ff: TFileFoundEvent);
    procedure TokenizeTestFile(const FileName: String; SkipWS: boolean=true);
  protected
    procedure SetUp; override;
    procedure TearDown; override;
    procedure CheckEquals(Exp, Act: TToken; Msg: string); overload;
    procedure CreateExpResult(st: TStrings; out Expct: TResultTypeArray);
    procedure ExpResultToTStr(const Exp: array of TResultType; st: TStrings);
  published
    procedure TestSetUp;
    procedure Tokens1;
    procedure Tokens2;
    procedure MiniFile;
    procedure Test_HelloWorld_cs;
    procedure Test_T_cs;
    procedure TestTechnique;
  public
    constructor Create; override;
  end;

implementation

uses typinfo;

const CDataPath = 'Data';
   Const CTest1 = #13;
   const CTest2 = #01#02;

constructor TTestCSScanner.Create;
var
  i: Integer;
begin
  inherited Create;
  FDataPath:= CDataPath;
  for i := 0 to 2 do
    if DirectoryExists(FDataPath) then
      Break
    else
      FDataPath:='..'+DirectorySeparator+FDataPath;
  FDataPath := FDataPath+DirectorySeparator+'CShSrc';
  ForceDirectories(FDataPath);
end;

procedure TTestCSScanner.TestSetUp;
begin
  CheckNotNull(FScanner,'Object is assigned');
  CheckNotNull(FFileRes,'Helper is assigned');
end;

procedure TTestCSScanner.Tokens1;
begin
  CheckEquals(tkEOF,TToken(0),'First Token is tkEOF');
  CheckEquals(tkTab,TToken(10),'10th Token is tktab');
  CheckEquals(tkCurlyBraceOpen,TToken(11),'Seventh Token is tkCurlyBraceOpen');
  CheckEquals(tkDivision,TToken(20),'20th Token is tkDivision');
  CheckEquals(tkBackslash,TToken(30),'30th Token is tkBackslash');
  CheckEquals(tkNotEqual,TToken(40),'50th Token is tkNotEqual');
  CheckEquals(tkAssignMul,TToken(50),'50th Token is tkAssignMul');
  CheckEquals(tkAssignshl,TToken(60),'60th Token is tkAssignshl');
end;

procedure TTestCSScanner.Tokens2;
begin
  CheckEquals('EOF',TokenInfos[tkEOF],'First Token is tkEOF');
  CheckEquals('{',TokenInfos[tkCurlyBraceOpen],'Seventh Token is tkCurlyBraceOpen');
  CheckEquals('&',TokenInfos[tkSingleAnd],'Seventh Token is tkSingleAnd');
  CheckEquals('&&',TokenInfos[tkand],'Seventh Token is tkCurlyBraceOpen');
  CheckEquals('|',TokenInfos[tkSingleOr],'Seventh Token is tkand');
  CheckEquals('||',TokenInfos[tkor],'Seventh Token is tkor');
  CheckEquals('?',TokenInfos[tkAsk],'Seventh Token is tkAsk');
  CheckEquals('!',TokenInfos[tknot],'30th Token is tknot');
end;

procedure TTestCSScanner.MiniFile;

const CFileName='Hello_World.cs';
var
  FileName: String;
  aToken: TToken;

begin
  Filename := FDatapath + DirectorySeparator+ CFileName;;
  FFileRes.AddIncludePath(ExtractFilePath(FileName));
  FScanner.OpenFile(FileName);
  aToken := Fscanner.FetchToken;
  CheckEquals(tkPublic,aToken,'Starts with public');
  aToken := Fscanner.FetchToken;
  CheckEquals(tkWhitespace,aToken,'a Whitespace');
  aToken := Fscanner.FetchToken;
  CheckEquals(CShScanner.tkClass,aToken,'Class');
  aToken := Fscanner.FetchToken;
  CheckEquals(tkWhitespace,aToken,'a Whitespace');
  aToken := Fscanner.FetchToken;
  CheckEquals(tkIdentifier,aToken,'Another identifyer');
  CheckEquals('Hello',FScanner.CurTokenString);
  aToken := Fscanner.FetchToken;
  CheckEquals(tkLineEnding,aToken,'a LineEnding');
  aToken := Fscanner.FetchToken;
  CheckEquals(tkCurlyBraceOpen,aToken,'a CurlyBraceOpen');
  aToken := Fscanner.FetchToken;
  CheckEquals(tkLineEnding,aToken,'a LineEnding');
  aToken := Fscanner.FetchToken;
  CheckEquals(tkWhitespace,aToken,'a Whitespace');
  aToken := Fscanner.FetchToken;
  CheckEquals(tkPublic,aToken,'a public - keyword');
  aToken := Fscanner.FetchToken;
  CheckEquals(tkWhitespace,aToken,'a Whitespace');
  aToken := Fscanner.FetchToken;
  CheckEquals(tkStatic,aToken,'a static - keyword');
  aToken := Fscanner.FetchToken;
  CheckEquals(tkWhitespace,aToken,'a Whitespace');
  aToken := Fscanner.FetchToken;
  CheckEquals(tkVoid,aToken,'a Void - keyword');
  aToken := Fscanner.FetchToken;
  CheckEquals(tkWhitespace,aToken,'a Whitespace');
  aToken := Fscanner.FetchToken;
  CheckEquals(tkIdentifier,aToken,'an Identifier');
  CheckEquals('helloworld',FScanner.CurTokenString);
  aToken := Fscanner.FetchToken;
  CheckEquals(tkBraceOpen,aToken,'an (');
  aToken := Fscanner.FetchToken;
  CheckEquals(tkBraceClose,aToken,'an )');
  aToken := Fscanner.FetchToken;
  CheckEquals(tkLineEnding,aToken,'a LineEnding');
  aToken := Fscanner.FetchToken;
  CheckEquals(tkWhitespace,aToken,'a Whitespace');
end;

procedure TTestCSScanner.TestOneFile(aFilename:String;ff:TFileFoundEvent);
var
  lFileSearcher: TFileSearcher;
begin
  lFileSearcher := TFileSearcher.Create;
  if ff=nil then
    ff:=@FSFileFound;
   try
     lFileSearcher.OnFileFound := ff;
     lFileSearcher.Search(FDataPath, aFilename, False, False);
   finally
     FreeAndNil(lFileSearcher);
   end;
end;

procedure TTestCSScanner.Test_HelloWorld_cs;

const CFileName='Hello_World.cs';

begin
  TestOneFile(CFileName,@FSFileFound);
end;

procedure TTestCSScanner.Test_T_cs;

const CFileName='t.cs';

begin
  TestOneFile(CFileName,@FSFileFound);
end;


procedure TTestCSScanner.TestTechnique;
var
  ch: Char;
  i: Integer;
begin
  for ch in string(CTest1) do
    CheckEquals(#13,ch,Testname+':1 Char is #13');
  i := 0;
  for ch in string(CTest2) do
    begin
      inc(i);
      CheckEquals(chr(i),ch,Testname+':2 Char is #13');
    end;
end;

procedure TTestCSScanner.ScannerLog(Sender: TObject; const Msg: String);
begin

end;

procedure TTestCSScanner.TokenizeTestFile(const FileName: String;SkipWS:boolean);
var
  aToken: TToken;

begin
  FFileRes.AddIncludePath(ExtractFilePath(FileName));
  FScanner.OpenFile(FileName);
  Fscanner.SkipWhiteSpace := true;
  try
    aToken:=FScanner.FetchToken;  // Advance
  Except
    ParserTestEvent(FScanner,TToken(-1),'Exception: ',Fscanner.CurFilename,0);
    exit
  end;
  while (aToken <> tkEOF) do
     begin
       ParserTestEvent(FScanner,aToken,FScanner.CurTokenString,ExtractFilenameOnly(Fscanner.CurFilename),FScanner.CurRow);
       try
         aToken:=FScanner.FetchToken;  // Advance
       Except
         ParserTestEvent(FScanner,TToken(-1),'Exception: ',Fscanner.CurFilename,0);
         break;
       end;
     end;
end;

procedure TTestCSScanner.ParserTestEvent(Sender: TObject;
    const eType:TToken;const aText, Ref: string; dsubtype: integer);
var
    lr: TResultType;
    lDebEv, {%H-}lLastDeb: string;
begin
    CheckTrue(FScanner.Equals(Sender), 'Teste Sender');
    lr.setall([etype, atext, Ref, dsubtype]);
    lDebEv := lr.ToString;
    if Length(ExpResults) = 0 then
      begin
        setlength(FResult, length(FResult) + 1);
        Fresult[high(FResult)] := lr;
        exit;
      end;
 (*   if (eType='ParserDebugMsg') then
      begin
        FlastDeb := lDebEv;
        if ((high(ExpResults) < FRCounter) or (ExpResults[FRCounter].eType<> eType))
          then exit;  // Ignore optional Element
      end;  *)
    //lLastDeb:= FlastDeb;
    CheckTrue(high(ExpResults) >= FRCounter, 'Result Exists[' + IntToStr(
        FRCounter) + '],' + FTestName);
    CheckEquals(ExpResults[FRCounter].Data, aText, 'Teste aText[' + IntToStr(
        FRCounter) + '],' + FTestName);
    CheckEquals(ExpResults[FRCounter].eType, GetEnumName(TypeInfo(TToken), Ord(eType)), 'Teste eType[' + IntToStr(
        FRCounter) + '],' + FTestName);
    CheckEquals(ExpResults[FRCounter].Ref, Ref, 'Teste Ref[' + IntToStr(
        FRCounter) + '],' + FTestName);
    CheckEquals(ExpResults[FRCounter].SubType, dsubtype, 'Teste SubType[' +
        IntToStr(FRCounter) + '],' + FTestName);
    Inc(FRCounter);
end;

procedure TTestCSScanner.SetUp;
begin
  FFileRes := TFileResolver.Create;
  FScanner:=TCSharpScanner.Create(FFileRes);
  Fscanner.LogEvents:=[sleFile,sleLineNumber,sleConditionals,sleDirective];
  Fscanner.OnLog:=@ScannerLog;
end;

procedure TTestCSScanner.TearDown;
begin
  FreeandNil(Fscanner);
  FreeAndNil(FFileRes);
end;

procedure TTestCSScanner.FSFileFound(FileIterator: TFileIterator);
var
    lSt, lRs: TStrings;
begin
    lRs := TStringList.Create;
      try
        setlength(FResult, 0);
        if FileExists(ChangeFileExt(FileIterator.FileName, '.entExp')) then
            lRs.LoadFromFile(ChangeFileExt(FileIterator.FileName, '.entExp'));
        CreateExpResult(lRs, ExpResults);
        FRCounter := 0;
        FTestName := ExtractFileName(FileIterator.FileName);
        TokenizeTestFile(FileIterator.FileName);
        CheckEquals(length(ExpResults), FRCounter, 'Counter');
        if not FileExists(ChangeFileExt(FileIterator.FileName, '.entExp')) then
          begin
            if FileExists(ChangeFileExt(FileIterator.FileName, '.entNew')) then
                DeleteFile(ChangeFileExt(FileIterator.FileName, '.entNew'));
            ExpResultToTStr(FResult, lRs);
            lRs.SaveToFile(ChangeFileExt(FileIterator.FileName, '.entNew'));
          end;
      finally
        FreeAndNil(lRs);
      end;
end;

procedure TTestCSScanner.CheckEquals( Exp,Act: TToken; Msg: string);
begin
  if exp <> Act then
    CheckEquals(GetEnumName(TypeInfo(TToken), Ord(Exp))+':'+TokenInfos[exp],GetEnumName(TypeInfo(TToken),ord(Act))+':'+TokenInfos[act],Msg)
  else
     CheckEquals(ord(exp),ord(act),Msg);
end;

procedure TTestCSScanner.CreateExpResult(st: TStrings; out
  Expct: TResultTypeArray);
var
    i: integer;
begin
    if st.Count = 0 then
        setlength(Expct, 0)
    else
        setlength(Expct, st.Count - 1);
    for i := 1 to st.Count - 1 do
        Expct[i - 1].SetAll(st[i].Split([#9]));
end;

procedure TTestCSScanner.AddExpResult(Data: array of variant);

begin
    setlength(ExpResults, high(ExpResults)+2);
    ExpResults[high(ExpResults)].SetAll(Data);
end;

procedure TTestCSScanner.ExpResultToTStr(const Exp: array of TResultType;
  st: TStrings);

var
le: TResultType;
begin
st.Clear;
st.append('eType'#9'Data'#9'Ref'#9'SubType');
for le in Exp do
    st.append(le.toCsv(#9));
end;

// }
initialization

  RegisterTest(TTestCSScanner);
end.

