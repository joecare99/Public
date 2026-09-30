unit tst_AHW52_SourceListSelectionTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52SourceListSelection = class(TTestCase)
  published
    procedure TestListClickCopiesSelectedAndUnselectedIndices;
    procedure TestFinishResetsSelectionAndCancelsGlobalForm;
    procedure TestUnboundCounterIncrementPreservesString;
    procedure TestUnboundCounterIncrementClearsStringAtZero;
    procedure TestUnboundCounterDecrement;
  end;

implementation

uses
  Controls, Forms, StdCtrls, SysUtils, Unit29;

procedure TTestAHW52SourceListSelection.
  TestFinishResetsSelectionAndCancelsGlobalForm;
var
  receiver: TForm29;
  target: TForm29;
begin
  Application.Initialize;
  receiver := TForm29.CreateNew(nil);
  target := TForm29.CreateNew(nil);
  try
    receiver.ListBox1 := TListBox.Create(receiver);
    receiver.ListBox1.Items.Add('First synthetic source');
    receiver.ListBox1.Items.Add('Second synthetic source');
    receiver.ListBox1.ItemIndex := 1;
    GlobalVar_0061E0F0 := 42;
    target.ModalResult := mrNone;
    receiver.ModalResult := mrNone;
    Unit29.Form29 := target;

    receiver.SpeedButton1Click(receiver);

    AssertEquals('The saved source index should be cleared.', 0,
      GlobalVar_0061E0F0);
    AssertEquals('The source list should select its first item.', 0,
      receiver.ListBox1.ItemIndex);
    AssertEquals('The global target should receive the cancel result.',
      mrCancel, target.ModalResult);
    AssertEquals('The receiver should not receive the modal result.', mrNone,
      receiver.ModalResult);
  finally
    Unit29.Form29 := nil;
    GlobalVar_0061E0F0 := 0;
    receiver.Free;
    target.Free;
  end;
end;

procedure TTestAHW52SourceListSelection.
  TestListClickCopiesSelectedAndUnselectedIndices;
var
  sourceForm: TForm29;
begin
  Application.Initialize;
  sourceForm := TForm29.CreateNew(nil);
  try
    sourceForm.ListBox1 := TListBox.Create(sourceForm);
    sourceForm.ListBox1.Items.Add('First synthetic source');
    sourceForm.ListBox1.Items.Add('Second synthetic source');
    sourceForm.ListBox1.ItemIndex := 1;
    GlobalVar_0061E0F0 := -99;
    sourceForm.ListBox1Click(sourceForm.ListBox1);

    if GlobalVar_0061E0F0 <> 1 then
      raise Exception.CreateFmt('Expected selected index 1, got %d.',
        [GlobalVar_0061E0F0]);

    sourceForm.ListBox1.ItemIndex := -1;
    sourceForm.ListBox1Click(sourceForm.ListBox1);
    if GlobalVar_0061E0F0 <> -1 then
      raise Exception.CreateFmt('Expected no-selection index -1, got %d.',
        [GlobalVar_0061E0F0]);
  finally
    GlobalVar_0061E0F0 := 0;
    sourceForm.Free;
  end;
end;

procedure TTestAHW52SourceListSelection.
  TestUnboundCounterIncrementPreservesString;
var
  sourceForm: TForm29;
begin
  sourceForm := TForm29.CreateNew(nil);
  try
    GlobalVar_0061E0F4 := 2;
    GlobalVar_0061E0EC := 'Synthetic source';

    sourceForm._PROC_00562290(sourceForm);

    AssertEquals(3, GlobalVar_0061E0F4);
    AssertEquals('Synthetic source', GlobalVar_0061E0EC);
  finally
    GlobalVar_0061E0F4 := 0;
    GlobalVar_0061E0EC := '';
    sourceForm.Free;
  end;
end;

procedure TTestAHW52SourceListSelection.
  TestUnboundCounterIncrementClearsStringAtZero;
var
  sourceForm: TForm29;
begin
  sourceForm := TForm29.CreateNew(nil);
  try
    GlobalVar_0061E0F4 := -1;
    GlobalVar_0061E0EC := 'Synthetic source';

    sourceForm._PROC_00562290(sourceForm);

    AssertEquals(0, GlobalVar_0061E0F4);
    AssertEquals('', GlobalVar_0061E0EC);
  finally
    GlobalVar_0061E0F4 := 0;
    GlobalVar_0061E0EC := '';
    sourceForm.Free;
  end;
end;

procedure TTestAHW52SourceListSelection.TestUnboundCounterDecrement;
var
  sourceForm: TForm29;
begin
  sourceForm := TForm29.CreateNew(nil);
  try
    GlobalVar_0061E0F4 := 2;

    sourceForm._PROC_005622CC(sourceForm);

    AssertEquals(1, GlobalVar_0061E0F4);
  finally
    GlobalVar_0061E0F4 := 0;
    GlobalVar_0061E0EC := '';
    sourceForm.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52SourceListSelection);

end.
