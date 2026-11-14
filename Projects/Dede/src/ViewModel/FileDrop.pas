unit FileDrop;

interface

uses
  Windows, Messages, Classes, Controls, ShellAPI;

type
  TFileDrop = class(TComponent)
  private
    FOriginalWindowProc: TWndMethod;
    procedure DropControlWindowProc(var Message: TMessage);
  public
    Files: TStrings;
    FileCount: Integer;
    EnableDrop: Boolean;
    OnDrop: TNotifyEvent;
    DropControl: TWinControl;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetDropControl(Value: TWinControl);
    procedure SetEnableDrop(Value: Boolean);
  end;

implementation

constructor TFileDrop.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Files := TStringList.Create;
  FileCount := 0;
  EnableDrop := False;
  DropControl := nil;
  FOriginalWindowProc := nil;
end;

destructor TFileDrop.Destroy;
begin
  SetDropControl(nil);
  Files.Free;
  inherited Destroy;
end;

procedure TFileDrop.SetDropControl(Value: TWinControl);
begin
  if DropControl = Value then
    Exit;

  if DropControl <> nil then
  begin
    DragAcceptFiles(DropControl.Handle, False);
    DropControl.WindowProc := FOriginalWindowProc;
    DropControl := nil;
    FOriginalWindowProc := nil;
  end;

  DropControl := Value;
  if DropControl <> nil then
  begin
    FOriginalWindowProc := DropControl.WindowProc;
    DropControl.WindowProc := DropControlWindowProc;
    SetEnableDrop(True);
  end
  else
    SetEnableDrop(False);
end;

procedure TFileDrop.SetEnableDrop(Value: Boolean);
begin
  if DropControl = nil then
  begin
    EnableDrop := False;
    Exit;
  end;

  EnableDrop := Value;
  DragAcceptFiles(DropControl.Handle, EnableDrop);
end;

procedure TFileDrop.DropControlWindowProc(var Message: TMessage);
var
  DropHandle: HDROP;
  DroppedFile: string;
  I, NameLength, Count: UINT;
begin
  if Message.Msg <> WM_DROPFILES then
  begin
    FOriginalWindowProc(Message);
    Exit;
  end;

  DropHandle := HDROP(Message.WParam);
  Message.Result := 0;
  try
    Files.BeginUpdate;
    try
      Files.Clear;
      Count := DragQueryFile(DropHandle, $FFFFFFFF, nil, 0);
      FileCount := Integer(Count);
      if Count > 0 then
        for I := 0 to Count - 1 do
        begin
          NameLength := DragQueryFile(DropHandle, I, nil, 0);
          if NameLength = 0 then
            Continue;
          SetLength(DroppedFile, Integer(NameLength));
          DragQueryFile(DropHandle, I, PChar(DroppedFile), NameLength + 1);
          Files.Add(DroppedFile);
        end;
    finally
      Files.EndUpdate;
    end;

    if EnableDrop and (FileCount > 0) and Assigned(OnDrop) then
      OnDrop(Self);
  finally
    DragFinish(DropHandle);
  end;
end;

end.
