unit MemLocUnit;

interface

uses
  Windows, TlHelp32, SysUtils, Classes, Controls, Forms, StdCtrls, Buttons;

type
  TChooseMemLocForm = class(TForm)
    StartOffsEdit: TEdit;
    Label16: TLabel;
    ProcsCB: TComboBox;
    Label15: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure ProcsCBDropDown(Sender: TObject);
  end;

var
  ChooseMemLocForm: TChooseMemLocForm;

implementation

{$R *.dfm}

uses DeDeMemDumps;

procedure TChooseMemLocForm.ProcsCBDropDown(Sender: TObject);
  procedure AddProcessName(const Name: string; ProcessID: DWORD;
    PIDDigits: Integer);
  var
    DisplayName: string;
  begin
    DisplayName := Name;
    if Length(DisplayName) < 30 then
      DisplayName := DisplayName +
        StringOfChar(' ', 30 - Length(DisplayName));
    DisplayName := DisplayName + ', PID=' + IntToHex(ProcessID, PIDDigits);
    ProcsCB.Items.AddObject(DisplayName, TObject(ProcessID));
  end;

  procedure EnumerateToolhelpProcesses;
  var
    Snapshot: THandle;
    Entry: TlHelp32.tagPROCESSENTRY32;
    ErrorCode: DWORD;
    ProcessName: string;
  begin
    Snapshot := CreateToolhelp32Snapshot(TH32CS_SNAPALL,
      GetCurrentProcessId);
    if Snapshot = INVALID_HANDLE_VALUE then
      RaiseLastOSError;
    try
      Entry.dwSize := SizeOf(Entry);
      if not Process32First(Snapshot, Entry) then
      begin
        ErrorCode := GetLastError;
        if ErrorCode <> ERROR_NO_MORE_FILES then
          RaiseLastOSError(ErrorCode);
        Exit;
      end;

      repeat
        if Entry.th32ProcessID <> 0 then
        begin
          ProcessName := ExtractFileName(StrPas(PChar(@Entry.szExeFile[0])));
          AddProcessName(ProcessName, Entry.th32ProcessID, 8);
        end;
        Entry.dwSize := SizeOf(Entry);
      until not Process32Next(Snapshot, Entry);

      ErrorCode := GetLastError;
      if ErrorCode <> ERROR_NO_MORE_FILES then
        RaiseLastOSError(ErrorCode);
    finally
      CloseHandle(Snapshot);
    end;
  end;

  procedure EnumeratePSAPIProcesses;
  const
    InitialProcessCapacity = 256;
    MaximumProcessCapacity = 65536;
    ModuleCapacity = 256;
    ProcessNameCapacity = 260;
  var
    ProcessIDs: array of DWORD;
    Modules: array of HMODULE;
    BytesNeeded, ProcessBufferBytes, ModuleBytes: DWORD;
    ProcessCount, I: Integer;
    ProcessHandle: THandle;
    ModuleBytesNeeded, NameLength: DWORD;
    ProcessName: AnsiString;
  begin
    if not Assigned(DeDeMemDumps.EnumProcesses) or
       not Assigned(DeDeMemDumps.EnumProcessModules) or
       not Assigned(DeDeMemDumps.GetModuleBaseNameA) then
      raise Exception.Create('PSAPI process enumeration is unavailable');

    SetLength(ProcessIDs, InitialProcessCapacity);
    repeat
      ProcessBufferBytes := DWORD(Length(ProcessIDs) * SizeOf(DWORD));
      BytesNeeded := 0;
      if not DeDeMemDumps.EnumProcesses(ProcessIDs[0], ProcessBufferBytes,
        BytesNeeded) then
        RaiseLastOSError;

      if BytesNeeded < ProcessBufferBytes then
        Break;
      if Length(ProcessIDs) >= MaximumProcessCapacity then
        raise ERangeError.Create('Process list exceeds the supported capacity');
      SetLength(ProcessIDs, Length(ProcessIDs) * 2);
    until False;

    if (BytesNeeded mod SizeOf(DWORD)) <> 0 then
      raise EReadError.Create('PSAPI returned a partial process identifier');
    ProcessCount := BytesNeeded div SizeOf(DWORD);
    if ProcessCount > Length(ProcessIDs) then
      raise EReadError.Create('PSAPI returned an invalid process count');

    SetLength(Modules, ModuleCapacity);
    ModuleBytes := DWORD(Length(Modules) * SizeOf(HMODULE));
    SetLength(ProcessName, ProcessNameCapacity);
    for I := 0 to ProcessCount - 1 do
    begin
      if ProcessIDs[I] = 0 then
        Continue;
      ProcessHandle := OpenProcess(PROCESS_QUERY_INFORMATION or
        PROCESS_VM_READ, False, ProcessIDs[I]);
      if ProcessHandle = 0 then
        Continue;
      try
        ModuleBytesNeeded := 0;
        if not DeDeMemDumps.EnumProcessModules(ProcessHandle, Modules[0],
          ModuleBytes, ModuleBytesNeeded) or
          (ModuleBytesNeeded < SizeOf(HMODULE)) then
          Continue;

        NameLength := DeDeMemDumps.GetModuleBaseNameA(ProcessHandle,
          Modules[0], PAnsiChar(ProcessName), Length(ProcessName));
        if NameLength = 0 then
          Continue;
        if NameLength > DWORD(Length(ProcessName)) then
          raise EReadError.Create('PSAPI returned an invalid module name length');
        SetLength(ProcessName, NameLength);
        AddProcessName(string(ProcessName), ProcessIDs[I], 4);
        SetLength(ProcessName, ProcessNameCapacity);
      finally
        CloseHandle(ProcessHandle);
      end;
    end;
  end;
begin
  ProcsCB.Items.BeginUpdate;
  try
    ProcsCB.Items.Clear;
    if DeDeMemDumps.IsWin9x then
      EnumerateToolhelpProcesses
    else
      EnumeratePSAPIProcesses;
  finally
    ProcsCB.Items.EndUpdate;
  end;
end;

end.
