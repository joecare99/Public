unit Unit13GraphicLayoutModel;

{$mode objfpc}{$H+}

interface

uses
  SysUtils;

type
  EGraphicLayoutProjectionBounds = class(Exception);

  { Projection of only the integer slots observed in the recovered listings. }
  TGraphicLayoutEntryProjection = record
    Slot00: LongInt;
    Slot04: LongInt;
    Slot08: LongInt;
    Slot14: LongInt;
  end;

  TGraphicLayoutEntryProjections = array of TGraphicLayoutEntryProjection;

procedure PropagateGraphicLayoutPrimaryValues(
  var Entries: TGraphicLayoutEntryProjections; MaximumLevel: LongInt);
procedure AdjustGraphicLayoutSlot00(
  var Entries: TGraphicLayoutEntryProjections; MaximumLevel: LongInt);
procedure AdjustGraphicLayoutSlot04(
  var Entries: TGraphicLayoutEntryProjections; MaximumLevel: LongInt);
procedure ReflowGraphicLayoutSlot00(
  var Entries: TGraphicLayoutEntryProjections; MaximumLevel: LongInt);
procedure ReflowGraphicLayoutSlot04(
  var Entries: TGraphicLayoutEntryProjections; MaximumLevel: LongInt);
function FindMaximumActiveGraphicLayoutLevel(
  const Entries: TGraphicLayoutEntryProjections): LongInt;
procedure ReflowGraphicLayoutSlot00ForActiveEntries(
  var Entries: TGraphicLayoutEntryProjections);
procedure ReflowGraphicLayoutSlot04ForActiveEntries(
  var Entries: TGraphicLayoutEntryProjections);

implementation

uses
  Math;

type
  TGraphicLayoutSlot = (glsSlot00, glsSlot04);

function ReadSlot(const Entries: TGraphicLayoutEntryProjections;
  EntryIndex: SizeInt; Slot: TGraphicLayoutSlot): LongInt;
begin
  if (EntryIndex < 0) or (EntryIndex >= Length(Entries)) then
    raise EGraphicLayoutProjectionBounds.CreateFmt(
      'Graphic-layout projection index %d is outside 0..%d.',
      [EntryIndex, Length(Entries) - 1]);

  case Slot of
    glsSlot00:
      Result := Entries[EntryIndex].Slot00;
    glsSlot04:
      Result := Entries[EntryIndex].Slot04;
  end;
end;

procedure WriteSlot(var Entries: TGraphicLayoutEntryProjections;
  EntryIndex: SizeInt; Slot: TGraphicLayoutSlot; Value: LongInt);
begin
  if (EntryIndex < 0) or (EntryIndex >= Length(Entries)) then
    raise EGraphicLayoutProjectionBounds.CreateFmt(
      'Graphic-layout projection index %d is outside 0..%d.',
      [EntryIndex, Length(Entries) - 1]);

  case Slot of
    glsSlot00:
      Entries[EntryIndex].Slot00 := Value;
    glsSlot04:
      Entries[EntryIndex].Slot04 := Value;
  end;
end;

function RequireEntryIndex(Index: Int64;
  const Entries: TGraphicLayoutEntryProjections): SizeInt;
begin
  if (Index < 0) or (Index >= Length(Entries)) then
    raise EGraphicLayoutProjectionBounds.CreateFmt(
      'Graphic-layout projection requires entry %d; available entry indexes are 0..%d.',
      [Index, Length(Entries) - 1]);
  Result := SizeInt(Index);
end;

function FirstBinaryEntryIndex(MaximumLevel: LongInt;
  const Entries: TGraphicLayoutEntryProjections): SizeInt;
var
  exponent: LongInt;
  roundedIndex: Int64;
begin
  exponent := MaximumLevel - 1;
  if exponent > 30 then
    raise EGraphicLayoutProjectionBounds.CreateFmt(
      'Graphic-layout level %d exceeds the supported Power index range.',
      [MaximumLevel]);

  roundedIndex := Round(Power(2.0, exponent));
  Result := RequireEntryIndex(roundedIndex - 1, Entries);
end;

function FindFirstNonZeroSlot(const Entries: TGraphicLayoutEntryProjections;
  StartIndex: SizeInt; Slot: TGraphicLayoutSlot): SizeInt;
begin
  Result := StartIndex;
  while Result < Length(Entries) do
  begin
    if ReadSlot(Entries, Result, Slot) <> 0 then
      Exit;
    Inc(Result);
  end;
  raise EGraphicLayoutProjectionBounds.CreateFmt(
    'Graphic-layout projection contains no nonzero anchor at or after entry %d.',
    [StartIndex]);
end;

function ChildEntryIndex(ParentIndex: SizeInt; IsRightChild: Boolean;
  const Entries: TGraphicLayoutEntryProjections): SizeInt;
var
  index: Int64;
begin
  index := Int64(ParentIndex) * 2 + 1;
  if IsRightChild then
    Inc(index);
  Result := RequireEntryIndex(index, Entries);
end;

procedure PropagateSlotDelta(var Entries: TGraphicLayoutEntryProjections;
  StartIndex: SizeInt; TargetLevel: LongInt; Slot: TGraphicLayoutSlot;
  Delta: LongInt);
var
  entryIndex: SizeInt;
  value: LongInt;
begin
  if (StartIndex < 0) or (StartIndex >= Length(Entries)) then
    raise EGraphicLayoutProjectionBounds.CreateFmt(
      'Graphic-layout delta propagation requires entry %d.',
      [StartIndex]);

  entryIndex := StartIndex;
  while (entryIndex < Length(Entries)) and
    (Entries[entryIndex].Slot14 = TargetLevel) do
  begin
    value := ReadSlot(Entries, entryIndex, Slot);
    if value > 0 then
      WriteSlot(Entries, entryIndex, Slot, value + Delta);
    Inc(entryIndex);
  end;
  if entryIndex = Length(Entries) then
    raise EGraphicLayoutProjectionBounds.CreateFmt(
      'Graphic-layout level %d continues beyond the supplied projection.',
      [TargetLevel]);
end;

procedure AdjustGraphicLayoutSlot(var Entries: TGraphicLayoutEntryProjections;
  MaximumLevel: LongInt; Slot: TGraphicLayoutSlot);
var
  pass: LongInt;
  level: LongInt;
  firstIndex: SizeInt;
  parentIndex: SizeInt;
  leftChildIndex: SizeInt;
  rightChildIndex: SizeInt;
  parentValue: LongInt;
  leftValue: LongInt;
  rightValue: LongInt;
  comparisonValue: LongInt;
  delta: LongInt;
begin
  if MaximumLevel <= 0 then
    Exit;

  for pass := 1 to MaximumLevel do
  begin
    level := MaximumLevel - 1;
    while level > 1 do
    begin
      firstIndex := FindFirstNonZeroSlot(Entries,
        FirstBinaryEntryIndex(level, Entries), Slot);
      firstIndex := RequireEntryIndex(Int64(firstIndex) + 1, Entries);
      while (firstIndex < Length(Entries)) and
        (Entries[firstIndex].Slot14 = level) do
      begin
        parentIndex := firstIndex;
        leftChildIndex := ChildEntryIndex(parentIndex, False, Entries);
        leftValue := ReadSlot(Entries, leftChildIndex, Slot);
        parentValue := ReadSlot(Entries, parentIndex, Slot);

        if leftValue > 0 then
        begin
          if leftValue < parentValue then
          begin
            delta := parentValue - leftValue;
            WriteSlot(Entries, leftChildIndex, Slot, parentValue);
            PropagateSlotDelta(Entries, parentIndex + 1, level + 1,
              Slot, delta);
          end;
        end
        else
        begin
          rightChildIndex := ChildEntryIndex(parentIndex, True, Entries);
          rightValue := ReadSlot(Entries, rightChildIndex, Slot);
          if rightValue > 0 then
          begin
            if Slot = glsSlot04 then
              comparisonValue := Entries[rightChildIndex].Slot00
            else
              comparisonValue := rightValue;

            if parentValue > comparisonValue then
            begin
              delta := parentValue - comparisonValue;
              WriteSlot(Entries, rightChildIndex, Slot, parentValue);
              PropagateSlotDelta(Entries, rightChildIndex + 1, level + 1,
                Slot, delta);
            end;
          end;
        end;
        Inc(firstIndex);
      end;
      Dec(level);
    end;
  end;
end;

procedure ReflowGraphicLayoutSlot(var Entries: TGraphicLayoutEntryProjections;
  MaximumLevel: LongInt; Slot: TGraphicLayoutSlot);
var
  level: LongInt;
  firstIndex: SizeInt;
  parentIndex: SizeInt;
  rightIndex: SizeInt;
  leftChildIndex: SizeInt;
  rightChildIndex: SizeInt;
  parentValue: LongInt;
  leftValue: LongInt;
  rightValue: LongInt;
  delta: LongInt;
begin
  if MaximumLevel <= 0 then
    Exit;

  level := MaximumLevel - 1;
  while level >= 1 do
  begin
    firstIndex := FindFirstNonZeroSlot(Entries,
      FirstBinaryEntryIndex(level, Entries), Slot);
    firstIndex := RequireEntryIndex(Int64(firstIndex) + 1, Entries);
    while (firstIndex < Length(Entries)) and
      (Entries[firstIndex].Slot14 = level) do
    begin
      parentIndex := firstIndex;
      rightIndex := RequireEntryIndex(Int64(parentIndex) + 1, Entries);
      leftChildIndex := ChildEntryIndex(parentIndex, False, Entries);

      if (ReadSlot(Entries, rightIndex, Slot) > 0) and
        (ReadSlot(Entries, leftChildIndex, Slot) = 0) then
      begin
        rightChildIndex := ChildEntryIndex(parentIndex, True, Entries);
        if ReadSlot(Entries, rightChildIndex, Slot) = 0 then
          AdjustGraphicLayoutSlot(Entries, MaximumLevel, Slot);
      end;

      leftValue := ReadSlot(Entries, leftChildIndex, Slot);
      parentValue := ReadSlot(Entries, parentIndex, Slot);
      if leftValue > 0 then
      begin
        if leftValue <> parentValue then
        begin
          delta := leftValue - parentValue;
          WriteSlot(Entries, parentIndex, Slot, leftValue);
          PropagateSlotDelta(Entries, parentIndex + 1, level + 1,
            Slot, delta);
        end;
      end
      else
      begin
        rightChildIndex := ChildEntryIndex(parentIndex, True, Entries);
        rightValue := ReadSlot(Entries, rightChildIndex, Slot);
        if (rightValue > 0) and (rightValue <> parentValue) then
        begin
          delta := rightValue - parentValue;
          WriteSlot(Entries, parentIndex, Slot, rightValue);
          PropagateSlotDelta(Entries, parentIndex + 1, level + 1,
            Slot, delta);
        end;
      end;
      Inc(firstIndex);
    end;
    Dec(level);
  end;
end;

procedure PropagateGraphicLayoutPrimaryValues(
  var Entries: TGraphicLayoutEntryProjections; MaximumLevel: LongInt);
var
  entryIndex: SizeInt;
  level: LongInt;
begin
  if (MaximumLevel < 2) or (Length(Entries) < 2) then
    Exit;

  for level := 2 to MaximumLevel do
    for entryIndex := 0 to Length(Entries) - 2 do
    begin
      if Entries[entryIndex].Slot14 <> level then
        Continue;
      if Entries[entryIndex + 1].Slot14 <> Entries[entryIndex].Slot14 then
        Continue;
      if Entries[entryIndex].Slot00 >= Entries[entryIndex + 1].Slot00 then
        Inc(Entries[entryIndex + 1].Slot00);
    end;
end;

procedure AdjustGraphicLayoutSlot00(
  var Entries: TGraphicLayoutEntryProjections; MaximumLevel: LongInt);
begin
  AdjustGraphicLayoutSlot(Entries, MaximumLevel, glsSlot00);
end;

procedure AdjustGraphicLayoutSlot04(
  var Entries: TGraphicLayoutEntryProjections; MaximumLevel: LongInt);
begin
  AdjustGraphicLayoutSlot(Entries, MaximumLevel, glsSlot04);
end;

procedure ReflowGraphicLayoutSlot00(
  var Entries: TGraphicLayoutEntryProjections; MaximumLevel: LongInt);
begin
  ReflowGraphicLayoutSlot(Entries, MaximumLevel, glsSlot00);
end;

procedure ReflowGraphicLayoutSlot04(
  var Entries: TGraphicLayoutEntryProjections; MaximumLevel: LongInt);
begin
  ReflowGraphicLayoutSlot(Entries, MaximumLevel, glsSlot04);
end;

function FindMaximumActiveGraphicLayoutLevel(
  const Entries: TGraphicLayoutEntryProjections): LongInt;
var
  entryIndex: SizeInt;
begin
  Result := 0;
  for entryIndex := 0 to Length(Entries) - 1 do
  begin
    if Entries[entryIndex].Slot08 <= 0 then
      Break;
    if Entries[entryIndex].Slot14 > Result then
      Result := Entries[entryIndex].Slot14;
  end;
end;

procedure ReflowGraphicLayoutSlot00ForActiveEntries(
  var Entries: TGraphicLayoutEntryProjections);
begin
  ReflowGraphicLayoutSlot00(Entries,
    FindMaximumActiveGraphicLayoutLevel(Entries));
end;

procedure ReflowGraphicLayoutSlot04ForActiveEntries(
  var Entries: TGraphicLayoutEntryProjections);
begin
  ReflowGraphicLayoutSlot04(Entries,
    FindMaximumActiveGraphicLayoutLevel(Entries));
end;

end.
