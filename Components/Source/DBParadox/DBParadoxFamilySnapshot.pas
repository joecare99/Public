unit DBParadoxFamilySnapshot;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, DBParadoxFileReader, DBParadoxRecordEncoder,
  DBParadoxSecondaryFamilyAdapter, DBParadoxFamilyPublisher;

type
  EDBParadoxFamilySnapshotError = class(Exception);

  TDBParadoxSnapshotMember = record
    Extension: string;
    Data: TBytes;
  end;

  TDBParadoxSnapshotMembers = array of TDBParadoxSnapshotMember;

  TDBParadoxFamilySnapshot = class
  private
    FTableFileName: string;
    FMembers: TDBParadoxSnapshotMembers;
    FFields: TDBParadoxFileFields;
    FRows: TDBParadoxFileRows;
    FRecordSize: Integer;
    FPrimaryKeyFieldCount: Integer;
    FPrimaryKeyFieldIndex: SizeInt;
    FDatabaseTemplate: TBytes;
    FPrimaryIndexTemplate: TBytes;
    FSecondaryIndexes: TDBParadoxSecondaryFamilyIndexes;
    constructor CreateSnapshot;
  public
    destructor Destroy; override;
    class function Capture(const ATableFileName: string):
      TDBParadoxFamilySnapshot;
    function MemberCount: SizeInt;
    function CopyMember(AIndex: SizeInt): TDBParadoxSnapshotMember;
    function CopyMembers: TDBParadoxSnapshotMembers;
    function CopyExpectedFamilyMembers:
      TDBParadoxExpectedFamilyMembers;
    function CopyFields: TDBParadoxFileFields;
    function CopyRows: TDBParadoxFileRows;
    function CopyDatabaseTemplate: TBytes;
    function CopyPrimaryIndexTemplate: TBytes;
    function CopySecondaryIndexes: TDBParadoxSecondaryFamilyIndexes;
    function MatchesCurrentFiles: Boolean;
    property TableFileName: string read FTableFileName;
    property RecordSize: Integer read FRecordSize;
    property PrimaryKeyFieldCount: Integer read FPrimaryKeyFieldCount;
    property PrimaryKeyFieldIndex: SizeInt read FPrimaryKeyFieldIndex;
  end;

implementation

uses
  Classes, DBParadoxFamilyJournal, DBParadoxFamilyLock,
  DBParadoxPrimaryKeyDiscovery;

function ReadUInt16LE(const AData: TBytes; AOffset: SizeInt): Word;
begin
  if (AOffset < 0) or (AOffset + 1 >= Length(AData)) then
    raise EDBParadoxFamilySnapshotError.Create(
      'A Paradox snapshot header is truncated.');
  Result := Word(AData[AOffset]) or (Word(AData[AOffset + 1]) shl 8);
end;

function ReadUInt32LE(const AData: TBytes; AOffset: SizeInt): Cardinal;
begin
  if (AOffset < 0) or (AOffset + 3 >= Length(AData)) then
    raise EDBParadoxFamilySnapshotError.Create(
      'A Paradox snapshot header is truncated.');
  Result := Cardinal(AData[AOffset]) or
    (Cardinal(AData[AOffset + 1]) shl 8) or
    (Cardinal(AData[AOffset + 2]) shl 16) or
    (Cardinal(AData[AOffset + 3]) shl 24);
end;

procedure WriteUInt16LE(var AData: TBytes; AOffset: SizeInt; AValue: Word);
begin
  AData[AOffset] := Byte(AValue);
  AData[AOffset + 1] := Byte(AValue shr 8);
end;

procedure WriteUInt32LE(var AData: TBytes; AOffset: SizeInt;
  AValue: Cardinal);
begin
  AData[AOffset] := Byte(AValue);
  AData[AOffset + 1] := Byte(AValue shr 8);
  AData[AOffset + 2] := Byte(AValue shr 16);
  AData[AOffset + 3] := Byte(AValue shr 24);
end;

function CopyBytes(const AData: TBytes): TBytes;
begin
  Result := Copy(AData, 0, Length(AData));
end;

function CopyFileRows(const ARows: TDBParadoxFileRows): TDBParadoxFileRows;
var
  Index: SizeInt;
begin
  Result := Copy(ARows, 0, Length(ARows));
  for Index := 0 to High(Result) do
    Result[Index].Data := CopyBytes(ARows[Index].Data);
end;

function CopySnapshotMembers(
  const AMembers: TDBParadoxSnapshotMembers): TDBParadoxSnapshotMembers;
var
  Index: SizeInt;
begin
  Result := Copy(AMembers, 0, Length(AMembers));
  for Index := 0 to High(Result) do
    Result[Index].Data := CopyBytes(AMembers[Index].Data);
end;

function CopyFamilyIndexes(
  const AIndexes: TDBParadoxSecondaryFamilyIndexes):
  TDBParadoxSecondaryFamilyIndexes;
var
  Index: SizeInt;
begin
  Result := Copy(AIndexes, 0, Length(AIndexes));
  for Index := 0 to High(Result) do
  begin
    Result[Index].DataTemplate := CopyBytes(AIndexes[Index].DataTemplate);
    Result[Index].IndexTemplate := CopyBytes(AIndexes[Index].IndexTemplate);
    Result[Index].KeyFieldIndexes := Copy(AIndexes[Index].KeyFieldIndexes,
      0, Length(AIndexes[Index].KeyFieldIndexes));
  end;
end;

function SameBytes(const ALeft, ARight: TBytes): Boolean;
begin
  Result := (Length(ALeft) = Length(ARight)) and
    ((Length(ALeft) = 0) or
     (CompareByte(ALeft[0], ARight[0], Length(ALeft)) = 0));
end;

function FamilyMembersFor(const AExtensions: array of string):
  TDBParadoxFamilyMembers;
var
  Index: SizeInt;
begin
  Result := nil;
  SetLength(Result, Length(AExtensions));
  for Index := 0 to High(AExtensions) do
    Result[Index] := AExtensions[Index];
end;

function SnapshotMemberExtensions(
  const AMembers: TDBParadoxSnapshotMembers): TDBParadoxFamilyMembers;
var
  Index: SizeInt;
begin
  Result := nil;
  SetLength(Result, Length(AMembers));
  for Index := 0 to High(AMembers) do
    Result[Index] := AMembers[Index].Extension;
end;

function MemberSetsEqual(const ALeft, ARight: TDBParadoxFamilyMembers):
  Boolean;
var
  LeftIndex, RightIndex: SizeInt;
  Used: array of Boolean;
  Found: Boolean;
begin
  if Length(ALeft) <> Length(ARight) then
    Exit(False);
  SetLength(Used, Length(ARight));
  for LeftIndex := 0 to High(ALeft) do
  begin
    Found := False;
    for RightIndex := 0 to High(ARight) do
      if not Used[RightIndex] and
        SameText(ALeft[LeftIndex], ARight[RightIndex]) then
      begin
        Used[RightIndex] := True;
        Found := True;
        Break;
      end;
    if not Found then
      Exit(False);
  end;
  Result := True;
end;

function ResolveFamilyMembers(const ATableFileName: string):
  TDBParadoxFamilyMembers;
var
  Directory, BaseName, SearchPath, FullName, Extension: string;
  Search: TSearchRec;
  SearchResult: Integer;
  Actual: TDBParadoxFamilyMembers;
  PrimaryOnly, TwoXG, ClassicAndTwoXG: TDBParadoxFamilyMembers;
begin
  Directory := ExtractFileDir(ExpandFileName(ATableFileName));
  BaseName := ChangeFileExt(ExtractFileName(ATableFileName), '');
  SearchPath := IncludeTrailingPathDelimiter(Directory) + BaseName + '.*';
  Actual := nil;
  SearchResult := FindFirst(SearchPath, faAnyFile, Search);
  if SearchResult = 0 then
  begin
    try
      repeat
        FullName := ExpandFileName(
          IncludeTrailingPathDelimiter(Directory) + Search.Name);
        if SameText(FullName, ExpandFileName(ATableFileName) +
          '.dbparadox.lock') then
          Continue;
        if (Search.Attr and faDirectory) <> 0 then
          raise EDBParadoxFamilySnapshotError.CreateFmt(
            'Unexpected directory in the table family: "%s".', [Search.Name]);
        Extension := ExtractFileExt(Search.Name);
        if (Extension = '') or
          not SameText(ChangeFileExt(Search.Name, ''), BaseName) then
          raise EDBParadoxFamilySnapshotError.CreateFmt(
            'Unexpected file in the table family: "%s".', [Search.Name]);
        SetLength(Actual, Length(Actual) + 1);
        Actual[High(Actual)] := Extension;
      until FindNext(Search) <> 0;
    finally
      SysUtils.FindClose(Search);
    end;
  end;

  PrimaryOnly := FamilyMembersFor(['.DB', '.PX']);
  TwoXG := FamilyMembersFor(['.DB', '.PX',
    '.XG0', '.YG0', '.XG1', '.YG1']);
  ClassicAndTwoXG := FamilyMembersFor(['.DB', '.PX',
    '.XG0', '.YG0', '.XG1', '.YG1', '.X02', '.Y02']);
  if MemberSetsEqual(Actual, PrimaryOnly) then
    Result := PrimaryOnly
  else if MemberSetsEqual(Actual, TwoXG) then
    Result := TwoXG
  else if MemberSetsEqual(Actual, ClassicAndTwoXG) then
    Result := ClassicAndTwoXG
  else
    raise EDBParadoxFamilySnapshotError.CreateFmt(
      'The table family "%s" is incomplete or has unsupported members.',
      [ATableFileName]);
end;

function LoadFileBytes(const AFileName: string): TBytes;
var
  Stream: TFileStream;
begin
  Result := nil;
  Stream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyNone);
  try
    {$IFDEF CPU32}
    if Stream.Size > High(SizeInt) then
      raise EDBParadoxFamilySnapshotError.CreateFmt(
        'Family member "%s" is too large for an in-memory snapshot.',
        [AFileName]);
    {$ENDIF}
    SetLength(Result, SizeInt(Stream.Size));
    if Stream.Size > 0 then
      Stream.ReadBuffer(Result[0], Stream.Size);
  finally
    Stream.Free;
  end;
end;

function CopyFileFields(const AFields: TDBParadoxFileFields):
  TDBParadoxFileFields;
begin
  Result := Copy(AFields, 0, Length(AFields));
end;

function MakeRecordFields(const AFields: TDBParadoxFileFields):
  TDBParadoxRecordFields;
var
  Index: SizeInt;
begin
  SetLength(Result, Length(AFields));
  for Index := 0 to High(AFields) do
  begin
    Result[Index].Name := AFields[Index].Name;
    Result[Index].TypeCode := AFields[Index].FieldType;
    Result[Index].Length := AFields[Index].FieldLength;
  end;
end;

function HeaderTemplate(const AData: TBytes; IsDatabase: Boolean): TBytes;
var
  HeaderSize: SizeInt;
begin
  if Length(AData) < $58 then
    raise EDBParadoxFamilySnapshotError.Create(
      'A table-family header is truncated.');
  HeaderSize := ReadUInt16LE(AData, 2);
  if (HeaderSize < $58) or (HeaderSize > Length(AData)) then
    raise EDBParadoxFamilySnapshotError.Create(
      'A table-family header size is invalid.');
  Result := Copy(AData, 0, HeaderSize);
  WriteUInt32LE(Result, 6, 0);
  WriteUInt16LE(Result, $0A, 0);
  WriteUInt16LE(Result, $0C, 0);
  WriteUInt16LE(Result, $0E, 0);
  WriteUInt16LE(Result, $10, 0);
  if IsDatabase then
    WriteUInt16LE(Result, $3A, 0)
  else
  begin
    WriteUInt16LE(Result, $1E, 0);
    Result[$20] := 0;
  end;
end;

constructor TDBParadoxFamilySnapshot.CreateSnapshot;
begin
  inherited Create;
end;

class function TDBParadoxFamilySnapshot.Capture(
  const ATableFileName: string): TDBParadoxFamilySnapshot;
var
  Lock: TDBParadoxFamilyLock;
  Extensions: TDBParadoxFamilyMembers;
  Fields: TDBParadoxFileFields;
  Rows: TDBParadoxFileRows;
  RecordFields: TDBParadoxRecordFields;
  ParsedRecordSize, PrimaryKeyCount, Index, DataBlockCount: Integer;
  MemberIndex, DataMemberIndex, IndexMemberIndex: SizeInt;
  PrimaryIndexData, DatabaseData, CurrentData: TBytes;
  FamilyBaseName: string;
  DatabaseRevision: Integer;
  SecondaryCount: SizeInt;
begin
  if Trim(ATableFileName) = '' then
    raise EDBParadoxFamilySnapshotError.Create(
      'A table file name is required for a family snapshot.');
  Result := nil;
  Lock := TDBParadoxFamilyLock.Create(ATableFileName);
  try
    TDBParadoxFamilyJournal.RecoverWhileLocked(ATableFileName);
    Extensions := ResolveFamilyMembers(ATableFileName);
    Result := TDBParadoxFamilySnapshot.CreateSnapshot;
    try
      Result.FTableFileName := ExpandFileName(ATableFileName);
      FamilyBaseName := ChangeFileExt(Result.FTableFileName, '');
      SetLength(Result.FMembers, Length(Extensions));
      for MemberIndex := 0 to High(Extensions) do
      begin
        Result.FMembers[MemberIndex].Extension := Extensions[MemberIndex];
        Result.FMembers[MemberIndex].Data := LoadFileBytes(
          FamilyBaseName + Extensions[MemberIndex]);
      end;

      DatabaseData := Result.FMembers[0].Data;
      ReadDBParadoxTable(Result.FTableFileName, Fields, Rows,
        ParsedRecordSize, PrimaryKeyCount);
      PrimaryIndexData := nil;
      for MemberIndex := 0 to High(Extensions) do
        if SameText(Extensions[MemberIndex], '.PX') then
          PrimaryIndexData := Result.FMembers[MemberIndex].Data;
      Result.FPrimaryKeyFieldIndex :=
        DiscoverDBParadoxPrimaryKeyFieldIndex(Fields, Rows,
          PrimaryKeyCount, PrimaryIndexData);
      Result.FFields := CopyFileFields(Fields);
      Result.FRows := CopyFileRows(Rows);
      Result.FRecordSize := ParsedRecordSize;
      Result.FPrimaryKeyFieldCount := PrimaryKeyCount;
      Result.FDatabaseTemplate := HeaderTemplate(DatabaseData, True);
      Result.FPrimaryIndexTemplate := HeaderTemplate(PrimaryIndexData, False);

      if Length(Extensions) > 2 then
      begin
        RecordFields := MakeRecordFields(Fields);
        DataBlockCount := ReadUInt16LE(DatabaseData, $0C);
        DatabaseRevision := PrimaryIndexData[$2C];
        SecondaryCount := (Length(Extensions) - 2) div 2;
        SetLength(Result.FSecondaryIndexes, SecondaryCount);
        for Index := 0 to SecondaryCount - 1 do
        begin
          DataMemberIndex := -1;
          IndexMemberIndex := -1;
          for MemberIndex := 0 to High(Extensions) do
          begin
            if (Index < 2) and SameText(Extensions[MemberIndex],
              '.XG' + IntToStr(Index)) then
              DataMemberIndex := MemberIndex
            else if (Index < 2) and SameText(Extensions[MemberIndex],
              '.YG' + IntToStr(Index)) then
              IndexMemberIndex := MemberIndex
            else if (Index = 2) and SameText(Extensions[MemberIndex], '.X02') then
              DataMemberIndex := MemberIndex
            else if (Index = 2) and SameText(Extensions[MemberIndex], '.Y02') then
              IndexMemberIndex := MemberIndex;
          end;
          if (DataMemberIndex < 0) or (IndexMemberIndex < 0) then
            raise EDBParadoxFamilySnapshotError.Create(
              'The enumerated secondary-index family is missing a required pair.');
          DiscoverDBParadoxSecondaryFamilyIndex(
            Result.FMembers[DataMemberIndex].Data,
            Result.FMembers[IndexMemberIndex].Data,
            Extensions[DataMemberIndex], Extensions[IndexMemberIndex],
            RecordFields, DatabaseRevision, DataBlockCount,
            Result.FSecondaryIndexes[Index]);
        end;
      end;

      for MemberIndex := 0 to High(Extensions) do
      begin
        CurrentData := LoadFileBytes(
          FamilyBaseName + Extensions[MemberIndex]);
        if not SameBytes(CurrentData, Result.FMembers[MemberIndex].Data) then
          raise EDBParadoxFamilySnapshotError.CreateFmt(
            'Family member "%s" changed while its snapshot was validated.',
            [Extensions[MemberIndex]]);
      end;
    except
      Result.Free;
      Result := nil;
      raise;
    end;
  finally
    Lock.Free;
  end;
end;

function TDBParadoxFamilySnapshot.MemberCount: SizeInt;
begin
  Result := Length(FMembers);
end;

function TDBParadoxFamilySnapshot.CopyMember(
  AIndex: SizeInt): TDBParadoxSnapshotMember;
begin
  if (AIndex < 0) or (AIndex >= Length(FMembers)) then
    raise EDBParadoxFamilySnapshotError.CreateFmt(
      'Snapshot member index %d is out of range.', [AIndex]);
  Result.Extension := FMembers[AIndex].Extension;
  Result.Data := CopyBytes(FMembers[AIndex].Data);
end;

function TDBParadoxFamilySnapshot.CopyMembers: TDBParadoxSnapshotMembers;
begin
  Result := CopySnapshotMembers(FMembers);
end;

function TDBParadoxFamilySnapshot.CopyExpectedFamilyMembers:
  TDBParadoxExpectedFamilyMembers;
var
  Index: SizeInt;
begin
  Result := nil;
  SetLength(Result, Length(FMembers));
  for Index := 0 to High(FMembers) do
  begin
    Result[Index].Extension := FMembers[Index].Extension;
    Result[Index].Data := CopyBytes(FMembers[Index].Data);
  end;
end;

function TDBParadoxFamilySnapshot.CopyFields: TDBParadoxFileFields;
begin
  Result := CopyFileFields(FFields);
end;

function TDBParadoxFamilySnapshot.CopyRows: TDBParadoxFileRows;
begin
  Result := CopyFileRows(FRows);
end;

function TDBParadoxFamilySnapshot.CopyDatabaseTemplate: TBytes;
begin
  Result := CopyBytes(FDatabaseTemplate);
end;

function TDBParadoxFamilySnapshot.CopyPrimaryIndexTemplate: TBytes;
begin
  Result := CopyBytes(FPrimaryIndexTemplate);
end;

function TDBParadoxFamilySnapshot.CopySecondaryIndexes:
  TDBParadoxSecondaryFamilyIndexes;
begin
  Result := CopyFamilyIndexes(FSecondaryIndexes);
end;

function TDBParadoxFamilySnapshot.MatchesCurrentFiles: Boolean;
var
  Index: SizeInt;
  Current: TBytes;
  FamilyBaseName: string;
  CurrentExtensions: TDBParadoxFamilyMembers;
begin
  try
    CurrentExtensions := ResolveFamilyMembers(FTableFileName);
  except
    Exit(False);
  end;
  if not MemberSetsEqual(CurrentExtensions,
    SnapshotMemberExtensions(FMembers)) then
    Exit(False);
  FamilyBaseName := ChangeFileExt(FTableFileName, '');
  for Index := 0 to High(FMembers) do
  begin
    try
      Current := LoadFileBytes(FamilyBaseName + FMembers[Index].Extension);
    except
      Exit(False);
    end;
    if not SameBytes(Current, FMembers[Index].Data) then
      Exit(False);
  end;
  Result := True;
end;

destructor TDBParadoxFamilySnapshot.Destroy;
begin
  inherited Destroy;
end;

end.
