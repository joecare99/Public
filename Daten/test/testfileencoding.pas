unit testFileEncoding;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry;

type

  { TTestGuessEncoing }

  TTestGuessEncoing= class(TTestCase)
  private
    FDataPath:string;
  published
    procedure TestHookUp;
    procedure TestANSI;
    procedure TestUTF8;
    procedure TestUCS2LE;
    procedure TestUCS2BE;
  public
    constructor Create;override;
  end;

implementation

uses LConvEncoding;

procedure TTestGuessEncoing.TestHookUp;
begin
  check(DirectoryExists(FDataPath),'Datapath exists');
end;

procedure TTestGuessEncoing.TestANSI;
var sf:TFileStream;
  s, lUTF8str, lFilename:String;
  lEncoded:boolean;

begin
  lFilename := copy(TestName,5,255)+'.txt';
  sf:=TFileStream.Create(FDataPath+DirectorySeparator+lFilename,fmOpenRead);
  try
  setlength(s,sf.Size);
  sf.ReadBuffer(s[1],sf.Size);
  CheckEquals(EncodingCP1252,GuessEncoding(s),'CP1252 Encoding Detected');
  finally
    freeandnil(sf);
  end;
  lUTF8str := ConvertEncodingToUTF8(s,EncodingCP1252,lEncoded);
  Check(lEncoded,'Encoding to UTF8');
  CheckEquals(49,length(lUTF8str),'Length of UTF8string');
  s:='';
  s := ConvertEncodingFromUTF8(lUTF8str,EncodingCP1252,lEncoded);
  Check(lEncoded,'Encoding from UTF8');
  CheckEquals(42,length(s),'Length of Orgstring');
  lFilename:= ChangeFileExt(lFilename,'_new.txt');
  if FileExists(lFilename) then
    sf:=TFileStream.Create(FDataPath+DirectorySeparator+lFilename,fmOpenWrite)
  else
    sf:=TFileStream.Create(FDataPath+DirectorySeparator+lFilename,fmCreate);
  try
    sf.WriteBuffer(s[1],length(s));
  finally
    freeandnil(sf);
  end;
end;

procedure TTestGuessEncoing.TestUTF8;
var sf:TFileStream;
  s,lUTF8str, lFilename:String;
  lEncoded:boolean;
begin
  lFilename := copy(TestName,5,255)+'.txt';
  sf:=TFileStream.Create(FDataPath+DirectorySeparator+lFilename,fmOpenRead);
  try
  setlength(s,sf.Size);
  sf.ReadBuffer(s[1],sf.Size);
  CheckEquals(EncodingUTF8BOM,GuessEncoding(s),'UTF8 Encoding Detected');
  finally
    freeandnil(sf);
  end;
  lUTF8str := ConvertEncodingToUTF8(s,EncodingUTF8BOM,lEncoded);
  Check(lEncoded,'Encoding to UTF8');
  CheckEquals(49,length(lUTF8str),'Length of UTF8string');
  s:='';
  s := ConvertEncodingFromUTF8(lUTF8str,EncodingUTF8BOM,lEncoded);
  Check(lEncoded,'Encoding from UTF8');
  CheckEquals(52,length(s),'Length of Orgstring');
  lFilename:= ChangeFileExt(lFilename,'_new.txt');
  if FileExists(lFilename) then
    sf:=TFileStream.Create(FDataPath+DirectorySeparator+lFilename,fmOpenWrite)
  else
    sf:=TFileStream.Create(FDataPath+DirectorySeparator+lFilename,fmCreate);
  try
    sf.WriteBuffer(s[1],length(s));
  finally
    freeandnil(sf);
  end;
end;

procedure TTestGuessEncoing.TestUCS2LE;
var sf:TFileStream;
  s,lUTF8str, lFilename:String;
  lEncoded:boolean;
begin
  lFilename := copy(TestName,5,255)+'.txt';
  sf:=TFileStream.Create(FDataPath+DirectorySeparator+lFilename,fmOpenRead);
  try
  setlength(s,sf.Size);
  sf.ReadBuffer(s[1],sf.Size);
  CheckEquals(EncodingUCS2LE,GuessEncoding(s),'UCS2LE Encoding Detected');
  finally
    freeandnil(sf);
  end;
   lUTF8str := ConvertEncodingToUTF8(s,EncodingUCS2LE,lEncoded);
  Check(lEncoded,'Encoding to UTF8');
  CheckEquals(52,length(lUTF8str),'Length of UTF8string');
  s:='';
  s := ConvertEncodingFromUTF8(lUTF8str,EncodingUCS2LE,lEncoded);
  Check(lEncoded,'Encoding from UTF8');
  CheckEquals(86,length(s),'Length of Orgstring');
  lFilename:= ChangeFileExt(lFilename,'_new.txt');
  if FileExists(lFilename) then
    sf:=TFileStream.Create(FDataPath+DirectorySeparator+lFilename,fmOpenWrite)
  else
    sf:=TFileStream.Create(FDataPath+DirectorySeparator+lFilename,fmCreate);
  try
    sf.WriteBuffer(s[1],length(s));
  finally
    freeandnil(sf);
  end;
end;

procedure TTestGuessEncoing.TestUCS2BE;
var sf:TFileStream;
  s,lUTF8str, lFilename:String;
  lEncoded:boolean;
begin
  lFilename := copy(TestName,5,255)+'.txt';
  sf:=TFileStream.Create(FDataPath+DirectorySeparator+lFilename,fmOpenRead);
  try
  setlength(s,sf.Size);
  sf.ReadBuffer(s[1],sf.Size);
  CheckEquals(EncodingUCS2BE,GuessEncoding(s),'UCS2BE Encoding Detected');
  finally
    freeandnil(sf);
  end;
   lUTF8str := ConvertEncodingToUTF8(s,EncodingUCS2BE,lEncoded);
  Check(lEncoded,'Encoding to UTF8');
  CheckEquals(52,length(lUTF8str),'Length of UTF8string');
  s:='';
  s := ConvertEncodingFromUTF8(lUTF8str,EncodingUCS2BE,lEncoded);
  Check(lEncoded,'Encoding from UTF8');
  CheckEquals(86,length(s),'Length of Orgstring');
  lFilename:= ChangeFileExt(lFilename,'_new.txt');
  if FileExists(lFilename) then
    sf:=TFileStream.Create(FDataPath+DirectorySeparator+lFilename,fmOpenWrite)
  else
    sf:=TFileStream.Create(FDataPath+DirectorySeparator+lFilename,fmCreate);
  try
    sf.WriteBuffer(s[1],length(s));
  finally
    freeandnil(sf);
  end;
end;

constructor TTestGuessEncoing.Create;
var
  i: Integer;
begin
  inherited;
  FDataPath:='Data';
  for i := 0 to 2 do
    if DirectoryExists(FDataPath) then
      break
    else
      FDataPath:='..'+DirectorySeparator+FDataPath;
  FDataPath:=FDataPath+DirectorySeparator+'EncTestfiles';
end;


initialization

  RegisterTest(TTestGuessEncoing);
end.

