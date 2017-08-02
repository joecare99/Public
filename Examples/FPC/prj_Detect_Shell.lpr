program prj_Detect_Shell;

uses Windows, JwaTlHelp32;

function GetParentProcessName: string;
var
  Snap: THandle;
  SelfId: DWORD;
  ParentId: DWORD;
  ProcInfo: TProcessEntry32;
begin
  Result := '';
  SelfId := GetCurrentProcessId;
  ParentId := 0;
  Snap := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if Snap = INVALID_HANDLE_VALUE then
    Exit;
  try
    ProcInfo.dwSize := SizeOf(ProcInfo);
    if Process32First(Snap, ProcInfo) then
    repeat
      if ProcInfo.th32ProcessID = SelfId then
      begin
        ParentId := ProcInfo.th32ParentProcessID;
        Break;
      end;
    until not Process32Next(Snap, ProcInfo);
    if ParentId <> 0 then
    begin
      Process32First(Snap, ProcInfo);
      repeat
        if ProcInfo.th32ProcessID = ParentId then
        begin
          Result := ProcInfo.szExeFile;
          Break;
        end;
      until not Process32Next(Snap, ProcInfo);
    end;
  finally
    CloseHandle(Snap);
  end;
end;

function IsDebuggerPresent: BOOL; stdcall; external kernel32;

function IsFromIDE: Boolean;
begin
  Result := IsDebuggerPresent or
    (LowerCase(GetParentProcessName) = 'lazarus.exe');
end;

begin
  if IsFromIDE then
    MessageBox(0, 'Start from IDE!', 'Info', MB_ICONEXCLAMATION)
  else
    MessageBox(0, 'Normal start', 'Info', MB_ICONINFORMATION);
end.
