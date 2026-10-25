unit DeDeBinaryTypes;

interface

uses
  Classes;

type
  TPE32RVA = type LongWord;
  TPE32VA = type LongWord;
  TPE32FileOffset = type LongWord;

  TPE32DWordEntry = packed record
    Value: LongWord;
    IsDefined: Boolean;
  end;

  TPE32DWordList = class
  private
    FValues: array of TPE32DWordEntry;
    procedure CheckIndex(Index: Integer);
    function GetCount: Integer;
    function GetItem(Index: Integer): LongWord;
    procedure SetItem(Index: Integer; AValue: LongWord);
  public
    constructor Create;
    destructor Destroy; override;
    function Add(AValue: LongWord): Integer;
    function AddUndefined: Integer;
    procedure Clear;
    procedure Delete(Index: Integer);
    function IndexOf(AValue: LongWord): Integer;
    function IsDefined(Index: Integer): Boolean;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: LongWord read GetItem write SetItem; default;
  end;

  TPE32FileOffsetBox = class
  public
    Value: TPE32FileOffset;
    constructor Create(AValue: TPE32FileOffset);
  end;

function TryAddPE32FileOffset(const ABase, ADelta: TPE32FileOffset;
  out AResult: TPE32FileOffset): Boolean;
function TryGetPE32RVA(const AImageBase, AVirtualAddress: TPE32VA;
  out ARVA: TPE32RVA): Boolean;

implementation

constructor TPE32DWordList.Create;
begin
  inherited Create;
end;

destructor TPE32DWordList.Destroy;
begin
  Clear;
  inherited Destroy;
end;

function TPE32DWordList.Add(AValue: LongWord): Integer;
begin
  Result := Length(FValues);
  SetLength(FValues, Result + 1);
  FValues[Result].Value := AValue;
  FValues[Result].IsDefined := True;
end;

function TPE32DWordList.AddUndefined: Integer;
begin
  Result := Length(FValues);
  SetLength(FValues, Result + 1);
  FValues[Result].Value := 0;
  FValues[Result].IsDefined := False;
end;

procedure TPE32DWordList.Clear;
begin
  SetLength(FValues, 0);
end;

procedure TPE32DWordList.Delete(Index: Integer);
var
  I: Integer;
begin
  CheckIndex(Index);
  for I := Index to High(FValues) - 1 do
    FValues[I] := FValues[I + 1];
  SetLength(FValues, Length(FValues) - 1);
end;

function TPE32DWordList.IndexOf(AValue: LongWord): Integer;
var
  I: Integer;
begin
  for I := 0 to High(FValues) do
    if FValues[I].IsDefined and (FValues[I].Value = AValue) then
      Exit(I);
  Result := -1;
end;

procedure TPE32DWordList.CheckIndex(Index: Integer);
begin
  if (Index < 0) or (Index >= Length(FValues)) then
    raise EListError.CreateFmt('List index out of bounds (%d)', [Index]);
end;

function TPE32DWordList.GetCount: Integer;
begin
  Result := Length(FValues);
end;

function TPE32DWordList.GetItem(Index: Integer): LongWord;
begin
  CheckIndex(Index);
  if not FValues[Index].IsDefined then
    Result := 0
  else
    Result := FValues[Index].Value;
end;

function TPE32DWordList.IsDefined(Index: Integer): Boolean;
begin
  CheckIndex(Index);
  Result := FValues[Index].IsDefined;
end;

procedure TPE32DWordList.SetItem(Index: Integer; AValue: LongWord);
begin
  CheckIndex(Index);
  FValues[Index].Value := AValue;
  FValues[Index].IsDefined := True;
end;

constructor TPE32FileOffsetBox.Create(AValue: TPE32FileOffset);
begin
  inherited Create;
  Value := AValue;
end;

function TryAddPE32FileOffset(const ABase, ADelta: TPE32FileOffset;
  out AResult: TPE32FileOffset): Boolean;
begin
  Result := ABase <= High(LongWord) - ADelta;
  if Result then
    AResult := TPE32FileOffset(LongWord(ABase) + LongWord(ADelta))
  else
    AResult := 0;
end;

function TryGetPE32RVA(const AImageBase, AVirtualAddress: TPE32VA;
  out ARVA: TPE32RVA): Boolean;
begin
  Result := AVirtualAddress >= AImageBase;
  if Result then
    ARVA := TPE32RVA(LongWord(AVirtualAddress) - LongWord(AImageBase))
  else
    ARVA := 0;
end;

end.
