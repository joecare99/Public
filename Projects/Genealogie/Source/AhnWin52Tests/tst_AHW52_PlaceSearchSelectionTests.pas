unit tst_AHW52_PlaceSearchSelectionTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry, Forms, Unit14;

type
  TTestAHW52PlaceSearchSelection = class(TTestCase)
  private
    FCloseEventCount: Integer;
    FGlobalValueAtClose: LongInt;
    FItemIndexAtClose: Integer;
    FPlaceSearchForm: TForm14;
    procedure MakeTestFormInvisible(form: TCustomForm);
    procedure RecordGlobalFormClose(Sender: TObject;
      var CloseAction: TCloseAction);
  published
    procedure TestListClickCopiesSelectedAndUnselectedIndices;
    procedure TestFinishResetsSelectionBeforeClosingGlobalForm;
    procedure TestUnboundCounterIncrementPreservesStrings;
    procedure TestUnboundCounterIncrementClearsStringsAtZero;
    procedure TestUnboundCounterDecrement;
  end;

implementation

uses
  StdCtrls, SysUtils;

procedure TTestAHW52PlaceSearchSelection.MakeTestFormInvisible(
  form: TCustomForm);
begin
  form.AlphaBlend := True;
  form.AlphaBlendValue := 0;
  form.ShowInTaskBar := stNever;
end;

procedure TTestAHW52PlaceSearchSelection.RecordGlobalFormClose(
  Sender: TObject; var CloseAction: TCloseAction);
begin
  Inc(FCloseEventCount);
  FGlobalValueAtClose := GlobalVar_0061DFC0;
  FItemIndexAtClose := FPlaceSearchForm.ListBox1.ItemIndex;
  CloseAction := caHide;
end;

procedure TTestAHW52PlaceSearchSelection.
  TestListClickCopiesSelectedAndUnselectedIndices;
var
  placeSearchForm: TForm14;
begin
  Application.Initialize;
  placeSearchForm := TForm14.CreateNew(nil);
  try
    placeSearchForm.ListBox1 := TListBox.Create(placeSearchForm);
    placeSearchForm.ListBox1.Items.Add('First synthetic place');
    placeSearchForm.ListBox1.Items.Add('Second synthetic place');
    placeSearchForm.ListBox1.ItemIndex := 1;
    GlobalVar_0061DFC0 := -99;
    placeSearchForm.ListBox1Click(placeSearchForm.ListBox1);

    if GlobalVar_0061DFC0 <> 1 then
      raise Exception.CreateFmt('Expected selected index 1, got %d.',
        [GlobalVar_0061DFC0]);

    placeSearchForm.ListBox1.ItemIndex := -1;
    placeSearchForm.ListBox1Click(placeSearchForm.ListBox1);
    if GlobalVar_0061DFC0 <> -1 then
      raise Exception.CreateFmt('Expected no-selection index -1, got %d.',
        [GlobalVar_0061DFC0]);
  finally
    GlobalVar_0061DFC0 := 0;
    placeSearchForm.Free;
  end;
end;

procedure TTestAHW52PlaceSearchSelection.
  TestFinishResetsSelectionBeforeClosingGlobalForm;
var
  receiver: TForm14;
  target: TForm14;
begin
  Application.Initialize;
  FCloseEventCount := 0;
  FGlobalValueAtClose := -1;
  FItemIndexAtClose := -1;
  target := TForm14.CreateNew(nil);
  receiver := TForm14.CreateNew(nil);
  FPlaceSearchForm := receiver;
  try
    receiver.ListBox1 := TListBox.Create(receiver);
    receiver.ListBox1.Items.Add('First synthetic place');
    receiver.ListBox1.Items.Add('Second synthetic place');
    receiver.ListBox1.ItemIndex := 1;
    GlobalVar_0061DFC0 := 42;
    Unit14.Form14 := target;
    MakeTestFormInvisible(target);
    MakeTestFormInvisible(receiver);
    target.OnClose := @RecordGlobalFormClose;
    target.Show;
    receiver.Show;

    receiver.BitBtn1Click(receiver);

    AssertEquals('The saved index should be cleared before close.', 0,
      GlobalVar_0061DFC0);
    AssertEquals('The list selection should be reset before close.', 0,
      receiver.ListBox1.ItemIndex);
    AssertEquals('The global target should receive one close event.', 1,
      FCloseEventCount);
    AssertEquals('The saved index should already be cleared at close.', 0,
      FGlobalValueAtClose);
    AssertEquals('The list selection should already be reset at close.', 0,
      FItemIndexAtClose);
    AssertFalse('The global target should be hidden by the test close action.',
      target.Visible);
    AssertTrue('The method receiver should remain visible.', receiver.Visible);
  finally
    Unit14.Form14 := nil;
    FPlaceSearchForm := nil;
    GlobalVar_0061DFC0 := 0;
    receiver.Free;
    target.Free;
  end;
end;

procedure TTestAHW52PlaceSearchSelection.
  TestUnboundCounterIncrementPreservesStrings;
var
  placeSearchForm: TForm14;
begin
  placeSearchForm := TForm14.CreateNew(nil);
  try
    GlobalVar_0061DFC4 := 7;
    GlobalVar_0061DFBC := 'First synthetic place';
    GlobalVar_0061DFB8 := 'Second synthetic place';

    placeSearchForm._PROC_0053C87C(placeSearchForm);

    AssertEquals(8, GlobalVar_0061DFC4);
    AssertEquals('First synthetic place', GlobalVar_0061DFBC);
    AssertEquals('Second synthetic place', GlobalVar_0061DFB8);
  finally
    GlobalVar_0061DFC4 := 0;
    GlobalVar_0061DFBC := '';
    GlobalVar_0061DFB8 := '';
    placeSearchForm.Free;
  end;
end;

procedure TTestAHW52PlaceSearchSelection.
  TestUnboundCounterIncrementClearsStringsAtZero;
var
  placeSearchForm: TForm14;
begin
  placeSearchForm := TForm14.CreateNew(nil);
  try
    GlobalVar_0061DFC4 := -1;
    GlobalVar_0061DFBC := 'First synthetic place';
    GlobalVar_0061DFB8 := 'Second synthetic place';

    placeSearchForm._PROC_0053C87C(placeSearchForm);

    AssertEquals(0, GlobalVar_0061DFC4);
    AssertEquals('', GlobalVar_0061DFBC);
    AssertEquals('', GlobalVar_0061DFB8);
  finally
    GlobalVar_0061DFC4 := 0;
    GlobalVar_0061DFBC := '';
    GlobalVar_0061DFB8 := '';
    placeSearchForm.Free;
  end;
end;

procedure TTestAHW52PlaceSearchSelection.TestUnboundCounterDecrement;
var
  placeSearchForm: TForm14;
begin
  placeSearchForm := TForm14.CreateNew(nil);
  try
    GlobalVar_0061DFC4 := 7;

    placeSearchForm._PROC_0053C8C0(placeSearchForm);

    AssertEquals(6, GlobalVar_0061DFC4);
  finally
    GlobalVar_0061DFC4 := 0;
    GlobalVar_0061DFBC := '';
    GlobalVar_0061DFB8 := '';
    placeSearchForm.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52PlaceSearchSelection);

end.
