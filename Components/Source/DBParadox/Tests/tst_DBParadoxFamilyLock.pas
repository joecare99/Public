unit tst_DBParadoxFamilyLock;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestDBParadoxFamilyLock = class(TTestCase)
  published
    procedure LockExcludesAnotherWriterAndPersistsAfterRelease;
    procedure EmptyTablePathIsRejected;
  end;

implementation

uses
  Classes, SysUtils, DBParadoxFamilyLock;

function NewScratchDirectory: string;
begin
  Result := IncludeTrailingPathDelimiter(GetTempDir(False)) +
    'DBParadoxFamilyLock-' + IntToHex(Random(MaxInt), 8);
  if not ForceDirectories(Result) then
    raise Exception.CreateFmt('Cannot create test directory "%s".', [Result]);
end;

procedure TTestDBParadoxFamilyLock.
  LockExcludesAnotherWriterAndPersistsAfterRelease;
var
  Directory: string;
  TableFileName: string;
  LockFileName: string;
  FirstLock: TDBParadoxFamilyLock;
  SecondLock: TDBParadoxFamilyLock;
  ContentionDetected: Boolean;
begin
  Randomize;
  Directory := NewScratchDirectory;
  TableFileName := IncludeTrailingPathDelimiter(Directory) + 'Synthetic.DB';
  LockFileName := TableFileName + '.dbparadox.lock';
  FirstLock := nil;
  SecondLock := nil;
  try
    FirstLock := TDBParadoxFamilyLock.Create(TableFileName);
    CheckEquals(ExpandFileName(LockFileName), FirstLock.LockPath);
    CheckTrue(FileExists(LockFileName));

    ContentionDetected := False;
    try
      SecondLock := TDBParadoxFamilyLock.Create(TableFileName);
    except
      on E: EDBParadoxFamilyLockError do
        ContentionDetected := True;
    end;
    CheckTrue(ContentionDetected);
    CheckTrue(FileExists(LockFileName));

    FirstLock.Free;
    FirstLock := nil;
    SecondLock := TDBParadoxFamilyLock.Create(TableFileName);
    CheckTrue(FileExists(LockFileName));
  finally
    SecondLock.Free;
    FirstLock.Free;
    if FileExists(LockFileName) then
      DeleteFile(LockFileName);
    if DirectoryExists(Directory) then
      RemoveDir(Directory);
  end;
end;

procedure TTestDBParadoxFamilyLock.EmptyTablePathIsRejected;
var
  RaisedExpectedError: Boolean;
  Lock: TDBParadoxFamilyLock;
begin
  RaisedExpectedError := False;
  Lock := nil;
  try
    try
      Lock := TDBParadoxFamilyLock.Create('');
    except
      on E: EDBParadoxFamilyLockError do
        RaisedExpectedError := True;
    end;
    CheckTrue(RaisedExpectedError);
  finally
    Lock.Free;
  end;
end;

initialization
  RegisterTest(TTestDBParadoxFamilyLock);

end.
