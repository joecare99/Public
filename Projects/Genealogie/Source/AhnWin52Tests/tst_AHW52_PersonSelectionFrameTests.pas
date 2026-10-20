unit tst_AHW52_PersonSelectionFrameTests;

{$mode objfpc}{$H+}

interface

uses
  Classes, Controls, fpcunit, testregistry;

type
  TTestAHW52PersonSelectionFrame = class(TTestCase)
  published
    procedure TestFrameStreamsSelectionGridAndEvents;
    procedure TestMainFormBindsSelectionTabEventsThroughFrame;
    procedure TestMainFormStreamsSelectionFrameIntoSelectionTab;
  end;

implementation

uses
  AHW52PersonSelectionFrame, ComCtrls, Forms, frmAhnenWinMain;

procedure TTestAHW52PersonSelectionFrame.TestFrameStreamsSelectionGridAndEvents;
var
  selectionFrame: TAHW52PersonSelectionFrame;
begin
  Application.Initialize;
  selectionFrame := TAHW52PersonSelectionFrame.Create(nil);
  try
    AssertEquals('The selection grid should retain all nine columns.',
      9, selectionFrame.DBGrid1.Columns.Count);
    AssertEquals('Nummer', selectionFrame.DBGrid1.Columns[0].FieldName);
    AssertEquals('Name', selectionFrame.DBGrid1.Columns[1].FieldName);
    AssertEquals('Vornamen', selectionFrame.DBGrid1.Columns[2].FieldName);
    AssertEquals('Gebjahr', selectionFrame.DBGrid1.Columns[3].FieldName);
    AssertEquals('Gebort', selectionFrame.DBGrid1.Columns[4].FieldName);
    AssertEquals('Taufjahr', selectionFrame.DBGrid1.Columns[5].FieldName);
    AssertEquals('Taufort', selectionFrame.DBGrid1.Columns[6].FieldName);
    AssertEquals('Stjahr', selectionFrame.DBGrid1.Columns[7].FieldName);
    AssertEquals('IDNR', selectionFrame.DBGrid1.Columns[8].FieldName);
    AssertTrue('The grid double-click event should be streamed.',
      Assigned(selectionFrame.DBGrid1.OnDblClick));
    AssertTrue('The grid key-down event should be streamed.',
      Assigned(selectionFrame.DBGrid1.OnKeyDown));
  finally
    selectionFrame.Free;
  end;
end;

procedure TTestAHW52PersonSelectionFrame.
  TestMainFormBindsSelectionTabEventsThroughFrame;
var
  mainForm: TForm1;
  pageControl: TPageControl;
  selectionTab: TTabSheet;
  selectionFrame: TAHW52PersonSelectionFrame;
begin
  Application.Initialize;
  mainForm := TForm1.CreateNew(nil);
  try
    pageControl := TPageControl.Create(mainForm);
    pageControl.Parent := mainForm;
    selectionTab := TTabSheet.Create(mainForm);
    selectionTab.PageControl := pageControl;
    selectionFrame := TAHW52PersonSelectionFrame.Create(mainForm);
    selectionFrame.Parent := selectionTab;
    selectionFrame.Align := alClient;
    mainForm.PageControl1 := pageControl;
    mainForm.TabSheet1 := selectionTab;
    mainForm.PersonSelectionFrame := selectionFrame;

    mainForm.FormCreate(mainForm);

    AssertTrue('The tab exit event should be owned by its frame.',
      selectionTab.OnExit = @selectionFrame.SelectionTabExit);
    AssertTrue('The tab mouse event should be owned by its frame.',
      selectionTab.OnMouseDown = @selectionFrame.SelectionTabMouseDown);
    AssertTrue('The tab show event should be owned by its frame.',
      selectionTab.OnShow = @selectionFrame.SelectionTabShow);
  finally
    mainForm.Free;
  end;
end;

procedure TTestAHW52PersonSelectionFrame.
  TestMainFormStreamsSelectionFrameIntoSelectionTab;
var
  mainForm: TForm1;
begin
  Application.Initialize;
  mainForm := TForm1.Create(nil);
  try
    AssertTrue('The main form should stream the selection frame.',
      Assigned(mainForm.PersonSelectionFrame));
    AssertTrue('The frame should be parented by the selection tab.',
      mainForm.PersonSelectionFrame.Parent = mainForm.TabSheet1);
    AssertEquals('The selection tab caption should remain unchanged.',
      'Auswahl', mainForm.TabSheet1.Caption);
    AssertEquals('The streamed selection grid should retain its columns.',
      9, mainForm.PersonSelectionFrame.DBGrid1.Columns.Count);
    AssertEquals('The original grid left position should remain unchanged.',
      37, mainForm.PersonSelectionFrame.DBGrid1.Left);
    AssertEquals('The original grid top position should remain unchanged.',
      13, mainForm.PersonSelectionFrame.DBGrid1.Top);
    AssertEquals('The original grid width should remain unchanged.',
      987, mainForm.PersonSelectionFrame.DBGrid1.Width);
    AssertEquals('The original grid height should remain unchanged.',
      640, mainForm.PersonSelectionFrame.DBGrid1.Height);
    AssertTrue('The streamed tab lifecycle should route through the frame.',
      mainForm.TabSheet1.OnShow =
        @mainForm.PersonSelectionFrame.SelectionTabShow);
  finally
    mainForm.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52PersonSelectionFrame);

end.
