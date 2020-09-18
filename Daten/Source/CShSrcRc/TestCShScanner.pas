unit TestCShScanner;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry, CShScanner;

type

  { TTestCSScanner }

  TTestCSScanner= class(TTestCase)
  private
    FDataPath: String;
    FFileRes: TBaseFileResolver;
    FScanner: TCSharpScanner;
    procedure ScannerLog(Sender: TObject; const Msg: String);
  protected
    procedure SetUp; override;
    procedure TearDown; override;
    procedure CheckEquals(Exp, Act: TToken; Msg: string); overload;
  published
    procedure TestHookUp;
    procedure Tokens1;
    procedure Tokens2;
    procedure MiniFile;
  end;

implementation

const CDataPath = 'Data';

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

procedure TTestCSScanner.TestHookUp;
begin
  Fail('Write your own test');
end;

procedure TTestCSScanner.Tokens1;
begin
  CheckEquals(tkEOF,TToken(0),'First Token is tkEOF');
  CheckEquals(tkCurlyBraceOpen,TToken(8),'Seventh Token is tkCurlyBraceOpen');
  CheckEquals(tkBraceOpen,TToken(10),'10th Token is tkBraceOpen');
  CheckEquals(tkLessThan,TToken(20),'20th Token is tkLessThan');
  CheckEquals(tkNot,TToken(30),'30th Token is tkNot');
  CheckEquals(tkAssignMinus,TToken(40),'50th Token is tkAssignMul');
  CheckEquals(tkbase,TToken(50),'50th Token is tkbase');
  CheckEquals(tkelse,TToken(60),'60th Token is tkelse');
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

var
  FileName: String;
begin
  Filename := FDatapath + DirectorySeparator+ CFileName;;
  FFileRes.AddIncludePath(ExtractFilePath(FileName));

end;

procedure TTestCSScanner.ScannerLog(Sender: TObject; const Msg: String);
begin

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

end;

procedure TTestCSScanner.CheckEquals( Exp,Act: TToken; Msg: string);
begin
  if exp <> Act then
    CheckEquals(inttostr(ord(exp))+':'+TokenInfos[exp],inttostr(ord(Act))+':'+TokenInfos[act],Msg)
  else
     CheckEquals(ord(exp),ord(act),Msg);
end;

initialization

  RegisterTest(TTestCSScanner);
end.

