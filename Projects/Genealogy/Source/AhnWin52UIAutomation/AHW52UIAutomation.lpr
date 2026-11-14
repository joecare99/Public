program AHW52UIAutomation;

{$mode objfpc}{$H+}
{$codepage utf8}

uses
  Classes, fpjson, jsonparser, SysUtils, Windows, AHW52UIProfile,
  AHW52UIExperiment, AHW52UICloseFlow;

const
  ApprovedExecutablePath = 'C:\ProgramData\AHNENWIN Test\AHNWIN51.exe';
  ApprovedExecutableSha256 =
    '817C1B1BB23469CD628C52E4A5EA26CB4DB26275B5EC84952717B218605F0AFF';
  ApprovedDataDirectory = 'C:\ProgramData\AHNENWIN Test';
  ApprovedOutputDirectory =
    'C:\Users\Mir\.copilot\session-state\bc780dc9-be21-4e10-b7a2-0aab27abfe2f\files\ahnwin-ui-profiles';
  MaximumCapturedText = 4096;
  WindowMessageTimeoutMs = 5000;
  WindowEnumerationAttempts = 4;
  WindowEnumerationRetryDelayMs = 100;
  SearchDialogWaitTimeoutMs = UIExperimentDialogWaitTimeoutMs;
  StartupTimeoutMs = 30000;
  ForegroundWaitTimeoutMs = 30000;
  CryptoProviderRsaAes = 24;
  CryptoVerifyContext = $F0000000;
  CryptoAlgorithmSha256 = $0000800C;
  CryptoHashValue = $0002;
  MoveFileWriteThroughFlag = $00000008;
  TabControlMessageBase = $1300;
  TabControlGetCurrentSelection = TabControlMessageBase + 11;
  TabControlGetItemCount = TabControlMessageBase + 4;
  UiVirtualKeyControl = $11;
  UiVirtualKeyTab = $09;
  KeyEventUp = $0002;
  ButtonClickMessage = $00F5;
  CloseWindowMessage = $0010;
  GetWindowOwnerCommand = 4;
  MessageSendBlock = $0001;
  MessageSendAbortIfHung = $0002;
  MaximumCloseWaitMs = 30000;
  ClosePollDelayMs = 100;

type
  THashProvider = PtrUInt;
  PHashProvider = ^THashProvider;
  THashHandle = PtrUInt;
  PHashHandle = ^THashHandle;
  TByteBuffer = array[0..4095] of Byte;
  TWindowEnumContext = record
    Profile: ^TWindowProfile;
    ErrorText: string;
    IncludeVisibleText: Boolean;
  end;
  PWindowEnumContext = ^TWindowEnumContext;
  TWideStringArray = array of UnicodeString;
  TUIFieldValueArray = array of UTF8String;
  TOptionValue = record
    Name: UTF8String;
    Value: UTF8String;
  end;
  TOptionValueArray = array of TOptionValue;
  TCloseDialogHandleArray = array of HWND;
  TCloseDialogSearchContext = record
    ProcessId: DWORD;
    MainWindowHandle: HWND;
    DialogHandles: TCloseDialogHandleArray;
    ErrorText: string;
  end;
  PCloseDialogSearchContext = ^TCloseDialogSearchContext;
  TCloseDialogButtonContext = record
    YesHandle: HWND;
    NoHandle: HWND;
    YesCount: LongInt;
    NoCount: LongInt;
    PromptText: UTF8String;
    ErrorText: string;
  end;
  PCloseDialogButtonContext = ^TCloseDialogButtonContext;
  TWideArgv = array[0..0] of PWideChar;
  PWideArgv = ^TWideArgv;

function CryptoAcquireContextW(
  Provider: PHashProvider; ContainerName, ProviderName: PWideChar;
  ProviderType, Flags: DWORD): BOOL; stdcall;
  external 'advapi32.dll' name 'CryptAcquireContextW';

function CryptoCreateHash(
  Provider: THashProvider; Algorithm: DWORD; Key: THashHandle;
  Flags: DWORD; Hash: PHashHandle): BOOL; stdcall;
  external 'advapi32.dll' name 'CryptCreateHash';

function CryptoHashData(
  Hash: THashHandle; Data: PByte; DataLength, Flags: DWORD): BOOL; stdcall;
  external 'advapi32.dll' name 'CryptHashData';

function CryptoGetHashParameter(
  Hash: THashHandle; Parameter: DWORD; Data: PByte;
  var DataLength: DWORD; Flags: DWORD): BOOL; stdcall;
  external 'advapi32.dll' name 'CryptGetHashParam';

function CryptoDestroyHash(Hash: THashHandle): BOOL; stdcall;
  external 'advapi32.dll' name 'CryptDestroyHash';

function CryptoReleaseContext(Provider: THashProvider; Flags: DWORD): BOOL; stdcall;
  external 'advapi32.dll' name 'CryptReleaseContext';

function GetProcessImagePathW(
  ProcessHandle: THandle; Flags: DWORD; Buffer: PWideChar;
  var BufferLength: DWORD): BOOL; stdcall;
  external 'kernel32.dll' name 'QueryFullProcessImageNameW';

function SendWindowMessageTimeoutW(
  WindowHandle: HWND; MessageId: UINT; WParam: WPARAM; LParam: LPARAM;
  Flags, Timeout: UINT; var MessageResult: DWORD_PTR): LRESULT; stdcall;
  external 'user32.dll' name 'SendMessageTimeoutW';

procedure SendKeyEvent(Key: BYTE; ScanCode: BYTE; Flags: DWORD;
  ExtraInfo: PtrUInt); stdcall;
  external 'user32.dll' name 'keybd_event';

function GetWindowAncestor(WindowHandle: HWND; AncestorType: UINT): HWND; stdcall;
  external 'user32.dll' name 'GetAncestor';

function GetWindowsCommandLine: PWideChar; stdcall;
  external 'kernel32.dll' name 'GetCommandLineW';

function SplitWindowsCommandLine(
  CommandLine: PWideChar; ArgumentCount: PLongInt): PWideArgv; stdcall;
  external 'shell32.dll' name 'CommandLineToArgvW';

function FreeWindowsLocalMemory(Memory: HLOCAL): HLOCAL; stdcall;
  external 'kernel32.dll' name 'LocalFree';

function GetFileAttributesUnicode(FileName: PWideChar): DWORD; stdcall;
  external 'kernel32.dll' name 'GetFileAttributesW';

function CreateNewOutputFile(
  FileName: PWideChar; DesiredAccess, ShareMode: DWORD;
  SecurityAttributes: Pointer; CreationDisposition, FlagsAndAttributes: DWORD;
  TemplateFile: THandle): THandle; stdcall;
  external 'kernel32.dll' name 'CreateFileW';

function WriteOutputBytes(
  FileHandle: THandle; Buffer: Pointer; BytesToWrite: DWORD;
  var BytesWritten: DWORD; Overlapped: Pointer): BOOL; stdcall;
  external 'kernel32.dll' name 'WriteFile';

function ReplaceOutputFile(
  ExistingFileName, ReplacementFileName: PWideChar;
  Flags: DWORD): BOOL; stdcall;
  external 'kernel32.dll' name 'MoveFileExW';

function DeleteOutputFile(FileName: PWideChar): BOOL; stdcall;
  external 'kernel32.dll' name 'DeleteFileW';

function CreateApprovedProcessW(
  ApplicationName: PWideChar; CommandLine: PWideChar;
  ProcessAttributes, ThreadAttributes: Pointer; InheritHandles: BOOL;
  CreationFlags: DWORD; Environment: Pointer; CurrentDirectory: PWideChar;
  StartupInfo: PStartupInfoW; ProcessInformation: PProcessInformation): BOOL; stdcall;
  external 'kernel32.dll' name 'CreateProcessW';

function WideToUTF8(const Value: UnicodeString): UTF8String;
begin
  Result := UTF8Encode(Value);
end;

function UTF8ToWide(const Value: UTF8String): UnicodeString;
begin
  Result := UTF8Decode(Value);
end;

function GetFileSha256(const FileName: string): string;
var
  Provider: THashProvider;
  Hash: THashHandle;
  Stream: TFileStream;
  Buffer: TByteBuffer;
  Digest: array[0..31] of Byte;
  DigestLength: DWORD;
  BytesRead: LongInt;
  I: LongInt;
begin
  Provider := 0;
  Hash := 0;
  if not CryptoAcquireContextW(@Provider, nil, nil, CryptoProviderRsaAes,
    CryptoVerifyContext) then
    RaiseLastOSError;
  try
    if not CryptoCreateHash(Provider, CryptoAlgorithmSha256, 0, 0, @Hash) then
      RaiseLastOSError;
    try
      Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
      try
        repeat
          BytesRead := Stream.Read(Buffer, SizeOf(Buffer));
          if (BytesRead > 0) and
             not CryptoHashData(Hash, @Buffer[0], BytesRead, 0) then
            RaiseLastOSError;
        until BytesRead = 0;
      finally
        Stream.Free;
      end;

      DigestLength := SizeOf(Digest);
      if not CryptoGetHashParameter(Hash, CryptoHashValue, @Digest[0],
        DigestLength, 0) then
        RaiseLastOSError;
      if DigestLength <> SizeOf(Digest) then
        raise Exception.Create('The Windows cryptographic provider returned an invalid SHA-256 length.');

      Result := '';
      for I := 0 to High(Digest) do
        Result := Result + IntToHex(Digest[I], 2);
    finally
      CryptoDestroyHash(Hash);
    end;
  finally
    CryptoReleaseContext(Provider, 0);
  end;
end;

procedure VerifyApprovedExecutable(const ActualPath: UTF8String);
var
  ActualHash: string;
begin
  ValidateExecutableIdentity(ActualPath, ApprovedExecutableSha256);
  if not FileExists(ActualPath) then
    raise Exception.Create('The approved test executable no longer exists.');
  ActualHash := GetFileSha256(ActualPath);
  ValidateExecutableIdentity(ActualPath, ActualHash);
end;

function QueryProcessPath(ProcessId: DWORD): UTF8String;
var
  ProcessHandle: THandle;
  Buffer: array[0..32767] of WideChar;
  BufferLength: DWORD;
  WidePath: UnicodeString;
begin
  ProcessHandle := OpenProcess(PROCESS_QUERY_LIMITED_INFORMATION, False, ProcessId);
  if ProcessHandle = 0 then
    RaiseLastOSError;
  try
    BufferLength := Length(Buffer);
    if not GetProcessImagePathW(ProcessHandle, 0, @Buffer[0], BufferLength) then
      RaiseLastOSError;
    SetString(WidePath, PWideChar(@Buffer[0]), BufferLength);
    Result := WideToUTF8(WidePath);
  finally
    CloseHandle(ProcessHandle);
  end;
end;

function GetWindowClass(WindowHandle: HWND): UTF8String; forward;

function IsPasswordEdit(WindowHandle: HWND): Boolean;
var
  WindowStyle: LONG_PTR;
  ClassName: UTF8String;
begin
  ClassName := GetWindowClass(WindowHandle);
  if not (SameText(ClassName, 'Edit') or
    SameText(ClassName, 'TEdit') or
    SameText(ClassName, 'TDBEdit') or
    SameText(ClassName, 'TMaskEdit') or
    SameText(ClassName, 'TDBMaskEdit')) then
    Exit(False);
  WindowStyle := GetWindowLongPtrW(WindowHandle, GWL_STYLE);
  Result := (WindowStyle and ES_PASSWORD) <> 0;
end;

function GetVisibleWindowText(WindowHandle: HWND): UTF8String;
var
  TextLength: DWORD_PTR;
  ReadLength: DWORD_PTR;
  Buffer: array of WideChar;
  MessageResult: DWORD_PTR;
  MessageStatus: LRESULT;
  WideText: UnicodeString;
begin
  Result := '';
  if not IsWindowVisible(WindowHandle) or IsPasswordEdit(WindowHandle) then
    Exit;

  MessageResult := 0;
  MessageStatus := SendWindowMessageTimeoutW(WindowHandle, WM_GETTEXTLENGTH,
    0, 0, SMTO_ABORTIFHUNG or SMTO_BLOCK, WindowMessageTimeoutMs, MessageResult);
  if MessageStatus = 0 then
    raise Exception.CreateFmt('WM_GETTEXTLENGTH failed or timed out (Win32 error %d).',
      [GetLastError]);
  TextLength := MessageResult;
  if TextLength > MaximumCapturedText then
    raise Exception.CreateFmt('Visible control text exceeds the %d-character safety limit.',
      [MaximumCapturedText]);

  SetLength(Buffer, TextLength + 1);
  MessageResult := 0;
  MessageStatus := SendWindowMessageTimeoutW(WindowHandle, WM_GETTEXT,
    Length(Buffer), LPARAM(@Buffer[0]), SMTO_ABORTIFHUNG or SMTO_BLOCK,
    WindowMessageTimeoutMs, MessageResult);
  if MessageStatus = 0 then
    raise Exception.CreateFmt('WM_GETTEXT failed or timed out (Win32 error %d).',
      [GetLastError]);
  ReadLength := MessageResult;
  if ReadLength > TextLength then
    ReadLength := TextLength;
  SetString(WideText, PWideChar(@Buffer[0]), ReadLength);
  Result := WideToUTF8(WideText);
end;

function GetWindowClass(WindowHandle: HWND): UTF8String;
var
  Buffer: array[0..255] of WideChar;
  CharacterCount: LongInt;
  WideClassName: UnicodeString;
begin
  CharacterCount := GetClassNameW(WindowHandle, @Buffer[0], Length(Buffer));
  if CharacterCount = 0 then
    RaiseLastOSError;
  SetString(WideClassName, PWideChar(@Buffer[0]), CharacterCount);
  Result := WideToUTF8(WideClassName);
end;

procedure AppendWindow(
  WindowHandle: HWND; Context: PWindowEnumContext);
var
  ProcessId: DWORD;
  WindowThreadId: DWORD;
  ParentHandle: HWND;
  OwnerHandle: HWND;
  IsTopLevel: Boolean;
  WindowRect: TRect;
  Control: TUIControlInfo;
  I: LongInt;
begin
  WindowThreadId := GetWindowThreadProcessId(WindowHandle, ProcessId);
  if (WindowThreadId = 0) or (ProcessId <> Context^.Profile^.ProcessId) then
    Exit;

  IsTopLevel := GetWindowAncestor(WindowHandle, GA_ROOT) = WindowHandle;
  if IsTopLevel then
    ParentHandle := 0
  else
    ParentHandle := GetParent(WindowHandle);
  OwnerHandle := GetWindow(WindowHandle, GW_OWNER);
  if not GetWindowRect(WindowHandle, WindowRect) then
  begin
    Context^.ErrorText := SysErrorMessage(GetLastError);
    Exit;
  end;

  FillChar(Control, SizeOf(Control), 0);
  Control.Handle := QWord(PtrUInt(WindowHandle));
  Control.ParentHandle := QWord(PtrUInt(ParentHandle));
  Control.OwnerHandle := QWord(PtrUInt(OwnerHandle));
  Control.ProcessId := ProcessId;
  Control.ClassName := GetWindowClass(WindowHandle);
  Control.Visible := IsWindowVisible(WindowHandle);
  Control.Enabled := IsWindowEnabled(WindowHandle);
  Control.IsPassword := IsPasswordEdit(WindowHandle);
  Control.IsTopLevel := IsTopLevel;
  if Context^.IncludeVisibleText and Control.Visible and
     not Control.IsPassword then
    Control.Text := GetVisibleWindowText(WindowHandle);
  Control.Left := WindowRect.Left;
  Control.Top := WindowRect.Top;
  Control.Width := WindowRect.Right - WindowRect.Left;
  Control.Height := WindowRect.Bottom - WindowRect.Top;
  Control.ControlId := GetDlgCtrlID(WindowHandle);
  Control.Ordinal := 0;
  for I := 0 to High(Context^.Profile^.Controls) do
    if Context^.Profile^.Controls[I].ParentHandle = Control.ParentHandle then
      Inc(Control.Ordinal);

  SetLength(Context^.Profile^.Controls,
    Length(Context^.Profile^.Controls) + 1);
  Context^.Profile^.Controls[High(Context^.Profile^.Controls)] := Control;
end;

function EnumerateChildWindow(
  WindowHandle: HWND; Parameter: LPARAM): BOOL; stdcall;
var
  Context: PWindowEnumContext;
begin
  Context := PWindowEnumContext(Parameter);
  try
    AppendWindow(WindowHandle, Context);
    Result := Context^.ErrorText = '';
  except
    on E: Exception do
    begin
      Context^.ErrorText := Format('Window inspection failed for HWND 0x%s: %s',
        [IntToHex(PtrUInt(WindowHandle), SizeOf(Pointer) * 2), E.Message]);
      Result := False;
    end;
  end;
end;

function EnumerateTopLevelWindow(
  WindowHandle: HWND; Parameter: LPARAM): BOOL; stdcall;
var
  Context: PWindowEnumContext;
  WindowProcessId: DWORD;
  EnumerationSucceeded: BOOL;
  EnumerationError: DWORD;
begin
  Context := PWindowEnumContext(Parameter);
  try
    WindowProcessId := 0;
    if GetWindowThreadProcessId(WindowHandle, WindowProcessId) <> 0 then
    begin
    if WindowProcessId = Context^.Profile^.ProcessId then
      AppendWindow(WindowHandle, Context);
    if (Context^.ErrorText = '') and
       (WindowProcessId = Context^.Profile^.ProcessId) then
    begin
      SetLastError(0);
      EnumerationSucceeded :=
        EnumChildWindows(WindowHandle, @EnumerateChildWindow, Parameter);
      EnumerationError := GetLastError;
      if not EnumerationSucceeded and (Context^.ErrorText = '') and
         (EnumerationError <> 0) then
        Context^.ErrorText := Format(
          'Child-window enumeration failed for HWND 0x%s (Win32 error %d).',
          [IntToHex(PtrUInt(WindowHandle), SizeOf(Pointer) * 2),
           EnumerationError]);
    end;
    end;
    Result := Context^.ErrorText = '';
  except
    on E: Exception do
    begin
    Context^.ErrorText := Format('Top-level inspection failed for HWND 0x%s: %s',
      [IntToHex(PtrUInt(WindowHandle), SizeOf(Pointer) * 2), E.Message]);
    Result := False;
    end;
  end;
end;

function CaptureProfile(ProcessId: DWORD;
  IncludeVisibleText: Boolean): TWindowProfile;
var
  Context: TWindowEnumContext;
  Attempt: LongInt;
  ForegroundWindow: HWND;
  ForegroundProcessId: DWORD;
begin
  Result.ProcessId := ProcessId;
  Result.ExecutablePath := QueryProcessPath(ProcessId);
  ValidateExecutableIdentity(Result.ExecutablePath, GetFileSha256(Result.ExecutablePath));
  Result.ExecutableSha256 := ApprovedExecutableSha256;
  Result.ForegroundWindowHandle := 0;
  for Attempt := 1 to WindowEnumerationAttempts do
  begin
    Result.Controls := nil;
    Context.Profile := @Result;
    Context.ErrorText := '';
    Context.IncludeVisibleText := IncludeVisibleText;
    if EnumWindows(@EnumerateTopLevelWindow, LPARAM(@Context)) then
    begin
      ForegroundWindow := GetForegroundWindow;
      ForegroundProcessId := 0;
      if (ForegroundWindow <> 0) and
         (GetWindowThreadProcessId(ForegroundWindow, ForegroundProcessId) <> 0) and
         (ForegroundProcessId = ProcessId) then
        Result.ForegroundWindowHandle := QWord(PtrUInt(ForegroundWindow));
      Exit;
    end;
    if Context.ErrorText <> '' then
      raise Exception.Create(Context.ErrorText);
    if Attempt < WindowEnumerationAttempts then
      Sleep(WindowEnumerationRetryDelayMs);
  end;
  raise Exception.CreateFmt(
    'The window hierarchy remained unstable after %d capture attempts.',
    [WindowEnumerationAttempts]);
end;

function PathIsInsideDirectory(
  const CandidatePath, DirectoryPath: UTF8String): Boolean;
var
  Candidate: string;
  DirectoryName: string;
begin
  Candidate := LowerCase(ExcludeTrailingPathDelimiter(ExpandFileName(CandidatePath)));
  DirectoryName := LowerCase(ExcludeTrailingPathDelimiter(ExpandFileName(DirectoryPath)));
  Result := (Candidate = DirectoryName) or
    (Copy(Candidate, 1, Length(DirectoryName) + 1) = DirectoryName + '\');
end;

procedure ValidateOutputLocation(
  const OutputPath: string; MustNotExist: Boolean);
var
  FullOutputPath: string;
  SafeOutputRoot: string;
  RootDrive: UnicodeString;
  WideOutputRoot: UnicodeString;
  RootAttributes: DWORD;
begin
  if OutputPath = '' then
    raise Exception.Create('An explicit output JSON path is required.');
  FullOutputPath := ExpandFileName(OutputPath);
  if PathIsInsideDirectory(FullOutputPath, ApprovedDataDirectory) then
    raise Exception.Create('Profiles and logs must be written outside the test-data directory.');
  SafeOutputRoot := ExpandFileName(ApprovedOutputDirectory);
  if not PathIsInsideDirectory(FullOutputPath, SafeOutputRoot) then
    raise Exception.CreateFmt('Profiles and logs must be stored under %s.',
      [SafeOutputRoot]);
  RootDrive := UTF8ToWide(ExtractFileDrive(SafeOutputRoot) + '\');
  if GetDriveTypeW(PWideChar(RootDrive)) <> DRIVE_FIXED then
    raise Exception.Create('The profile output root must reside on a local fixed drive.');
  if not DirectoryExists(SafeOutputRoot) and
     not ForceDirectories(SafeOutputRoot) then
    raise Exception.Create('The local profile output directory could not be created.');
  WideOutputRoot := UTF8ToWide(SafeOutputRoot);
  RootAttributes := GetFileAttributesUnicode(PWideChar(WideOutputRoot));
  if RootAttributes = INVALID_FILE_ATTRIBUTES then
    RaiseLastOSError;
  if (RootAttributes and FILE_ATTRIBUTE_REPARSE_POINT) <> 0 then
    raise Exception.Create('The local profile output directory cannot be a reparse point.');
  if MustNotExist and FileExists(FullOutputPath) then
    raise Exception.Create('Refusing to overwrite an existing output file.');
  if not MustNotExist and not FileExists(FullOutputPath) then
    raise Exception.Create('The progress log to update does not exist.');
  if not DirectoryExists(ExtractFileDir(FullOutputPath)) then
    raise Exception.Create('The output directory does not exist.');
end;

procedure ValidateOutputPath(const OutputPath: string);
begin
  ValidateOutputLocation(OutputPath, True);
end;

procedure WriteNewUTF8File(const FileName: string; const Contents: UTF8String);
var
  FileHandle: THandle;
  UTF8Contents: UTF8String;
  WideFileName: UnicodeString;
  BytesWritten: DWORD;
begin
  ValidateOutputPath(FileName);
  UTF8Contents := Contents;
  if QWord(Length(UTF8Contents)) > High(DWORD) then
    raise Exception.Create('The output profile exceeds the Windows file-write limit.');
  WideFileName := UTF8ToWide(UTF8String(FileName));
  FileHandle := CreateNewOutputFile(PWideChar(WideFileName), GENERIC_WRITE, 0,
    nil, CREATE_NEW, FILE_ATTRIBUTE_NORMAL, 0);
  if FileHandle = INVALID_HANDLE_VALUE then
    RaiseLastOSError;
  try
    if Length(UTF8Contents) > 0 then
    begin
      BytesWritten := 0;
      if not WriteOutputBytes(FileHandle, @UTF8Contents[1],
        Length(UTF8Contents), BytesWritten, nil) then
        RaiseLastOSError;
      if BytesWritten <> DWORD(Length(UTF8Contents)) then
        raise Exception.Create('The complete profile could not be written to its output file.');
    end;
  finally
    CloseHandle(FileHandle);
  end;
end;

procedure ReplaceUTF8File(const FileName: string; const Contents: UTF8String);
var
  TemporaryFileName: string;
  TemporaryWideName: UnicodeString;
  DestinationWideName: UnicodeString;
  MoveError: DWORD;
  CleanupError: DWORD;
begin
  ValidateOutputLocation(FileName, False);
  TemporaryFileName := FileName + '.tmp-' + IntToStr(GetCurrentProcessId) +
    '-' + IntToStr(GetTickCount64);
  WriteNewUTF8File(TemporaryFileName, Contents);
  TemporaryWideName := UTF8ToWide(UTF8String(TemporaryFileName));
  DestinationWideName := UTF8ToWide(UTF8String(FileName));
  if not ReplaceOutputFile(PWideChar(TemporaryWideName),
    PWideChar(DestinationWideName),
    MOVEFILE_REPLACE_EXISTING or MoveFileWriteThroughFlag) then
  begin
    MoveError := GetLastError;
    if not DeleteOutputFile(PWideChar(TemporaryWideName)) then
    begin
      CleanupError := GetLastError;
      raise Exception.CreateFmt(
        'Atomic log replacement failed (Win32 %d) and its temporary file could not be removed (Win32 %d).',
        [MoveError, CleanupError]);
    end;
    SetLastError(MoveError);
    RaiseLastOSError;
  end;
end;

function ParseOptions(
  const Arguments: TWideStringArray; FirstOption: LongInt): TOptionValueArray;
var
  I: LongInt;
  OptionValue: TOptionValue;
begin
  Result := nil;
  I := FirstOption;
  while I <= High(Arguments) do
  begin
    if (Arguments[I] = '--allow-input') or (Arguments[I] = '--allow-read') or
       (Arguments[I] = '--allow-close') or (Arguments[I] = '--resume-backup') or
       (Arguments[I] = '--dry-run') or
       (Arguments[I] = '--wait-for-dialog') then
    begin
      OptionValue.Name := WideToUTF8(Arguments[I]);
      OptionValue.Value := 'true';
      SetLength(Result, Length(Result) + 1);
      Result[High(Result)] := OptionValue;
      Inc(I);
      Continue;
    end;
    if (I = High(Arguments)) or (Copy(Arguments[I], 1, 2) <> '--') then
      raise Exception.CreateFmt('Unexpected argument: %s', [WideToUTF8(Arguments[I])]);
    OptionValue.Name := WideToUTF8(Arguments[I]);
    OptionValue.Value := WideToUTF8(Arguments[I + 1]);
    SetLength(Result, Length(Result) + 1);
    Result[High(Result)] := OptionValue;
    Inc(I, 2);
  end;
end;

function FindOption(
  const Options: TOptionValueArray; const Name: UTF8String): UTF8String;
var
  I: LongInt;
begin
  for I := 0 to High(Options) do
    if Options[I].Name = Name then
      Exit(Options[I].Value);
  Result := '';
end;

function HasOption(
  const Options: TOptionValueArray; const Name: UTF8String): Boolean;
var
  I: LongInt;
begin
  for I := 0 to High(Options) do
    if Options[I].Name = Name then
      Exit(True);
  Result := False;
end;

procedure RequireOnlyOptions(
  const Options: TOptionValueArray; const AllowedNames: array of string);
var
  I: LongInt;
  J: LongInt;
  K: LongInt;
  Found: Boolean;
begin
  for I := 0 to High(Options) do
  begin
    for K := I + 1 to High(Options) do
      if Options[I].Name = Options[K].Name then
        raise Exception.CreateFmt('Option %s was supplied more than once.',
          [Options[I].Name]);
    Found := False;
    for J := Low(AllowedNames) to High(AllowedNames) do
      if Options[I].Name = AllowedNames[J] then
        Found := True;
    if not Found then
      raise Exception.CreateFmt('Unsupported option: %s', [Options[I].Name]);
  end;
end;

function ReadProfileFile(const FileName: string): TWindowProfile;
var
  Stream: TFileStream;
  Buffer: UTF8String;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    if Stream.Size > 16 * 1024 * 1024 then
      raise Exception.Create('The profile file exceeds the 16 MiB safety limit.');
    SetLength(Buffer, Stream.Size);
    if Length(Buffer) > 0 then
      Stream.ReadBuffer(Buffer[1], Length(Buffer));
  finally
    Stream.Free;
  end;
  Result := ProfileFromJSON(Buffer);
end;

function ParseProcessId(const Value: string): DWORD;
var
  ParsedValue: QWord;
begin
  if (Value = '') or not TryStrToQWord(Value, ParsedValue) or
     (ParsedValue = 0) or (ParsedValue > High(DWORD)) then
    raise Exception.Create('A valid --pid value is required.');
  Result := DWORD(ParsedValue);
end;

function StartApprovedApplication: DWORD;
var
  StartupInfo: TStartupInfoW;
  ProcessInfo: TProcessInformation;
  ExecutablePath: UnicodeString;
  WorkingDirectory: UnicodeString;
begin
  VerifyApprovedExecutable(ApprovedExecutablePath);
  FillChar(StartupInfo, SizeOf(StartupInfo), 0);
  StartupInfo.cb := SizeOf(StartupInfo);
  FillChar(ProcessInfo, SizeOf(ProcessInfo), 0);
  ExecutablePath := UTF8ToWide(ApprovedExecutablePath);
  WorkingDirectory := UTF8ToWide(ExtractFileDir(ApprovedExecutablePath));
  if not CreateApprovedProcessW(PWideChar(ExecutablePath), nil, nil, nil, False,
    CREATE_DEFAULT_ERROR_MODE, nil, PWideChar(WorkingDirectory), @StartupInfo,
    @ProcessInfo) then
    RaiseLastOSError;
  Result := ProcessInfo.dwProcessId;
  CloseHandle(ProcessInfo.hThread);
  CloseHandle(ProcessInfo.hProcess);
end;

function HasMainWindow(const Profile: TWindowProfile): Boolean;
var
  I: LongInt;
begin
  for I := 0 to High(Profile.Controls) do
    if Profile.Controls[I].IsTopLevel and Profile.Controls[I].Visible and
       (Profile.Controls[I].Text = 'AHNENWIN 5.1') then
      Exit(True);
  Result := False;
end;

function WaitForMainWindow(ProcessId: DWORD): TWindowProfile;
var
  StartedAt: QWord;
  ProcessHandle: THandle;
begin
  ProcessHandle := OpenProcess(SYNCHRONIZE, False, ProcessId);
  if ProcessHandle = 0 then
    RaiseLastOSError;
  try
    StartedAt := GetTickCount64;
    repeat
      if WaitForSingleObject(ProcessHandle, 0) = WAIT_OBJECT_0 then
        raise Exception.CreateFmt('The approved application exited during startup (PID %d).',
          [ProcessId]);
      Result := CaptureProfile(ProcessId, True);
      if HasMainWindow(Result) then
        Exit;
      Sleep(250);
    until GetTickCount64 - StartedAt >= StartupTimeoutMs;
    raise Exception.CreateFmt(
      'The main window did not appear within %d ms; the application remains running with PID %d.',
      [StartupTimeoutMs, ProcessId]);
  finally
    CloseHandle(ProcessHandle);
  end;
end;

function WaitForPersonSearchDialog(
  ProcessId: DWORD; const ExpectedProfile: TWindowProfile;
  out Targets: TPersonSearchTargets;
  out FinalProfile: TWindowProfile): Boolean;
var
  StartedAt: QWord;
begin
  StartedAt := GetTickCount64;
  repeat
    FinalProfile := CaptureProfile(ProcessId, True);
    if HasVisiblePersonSearchDialog(FinalProfile) then
    begin
      ValidatePersonSearchProfile(FinalProfile, ExpectedProfile, Targets);
      Exit(True);
    end;
    if GetTickCount64 - StartedAt >= SearchDialogWaitTimeoutMs then
    begin
      Result := False;
      Exit;
    end;
    Sleep(250);
  until False;
end;

procedure SaveProfile(const Profile: TWindowProfile; const OutputPath: string);
begin
  WriteNewUTF8File(OutputPath, ProfileToJSON(Profile) + LineEnding);
end;

function EnumerateCloseDialog(
  WindowHandle: HWND; Parameter: LPARAM): BOOL; stdcall;
var
  Context: PCloseDialogSearchContext;
  WindowProcessId: DWORD;
  WindowRect: TRect;
  OwnerHandle: HWND;
  OwnerProcessId: DWORD;
begin
  Context := PCloseDialogSearchContext(Parameter);
  WindowProcessId := 0;
  GetWindowThreadProcessId(WindowHandle, WindowProcessId);
  if not IsWindow(WindowHandle) or
     (WindowProcessId <> Context^.ProcessId) or
     (WindowHandle = Context^.MainWindowHandle) or
     not IsWindowVisible(WindowHandle) then
    Exit(True);

  if not GetWindowRect(WindowHandle, WindowRect) then
  begin
    Context^.ErrorText := 'Could not inspect a visible target-process window.';
    Exit(False);
  end;
  if (WindowRect.Right <= WindowRect.Left) or
     (WindowRect.Bottom <= WindowRect.Top) then
    Exit(True);

  OwnerHandle := GetWindow(WindowHandle, GetWindowOwnerCommand);
  if OwnerHandle = 0 then
  begin
    Context^.ErrorText :=
      'A visible non-main window has no validated owner; refusing close automation.';
    Exit(False);
  end;
  OwnerProcessId := 0;
  GetWindowThreadProcessId(OwnerHandle, OwnerProcessId);
  if OwnerProcessId <> Context^.ProcessId then
  begin
    Context^.ErrorText :=
      'A visible non-main window is not owned by the approved process.';
    Exit(False);
  end;

  SetLength(Context^.DialogHandles, Length(Context^.DialogHandles) + 1);
  Context^.DialogHandles[High(Context^.DialogHandles)] := WindowHandle;
  Result := True;
end;

function EnumerateCloseDialogButton(
  WindowHandle: HWND; Parameter: LPARAM): BOOL; stdcall;
var
  Context: PCloseDialogButtonContext;
  WindowClass: UTF8String;
  ControlText: UTF8String;
  Choice: TConfirmationChoice;
begin
  Context := PCloseDialogButtonContext(Parameter);
  if not IsWindow(WindowHandle) or not IsWindowVisible(WindowHandle) then
    Exit(True);
  try
    WindowClass := GetWindowClass(WindowHandle);
    ControlText := GetVisibleWindowText(WindowHandle);
    if not IsWindow(WindowHandle) then
      Exit(True);
    Choice := ClassifyConfirmationButton(ControlText);
    if (WindowClass = 'TButton') or (WindowClass = 'TBitBtn') or
       (WindowClass = 'Button') then
    begin
      case Choice of
        ccYes:
          begin
            Inc(Context^.YesCount);
            Context^.YesHandle := WindowHandle;
          end;
        ccNo:
          begin
            Inc(Context^.NoCount);
            Context^.NoHandle := WindowHandle;
          end;
      end;
    end
    else if (ControlText <> '') and (Choice = ccUnknown) then
      Context^.PromptText := Context^.PromptText + ' ' + ControlText;
    Result := True;
  except
    on E: Exception do
    begin
      if not IsWindow(WindowHandle) then
        Exit(True);
      Context^.ErrorText := E.Message;
      Result := False;
    end;
  end;
end;

procedure CheckApprovedProcessWindow(
  ProcessId: DWORD; MainWindowHandle: HWND);
var
  WindowProcessId: DWORD;
  WindowClass: UTF8String;
  ProcessPath: UTF8String;
begin
  if not IsWindow(MainWindowHandle) then
    raise Exception.Create('The approved main window no longer exists.');
  WindowProcessId := 0;
  GetWindowThreadProcessId(MainWindowHandle, WindowProcessId);
  if WindowProcessId <> ProcessId then
    raise Exception.Create('The main-window handle no longer belongs to the approved PID.');
  WindowClass := GetWindowClass(MainWindowHandle);
  if not SameText(WindowClass, 'TForm1') then
    raise Exception.Create('The approved main-window class changed.');
  ProcessPath := QueryProcessPath(ProcessId);
  ValidateExecutableIdentity(ProcessPath, ApprovedExecutableSha256);
end;

function FindExpectedClosePrompt(
  ProcessId: DWORD; MainWindowHandle: HWND; ExpectedPrompt: TClosePromptKind;
  out YesHandle, NoHandle: HWND): Boolean;
var
  Context: TCloseDialogSearchContext;
  ButtonContext: TCloseDialogButtonContext;
  EnumerationSucceeded: BOOL;
  EnumerationError: DWORD;
  WindowClass: UTF8String;
  DialogTitle: UTF8String;
  PromptKind: TClosePromptKind;
  DialogHandle: HWND;
  OwnerHandle: HWND;
  OwnerProcessId: DWORD;
  MessageResult: DWORD_PTR;
  SendResult: LRESULT;
begin
  FillChar(Context, SizeOf(Context), 0);
  Context.ProcessId := ProcessId;
  Context.MainWindowHandle := MainWindowHandle;
  SetLastError(0);
  EnumerationSucceeded := EnumWindows(@EnumerateCloseDialog,
    LPARAM(@Context));
  EnumerationError := GetLastError;
  if not EnumerationSucceeded and (Context.ErrorText = '') and
     (EnumerationError <> 0) then
    RaiseLastOSError(EnumerationError);
  if Context.ErrorText <> '' then
    raise Exception.Create(Context.ErrorText);
  if Length(Context.DialogHandles) = 0 then
    Exit(False);
  if Length(Context.DialogHandles) <> 1 then
    raise Exception.Create(
      'Multiple visible target-process dialogs were found; none was handled.');

  DialogHandle := Context.DialogHandles[0];
  WindowClass := GetWindowClass(DialogHandle);
  if not (SameText(WindowClass, '#32770') or
          SameText(WindowClass, 'TMessageForm')) then
    raise Exception.CreateFmt(
      'Unexpected close-window class "%s"; no input was sent.',
      [WindowClass]);
  OwnerHandle := GetWindow(DialogHandle, GetWindowOwnerCommand);
  OwnerProcessId := 0;
  if OwnerHandle <> 0 then
    GetWindowThreadProcessId(OwnerHandle, OwnerProcessId);
  if (OwnerHandle = 0) or (OwnerProcessId <> ProcessId) then
    raise Exception.Create(
      'The close prompt is not owned by the approved AhnWin process.');

  FillChar(ButtonContext, SizeOf(ButtonContext), 0);
  DialogTitle := GetVisibleWindowText(DialogHandle);
  SetLastError(0);
  EnumerationSucceeded := EnumChildWindows(DialogHandle,
    @EnumerateCloseDialogButton, LPARAM(@ButtonContext));
  EnumerationError := GetLastError;
  if not EnumerationSucceeded and (ButtonContext.ErrorText = '') and
     (EnumerationError <> 0) then
    RaiseLastOSError(EnumerationError);
  if ButtonContext.ErrorText <> '' then
    raise Exception.Create(ButtonContext.ErrorText);
  if (ButtonContext.YesCount <> 1) or (ButtonContext.NoCount <> 1) then
    raise Exception.Create(
      'The expected close dialog must expose exactly one Ja/Yes and one Nein/No button.');

  PromptKind := ClassifyClosePrompt(
    ButtonContext.PromptText + ' ' + DialogTitle);
  if (PromptKind <> cpkUnknown) and (PromptKind <> ExpectedPrompt) then
    raise Exception.Create(
      'The visible close prompt does not match the expected confirmation phase.');
  if (PromptKind = cpkUnknown) and
     not CanUseKnownPromptSequenceFallback(
       WindowClass, DialogTitle, ButtonContext.PromptText) then
    raise Exception.Create(
      'The expected prompt text is not exposed by the native message box.');

  YesHandle := ButtonContext.YesHandle;
  NoHandle := ButtonContext.NoHandle;
  if not IsWindowEnabled(YesHandle) or not IsWindowEnabled(NoHandle) then
    raise Exception.Create('A confirmation button is disabled.');
  MessageResult := 0;
  SendResult := SendWindowMessageTimeoutW(DialogHandle, WM_NULL, 0, 0,
    MessageSendBlock or MessageSendAbortIfHung, WindowMessageTimeoutMs,
    MessageResult);
  if SendResult = 0 then
    raise Exception.Create('The validated close dialog stopped responding.');
  Result := True;
end;

procedure WaitForExpectedClosePrompt(
  ProcessId: DWORD; MainWindowHandle: HWND;
  ExpectedPrompt: TClosePromptKind; out YesHandle, NoHandle: HWND);
var
  StartedAt: QWord;
  ProcessHandle: THandle;
begin
  ProcessHandle := OpenProcess(SYNCHRONIZE, False, ProcessId);
  if ProcessHandle = 0 then
    RaiseLastOSError;
  try
    StartedAt := GetTickCount64;
    repeat
      if WaitForSingleObject(ProcessHandle, 0) = WAIT_OBJECT_0 then
        raise Exception.Create(
          'AhnWin exited before the expected close confirmation appeared.');
      CheckApprovedProcessWindow(ProcessId, MainWindowHandle);
      if FindExpectedClosePrompt(ProcessId, MainWindowHandle,
        ExpectedPrompt, YesHandle, NoHandle) then
        Exit;
      if GetTickCount64 - StartedAt >= MaximumCloseWaitMs then
        raise Exception.CreateFmt(
          'The expected close confirmation did not appear within %d ms; the process was not terminated.',
          [MaximumCloseWaitMs]);
      Sleep(ClosePollDelayMs);
    until False;
  finally
    CloseHandle(ProcessHandle);
  end;
end;

procedure ClickValidatedDialogButton(ButtonHandle: HWND);
var
  MessageResult: DWORD_PTR;
  SendResult: LRESULT;
begin
  if not IsWindow(ButtonHandle) or not IsWindowEnabled(ButtonHandle) then
    raise Exception.Create('The validated confirmation button is no longer enabled.');
  MessageResult := 0;
  SendResult := SendWindowMessageTimeoutW(ButtonHandle, ButtonClickMessage,
    0, 0, MessageSendBlock or MessageSendAbortIfHung,
    WindowMessageTimeoutMs, MessageResult);
  if SendResult = 0 then
    raise Exception.Create('Windows did not deliver the confirmation-button action.');
end;

function RequiredCloseButton(
  Prompt: TClosePromptKind; YesHandle, NoHandle: HWND): HWND;
begin
  case RequiredCloseChoice(Prompt) of
    ccYes: Result := YesHandle;
    ccNo: Result := NoHandle;
  else
    raise Exception.Create('The close prompt has no approved button choice.');
  end;
end;

function BuildCloseFlowJSON(
  ProcessId: DWORD; const ProfileSha256, Phase: UTF8String): UTF8String;
var
  Root: TJSONObject;
begin
  Root := TJSONObject.Create;
  try
    Root.Add('schemaVersion', TJSONIntegerNumber.Create(1));
    Root.Add('processId', TJSONInt64Number.Create(ProcessId));
    Root.Add('profileSha256', ProfileSha256);
    Root.Add('phase', Phase);
    Root.Add('expectedExitChoice', 'yes');
    Root.Add('expectedBackupChoice', 'no');
    Root.Add('forcedTermination', False);
    Result := Root.FormatJSON;
  finally
    Root.Free;
  end;
end;

function BuildNextTabStatusJSON(
  ProcessId: DWORD; const ProfileSha256, Phase: UTF8String;
  CurrentTabIndex, NextTabIndex: LongInt): UTF8String;
var
  Root: TJSONObject;
begin
  Root := TJSONObject.Create;
  try
    Root.Add('schemaVersion', TJSONIntegerNumber.Create(1));
    Root.Add('processId', TJSONInt64Number.Create(ProcessId));
    Root.Add('profileSha256', ProfileSha256);
    Root.Add('phase', Phase);
    Root.Add('currentTabIndex', TJSONIntegerNumber.Create(CurrentTabIndex));
    Root.Add('expectedNextTabIndex', TJSONIntegerNumber.Create(NextTabIndex));
    Result := Root.FormatJSON;
  finally
    Root.Free;
  end;
end;

function FindControlByHandle(
  const Profile: TWindowProfile; Handle: QWord): LongInt; forward;

procedure SendValidatedNextTabInput(
  ProcessId: DWORD; MainWindowHandle, PageControlHandle: HWND;
  const Profile: TWindowProfile);
var
  MainThreadProcessId: DWORD;
  MainThreadId: DWORD;
  FocusProcessId: DWORD;
  ForegroundProcessId: DWORD;
  CurrentThreadId: DWORD;
  ForegroundStartedAt: QWord;
  ForegroundWaitMessageShown: Boolean;
  FocusHandle: HWND;
  ForegroundHandle: HWND;
  FocusIndex: LongInt;
  ParentIndex: LongInt;
  CurrentIndex: LongInt;
  ActiveSheetFound: Boolean;
  Attached: Boolean;
  I: LongInt;
begin
  MainThreadProcessId := 0;
  MainThreadId := GetWindowThreadProcessId(
    MainWindowHandle, MainThreadProcessId);
  if (MainThreadId = 0) or (MainThreadProcessId <> ProcessId) then
    raise Exception.Create('Could not validate the main-window input thread.');

  CurrentThreadId := GetCurrentThreadId;
  Attached := False;
  if CurrentThreadId <> MainThreadId then
  begin
    Attached := AttachThreadInput(CurrentThreadId, MainThreadId, True);
    if not Attached then
      RaiseLastOSError;
  end;
  try
    SetForegroundWindow(MainWindowHandle);
    ForegroundStartedAt := GetTickCount64;
    ForegroundWaitMessageShown := False;
    ForegroundHandle := 0;
    repeat
      ForegroundHandle := GetForegroundWindow;
      ForegroundProcessId := 0;
      if ForegroundHandle <> 0 then
        GetWindowThreadProcessId(ForegroundHandle, ForegroundProcessId);
      if (ForegroundProcessId = ProcessId) and
         (ForegroundHandle = MainWindowHandle) then
        Break;
      if not ForegroundWaitMessageShown then
      begin
        WriteLn('Windows requires foreground user activation; click the approved AhnWin window within 30 seconds. No input has been sent.');
        Flush(Output);
        ForegroundWaitMessageShown := True;
      end;
      if GetTickCount64 - ForegroundStartedAt >= ForegroundWaitTimeoutMs then
        raise Exception.Create(
          'The approved process was not brought to the foreground; no keyboard input was sent.');
      Sleep(ClosePollDelayMs);
    until False;

    FocusHandle := GetFocus;
    if FocusHandle = 0 then
      raise Exception.Create(
        'The approved process has no focused child control; no key was sent.');
    FocusProcessId := 0;
    GetWindowThreadProcessId(FocusHandle, FocusProcessId);
    if FocusProcessId <> ProcessId then
      raise Exception.Create('The focused control no longer belongs to the approved PID.');
    FocusIndex := FindControlByHandle(Profile, QWord(PtrUInt(FocusHandle)));
    if FocusIndex < 0 then
      raise Exception.Create('The focused control is not in the approved metadata profile.');
    if not Profile.Controls[FocusIndex].Visible or
       not Profile.Controls[FocusIndex].Enabled then
      raise Exception.Create('The focused control is not visible and enabled.');

    ActiveSheetFound := False;
    CurrentIndex := FocusIndex;
    for I := 0 to High(Profile.Controls) do
    begin
      if Profile.Controls[CurrentIndex].ParentHandle = PageControlHandle then
      begin
        ActiveSheetFound :=
          SameText(Profile.Controls[CurrentIndex].ClassName, 'TTabSheet') and
          Profile.Controls[CurrentIndex].Visible;
        Break;
      end;
      ParentIndex := FindControlByHandle(Profile,
        Profile.Controls[CurrentIndex].ParentHandle);
      if ParentIndex < 0 then
        Break;
      CurrentIndex := ParentIndex;
    end;
    if not ActiveSheetFound then
      raise Exception.Create(
        'The keyboard focus is not inside the sole active page sheet; no key was sent.');

    if GetFocus <> FocusHandle then
    begin
      SetLastError(0);
      SetFocus(FocusHandle);
      if GetFocus <> FocusHandle then
        raise Exception.Create(
          'Windows did not restore focus to the validated active-page control.');
    end;
    SendKeyEvent(UiVirtualKeyControl, 0, 0, 0);
    try
      Sleep(25);
      SendKeyEvent(UiVirtualKeyTab, 0, 0, 0);
      Sleep(25);
      SendKeyEvent(UiVirtualKeyTab, 0, KeyEventUp, 0);
    finally
      SendKeyEvent(UiVirtualKeyControl, 0, KeyEventUp, 0);
    end;
  finally
    if Attached then
      AttachThreadInput(CurrentThreadId, MainThreadId, False);
  end;
end;

procedure RunNextTab(const Options: TOptionValueArray);
var
  ProcessId: DWORD;
  ExpectedProfilePath: string;
  OutputPath: string;
  StatusPath: string;
  ExpectedProfile: TWindowProfile;
  CurrentProfile: TWindowProfile;
  FinalProfile: TWindowProfile;
  Targets: TMainWindowTargets;
  FinalTargets: TMainWindowTargets;
  PageControlHandle: HWND;
  CurrentTabIndex: LRESULT;
  TabCount: LRESULT;
  FinalTabIndex: LRESULT;
  ExpectedNextTabIndex: LongInt;
  MessageResult: DWORD_PTR;
  StartedAt: QWord;
  ProfileSha256: string;
begin
  RequireOnlyOptions(Options, [
    '--pid', '--profile', '--allow-input', '--output']);
  if FindOption(Options, '--allow-input') <> 'true' then
    raise Exception.Create('next-tab requires the explicit --allow-input switch.');
  if not HasOption(Options, '--profile') then
    raise Exception.Create('next-tab requires a fresh metadata-only --profile.');
  ProcessId := ParseProcessId(FindOption(Options, '--pid'));
  ExpectedProfilePath := FindOption(Options, '--profile');
  OutputPath := FindOption(Options, '--output');
  ValidateOutputLocation(ExpectedProfilePath, False);
  ValidateOutputPath(OutputPath);
  StatusPath := OutputPath + '.status.json';
  ValidateOutputPath(StatusPath);
  ProfileSha256 := GetFileSha256(ExpectedProfilePath);
  ExpectedProfile := ReadProfileFile(ExpectedProfilePath);
  ValidateMetadataOnlyProfile(ExpectedProfile);
  if ExpectedProfile.ProcessId <> ProcessId then
    raise Exception.Create('The metadata profile PID does not match --pid.');
  if GetFileSha256(ExpectedProfilePath) <> ProfileSha256 then
    raise Exception.Create('The metadata profile changed while it was being read.');

  CurrentProfile := CaptureProfile(ProcessId, False);
  ValidateNextTabProfile(CurrentProfile, ExpectedProfile, Targets);
  PageControlHandle := HWND(PtrUInt(Targets.PageControlHandle));
  MessageResult := 0;
  if SendWindowMessageTimeoutW(PageControlHandle,
    TabControlGetCurrentSelection, 0, 0,
    MessageSendBlock or MessageSendAbortIfHung, WindowMessageTimeoutMs,
    MessageResult) = 0 then
    raise Exception.Create('Could not read the native tab selection.');
  CurrentTabIndex := LRESULT(MessageResult);
  MessageResult := 0;
  if SendWindowMessageTimeoutW(PageControlHandle, TabControlGetItemCount,
    0, 0, MessageSendBlock or MessageSendAbortIfHung,
    WindowMessageTimeoutMs, MessageResult) = 0 then
    raise Exception.Create('Could not read the native tab count.');
  TabCount := LRESULT(MessageResult);
  if (CurrentTabIndex < Low(LongInt)) or
     (CurrentTabIndex > High(LongInt)) or
     (TabCount < Low(LongInt)) or (TabCount > High(LongInt)) then
    raise Exception.Create('The native page-control selection/count is out of range.');
  ExpectedNextTabIndex := NextNativeTabIndex(
    LongInt(CurrentTabIndex), LongInt(TabCount));

  if GetFileSha256(ExpectedProfilePath) <> ProfileSha256 then
    raise Exception.Create('The metadata profile changed before the tab action.');

  WriteNewUTF8File(StatusPath,
    BuildNextTabStatusJSON(ProcessId, UTF8String(ProfileSha256),
      'validated-before-next-tab', LongInt(CurrentTabIndex),
      ExpectedNextTabIndex) + LineEnding);
  SendValidatedNextTabInput(ProcessId,
    HWND(PtrUInt(Targets.MainWindowHandle)), PageControlHandle,
    CurrentProfile);
  ReplaceUTF8File(StatusPath,
    BuildNextTabStatusJSON(ProcessId, UTF8String(ProfileSha256),
      'input-sent', LongInt(CurrentTabIndex),
      ExpectedNextTabIndex) + LineEnding);

  StartedAt := GetTickCount64;
  repeat
    FinalProfile := CaptureProfile(ProcessId, False);
    ValidateMetadataOnlyProfile(FinalProfile);
    ValidateNextTabProfile(FinalProfile, FinalProfile, FinalTargets);
    if (FinalTargets.MainWindowHandle <> Targets.MainWindowHandle) or
       (FinalTargets.PageControlHandle <> Targets.PageControlHandle) then
      raise Exception.Create('The main window or page-control handle changed after input.');
    MessageResult := 0;
    if SendWindowMessageTimeoutW(PageControlHandle,
      TabControlGetCurrentSelection, 0, 0,
      MessageSendBlock or MessageSendAbortIfHung, WindowMessageTimeoutMs,
      MessageResult) = 0 then
      raise Exception.Create('Could not verify the native tab selection after input.');
    FinalTabIndex := LRESULT(MessageResult);
    if FinalTabIndex = ExpectedNextTabIndex then
    begin
      if GetFileSha256(ExpectedProfilePath) <> ProfileSha256 then
        raise Exception.Create('The metadata profile changed during the tab action.');
      SaveProfile(FinalProfile, OutputPath);
      ReplaceUTF8File(StatusPath,
        BuildNextTabStatusJSON(ProcessId, UTF8String(ProfileSha256),
          'next-tab-verified', LongInt(CurrentTabIndex),
          ExpectedNextTabIndex) + LineEnding);
      WriteLn(Format('Advanced exactly one native tab for PID %d; post-action profile saved locally.',
        [ProcessId]));
      Exit;
    end;
    if FinalTabIndex <> CurrentTabIndex then
      raise Exception.Create(
        'The native tab selection changed by more than one position; no further input was sent.');
    if GetTickCount64 - StartedAt >= WindowMessageTimeoutMs then
      raise Exception.Create(
        'The native tab selection did not advance; no additional input was sent.');
    Sleep(ClosePollDelayMs);
  until False;
end;

procedure RunCloseApproved(const Options: TOptionValueArray);
var
  ProcessId: DWORD;
  ProfilePath: string;
  OutputPath: string;
  ExpectedProfile: TWindowProfile;
  CurrentProfile: TWindowProfile;
  Targets: TMainWindowTargets;
  YesHandle: HWND;
  NoHandle: HWND;
  ProcessHandle: THandle;
  ProfileSha256: string;
  ExitPromptAlreadyOpen: Boolean;
  ResumeBackup: Boolean;
begin
  RequireOnlyOptions(Options, [
    '--pid', '--profile', '--allow-close', '--resume-backup', '--output']);
  if FindOption(Options, '--allow-close') <> 'true' then
    raise Exception.Create('close requires the explicit --allow-close switch.');
  if not HasOption(Options, '--profile') then
    raise Exception.Create('close requires a fresh metadata-only --profile.');
  ProcessId := ParseProcessId(FindOption(Options, '--pid'));
  ProfilePath := FindOption(Options, '--profile');
  OutputPath := FindOption(Options, '--output');
  ResumeBackup := FindOption(Options, '--resume-backup') = 'true';
  ValidateOutputLocation(ProfilePath, False);
  ValidateOutputPath(OutputPath);
  ProfileSha256 := GetFileSha256(ProfilePath);
  ExpectedProfile := ReadProfileFile(ProfilePath);
  ValidateMetadataOnlyProfile(ExpectedProfile);
  if ExpectedProfile.ProcessId <> ProcessId then
    raise Exception.Create('The metadata profile PID does not match --pid.');
  if GetFileSha256(ProfilePath) <> ProfileSha256 then
    raise Exception.Create('The metadata profile changed while it was being read.');

  CurrentProfile := CaptureProfile(ProcessId, False);
  ValidateCloseMainWindowProfile(CurrentProfile, ExpectedProfile, Targets);
  if GetFileSha256(ProfilePath) <> ProfileSha256 then
    raise Exception.Create('The metadata profile changed before the close action.');
  ProcessHandle := OpenProcess(SYNCHRONIZE, False, ProcessId);
  if ProcessHandle = 0 then
    RaiseLastOSError;
  try
    if ResumeBackup then
    begin
      if IsWindowEnabled(HWND(PtrUInt(Targets.MainWindowHandle))) then
        raise Exception.Create(
          'The main window is enabled; refusing to resume the backup-prompt phase.');
      if not FindExpectedClosePrompt(ProcessId,
        HWND(PtrUInt(Targets.MainWindowHandle)), cpkBackup, YesHandle, NoHandle) then
        raise Exception.Create(
          'The expected backup confirmation is not open; no close input was sent.');
      WriteNewUTF8File(OutputPath,
        BuildCloseFlowJSON(ProcessId, UTF8String(ProfileSha256),
          'backup-prompt-already-open') + LineEnding);
      ClickValidatedDialogButton(RequiredCloseButton(
        cpkBackup, YesHandle, NoHandle));
      ReplaceUTF8File(OutputPath,
        BuildCloseFlowJSON(ProcessId, UTF8String(ProfileSha256),
          'backup-declined-waiting-for-exit') + LineEnding);
    end
    else
    begin
    ExitPromptAlreadyOpen := FindExpectedClosePrompt(ProcessId,
      HWND(PtrUInt(Targets.MainWindowHandle)), cpkExit, YesHandle, NoHandle);
    if not ExitPromptAlreadyOpen and
       not IsWindowEnabled(HWND(PtrUInt(Targets.MainWindowHandle))) then
      raise Exception.Create(
        'The main window is disabled without the expected exit prompt; no close input was sent.');
    WriteNewUTF8File(OutputPath,
      BuildCloseFlowJSON(ProcessId, UTF8String(ProfileSha256),
        'validated-before-window-close') + LineEnding);
    if ExitPromptAlreadyOpen then
      ReplaceUTF8File(OutputPath,
        BuildCloseFlowJSON(ProcessId, UTF8String(ProfileSha256),
          'expected-exit-prompt-already-open') + LineEnding)
    else
    begin
      CheckApprovedProcessWindow(ProcessId,
        HWND(PtrUInt(Targets.MainWindowHandle)));
      if not PostMessage(HWND(PtrUInt(Targets.MainWindowHandle)),
        CloseWindowMessage, 0, 0) then
        RaiseLastOSError;
      ReplaceUTF8File(OutputPath,
        BuildCloseFlowJSON(ProcessId, UTF8String(ProfileSha256),
          'window-close-sent') + LineEnding);
      WaitForExpectedClosePrompt(ProcessId,
        HWND(PtrUInt(Targets.MainWindowHandle)), cpkExit, YesHandle, NoHandle);
    end;
    ClickValidatedDialogButton(RequiredCloseButton(
      cpkExit, YesHandle, NoHandle));
    ReplaceUTF8File(OutputPath,
      BuildCloseFlowJSON(ProcessId, UTF8String(ProfileSha256),
        'exit-confirmation-accepted') + LineEnding);

    WaitForExpectedClosePrompt(ProcessId,
      HWND(PtrUInt(Targets.MainWindowHandle)), cpkBackup, YesHandle, NoHandle);
    ClickValidatedDialogButton(RequiredCloseButton(
      cpkBackup, YesHandle, NoHandle));
    ReplaceUTF8File(OutputPath,
      BuildCloseFlowJSON(ProcessId, UTF8String(ProfileSha256),
        'backup-declined-waiting-for-exit') + LineEnding);
    end;

    if WaitForSingleObject(ProcessHandle, MaximumCloseWaitMs) <> WAIT_OBJECT_0 then
      raise Exception.CreateFmt(
        'AhnWin PID %d did not exit within %d ms; it was not terminated.',
        [ProcessId, MaximumCloseWaitMs]);
    ReplaceUTF8File(OutputPath,
      BuildCloseFlowJSON(ProcessId, UTF8String(ProfileSha256),
        'process-exited-without-force-termination') + LineEnding);
    WriteLn(Format('AhnWin PID %d exited after Yes to close and No to backup; no forced termination was used.',
      [ProcessId]));
  finally
    CloseHandle(ProcessHandle);
  end;
end;

procedure RunInspect(const Options: TOptionValueArray);
var
  ProcessId: DWORD;
  OutputPath: string;
  Profile: TWindowProfile;
begin
  RequireOnlyOptions(Options, ['--pid', '--output']);
  ProcessId := ParseProcessId(FindOption(Options, '--pid'));
  OutputPath := FindOption(Options, '--output');
  ValidateOutputPath(OutputPath);
  Profile := CaptureProfile(ProcessId, True);
  if Length(Profile.Controls) = 0 then
    raise Exception.CreateFmt('No windows were found for process %d.', [ProcessId]);
  SaveProfile(Profile, OutputPath);
  WriteLn(Format('Profile saved for PID %d to %s',
    [ProcessId, ExpandFileName(OutputPath)]));
end;

procedure RunVerify(const Options: TOptionValueArray);
begin
  RequireOnlyOptions(Options, []);
  VerifyApprovedExecutable(ApprovedExecutablePath);
  WriteLn('Approved test executable path and SHA-256 match.');
end;

procedure RunStartAndInspect(const Options: TOptionValueArray);
var
  OutputPath: string;
  ProcessId: DWORD;
  Profile: TWindowProfile;
begin
  RequireOnlyOptions(Options, ['--output']);
  OutputPath := FindOption(Options, '--output');
  ValidateOutputPath(OutputPath);
  ProcessId := StartApprovedApplication;
  WriteLn(Format('Started the approved test application with PID %d.', [ProcessId]));
  Profile := WaitForMainWindow(ProcessId);
  SaveProfile(Profile, OutputPath);
  WriteLn(Format('Profile saved to %s', [ExpandFileName(OutputPath)]));
end;

procedure RunPrepareSearch(const Options: TOptionValueArray);
var
  ProfilePath: string;
  OutputPath: string;
  SnapshotReference: UTF8String;
  Category: TUIExperimentCategory;
  Surname: UTF8String;
  GivenName: UTF8String;
  Profile: TWindowProfile;
  Targets: TPersonSearchTargets;
  Manifest: TUIExperimentManifest;
  ManifestId: TGUID;
begin
  RequireOnlyOptions(Options, [
    '--profile', '--snapshot-reference', '--category', '--surname',
    '--given-name', '--output']);
  ProfilePath := FindOption(Options, '--profile');
  OutputPath := FindOption(Options, '--output');
  SnapshotReference := FindOption(Options, '--snapshot-reference');
  if not HasOption(Options, '--profile') or
     not HasOption(Options, '--snapshot-reference') or
     not HasOption(Options, '--category') or
     not HasOption(Options, '--surname') or
     not HasOption(Options, '--given-name') then
    raise Exception.Create(
      'prepare-search requires explicit profile, snapshot reference, category, surname, and given-name options.');
  if ProfilePath = '' then
    raise Exception.Create('A saved --profile is required.');
  ValidateOutputLocation(ProfilePath, False);
  ValidateOutputPath(OutputPath);

  Profile := ReadProfileFile(ProfilePath);
  ValidateExecutableIdentity(Profile.ExecutablePath,
    GetFileSha256(Profile.ExecutablePath));
  ValidatePersonSearchProfile(Profile, Profile, Targets);
  Category := ParseUIExperimentCategory(FindOption(Options, '--category'));
  Surname := FindOption(Options, '--surname');
  GivenName := FindOption(Options, '--given-name');
  if CreateGUID(ManifestId) <> 0 then
    raise Exception.Create('A unique experiment manifest ID could not be created.');

  Manifest := CreateUIExperimentManifest(
    UTF8String(GUIDToString(ManifestId)), SnapshotReference,
    UTF8String(ExpandFileName(ProfilePath)),
    UTF8String(GetFileSha256(ProfilePath)), Profile, Category, Surname,
    GivenName);
  WriteNewUTF8File(OutputPath,
    UIExperimentManifestToJSON(Manifest) + LineEnding);
  WriteLn(Format(
    'Prepared a non-executable search manifest for PID %d at %s',
    [Profile.ProcessId, ExpandFileName(OutputPath)]));
  WriteLn('No process was started or queried; no UI input was sent.');
end;

procedure RequireSameTargetProcess(
  const Profile: TWindowProfile; ProcessId: DWORD);
begin
  if Profile.ProcessId <> ProcessId then
    raise EUIProfileError.Create('The profile PID does not match --pid.');
  ValidateExecutableIdentity(Profile.ExecutablePath, GetFileSha256(Profile.ExecutablePath));
end;

procedure SetWindowTextSafely(WindowHandle: HWND; const Value: UTF8String);
var
  WideValue: UnicodeString;
  I: LongInt;
  MessageResult: DWORD_PTR;
  MessageStatus: LRESULT;
begin
  if Length(Value) > MaximumCapturedText then
    raise Exception.CreateFmt('Search input exceeds the %d-character safety limit.',
      [MaximumCapturedText]);
  for I := 1 to Length(Value) do
    if (Ord(Value[I]) < 32) or (Value[I] = #127) then
      raise Exception.Create('Search input cannot contain control characters.');
  WideValue := UTF8ToWide(Value);
  MessageResult := 0;
  MessageStatus := SendWindowMessageTimeoutW(WindowHandle, WM_SETTEXT, 0,
    LPARAM(PWideChar(WideValue)), SMTO_ABORTIFHUNG or SMTO_BLOCK,
    WindowMessageTimeoutMs, MessageResult);
  if MessageStatus = 0 then
    RaiseLastOSError;
  if MessageResult = 0 then
    raise Exception.Create('The target edit control rejected WM_SETTEXT.');
end;

function GetWindowTextSafely(WindowHandle: HWND): UTF8String;
var
  TextLength: DWORD_PTR;
  MessageResult: DWORD_PTR;
  MessageStatus: LRESULT;
  Buffer: array of WideChar;
  WideText: UnicodeString;
begin
  MessageResult := 0;
  MessageStatus := SendWindowMessageTimeoutW(WindowHandle, WM_GETTEXTLENGTH,
    0, 0, SMTO_ABORTIFHUNG or SMTO_BLOCK, WindowMessageTimeoutMs, MessageResult);
  if MessageStatus = 0 then
    raise Exception.CreateFmt('WM_GETTEXTLENGTH failed or timed out (Win32 error %d).',
      [GetLastError]);
  TextLength := MessageResult;
  if TextLength > MaximumCapturedText then
    raise Exception.Create('A search edit value exceeds the safety limit.');
  SetLength(Buffer, TextLength + 1);
  MessageResult := 0;
  MessageStatus := SendWindowMessageTimeoutW(WindowHandle, WM_GETTEXT,
    Length(Buffer), LPARAM(@Buffer[0]), SMTO_ABORTIFHUNG or SMTO_BLOCK,
    WindowMessageTimeoutMs, MessageResult);
  if MessageStatus = 0 then
    raise Exception.CreateFmt('WM_GETTEXT failed or timed out (Win32 error %d).',
      [GetLastError]);
  if MessageResult > TextLength then
    MessageResult := TextLength;
  SetString(WideText, PWideChar(@Buffer[0]), MessageResult);
  Result := WideToUTF8(WideText);
end;

function ParseFieldHandles(const Value: UTF8String): TUIHandleArray;
var
  Parts: TStringList;
  I: LongInt;
  ParsedHandle: QWord;
  Part: string;
begin
  Result := nil;
  Parts := TStringList.Create;
  try
    Parts.StrictDelimiter := True;
    Parts.Delimiter := ',';
    Parts.DelimitedText := string(Value);
    if (Parts.Count = 0) or (Parts.Count > 16) then
      raise Exception.Create('Select between 1 and 16 field handles.');
    SetLength(Result, Parts.Count);
    for I := 0 to Parts.Count - 1 do
    begin
      Part := Trim(Parts[I]);
      if (Length(Part) > 2) and (Copy(Part, 1, 2) = '0x') then
        Part := '$' + Copy(Part, 3, MaxInt);
      if (Part = '') or not TryStrToQWord(Part, ParsedHandle) or
         (ParsedHandle = 0) or (PtrUInt(ParsedHandle) <> ParsedHandle) then
        raise Exception.CreateFmt('Invalid window handle "%s".', [Parts[I]]);
      Result[I] := ParsedHandle;
    end;
  finally
    Parts.Free;
  end;
end;

function FindControlByHandle(
  const Profile: TWindowProfile; Handle: QWord): LongInt;
var
  I: LongInt;
begin
  for I := 0 to High(Profile.Controls) do
    if Profile.Controls[I].Handle = Handle then
      Exit(I);
  Result := -1;
end;

procedure ValidateLiveFieldHandle(WindowHandle: HWND;
  const Control: TUIControlInfo; ProcessId: DWORD);
var
  ActualProcessId: DWORD;
begin
  if not IsWindow(WindowHandle) or not IsWindowVisible(WindowHandle) then
    raise Exception.Create('A selected field window is no longer visible.');
  if GetWindowThreadProcessId(WindowHandle, ActualProcessId) = 0 then
    RaiseLastOSError;
  if ActualProcessId <> ProcessId then
    raise Exception.Create('A selected field no longer belongs to the target process.');
  if not SameText(GetWindowClass(WindowHandle), Control.ClassName) then
    raise Exception.Create('A selected field window class changed after validation.');
  if QWord(PtrUInt(GetParent(WindowHandle))) <> Control.ParentHandle then
    raise Exception.Create('A selected field parent changed after validation.');
  if GetDlgCtrlID(WindowHandle) <> Control.ControlId then
    raise Exception.Create('A selected field control ID changed after validation.');
  if IsPasswordEdit(WindowHandle) then
    raise Exception.Create('Password controls cannot be read.');
end;

function BuildFieldReadJSON(const Profile: TWindowProfile;
  const ProfileSha256: string; const Handles: TUIHandleArray;
  const Values: TUIFieldValueArray): UTF8String;
var
  Root: TJSONObject;
  Fields: TJSONArray;
  Field: TJSONObject;
  Index: LongInt;
  ControlIndex: LongInt;
begin
  Root := TJSONObject.Create;
  try
    Root.Add('schemaVersion', TJSONIntegerNumber.Create(1));
    Root.Add('processId', TJSONInt64Number.Create(Profile.ProcessId));
    Root.Add('profileSha256', ProfileSha256);
    Fields := TJSONArray.Create;
    for Index := 0 to High(Handles) do
    begin
      ControlIndex := FindControlByHandle(Profile, Handles[Index]);
      if ControlIndex < 0 then
        raise Exception.Create('A field disappeared before result serialization.');
      Field := TJSONObject.Create;
      Field.Add('handle', TJSONInt64Number.Create(Int64(Handles[Index])));
      Field.Add('parentHandle', TJSONInt64Number.Create(
        Int64(Profile.Controls[ControlIndex].ParentHandle)));
      Field.Add('controlId', TJSONIntegerNumber.Create(
        Profile.Controls[ControlIndex].ControlId));
      Field.Add('class', Profile.Controls[ControlIndex].ClassName);
      Field.Add('value', Values[Index]);
      Fields.Add(Field);
    end;
    Root.Add('fields', Fields);
    Result := Root.FormatJSON;
  finally
    Root.Free;
  end;
end;

procedure RunInspectMetadata(const Options: TOptionValueArray);
var
  ProcessId: DWORD;
  OutputPath: string;
  Profile: TWindowProfile;
begin
  RequireOnlyOptions(Options, ['--pid', '--output']);
  ProcessId := ParseProcessId(FindOption(Options, '--pid'));
  OutputPath := FindOption(Options, '--output');
  ValidateOutputPath(OutputPath);
  Profile := CaptureProfile(ProcessId, False);
  ValidateMetadataOnlyProfile(Profile);
  SaveProfile(Profile, OutputPath);
  WriteLn(Format('Metadata-only profile saved for PID %d to %s; no control text was read.',
    [ProcessId, ExpandFileName(OutputPath)]));
end;

procedure RunReadFields(const Options: TOptionValueArray);
var
  ProcessId: DWORD;
  ProfilePath: string;
  OutputPath: string;
  HandlesText: UTF8String;
  Handles: TUIHandleArray;
  Values: TUIFieldValueArray;
  ExpectedProfile: TWindowProfile;
  CurrentProfile: TWindowProfile;
  FinalProfile: TWindowProfile;
  ProfileSha256: string;
  ControlIndex: LongInt;
  Index: LongInt;
  WindowHandle: HWND;
begin
  RequireOnlyOptions(Options, [
    '--pid', '--profile', '--handles', '--allow-read', '--output']);
  if FindOption(Options, '--allow-read') <> 'true' then
    raise Exception.Create(
      'read-fields requires the explicit --allow-read switch.');
  if not HasOption(Options, '--profile') or
     not HasOption(Options, '--handles') then
    raise Exception.Create(
      'read-fields requires an explicit metadata --profile and --handles list.');
  ProcessId := ParseProcessId(FindOption(Options, '--pid'));
  ProfilePath := FindOption(Options, '--profile');
  HandlesText := FindOption(Options, '--handles');
  OutputPath := FindOption(Options, '--output');
  ValidateOutputLocation(ProfilePath, False);
  ValidateOutputPath(OutputPath);
  Handles := ParseFieldHandles(HandlesText);
  ProfileSha256 := GetFileSha256(ProfilePath);
  ExpectedProfile := ReadProfileFile(ProfilePath);
  ValidateMetadataOnlyProfile(ExpectedProfile);
  if ExpectedProfile.ProcessId <> ProcessId then
    raise Exception.Create('The metadata profile PID does not match --pid.');
  ValidateExecutableIdentity(ExpectedProfile.ExecutablePath,
    GetFileSha256(ExpectedProfile.ExecutablePath));
  if GetFileSha256(ProfilePath) <> ProfileSha256 then
    raise Exception.Create('The metadata profile changed while it was being read.');

  CurrentProfile := CaptureProfile(ProcessId, False);
  ValidateReadableFieldTargets(CurrentProfile, ExpectedProfile, Handles);
  SetLength(Values, Length(Handles));
  for Index := 0 to High(Handles) do
  begin
    ControlIndex := FindControlByHandle(CurrentProfile, Handles[Index]);
    if ControlIndex < 0 then
      raise Exception.Create('A selected field disappeared before it was read.');
    WindowHandle := HWND(PtrUInt(Handles[Index]));
    ValidateLiveFieldHandle(WindowHandle,
      CurrentProfile.Controls[ControlIndex], ProcessId);
    Values[Index] := GetVisibleWindowText(WindowHandle);
    ValidateLiveFieldHandle(WindowHandle,
      CurrentProfile.Controls[ControlIndex], ProcessId);
  end;

  FinalProfile := CaptureProfile(ProcessId, False);
  ValidateReadableFieldTargets(FinalProfile, ExpectedProfile, Handles);
  if GetFileSha256(ProfilePath) <> ProfileSha256 then
    raise Exception.Create('The metadata profile changed during the field read.');
  WriteNewUTF8File(OutputPath,
    BuildFieldReadJSON(FinalProfile, ProfileSha256, Handles, Values) +
    LineEnding);
  WriteLn(Format('Read %d explicitly selected visible field control(s) for PID %d; values saved locally to %s.',
    [Length(Handles), ProcessId, ExpandFileName(OutputPath)]));
end;

procedure FocusValidatedEdit(DialogHandle, EditHandle: HWND);
var
  DialogThreadId: DWORD;
  CurrentThreadId: DWORD;
  WindowProcessId: DWORD;
  Attached: Boolean;
  PreviousFocus: HWND;
begin
  WindowProcessId := 0;
  DialogThreadId := GetWindowThreadProcessId(DialogHandle, WindowProcessId);
  CurrentThreadId := GetCurrentThreadId;
  if (DialogThreadId = 0) or (WindowProcessId = 0) then
    raise Exception.Create('Could not identify the person-search UI thread.');
  Attached := AttachThreadInput(CurrentThreadId, DialogThreadId, True);
  if not Attached then
    RaiseLastOSError;
  try
    if not SetForegroundWindow(DialogHandle) then
      raise Exception.Create('Windows refused to foreground the person-search dialog.');
    SetLastError(0);
    PreviousFocus := SetFocus(EditHandle);
    if (PreviousFocus = 0) and (GetLastError <> 0) then
      RaiseLastOSError;
    if GetFocus <> EditHandle then
      raise Exception.Create('Windows did not focus the validated person-search edit control.');
  finally
    AttachThreadInput(CurrentThreadId, DialogThreadId, False);
  end;
end;

function BuildSearchStatusJSON(
  const Profile: TWindowProfile;
  const Surname, GivenName, PreviousSurname, PreviousGivenName,
    Phase: UTF8String): UTF8String;
var
  RootObject: TJSONObject;
  SearchObject: TJSONObject;
  ProfileData: TJSONData;
  PreviousInputObject: TJSONObject;
  Observation: TUIVisibleObservation;
  ActionStatus: TUIActionStatus;
begin
  RootObject := TJSONObject.Create;
  try
    RootObject.Add('schemaVersion', TJSONIntegerNumber.Create(2));
    RootObject.Add('resultSchemaVersion', TJSONIntegerNumber.Create(2));
    RootObject.Add('processId', TJSONInt64Number.Create(Profile.ProcessId));
    RootObject.Add('phase', Phase);
    ActionStatus := CaptureUIActionStatus(Phase);
    RootObject.Add('action', GetJSON(UIActionStatusToJSON(ActionStatus)));
    SearchObject := TJSONObject.Create;
    SearchObject.Add('surname', Surname);
    SearchObject.Add('givenName', GivenName);
    if (Phase = 'about-to-trigger-search-on-edit2-exit') or
       (Phase = 'search-not-triggered-dialog-still-open') or
       (Phase = 'search-triggered-by-edit2-exit-dialog-closed') then
      SearchObject.Add('trigger', 'Edit2Exit->Button1Click');
    if Phase = 'button-click-sent' then
      SearchObject.Add('buttonClickStatus', 'sent')
    else if Phase = 'about-to-click-search' then
      SearchObject.Add('buttonClickStatus', 'outcome-unknown-until-post-profile')
    else
      SearchObject.Add('buttonClickStatus', 'not-sent');
    if Phase = 'about-to-trigger-search-on-edit2-exit' then
      SearchObject.Add('searchTriggerStatus', 'pending')
    else if Phase = 'search-not-triggered-dialog-still-open' then
      SearchObject.Add('searchTriggerStatus', 'dialog-remains-open')
    else if Phase = 'search-triggered-by-edit2-exit-dialog-closed' then
      SearchObject.Add('searchTriggerStatus', 'dialog-closed');
    RootObject.Add('search', SearchObject);
    PreviousInputObject := TJSONObject.Create;
    PreviousInputObject.Add('surname', PreviousSurname);
    PreviousInputObject.Add('givenName', PreviousGivenName);
    RootObject.Add('preSearchValues', PreviousInputObject);
    Observation := CaptureVisibleObservation(Profile);
    RootObject.Add('observation',
      GetJSON(UIVisibleObservationToJSON(Observation)));
    ProfileData := GetJSON(ProfileToJSON(Profile));
    RootObject.Add('visibleProfile', ProfileData);
    Result := RootObject.FormatJSON;
  finally
    RootObject.Free;
  end;
end;

procedure RunPersonSearch(const Options: TOptionValueArray);
var
  ProcessId: DWORD;
  ExpectedProfilePath: string;
  OutputPath: string;
  Surname: UTF8String;
  GivenName: UTF8String;
  WaitForDialog: Boolean;
  ExpectedProfile: TWindowProfile;
  CurrentProfile: TWindowProfile;
  PostActionProfile: TWindowProfile;
  Targets: TPersonSearchTargets;
  NameTextBefore: UTF8String;
  GivenTextBefore: UTF8String;
  NameTextAfter: UTF8String;
  GivenTextAfter: UTF8String;
  ProgressJSON: UTF8String;
begin
  RequireOnlyOptions(Options, [
    '--pid', '--profile', '--output', '--surname', '--given-name',
    '--allow-input', '--dry-run', '--wait-for-dialog']);
  if FindOption(Options, '--allow-input') <> 'true' then
    raise Exception.Create('person-search requires the explicit --allow-input switch.');

  ProcessId := ParseProcessId(FindOption(Options, '--pid'));
  ExpectedProfilePath := FindOption(Options, '--profile');
  OutputPath := FindOption(Options, '--output');
  if not HasOption(Options, '--surname') or not HasOption(Options, '--given-name') then
    raise Exception.Create('Both --surname and --given-name must be provided explicitly.');
  Surname := FindOption(Options, '--surname');
  GivenName := FindOption(Options, '--given-name');
  if ExpectedProfilePath = '' then
    raise Exception.Create('An --profile captured from the same running process is required.');
  if (Surname = '') and (GivenName = '') then
    raise Exception.Create('At least one of --surname or --given-name must be non-empty.');
  ValidateOutputPath(OutputPath);

  ExpectedProfile := ReadProfileFile(ExpectedProfilePath);
  RequireSameTargetProcess(ExpectedProfile, ProcessId);
  WaitForDialog := HasOption(Options, '--wait-for-dialog');
  if WaitForDialog then
  begin
    if not WaitForPersonSearchDialog(ProcessId, ExpectedProfile, Targets,
      CurrentProfile) then
    begin
      ProgressJSON := BuildSearchStatusJSON(CurrentProfile, Surname,
        GivenName, '', '', 'timeout-waiting-for-dialog');
      WriteNewUTF8File(OutputPath, ProgressJSON + LineEnding);
      raise Exception.CreateFmt(
        'The visible person-search dialog did not appear within %d ms; no input was sent.',
        [SearchDialogWaitTimeoutMs]);
    end;
  end
  else
  begin
    CurrentProfile := CaptureProfile(ProcessId, True);
    ValidatePersonSearchProfile(CurrentProfile, ExpectedProfile, Targets);
  end;

  NameTextBefore := GetWindowTextSafely(HWND(Targets.NameEditHandle));
  GivenTextBefore := GetWindowTextSafely(HWND(Targets.GivenNameEditHandle));
  if FindOption(Options, '--dry-run') = 'true' then
  begin
    WriteLn('DRY RUN: profile validated; no input messages were sent.');
    WriteLn(Format('Surname edit currently contains %d visible characters.',
      [Length(NameTextBefore)]));
    WriteLn(Format('Given-name edit currently contains %d visible characters.',
      [Length(GivenTextBefore)]));
    Exit;
  end;

  ProgressJSON := BuildSearchStatusJSON(CurrentProfile, Surname, GivenName,
    NameTextBefore, GivenTextBefore, 'validated-no-input');
  WriteNewUTF8File(OutputPath, ProgressJSON + LineEnding);

  ProgressJSON := BuildSearchStatusJSON(CurrentProfile, Surname, GivenName,
    NameTextBefore, GivenTextBefore, 'about-to-set-surname');
  ReplaceUTF8File(OutputPath, ProgressJSON + LineEnding);
  FocusValidatedEdit(HWND(Targets.DialogHandle), HWND(Targets.NameEditHandle));
  CurrentProfile := CaptureProfile(ProcessId, True);
  ValidatePersonSearchProfile(CurrentProfile, ExpectedProfile, Targets);
  SetWindowTextSafely(HWND(Targets.NameEditHandle), Surname);

  CurrentProfile := CaptureProfile(ProcessId, True);
  ValidatePersonSearchProfile(CurrentProfile, ExpectedProfile, Targets);
  if GetWindowTextSafely(HWND(Targets.NameEditHandle)) <> Surname then
    raise Exception.Create('Surname text changed after profile revalidation; search was not clicked.');
  ProgressJSON := BuildSearchStatusJSON(CurrentProfile, Surname, GivenName,
    NameTextBefore, GivenTextBefore, 'surname-set');
  ReplaceUTF8File(OutputPath, ProgressJSON + LineEnding);

  ProgressJSON := BuildSearchStatusJSON(CurrentProfile, Surname, GivenName,
    NameTextBefore, GivenTextBefore, 'about-to-set-given-name');
  ReplaceUTF8File(OutputPath, ProgressJSON + LineEnding);
  FocusValidatedEdit(HWND(Targets.DialogHandle), HWND(Targets.GivenNameEditHandle));
  CurrentProfile := CaptureProfile(ProcessId, True);
  ValidatePersonSearchProfile(CurrentProfile, ExpectedProfile, Targets);
  SetWindowTextSafely(HWND(Targets.GivenNameEditHandle), GivenName);

  CurrentProfile := CaptureProfile(ProcessId, True);
  ValidatePersonSearchProfile(CurrentProfile, ExpectedProfile, Targets);
  NameTextAfter := GetWindowTextSafely(HWND(Targets.NameEditHandle));
  GivenTextAfter := GetWindowTextSafely(HWND(Targets.GivenNameEditHandle));
  if NameTextAfter <> Surname then
    raise Exception.Create('Surname text readback did not match; search was not clicked.');
  if GivenTextAfter <> GivenName then
    raise Exception.Create('Given-name text readback did not match; search was not clicked.');

  ProgressJSON := BuildSearchStatusJSON(CurrentProfile, Surname, GivenName,
    NameTextBefore, GivenTextBefore, 'given-name-set');
  ReplaceUTF8File(OutputPath, ProgressJSON + LineEnding);
  ProgressJSON := BuildSearchStatusJSON(CurrentProfile, Surname, GivenName,
    NameTextBefore, GivenTextBefore, 'about-to-trigger-search-on-edit2-exit');
  ReplaceUTF8File(OutputPath, ProgressJSON + LineEnding);
  { Leaving Edit2 invokes its DFM-bound OnExit handler, which calls Button1Click. }
  FocusValidatedEdit(HWND(Targets.DialogHandle), HWND(Targets.NameEditHandle));
  PostActionProfile := CaptureProfile(ProcessId, True);
  if HasVisiblePersonSearchDialog(PostActionProfile) then
  begin
    ProgressJSON := BuildSearchStatusJSON(PostActionProfile, Surname, GivenName,
      NameTextBefore, GivenTextBefore, 'search-not-triggered-dialog-still-open');
    ReplaceUTF8File(OutputPath, ProgressJSON + LineEnding);
    raise Exception.Create(
      'The search dialog remained open after leaving the given-name edit; no button click was sent.');
  end;
  ProgressJSON := BuildSearchStatusJSON(PostActionProfile, Surname, GivenName,
    NameTextBefore, GivenTextBefore, 'search-triggered-by-edit2-exit-dialog-closed');
  ReplaceUTF8File(OutputPath, ProgressJSON + LineEnding);
  WriteLn(Format('The Edit2Exit handler closed the dialog; post-action profile saved to %s',
    [ExpandFileName(OutputPath)]));
end;

procedure PrintUsage;
begin
  WriteLn('AHW52UIAutomation - external UI automation for the approved test instance');
  WriteLn('  verify');
  WriteLn('  inspect --pid PID --output PROFILE.json');
  WriteLn('  inspect-metadata --pid PID --output METADATA.json');
  WriteLn('  read-fields --pid PID --profile METADATA.json');
  WriteLn('      --handles HWND[,HWND...] --allow-read --output FIELDS.json');
  WriteLn('  next-tab --pid PID --profile METADATA.json --allow-input --output PROFILE.json');
  WriteLn('  close --pid PID --profile METADATA.json --allow-close [--resume-backup] --output RESULT.json');
  WriteLn('  start-and-inspect --output PROFILE.json');
  WriteLn('  prepare-search --profile PROFILE.json --snapshot-reference ID');
  WriteLn('      --category known-hit|surname-only-prefix|absent-surname|absent-given-name');
  WriteLn('      --surname TEXT --given-name TEXT --output MANIFEST.json');
  WriteLn('  person-search --pid PID --profile PROFILE.json --surname TEXT');
  WriteLn('      --given-name TEXT --allow-input [--dry-run]');
  WriteLn('      [--wait-for-dialog] --output RESULT.json');
  WriteLn('prepare-search only creates a manifest; it does not start AhnWin or send input.');
  WriteLn('Profiles/results must be written outside C:\ProgramData\AHNENWIN Test.');
end;

function GetArguments: TWideStringArray;
var
  I: LongInt;
  ArgumentCount: LongInt;
  WideArguments: PWideArgv;
begin
  Result := nil;
  ArgumentCount := 0;
  WideArguments := SplitWindowsCommandLine(GetWindowsCommandLine, @ArgumentCount);
  if WideArguments = nil then
    RaiseLastOSError;
  try
    if ArgumentCount > 1 then
    begin
      SetLength(Result, ArgumentCount - 1);
      for I := 1 to ArgumentCount - 1 do
        Result[I - 1] := UnicodeString(WideArguments^[I]);
    end;
  finally
    FreeWindowsLocalMemory(HLOCAL(WideArguments));
  end;
end;

var
  Arguments: TWideStringArray;
  Options: TOptionValueArray;
  CommandName: UTF8String;
begin
  try
    Arguments := GetArguments;
    if Length(Arguments) = 0 then
    begin
      PrintUsage;
      Halt(2);
    end;
    CommandName := WideToUTF8(Arguments[0]);
    Options := ParseOptions(Arguments, 1);

    if CommandName = 'verify' then
      RunVerify(Options)
    else if CommandName = 'inspect' then
      RunInspect(Options)
    else if CommandName = 'inspect-metadata' then
      RunInspectMetadata(Options)
    else if CommandName = 'read-fields' then
      RunReadFields(Options)
    else if CommandName = 'next-tab' then
      RunNextTab(Options)
    else if CommandName = 'close' then
      RunCloseApproved(Options)
    else if CommandName = 'start-and-inspect' then
      RunStartAndInspect(Options)
    else if CommandName = 'prepare-search' then
      RunPrepareSearch(Options)
    else if CommandName = 'person-search' then
      RunPersonSearch(Options)
    else
    begin
      PrintUsage;
      raise Exception.CreateFmt('Unknown command: %s', [CommandName]);
    end;
  except
    on E: Exception do
    begin
      WriteLn(StdErr, 'ERROR: ', E.Message);
      Halt(1);
    end;
  end;
end.
