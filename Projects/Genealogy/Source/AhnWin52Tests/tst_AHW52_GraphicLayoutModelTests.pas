unit tst_AHW52_GraphicLayoutModelTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52GraphicLayoutModel = class(TTestCase)
  published
    procedure TestPassSkipsLevelsBelowTwoAndHandlesShortInput;
    procedure TestPassProcessesLevelsThroughMaximumInclusive;
    procedure TestPassRequiresMatchingAdjacentLevelMarkers;
    procedure TestPassIncrementsOnlyWhenCurrentValueIsAtLeastNextValue;
    procedure TestEarlierMutationIsVisibleToNextAdjacentPair;
    procedure TestSlot00AdjustmentUsesLeftChildAndPropagatesDelta;
    procedure TestSlot00AdjustmentUsesPowerSelectedStartIndex;
    procedure TestSlot00AdjustmentUsesSignedValueChecks;
    procedure TestSlot04AdjustmentUsesRightChildAndSlot00Comparison;
    procedure TestSlot04AdjustmentUsesSignedComparisonValues;
    procedure TestSlot00ReflowCopiesPositiveLeftChild;
    procedure TestSlot04ReflowCopiesPositiveRightChild;
    procedure TestActiveEntrySelectorsUseContiguousPrefixAndMaximumMarker;
    procedure TestActiveEntrySelectorsDispatchToTheMatchingModelPass;
    procedure TestLayoutMethodsRejectMissingRequiredProjectionEntries;
  end;

implementation

uses
  Unit13GraphicLayoutModel;

procedure TTestAHW52GraphicLayoutModel.
  TestPassSkipsLevelsBelowTwoAndHandlesShortInput;
var
  entries: TGraphicLayoutEntryProjections;
begin
  entries := nil;
  SetLength(entries, 2);
  entries[0].Slot00 := 4;
  entries[0].Slot14 := 2;
  entries[1].Slot00 := 3;
  entries[1].Slot14 := 2;
  PropagateGraphicLayoutPrimaryValues(entries, 1);
  AssertEquals('A maximum level below two leaves the entries unchanged.',
    3, entries[1].Slot00);

  SetLength(entries, 1);
  entries[0].Slot00 := 8;
  entries[0].Slot14 := 2;
  PropagateGraphicLayoutPrimaryValues(entries, 2);
  AssertEquals('A single entry has no adjacent pair to update.',
    8, entries[0].Slot00);

  SetLength(entries, 0);
  PropagateGraphicLayoutPrimaryValues(entries, 2);
  AssertEquals('An empty projection remains empty.', 0, Length(entries));
end;

procedure TTestAHW52GraphicLayoutModel.
  TestPassProcessesLevelsThroughMaximumInclusive;
var
  entries: TGraphicLayoutEntryProjections;
begin
  entries := nil;
  SetLength(entries, 6);
  entries[0].Slot00 := 5;
  entries[0].Slot14 := 2;
  entries[1].Slot00 := 5;
  entries[1].Slot14 := 2;
  entries[2].Slot00 := 7;
  entries[2].Slot14 := 3;
  entries[3].Slot00 := 7;
  entries[3].Slot14 := 3;
  entries[4].Slot00 := 9;
  entries[4].Slot14 := 4;
  entries[5].Slot00 := 9;
  entries[5].Slot14 := 4;

  PropagateGraphicLayoutPrimaryValues(entries, 3);

  AssertEquals('Level two is processed.', 6, entries[1].Slot00);
  AssertEquals('The inclusive maximum level is processed.',
    8, entries[3].Slot00);
  AssertEquals('The next level is not processed.',
    9, entries[5].Slot00);
  AssertEquals('Matching level markers are not modified.',
    3, entries[3].Slot14);
end;

procedure TTestAHW52GraphicLayoutModel.
  TestPassRequiresMatchingAdjacentLevelMarkers;
var
  entries: TGraphicLayoutEntryProjections;
begin
  entries := nil;
  SetLength(entries, 5);
  entries[0].Slot00 := 10;
  entries[0].Slot14 := 2;
  entries[1].Slot00 := 1;
  entries[1].Slot14 := 3;
  entries[2].Slot00 := 2;
  entries[2].Slot14 := 2;
  entries[3].Slot00 := 2;
  entries[3].Slot14 := 2;

  PropagateGraphicLayoutPrimaryValues(entries, 3);

  AssertEquals('A pair with different level markers is skipped.',
    1, entries[1].Slot00);
  AssertEquals('The adjacent matching pair is processed.',
    3, entries[3].Slot00);
  AssertEquals('Level markers remain unchanged.', 3, entries[1].Slot14);
end;

procedure TTestAHW52GraphicLayoutModel.
  TestPassIncrementsOnlyWhenCurrentValueIsAtLeastNextValue;
var
  entries: TGraphicLayoutEntryProjections;
begin
  entries := nil;
  SetLength(entries, 14);
  entries[0].Slot00 := 9;
  entries[0].Slot14 := 2;
  entries[1].Slot00 := 4;
  entries[1].Slot14 := 2;
  entries[2].Slot14 := 3;
  entries[3].Slot00 := 3;
  entries[3].Slot14 := 2;
  entries[4].Slot00 := 5;
  entries[4].Slot14 := 2;
  entries[5].Slot14 := 3;
  entries[6].Slot00 := 2;
  entries[6].Slot14 := 2;
  entries[7].Slot00 := 2;
  entries[7].Slot14 := 2;
  entries[8].Slot14 := 3;
  entries[9].Slot00 := -1;
  entries[9].Slot14 := 2;
  entries[10].Slot00 := 0;
  entries[10].Slot14 := 2;
  entries[11].Slot14 := 3;
  entries[12].Slot00 := 0;
  entries[12].Slot14 := 2;
  entries[13].Slot00 := -1;
  entries[13].Slot14 := 2;

  PropagateGraphicLayoutPrimaryValues(entries, 3);

  AssertEquals('A greater current value increments the next value.',
    5, entries[1].Slot00);
  AssertEquals('A lower current value leaves the next value unchanged.',
    5, entries[4].Slot00);
  AssertEquals('Equal values increment the next value.',
    3, entries[7].Slot00);
  AssertEquals('The signed comparison does not treat a negative value as unsigned.',
    0, entries[10].Slot00);
  AssertEquals('Zero is greater than a negative next value.',
    0, entries[13].Slot00);
end;

procedure TTestAHW52GraphicLayoutModel.
  TestEarlierMutationIsVisibleToNextAdjacentPair;
var
  entries: TGraphicLayoutEntryProjections;
begin
  entries := nil;
  SetLength(entries, 3);
  entries[0].Slot00 := 5;
  entries[0].Slot14 := 2;
  entries[1].Slot00 := 5;
  entries[1].Slot14 := 2;
  entries[2].Slot00 := 6;
  entries[2].Slot14 := 2;

  PropagateGraphicLayoutPrimaryValues(entries, 2);

  AssertEquals('The first adjacent pair increments the middle value.',
    6, entries[1].Slot00);
  AssertEquals('The second pair observes that updated middle value.',
    7, entries[2].Slot00);
end;

procedure TTestAHW52GraphicLayoutModel.
  TestSlot00AdjustmentUsesLeftChildAndPropagatesDelta;
var
  entries: TGraphicLayoutEntryProjections;
begin
  entries := nil;
  SetLength(entries, 10);
  entries[1].Slot00 := 1;
  entries[2].Slot00 := 5;
  entries[2].Slot14 := 2;
  entries[3].Slot00 := 1;
  entries[3].Slot14 := 3;
  entries[4].Slot00 := 1;
  entries[4].Slot14 := 3;
  entries[5].Slot00 := 2;
  entries[5].Slot14 := 3;
  entries[6].Slot00 := 3;
  entries[6].Slot14 := 3;

  AdjustGraphicLayoutSlot00(entries, 3);

  AssertEquals('The positive left-child slot is set and receives the propagated delta.',
    8, entries[5].Slot00);
  AssertEquals('Positive entries in the next marked run receive the delta.',
    6, entries[6].Slot00);
  AssertEquals('An unrelated slot remains unchanged.',
    0, entries[5].Slot04);
end;

procedure TTestAHW52GraphicLayoutModel.
  TestSlot00AdjustmentUsesPowerSelectedStartIndex;
var
  entries: TGraphicLayoutEntryProjections;
begin
  entries := nil;
  SetLength(entries, 16);
  entries[3].Slot00 := 1;
  entries[4].Slot00 := 5;
  entries[4].Slot14 := 3;
  entries[9].Slot00 := 2;
  entries[9].Slot14 := 4;

  AdjustGraphicLayoutSlot00(entries, 4);

  AssertEquals('Round(Power(2, 2)) selects the next parent scan boundary.',
    5, entries[9].Slot00);
end;

procedure TTestAHW52GraphicLayoutModel.
  TestSlot00AdjustmentUsesSignedValueChecks;
var
  entries: TGraphicLayoutEntryProjections;
begin
  entries := nil;
  SetLength(entries, 10);
  entries[1].Slot00 := 1;
  entries[2].Slot00 := -3;
  entries[2].Slot14 := 2;
  entries[5].Slot00 := -1;
  entries[5].Slot14 := 3;
  entries[6].Slot00 := 2;
  entries[6].Slot14 := 3;

  AdjustGraphicLayoutSlot00(entries, 3);

  AssertEquals('A negative left child is not treated as a positive branch.',
    -1, entries[5].Slot00);
  AssertEquals('Signed comparison prevents raising a negative parent to a positive child.',
    2, entries[6].Slot00);
end;

procedure TTestAHW52GraphicLayoutModel.
  TestSlot04AdjustmentUsesRightChildAndSlot00Comparison;
var
  entries: TGraphicLayoutEntryProjections;
begin
  entries := nil;
  SetLength(entries, 10);
  entries[1].Slot04 := 1;
  entries[2].Slot14 := 2;
  entries[2].Slot04 := 8;
  entries[5].Slot04 := -1;
  entries[5].Slot14 := 3;
  entries[6].Slot04 := 3;
  entries[6].Slot00 := 2;
  entries[6].Slot14 := 3;
  entries[7].Slot04 := 1;
  entries[7].Slot14 := 3;

  AdjustGraphicLayoutSlot04(entries, 3);

  AssertEquals('The right child slot is set from the parent slot.',
    8, entries[6].Slot04);
  AssertEquals('The slot-00 comparison delta is propagated on each pass.',
    19, entries[7].Slot04);
  AssertEquals('Slot 00 is only read and remains unchanged.',
    2, entries[6].Slot00);
end;

procedure TTestAHW52GraphicLayoutModel.
  TestSlot04AdjustmentUsesSignedComparisonValues;
var
  entries: TGraphicLayoutEntryProjections;
begin
  entries := nil;
  SetLength(entries, 10);
  entries[1].Slot04 := 1;
  entries[2].Slot04 := -1;
  entries[2].Slot14 := 2;
  entries[5].Slot04 := -1;
  entries[5].Slot14 := 3;
  entries[6].Slot04 := 1;
  entries[6].Slot00 := -2;
  entries[6].Slot14 := 3;
  entries[7].Slot04 := 2;
  entries[7].Slot14 := 3;

  AdjustGraphicLayoutSlot04(entries, 3);

  AssertEquals('The signed slot-00 comparison selects the right-child branch.',
    -1, entries[6].Slot04);
  AssertEquals('Only positive matching descendants receive the slot delta.',
    3, entries[7].Slot04);
end;

procedure TTestAHW52GraphicLayoutModel.
  TestSlot00ReflowCopiesPositiveLeftChild;
var
  entries: TGraphicLayoutEntryProjections;
begin
  entries := nil;
  SetLength(entries, 10);
  entries[1].Slot00 := 1;
  entries[2].Slot00 := 4;
  entries[2].Slot14 := 2;
  entries[3].Slot00 := 2;
  entries[3].Slot14 := 3;
  entries[5].Slot00 := 8;
  entries[5].Slot14 := 3;
  entries[6].Slot00 := 1;
  entries[6].Slot14 := 3;

  ReflowGraphicLayoutSlot00(entries, 3);

  AssertEquals('The positive left-child value replaces the parent value.',
    8, entries[2].Slot00);
  AssertEquals('The offset difference propagates across matching entries.',
    6, entries[3].Slot00);
end;

procedure TTestAHW52GraphicLayoutModel.
  TestSlot04ReflowCopiesPositiveRightChild;
var
  entries: TGraphicLayoutEntryProjections;
begin
  entries := nil;
  SetLength(entries, 10);
  entries[1].Slot04 := 1;
  entries[2].Slot04 := 4;
  entries[2].Slot14 := 2;
  entries[3].Slot04 := 1;
  entries[3].Slot14 := 3;
  entries[5].Slot04 := 0;
  entries[5].Slot14 := 3;
  entries[6].Slot04 := 8;
  entries[6].Slot14 := 3;

  ReflowGraphicLayoutSlot04(entries, 3);

  AssertEquals('The positive right-child slot replaces the parent slot.',
    8, entries[2].Slot04);
  AssertEquals('The offset difference propagates to a positive matching slot.',
    5, entries[3].Slot04);
end;

procedure TTestAHW52GraphicLayoutModel.
  TestActiveEntrySelectorsUseContiguousPrefixAndMaximumMarker;
var
  entries: TGraphicLayoutEntryProjections;
begin
  entries := nil;
  SetLength(entries, 5);
  entries[0].Slot08 := 1;
  entries[0].Slot14 := 2;
  entries[1].Slot08 := 1;
  entries[1].Slot14 := 5;
  entries[2].Slot08 := 1;
  entries[2].Slot14 := 5;
  entries[3].Slot08 := 0;
  entries[3].Slot14 := 12;
  entries[4].Slot08 := 1;
  entries[4].Slot14 := 14;

  AssertEquals('Only the active contiguous prefix contributes to the maximum.',
    5, FindMaximumActiveGraphicLayoutLevel(entries));

  entries := nil;
  SetLength(entries, 2);
  entries[0].Slot08 := 1;
  entries[0].Slot14 := -3;
  AssertEquals('Negative markers do not replace the selector zero baseline.',
    0, FindMaximumActiveGraphicLayoutLevel(entries));

  entries := nil;
  AssertEquals('An empty projection has no active level.',
    0, FindMaximumActiveGraphicLayoutLevel(entries));
  ReflowGraphicLayoutSlot00ForActiveEntries(entries);
  ReflowGraphicLayoutSlot04ForActiveEntries(entries);
  AssertEquals('Both empty active-entry selectors remain no-ops.',
    0, Length(entries));
end;

procedure TTestAHW52GraphicLayoutModel.
  TestActiveEntrySelectorsDispatchToTheMatchingModelPass;
var
  entries: TGraphicLayoutEntryProjections;
begin
  entries := nil;
  SetLength(entries, 10);
  entries[0].Slot08 := 1;
  entries[0].Slot14 := 2;
  entries[1].Slot08 := 1;
  entries[1].Slot14 := 3;
  entries[1].Slot00 := 1;
  entries[2].Slot00 := 4;
  entries[2].Slot14 := 2;
  entries[3].Slot00 := 2;
  entries[3].Slot14 := 3;
  entries[5].Slot00 := 8;
  entries[5].Slot14 := 3;
  entries[6].Slot00 := 1;
  entries[6].Slot14 := 3;

  ReflowGraphicLayoutSlot00ForActiveEntries(entries);

  AssertEquals('The active-prefix maximum dispatches the slot-00 pass.',
    8, entries[2].Slot00);

  entries := nil;
  SetLength(entries, 10);
  entries[0].Slot08 := 1;
  entries[0].Slot14 := 2;
  entries[1].Slot08 := 1;
  entries[1].Slot14 := 3;
  entries[1].Slot04 := 1;
  entries[2].Slot04 := 4;
  entries[2].Slot14 := 2;
  entries[5].Slot14 := 3;
  entries[6].Slot04 := 8;
  entries[6].Slot14 := 3;

  ReflowGraphicLayoutSlot04ForActiveEntries(entries);

  AssertEquals('The active-prefix maximum dispatches the slot-04 pass.',
    8, entries[2].Slot04);
end;

procedure TTestAHW52GraphicLayoutModel.
  TestLayoutMethodsRejectMissingRequiredProjectionEntries;
var
  entries: TGraphicLayoutEntryProjections;
  raised: Boolean;
begin
  entries := nil;
  SetLength(entries, 3);
  entries[1].Slot00 := 1;
  entries[2].Slot00 := 1;
  entries[2].Slot14 := 2;
  raised := False;
  try
    AdjustGraphicLayoutSlot00(entries, 3);
  except
    on EGraphicLayoutProjectionBounds do
      raised := True;
  end;
  AssertTrue('A projection missing a required binary-tree entry is rejected.',
    raised);
end;

initialization
  RegisterTest(TTestAHW52GraphicLayoutModel);

end.
