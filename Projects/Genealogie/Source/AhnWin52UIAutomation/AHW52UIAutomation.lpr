program AHW52UIAutomation;

{$mode objfpc}{$H+}
{$codepage utf8}

uses
  Classes, fpjson, jsonparser, SysUtils, Windows, AHW52UIProfile;

const
  ApprovedExecutablePath = 'C:\ProgramData\AHNENWIN Test\AHNWIN51.exe';
  ApprovedExecutableSha256 =
    '817C1B1BB23469CD628C52E4A5EA26CB4DB26275B5EC84952717B218605F0AFF';
  ApprovedDataDirectory = 'C:\ProgramData\AHNENWIN Test';
  ApprovedOutputDirectory =
    'C:\Users\Mir\.copilot\session-state\bc780dc9-be21-4e10-b7a2-0aab27abfe2f\files\ahnwin-ui-profiles';
  MaximumCapturedText = 4096;
  WindowMessageTimeoutMs = 5000;
  SearchActionTimeoutMs = 30000;
  StartupTimeoutMs = 30000;
  CryptoProviderRsaAes = 24;
  CryptoVerifyContext = $F0000000;
  CryptoAlgorithmSha256 = $0000800C;
  CryptoHashValue = $0002;
  MoveFileWriteThroughFlag = $00000008;

type
  THashProvider = PtrUInt;
  PHashProvider = ^THashProvider;
  THashHandle = PtrUInt;
  PHashHandle = ^THashHandle;
  TByteBuffer = array[0..4095] of Byte;
  TWindowEnumContext = record
    Profile: ^TWindowProfile;
    ErrorText: string;
  end;
  PWindowEnumContext = ^TWindowEnumContext;
  TWideStringArray = array of UnicodeString;
  TOptionValue = record
    Name: UTF8String;
    Value: UTF8String;
  end;
  TOptionValueArray = array of TOptionValue;
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

function IsPasswordEdit(WindowHandle: HWND): Boolean;
var
  WindowStyle: LONG_PTR;
begin
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
  if Control.Visible and not Control.IsPassword then
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
      Context^.ErrorText := E.Message;
      Result := False;
    end;
  end;
end;

function EnumerateTopLevelWindow(
  WindowHandle: HWND; Parameter: LPARAM): BOOL; stdcall;
var
  Context: PWindowEnumContext;
    WindowProcessId: DWORD;
  begin
    Context := PWindowEnumContext(Parameter);
    try
      WindowProcessId := 0;
      if GetWindowThreadProcessId(WindowHandle, WindowProcessId) <> 0 then
      begin
        if WindowProcessId = Context^.Profile^.ProcessId then
          AppendWindow(WindowHandle, Context);
        if (Context^.ErrorText = '') and (WindowProcessId = Context^.Profile^.ProcessId) and
           not EnumChildWindows(WindowHandle, @EnumerateChildWindow, Parameter) then
          Context^.ErrorText := 'Child-window enumeration failed.';
    end;
    Result := Context^.ErrorText = '';
  except
    on E: Exception do
    begin
      Context^.ErrorText := E.Message;
      Result := False;
    end;
  end;
end;

function CaptureProfile(ProcessId: DWORD): TWindowProfile;
var
  Context: TWindowEnumContext;
begin
  Result.ProcessId := ProcessId;
  Result.ExecutablePath := QueryProcessPath(ProcessId);
  ValidateExecutableIdentity(Result.ExecutablePath, GetFileSha256(Result.ExecutablePath));
  Result.ExecutableSha256 := ApprovedExecutableSha256;
  Result.Controls := nil;

  Context.Profile := @Result;
  Context.ErrorText := '';
  if not EnumWindows(@EnumerateTopLevelWindow, LPARAM(@Context)) then
  begin
    if Context.ErrorText <> '' then
      raise Exception.Create(Context.ErrorText);
    raise Exception.Create('Top-level window enumeration failed.');
  end;

  if Length(Result.Controls) = 0 then
    raise Exception.CreateFmt('No windows were found for process %d.', [ProcessId]);
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
    DeleteOutputFile(PWideChar(TemporaryWideName));
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
    if (Arguments[I] = '--allow-input') or (Arguments[I] = '--dry-run') then
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
      Result := CaptureProfile(ProcessId);
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

procedure SaveProfile(const Profile: TWindowProfile; const OutputPath: string);
begin
  WriteNewUTF8File(OutputPath, ProfileToJSON(Profile) + LineEnding);
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
  Profile := CaptureProfile(ProcessId);
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

procedure ClickValidatedSearchButton(ButtonHandle: HWND);
var
  MessageResult: DWORD_PTR;
  MessageStatus: LRESULT;
begin
  MessageResult := 0;
  MessageStatus := SendWindowMessageTimeoutW(ButtonHandle, BM_CLICK, 0, 0,
    SMTO_ABORTIFHUNG or SMTO_BLOCK, SearchActionTimeoutMs, MessageResult);
  if MessageStatus = 0 then
    raise Exception.CreateFmt('BM_CLICK failed or timed out (Win32 error %d).',
      [GetLastError]);
end;

function BuildSearchStatusJSON(
  const Profile: TWindowProfile;
  const Surname, GivenName, PreviousSurname, PreviousGivenName,
    Phase: UTF8String; ButtonClickSent: Boolean): UTF8String;
var
  RootObject: TJSONObject;
  SearchObject: TJSONObject;
  ProfileData: TJSONData;
  PreviousInputObject: TJSONObject;
begin
  RootObject := TJSONObject.Create;
  try
    RootObject.Add('schemaVersion', TJSONIntegerNumber.Create(1));
    RootObject.Add('processId', TJSONInt64Number.Create(Profile.ProcessId));
    RootObject.Add('phase', Phase);
    SearchObject := TJSONObject.Create;
    SearchObject.Add('surname', Surname);
    SearchObject.Add('givenName', GivenName);
    SearchObject.Add('buttonClickSent', TJSONBoolean.Create(ButtonClickSent));
    RootObject.Add('search', SearchObject);
    PreviousInputObject := TJSONObject.Create;
    PreviousInputObject.Add('surname', PreviousSurname);
    PreviousInputObject.Add('givenName', PreviousGivenName);
    RootObject.Add('preSearchValues', PreviousInputObject);
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
  ExpectedProfile: TWindowProfile;
  CurrentProfile: TWindowProfile;
  PostActionProfile: TWindowProfile;
  Targets: TPersonSearchTargets;
  NameTextBefore: UTF8String;
  GivenTextBefore: UTF8String;
  NameTextAfter: UTF8String;
  GivenTextAfter: UTF8String;
  OriginalTargets: TPersonSearchTargets;
  ProgressJSON: UTF8String;
begin
  RequireOnlyOptions(Options, [
    '--pid', '--profile', '--output', '--surname', '--given-name',
    '--allow-input', '--dry-run']);
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
  CurrentProfile := CaptureProfile(ProcessId);
  ValidatePersonSearchProfile(CurrentProfile, ExpectedProfile, Targets);

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
    NameTextBefore, GivenTextBefore, 'validated-no-input', False);
  WriteNewUTF8File(OutputPath, ProgressJSON + LineEnding);

  ProgressJSON := BuildSearchStatusJSON(CurrentProfile, Surname, GivenName,
    NameTextBefore, GivenTextBefore, 'about-to-set-surname', False);
  ReplaceUTF8File(OutputPath, ProgressJSON + LineEnding);
  FocusValidatedEdit(HWND(Targets.DialogHandle), HWND(Targets.NameEditHandle));
  CurrentProfile := CaptureProfile(ProcessId);
  ValidatePersonSearchProfile(CurrentProfile, ExpectedProfile, Targets);
  SetWindowTextSafely(HWND(Targets.NameEditHandle), Surname);

  CurrentProfile := CaptureProfile(ProcessId);
  ValidatePersonSearchProfile(CurrentProfile, ExpectedProfile, Targets);
  if GetWindowTextSafely(HWND(Targets.NameEditHandle)) <> Surname then
    raise Exception.Create('Surname text changed after profile revalidation; search was not clicked.');
  ProgressJSON := BuildSearchStatusJSON(CurrentProfile, Surname, GivenName,
    NameTextBefore, GivenTextBefore, 'surname-set', False);
  ReplaceUTF8File(OutputPath, ProgressJSON + LineEnding);

  ProgressJSON := BuildSearchStatusJSON(CurrentProfile, Surname, GivenName,
    NameTextBefore, GivenTextBefore, 'about-to-set-given-name', False);
  ReplaceUTF8File(OutputPath, ProgressJSON + LineEnding);
  FocusValidatedEdit(HWND(Targets.DialogHandle), HWND(Targets.GivenNameEditHandle));
  CurrentProfile := CaptureProfile(ProcessId);
  ValidatePersonSearchProfile(CurrentProfile, ExpectedProfile, Targets);
  SetWindowTextSafely(HWND(Targets.GivenNameEditHandle), GivenName);

  CurrentProfile := CaptureProfile(ProcessId);
  ValidatePersonSearchProfile(CurrentProfile, ExpectedProfile, Targets);
  NameTextAfter := GetWindowTextSafely(HWND(Targets.NameEditHandle));
  GivenTextAfter := GetWindowTextSafely(HWND(Targets.GivenNameEditHandle));
  if NameTextAfter <> Surname then
    raise Exception.Create('Surname text readback did not match; search was not clicked.');
  if GivenTextAfter <> GivenName then
    raise Exception.Create('Given-name text readback did not match; search was not clicked.');

  OriginalTargets := Targets;
  ProgressJSON := BuildSearchStatusJSON(CurrentProfile, Surname, GivenName,
    NameTextBefore, GivenTextBefore, 'given-name-set', False);
  ReplaceUTF8File(OutputPath, ProgressJSON + LineEnding);
  ProgressJSON := BuildSearchStatusJSON(CurrentProfile, Surname, GivenName,
    NameTextBefore, GivenTextBefore, 'about-to-focus-search', False);
  ReplaceUTF8File(OutputPath, ProgressJSON + LineEnding);
  FocusValidatedEdit(HWND(Targets.DialogHandle), HWND(Targets.NameEditHandle));
  CurrentProfile := CaptureProfile(ProcessId);
  ValidatePersonSearchProfile(CurrentProfile, ExpectedProfile, Targets);
  if (Targets.SearchButtonHandle <> OriginalTargets.SearchButtonHandle) or
     (Targets.DialogHandle <> OriginalTargets.DialogHandle) then
    raise Exception.Create('The UI changed immediately before the search click.');
  ProgressJSON := BuildSearchStatusJSON(CurrentProfile, Surname, GivenName,
    NameTextBefore, GivenTextBefore, 'about-to-click-search', False);
  ReplaceUTF8File(OutputPath, ProgressJSON + LineEnding);
  ClickValidatedSearchButton(HWND(Targets.SearchButtonHandle));
  Sleep(750);
  PostActionProfile := CaptureProfile(ProcessId);
  ProgressJSON := BuildSearchStatusJSON(PostActionProfile, Surname, GivenName,
    NameTextBefore, GivenTextBefore, 'button-click-sent', True);
  ReplaceUTF8File(OutputPath, ProgressJSON + LineEnding);
  WriteLn(Format('Search click sent; post-action profile saved to %s',
    [ExpandFileName(OutputPath)]));
end;

procedure PrintUsage;
begin
  WriteLn('AHW52UIAutomation - external UI automation for the approved test instance');
  WriteLn('  verify');
  WriteLn('  inspect --pid PID --output PROFILE.json');
  WriteLn('  start-and-inspect --output PROFILE.json');
  WriteLn('  person-search --pid PID --profile PROFILE.json --surname TEXT');
  WriteLn('      --given-name TEXT --allow-input [--dry-run] --output RESULT.json');
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
    else if CommandName = 'start-and-inspect' then
      RunStartAndInspect(Options)
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
