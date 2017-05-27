unit testVectFont;

{$IFDEF FPC}
  {$mode delphi}{$H+}
{$ENDIF}

interface

uses
  Classes, SysUtils, {$IFDEF FPC} fpcunit, testutils, testregistry,{$ELSE}testframework, {$ENDIF}cls_VecFont;

type

  { TTestVectFont }

  TTestVectFont= class(TTestCase)
  private
    FVectFont:TVectorFont;
    FDataDir:string;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestLoadFont1;
    procedure TestLoadandSaveFont;
    procedure TestLoadandSaveFont2;
  public
    procedure AfterConstruction; override;
  end;

implementation

const BaseDir= 'Data';
   {$IFNDEF FPC}
  DirectorySeparator = '\';
{$ENDIF}

procedure TTestVectFont.TestLoadFont1;
var
  fs: TFileStream;
  c32: TdAob;
begin
  fs:= TFileStream.Create(FDataDir+DirectorySeparator+'scribe.vec',fmOpenRead);
  try
  FVectFont.LoadFromStream(fs);
  finally
    fs.Free;
  end;
  CheckEquals('Vectordatei: SCRIBE-Zeichensatz',FVectFont.FileDescription,'Dateibeschreibung');
  c32 := FVectFont.Character[32];
  CheckEquals(4,high(c32)+1,'Zeichen '' '' hat 4 Vectoren');
  CheckEquals(0,c32[0],'1. Vector');
  CheckEquals(0,c32[1],'2. Vector');
  CheckEquals(0,c32[2],'3. Vector');
  CheckEquals(1,c32[3],'4. Vector');
  setlength(c32,5);
  CheckEquals(4,high(FVectFont.Character[32])+1,'Zeichen '' '' hat noch 4 Vectoren');
  c32[4]:=2;
  FVectFont.Character[32]:= c32;
  c32 := FVectFont.Character[32];
  CheckEquals(5,high(c32)+1,'Zeichen '' '' hat jetzt 5 Vectoren');

end;

procedure TTestVectFont.TestLoadandSaveFont;
var
  fs: TFileStream;
  c32: TdAob;
begin
  fs:= TFileStream.Create(FDataDir+DirectorySeparator+'scribe.vec',fmOpenRead);
  try
  FVectFont.LoadFromStream(fs);
  finally
    fs.Free;
  end;
  fs:=TFileStream.Create(FDataDir+DirectorySeparator+'scribe.txt',fmCreate+fmOpenWrite);
  try
  FVectFont.SaveToStream(fs,fft_Textfile);
  finally
    fs.Free;
  end;

end;

procedure TTestVectFont.TestLoadandSaveFont2;
var
  fs: TFileStream;
  fs2: TMemoryStream;
  bb0,bb1:byte;
  i:integer;

begin
  fs:= TFileStream.Create(FDataDir+DirectorySeparator+'scribe.vec',fmOpenRead);
  try
  FVectFont.LoadFromStream(fs);
  fs2:=TMemoryStream.Create;
  try
  FVectFont.SaveToStream(fs2,fft_Compressed);
  fs.Position:=0;
  fs2.Position:=0;
  for i := 0 to fs.Size-1 do
    begin
      fs.Read(bb0,1);
      fs2.read(bb1,1);
      CheckEquals(bb0,bb1,'Stream('+inttostr(i)+')');
    end;
  CheckEquals(fs.Size,fs2.Size,'Stream.size');
  finally
    fs2.Free;
  end;
  finally
    fs.Free;
  end;
end;

procedure TTestVectFont.AfterConstruction;
var
  i: Integer;
begin
  inherited AfterConstruction;
  FDataDir:=BaseDir;
  For i := 0 to 2 do
    if DirectoryExists(FDataDir) then
    break
    else
      FDataDir:='..'+DirectorySeparator+ FDataDir;
end;

procedure TTestVectFont.SetUp;
begin
  FVectFont:= TVectorFont.Create;
end;

procedure TTestVectFont.TearDown;
begin
  freeandnil(FVectFont);
end;

initialization

  RegisterTest(TTestVectFont{$IFNDEF FPC}.suite {$ENDIF});
end.

