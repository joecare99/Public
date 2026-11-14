program FileDropSmoke;

{$APPTYPE CONSOLE}

uses
  SysUtils, Classes, Forms, Windows, Messages, Controls, ShellAPI, FileDrop;

type
  TDropRecorder = class
  public
    Calls: Integer;
    Files: TStringList;
    procedure HandleDrop(Sender: TObject);
  end;

procedure TDropRecorder.HandleDrop(Sender: TObject);
begin
  Inc(Calls);
  Files.Assign(TFileDrop(Sender).Files);
end;

procedure Require(Value: Boolean; const MessageText: string);
begin
  if not Value then
    raise Exception.Create(MessageText);
end;

function MakeDropHandle(const Paths: array of string): HDROP;
type
  TDropFilesHeader = packed record
    pFiles: DWORD;
    pt: TPoint;
    fNC: BOOL;
    fWide: BOOL;
  end;
var
  Header: TDropFilesHeader;
  MultiString: string;
  Data: array of Byte;
  I, DataSize: Integer;
  Buffer: Pointer;
begin
  MultiString := '';
  for I := Low(Paths) to High(Paths) do
    MultiString := MultiString + Paths[I] + #0;
  MultiString := MultiString + #0;

  FillChar(Header, SizeOf(Header), 0);
  Header.pFiles := SizeOf(Header);
  Header.fWide := True;
  DataSize := SizeOf(Header) + Length(MultiString) * SizeOf(Char);
  SetLength(Data, DataSize);
  Move(Header, Data[0], SizeOf(Header));
  Move(MultiString[1], Data[SizeOf(Header)], Length(MultiString) * SizeOf(Char));

  Result := HDROP(GlobalAlloc(GMEM_MOVEABLE or GMEM_ZEROINIT, DataSize));
  if Result = 0 then
    RaiseLastOSError;
  Buffer := GlobalLock(Result);
  if Buffer = nil then
  begin
    GlobalFree(Result);
    RaiseLastOSError;
  end;
  Move(Data[0], Buffer^, DataSize);
  GlobalUnlock(Result);
end;

var
  Form: TForm;
  Drop: TFileDrop;
  Recorder: TDropRecorder;
  OriginalWindowProc: TWndMethod;
  DropHandle: HDROP;
begin
  Application.Initialize;
  Form := TForm.Create(nil);
  Recorder := TDropRecorder.Create;
  Recorder.Files := TStringList.Create;
  Drop := TFileDrop.Create(Form);
  try
    OriginalWindowProc := Form.WindowProc;
    Drop.OnDrop := Recorder.HandleDrop;
    Drop.SetDropControl(Form);
    Drop.SetEnableDrop(True);
    DropHandle := MakeDropHandle(['C:\first.exe', 'D:\zweite.exe']);
    SendMessage(Form.Handle, WM_DROPFILES, WPARAM(DropHandle), 0);

    Require(Recorder.Calls = 1, 'Drop event was not dispatched once');
    Require(Drop.FileCount = 2, 'Drop file count was not preserved');
    Require(Recorder.Files.Count = 2, 'Dropped paths were not collected');
    Require(Recorder.Files[0] = 'C:\first.exe', 'First dropped path changed');
    Require(Recorder.Files[1] = 'D:\zweite.exe', 'Second dropped path changed');

    Drop.SetDropControl(nil);
    Require(TMethod(Form.WindowProc).Code = TMethod(OriginalWindowProc).Code,
      'Original form WindowProc was not restored');
    Require(TMethod(Form.WindowProc).Data = TMethod(OriginalWindowProc).Data,
      'Original form WindowProc context was not restored');
    WriteLn('FileDrop dispatch smoke test passed');
  finally
    Drop.Free;
    Recorder.Files.Free;
    Recorder.Free;
    Form.Free;
  end;
end.
