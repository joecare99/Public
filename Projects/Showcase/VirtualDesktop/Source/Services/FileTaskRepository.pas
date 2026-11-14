unit FileTaskRepository;

{$mode objfpc}{$H+}

interface

uses
  Classes, StrUtils, SysUtils, Services, TaskItem, TaskRepository;

type
  TFileTaskRepository = class(TInterfacedObject, ITaskRepository)
  private
    FWorkspace: IUserWorkspaceService;
    FFileName: string;
    class function EncodeField(const AValue: string): string; static;
    class function DecodeField(const AValue: string): string; static;
    class function HexValue(ACharacter: Char): Integer; static;
    function ContainsId(const ATasks: TTaskItemArray;
      const AId: string): Boolean;
  public
    constructor Create(const AWorkspace: IUserWorkspaceService);
    function LoadTasks: TTaskItemArray;
    procedure SaveTasks(const ATasks: TTaskItemArray);
  end;

implementation

constructor TFileTaskRepository.Create(const AWorkspace: IUserWorkspaceService);
begin
  if AWorkspace = nil then
    raise EArgumentNilException.Create('A workspace service is required.');
  FWorkspace := AWorkspace;
  FFileName := FWorkspace.ResolveFile('tasks.txt');
end;

class function TFileTaskRepository.EncodeField(const AValue: string): string;
const
  HexDigits = '0123456789ABCDEF';
var
  I: Integer;
  B: Byte;
begin
  Result := '';
  for I := 1 to Length(AValue) do
  begin
    B := Ord(AValue[I]);
    if ((B >= Ord('A')) and (B <= Ord('Z'))) or
       ((B >= Ord('a')) and (B <= Ord('z'))) or
       ((B >= Ord('0')) and (B <= Ord('9'))) or
       (B in [Ord('-'), Ord('_'), Ord('.')]) then
      Result := Result + Chr(B)
    else
      Result := Result + '%' + HexDigits[(B shr 4) + 1] +
        HexDigits[(B and $0F) + 1];
  end;
end;

class function TFileTaskRepository.HexValue(ACharacter: Char): Integer;
begin
  if ACharacter in ['0'..'9'] then
    Exit(Ord(ACharacter) - Ord('0'));
  if ACharacter in ['A'..'F'] then
    Exit(Ord(ACharacter) - Ord('A') + 10);
  if ACharacter in ['a'..'f'] then
    Exit(Ord(ACharacter) - Ord('a') + 10);
  Result := -1;
end;

class function TFileTaskRepository.DecodeField(const AValue: string): string;
var
  I: Integer;
  HighNibble, LowNibble: Integer;
begin
  Result := '';
  I := 1;
  while I <= Length(AValue) do
  begin
    if AValue[I] <> '%' then
      Result := Result + AValue[I]
    else
    begin
      if I + 2 > Length(AValue) then
        raise EConvertError.Create('Invalid encoded task data.');
      HighNibble := HexValue(AValue[I + 1]);
      LowNibble := HexValue(AValue[I + 2]);
      if (HighNibble < 0) or (LowNibble < 0) then
        raise EConvertError.Create('Invalid encoded task data.');
      Result := Result + Chr((HighNibble shl 4) or LowNibble);
      Inc(I, 2);
    end;
    Inc(I);
  end;
end;

function TFileTaskRepository.ContainsId(const ATasks: TTaskItemArray;
  const AId: string): Boolean;
var
  I: Integer;
begin
  for I := 0 to High(ATasks) do
    if ATasks[I].Id = AId then
      Exit(True);
  Result := False;
end;

function TFileTaskRepository.LoadTasks: TTaskItemArray;
var
  Lines: TStringList;
  I, SeparatorOne, SeparatorTwo: Integer;
  Id, Title, CompletedText, Line: string;
  Completed: Boolean;
begin
  Result := nil;
  SetLength(Result, 0);
  if not FileExists(FFileName) then
    Exit;

  Lines := TStringList.Create;
  try
    Lines.LoadFromFile(FFileName);
    if (Lines.Count = 0) or (Lines[0] <> 'TASKS-1') then
      raise EConvertError.Create('Unsupported task file format.');

    try
      for I := 1 to Lines.Count - 1 do
      begin
        Line := Lines[I];
        if Line = '' then
          Continue;
        SeparatorOne := Pos('|', Line);
        if SeparatorOne = 0 then
          raise EConvertError.CreateFmt('Invalid task record on line %d.',
            [I + 1]);
        SeparatorTwo := PosEx('|', Line, SeparatorOne + 1);
        if SeparatorTwo = 0 then
          raise EConvertError.CreateFmt('Invalid task record on line %d.',
            [I + 1]);

        Id := DecodeField(Copy(Line, 1, SeparatorOne - 1));
        CompletedText := Copy(Line, SeparatorOne + 1,
          SeparatorTwo - SeparatorOne - 1);
        Title := DecodeField(Copy(Line, SeparatorTwo + 1, MaxInt));
        if (Id = '') or (Title = '') or ContainsId(Result, Id) then
          raise EConvertError.CreateFmt(
            'Invalid or duplicate task on line %d.', [I + 1]);
        if (CompletedText <> '0') and (CompletedText <> '1') then
          raise EConvertError.CreateFmt(
            'Invalid completion flag on line %d.', [I + 1]);
        Completed := CompletedText = '1';

        SetLength(Result, Length(Result) + 1);
        Result[High(Result)] := TTaskItem.Create(Id, Title, Completed);
      end;
    except
      for I := 0 to High(Result) do
        Result[I].Free;
      Result := nil;
      raise;
    end;
  finally
    Lines.Free;
  end;
end;

procedure TFileTaskRepository.SaveTasks(const ATasks: TTaskItemArray);
var
  Lines: TStringList;
  I, J: Integer;
begin
  Lines := TStringList.Create;
  try
    Lines.Add('TASKS-1');
    for I := 0 to High(ATasks) do
    begin
      if ATasks[I] = nil then
        raise EArgumentException.CreateFmt('Task %d is nil.', [I]);
      if (ATasks[I].Id = '') or (ATasks[I].Title = '') then
        raise EArgumentException.CreateFmt('Task %d is invalid.', [I]);
      for J := 0 to I - 1 do
        if ATasks[J].Id = ATasks[I].Id then
          raise EArgumentException.Create('Task IDs must be unique.');
      Lines.Add(EncodeField(ATasks[I].Id) + '|' +
        BoolToStr(ATasks[I].Completed, '1', '0') + '|' +
        EncodeField(ATasks[I].Title));
    end;
    Lines.SaveToFile(FFileName);
  finally
    Lines.Free;
  end;
end;

end.
