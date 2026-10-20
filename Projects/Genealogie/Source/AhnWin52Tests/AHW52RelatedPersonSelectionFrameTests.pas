unit AHW52RelatedPersonSelectionFrameTests;

{$mode objfpc}{$H+}

interface

uses
  AHW52RelatedPersonSelectionFrame, Classes, Controls, fpcunit, testregistry;

type
  TTestAHW52RelatedPersonSelectionFrame = class(TTestCase)
  published
    procedure TestMainFormStreamsHiddenRelatedSelectionFrame;
  end;

implementation

uses
  Forms, frmAhnenWinMain;

procedure TTestAHW52RelatedPersonSelectionFrame.
  TestMainFormStreamsHiddenRelatedSelectionFrame;
var
  mainForm: TForm1;
  expectedFields: array[0..8] of string;
  columnIndex: Integer;
begin
  Application.Initialize;
  mainForm := TForm1.Create(nil);
  try
    AssertTrue('TabSheet7 should stream its production related-selection frame.',
      Assigned(mainForm.RelatedPersonSelectionFrame));
    AssertTrue('The related-selection frame should be parented by TabSheet7.',
      mainForm.RelatedPersonSelectionFrame.Parent = mainForm.TabSheet7);
    AssertEquals('The hidden tab should retain its image index.',
      6, mainForm.TabSheet7.ImageIndex);
    AssertFalse('The secondary-selection tab should remain hidden.',
      mainForm.TabSheet7.TabVisible);
    AssertEquals('The frame should own the original two tab controls.',
      2, mainForm.RelatedPersonSelectionFrame.ComponentCount);

    AssertEquals('The label should retain its original horizontal position.',
      45, mainForm.RelatedPersonSelectionFrame.Label27.Left);
    AssertEquals('The label should retain its original vertical position.',
      20, mainForm.RelatedPersonSelectionFrame.Label27.Top);
    AssertEquals('The grid should retain its original horizontal position.',
      41, mainForm.RelatedPersonSelectionFrame.DBGrid2.Left);
    AssertEquals('The grid should retain its original vertical position.',
      64, mainForm.RelatedPersonSelectionFrame.DBGrid2.Top);
    AssertEquals('The grid should retain its original width.',
      955, mainForm.RelatedPersonSelectionFrame.DBGrid2.Width);
    AssertEquals('The grid should retain its original height.',
      577, mainForm.RelatedPersonSelectionFrame.DBGrid2.Height);
    AssertEquals('The grid should retain its original activation hint.',
      'Auswahl durch Doppelclick auf Name oder <ENTER>;  Schließen auch mit <ESC>',
      mainForm.RelatedPersonSelectionFrame.DBGrid2.Hint);

    expectedFields[0] := 'Nummer';
    expectedFields[1] := 'Name';
    expectedFields[2] := 'Vornamen';
    expectedFields[3] := 'Gebjahr';
    expectedFields[4] := 'Gebort';
    expectedFields[5] := 'Taufjahr';
    expectedFields[6] := 'Taufort';
    expectedFields[7] := 'Stjahr';
    expectedFields[8] := 'IDNR';
    AssertEquals('The related-selection grid should retain its nine columns.',
      Length(expectedFields),
      mainForm.RelatedPersonSelectionFrame.DBGrid2.Columns.Count);
    for columnIndex := Low(expectedFields) to High(expectedFields) do
      AssertEquals('The original grid field order should be preserved.',
        expectedFields[columnIndex],
        mainForm.RelatedPersonSelectionFrame.DBGrid2.Columns[columnIndex].FieldName);

    AssertTrue('The grid double-click event should belong to the frame.',
      mainForm.RelatedPersonSelectionFrame.DBGrid2.OnDblClick =
        @mainForm.RelatedPersonSelectionFrame.DBGrid2DblClick);
    AssertTrue('The hidden tab should route entry to the frame.',
      mainForm.TabSheet7.OnEnter =
        @mainForm.RelatedPersonSelectionFrame.TabSheet7Enter);
    AssertTrue('The hidden tab should route mouse-down to the frame.',
      mainForm.TabSheet7.OnMouseDown =
        @mainForm.RelatedPersonSelectionFrame.TabSheet7MouseDown);
    AssertTrue('No dataset should be opened by the frame extraction.',
      mainForm.RelatedPersonSelectionFrame.DBGrid2.DataSource = nil);
  finally
    mainForm.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52RelatedPersonSelectionFrame);

end.
