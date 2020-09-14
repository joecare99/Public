unit tst_PoFile;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry,unt_PoFile;

type

  { TTestPoFile }

  TTestPoFile= class(TTestCase)
  private
    FPoFile:TPoFile;
    FDataPath:string;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSetUp;
    procedure TestQuotedStr;
    procedure TestUnQuotedStr;
  public
    constructor Create; override;
  end;

implementation

const CDatapath = 'Data';

procedure TTestPoFile.TestSetUp;
begin
  CheckTrue(DirectoryExists(FDataPath),'Datapath exists');
  CheckNotNull(FPoFile,'TestObject is assigned');
end;

procedure TTestPoFile.TestQuotedStr;
begin
  CheckEquals('""',TPoFile.QuotedStr2(''),'Quote empty String');
  CheckEquals('"Test"',TPoFile.QuotedStr2('Test'),'Quote ''Test''');
  CheckEquals('"Quote \"This\""',TPoFile.QuotedStr2('Quote "This"'),'Quote ''This''');
  CheckEquals('"\r"',TPoFile.QuotedStr2(#13),'Quote <LineFeed>');
  CheckEquals('"\n"',TPoFile.QuotedStr2(#10),'Quote <CariageReturn>');
  CheckEquals('"\t"',TPoFile.QuotedStr2(#9),'Quote <Tab>');
  CheckEquals('"\d"',TPoFile.QuotedStr2(#8),'Quote <Del>');
  CheckEquals('"Quote \"Th\\nis\""',TPoFile.QuotedStr2('Quote "Th\nis"'),'Quote ''Teat''');
end;

procedure TTestPoFile.TestUnQuotedStr;
begin
  CheckEquals('',TPoFile.UnQuotedStr2('""'),'Quote empty String');
  CheckEquals('Test',TPoFile.UnQuotedStr2('"Test"'),'Quote ''Test''');
  CheckEquals('Quote "This"',TPoFile.UnQuotedStr2('"Quote \"This\""'),'Quote ''This''');
  CheckEquals(#13,TPoFile.UnQuotedStr2('"\r"'),'Quote <LineFeed>');
  CheckEquals(#10,TPoFile.UnQuotedStr2('"\n"'),'Quote <CariageReturn>');
  CheckEquals(#9,TPoFile.UnQuotedStr2('"\t"'),'Quote <Tab>');
  CheckEquals(#8,TPoFile.UnQuotedStr2('"\d"'),'Quote <Del>');
  CheckEquals('Quote "Th\nat"',TPoFile.UnQuotedStr2('"Quote \"Th\\nat\""'),'Quote ''That''');

end;

procedure TTestPoFile.SetUp;
begin
  FPoFile := TPoFile.Create(nil);
end;

procedure TTestPoFile.TearDown;
begin
  FreeAndNil(FPoFile);
end;

constructor TTestPoFile.Create;
var
  i: Integer;

begin
  inherited Create;
  FDataPath := CDatapath;
  for i := 0 to 2 do
    if not DirectoryExists(FDataPath) then
      FDataPath := '..' + DirectorySeparator+ FDataPath
    else
      Break;
  FDataPath := FDataPath + DirectorySeparator + 'PicPasTest';
  ForceDirectories(FDataPath);
end;

initialization

  RegisterTest(TTestPoFile);
end.

