{*******************************************************

 ��    �ܣ�BSS

 ע�����
 
                                                       
*******************************************************}
unit DeDeBSS;


interface

uses Classes, DeDeClasses, DeDeBinaryTypes;

Type

  TBSS = Class
  protected
    Data : TPE32DWordList;
    DataPtr : TPE32DWordList;
    Pointers : TPE32DWordList;
    Values : TPE32DWordList;
    PrimValues : TPE32DWordList;
  public
    dwStartRVA, dwSize : DWORD;
    dwDATAStartRVA, dwDATASize : DWORD;
    constructor Create;
    destructor Destroy; override;
    procedure Dump(FileName : String);
    function GetPointer(Offset : DWORD) : DWORD;
    function GetValue(Offset : DWORD) : DWORD;
    function GetValuePrim(Offset : DWORD) : DWORD;
    function GetData(Offset : DWORD) : DWORD;
    function GetDataPtr(Offset : DWORD) : DWORD;
    function GetDataPrtOfBSSData(Offset : DWORD) : DWORD;
    procedure GetProtectedDataForDPJSave(var buff : array of byte; var size : integer);
  end;

implementation

{ TBSS }

Uses SysUtils, DeDeRes, DeDeCoreServices
{$IFDEF MSWINDOWS}
  , Windows
{$ENDIF}
  ;

{$IFDEF MSWINDOWS}
function RemoteProcessAddressPointer(
  const Address: TPE32VA): Pointer;
begin
  // ReadProcessMemory needs a host-sized pointer for the remote PE32 address.
  Result := nil;
  Move(Address, Result, SizeOf(Address));
end;
{$ENDIF}

constructor TBSS.Create;
begin
  Values:=TPE32DWordList.Create;
  PrimValues:=TPE32DWordList.Create;
  Pointers:=TPE32DWordList.Create;
  Data:=TPE32DWordList.Create;
  DataPtr:=TPE32DWordList.Create;
  dwSize:=0;
end;

destructor TBSS.Destroy;
begin
  Values.Clear;
  Pointers.Clear;

  PrimValues.Free;
  Values.Free;
  Pointers.Free;
  Data.Free;
  DataPtr.Free;
end;

procedure TBSS.Dump(FileName: String);
{$IFDEF MSWINDOWS}
var pi : PROCESS_INFORMATION;
    si : TStartupInfo;
    bssi, i : Integer;
    dw, dw1 : DWORD;
    ImageHeader: TPEHeader;
{$IFDEF CPU64}
    sz : QWord;
{$ELSE}
    sz : Cardinal;
{$ENDIF}
{$ENDIF}
begin
{$IFDEF MSWINDOWS}
  ImageHeader := DeDeCoreContext.PEHeader;
  if ImageHeader = nil then
    raise EInvalidOp.Create('No PE header is available for BSS dumping');
  bssi := ImageHeader.GetSectionIndexEx('DATA');

  dwDATAStartRVA := ImageHeader.IMAGE_BASE+ImageHeader.Objects[bssi].RVA;
  dwDATASize := ImageHeader.Objects[bssi].VIRTUAL_SIZE;

  bssi := ImageHeader.GetSectionIndexEx('BSS');
  dwStartRVA := ImageHeader.IMAGE_BASE+ImageHeader.Objects[bssi].RVA;
  dwSize := ImageHeader.Objects[bssi].VIRTUAL_SIZE;


  GetStartUpInfo(si);
  si.dwFlags:=STARTF_USESHOWWINDOW;
  si.wShowWindow:=SW_HIDE;

  If CreateProcess(PCHar(FileName), nil, nil, nil, False,
   CREATE_NEW_PROCESS_GROUP OR CREATE_SUSPENDED, nil, nil, si, pi) Then
  Begin
    //
    ResumeThread(pi.hThread);
    WaitForInputIdle(pi.hProcess,10000);

    if not DeDeCoreContext.Confirm(txt_dede_loader, msg_ok_when_loaded) then
    begin
      TerminateProcess(pi.hProcess, 0);
      CloseHandle(pi.hThread);
      CloseHandle(pi.hProcess);
      Exit;
    end;

    SuspendThread(pi.hThread);

    dw := dwStartRVA;
    i:=0;
    while dw < (dwStartRVA + dwSize) Do
    begin
      ReadProcessMemory(pi.hProcess,RemoteProcessAddressPointer(
        TPE32VA(dw)),@dw1,4,sz);
      Pointers.Add(dw1);

      ReadProcessMemory(pi.hProcess,RemoteProcessAddressPointer(
        TPE32VA(dw1)),@dw1,4,sz);
      Values.Add(dw1);

      ReadProcessMemory(pi.hProcess,RemoteProcessAddressPointer(
        TPE32VA(dw1)),@dw1,4,sz);
      PrimValues.Add(dw1);

      Inc(dw,4);
      Inc(i);
    end;

    dw := dwDATAStartRVA;
    i:=0;
    while dw < (dwDATAStartRVA + dwDATASize) Do
    begin
      DataPtr.Add(LongWord(i));

      ReadProcessMemory(pi.hProcess,RemoteProcessAddressPointer(
        TPE32VA(dw)),@dw1,4,sz);

      Data.Add(dw1);

      Inc(dw,4);
      Inc(i);
    end;

    //ResumeThread(pi.hThread);
    TerminateProcess(pi.hProcess,0);
  End
  Else
  Begin
    DeDeCoreContext.ReportWarning(
      err_can_not_create_process + '"' + FileName + '"');
      
    dw:=dwStartRVA;
    while dw < (dwStartRVA + dwSize) Do
    begin
      Pointers.Add(dwStartRVA);
      Values.AddUndefined;
      PrimValues.Add(dwStartRVA);
      Data.AddUndefined;
      DataPtr.Add(dwStartRVA);
      Inc(dw,4);
    end;
  End;
{$ELSE}
  raise EDeDeServiceUnavailable.Create(
    'BSS/DATA process dumping is only supported on Windows hosts');
{$ENDIF}
end;

function TBSS.GetData(Offset: DWORD): DWORD;
begin
  if bBSS then Result:=Data[(Offset-dwDATAStartRVA) div 4]
          else Result:=0;
end;

function TBSS.GetDataPrtOfBSSData(Offset: DWORD): DWORD;
var i : DWORD;
begin
  Result:=0;
  if not bBSS then exit;
  
  i:=dwDATAStartRVA;
  while i<(dwDATAStartRVA+dwDATASize) do
  begin
    if GetData(i)=Offset then
    begin
      Result:=i;
      break;
    end;
    inc(i,4);
  end;
end;

function TBSS.GetDataPtr(Offset: DWORD): DWORD;
begin
  if bBSS then
    Result:=DataPtr[(Offset-dwDATAStartRVA) div 4]
  else
    Result:=0;

end;

function TBSS.GetPointer(Offset: DWORD): DWORD;
begin
   if bBSS then
     Result:=Pointers[(Offset-dwStartRVA) div 4]
   else
     Result:=0;
end;

procedure TBSS.GetProtectedDataForDPJSave(var buff: array of byte;
  var size: integer);
var i : Integer;
begin
  size:=Data.Count+DataPtr.Count+Pointers.Count+Values.Count+PrimValues.Count;
  if Length(buff)<>size then exit;

  for i:=0 to Data.Count-1 do buff[i]:=Byte(Data[i]);
  size:=Data.Count;
  for i:=0 to DataPtr.Count-1 do buff[size+i]:=Byte(DataPtr[i]);
  size:=size+DataPtr.Count;
  for i:=0 to Pointers.Count-1 do buff[size+i]:=Byte(Pointers[i]);
  size:=size+Pointers.Count;
  for i:=0 to Values.Count-1 do buff[size+i]:=Byte(Values[i]);
  size:=size+Values.Count;
  for i:=0 to PrimValues.Count-1 do buff[size+i]:=Byte(PrimValues[i]);
  size:=size+PrimValues.Count;
end;

function TBSS.GetValue(Offset: DWORD): DWORD;
begin
  if bBSS then
    Result:=Values[(Offset-dwStartRVA) div 4]
  else
    Result:=0;
end;

function TBSS.GetValuePrim(Offset: DWORD): DWORD;
begin
  if bBSS then
   Result:=PrimValues[(Offset-dwStartRVA) div 4]
  else
   Result:=0;
end;

end.
