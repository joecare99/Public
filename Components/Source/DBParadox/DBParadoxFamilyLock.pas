unit DBParadoxFamilyLock;

{$mode objfpc}{$H+}

interface

uses
  SysUtils
  {$IFDEF MSWINDOWS}
  , Windows
  {$ELSE}
  , BaseUnix
  {$ENDIF};

type
  EDBParadoxFamilyLockError = class(Exception);

  TDBParadoxFamilyLock = class
  private
    FLockPath: string;
    FLocked: Boolean;
    {$IFDEF MSWINDOWS}
    FHandle: THandle;
    {$ELSE}
    FFileDescriptor: cint;
    {$ENDIF}
    procedure Release;
  public
    constructor Create(const ATableFileName: string);
    destructor Destroy; override;
    property LockPath: string read FLockPath;
  end;

implementation

constructor TDBParadoxFamilyLock.Create(const ATableFileName: string);
var
  ErrorCode: Integer;
begin
  inherited Create;
  if Trim(ATableFileName) = '' then
    raise EDBParadoxFamilyLockError.Create(
      'A table file name is required to acquire a family lock.');

  FLockPath := ExpandFileName(ATableFileName) + '.dbparadox.lock';
  {$IFDEF MSWINDOWS}
  FHandle := CreateFile(PChar(FLockPath), GENERIC_READ or GENERIC_WRITE, 0,
    nil, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
  if FHandle = THandle(-1) then
  begin
    ErrorCode := GetLastError;
    raise EDBParadoxFamilyLockError.CreateFmt(
      'Cannot acquire the DBParadox family lock "%s" (%d: %s).',
      [FLockPath, ErrorCode, SysErrorMessage(ErrorCode)]);
  end;
  {$ELSE}
  FFileDescriptor := fpOpen(PChar(FLockPath), O_RDWR or O_CREAT, &600);
  if FFileDescriptor < 0 then
  begin
    ErrorCode := GetLastOSError;
    raise EDBParadoxFamilyLockError.CreateFmt(
      'Cannot open the DBParadox family lock "%s" (%d: %s).',
      [FLockPath, ErrorCode, SysErrorMessage(ErrorCode)]);
  end;
  if fpFlock(FFileDescriptor, LOCK_EX or LOCK_NB) <> 0 then
  begin
    ErrorCode := GetLastOSError;
    fpClose(FFileDescriptor);
    FFileDescriptor := -1;
    raise EDBParadoxFamilyLockError.CreateFmt(
      'Cannot acquire the DBParadox family lock "%s" (%d: %s).',
      [FLockPath, ErrorCode, SysErrorMessage(ErrorCode)]);
  end;
  {$ENDIF}
  FLocked := True;
end;

procedure TDBParadoxFamilyLock.Release;
var
  ErrorCode: Integer;
begin
  if not FLocked then
    Exit;
  {$IFDEF MSWINDOWS}
  if not CloseHandle(FHandle) then
  begin
    ErrorCode := GetLastError;
    raise EDBParadoxFamilyLockError.CreateFmt(
      'Cannot release the DBParadox family lock "%s" (%d: %s).',
      [FLockPath, ErrorCode, SysErrorMessage(ErrorCode)]);
  end;
  {$ELSE}
  if fpClose(FFileDescriptor) <> 0 then
  begin
    ErrorCode := GetLastOSError;
    raise EDBParadoxFamilyLockError.CreateFmt(
      'Cannot release the DBParadox family lock "%s" (%d: %s).',
      [FLockPath, ErrorCode, SysErrorMessage(ErrorCode)]);
  end;
  FFileDescriptor := -1;
  {$ENDIF}
  FLocked := False;
end;

destructor TDBParadoxFamilyLock.Destroy;
begin
  Release;
  inherited Destroy;
end;

end.
