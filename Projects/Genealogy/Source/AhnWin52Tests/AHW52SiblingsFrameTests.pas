unit AHW52SiblingsFrameTests;

{$mode objfpc}{$H+}

interface

uses
  AHW52SiblingsFrame, Controls, fpcunit, testregistry;

type
  TTestAHW52SiblingsFrame = class(TTestCase)
  published
    procedure TestMainFormStreamsSiblingsFrameAndPreservesGridProperties;
  end;

implementation

uses
  Forms, frmAhnenWinMain;

procedure TTestAHW52SiblingsFrame.
  TestMainFormStreamsSiblingsFrameAndPreservesGridProperties;
var
  mainForm: TForm1;
begin
  Application.Initialize;
  mainForm := TForm1.Create(nil);
  try
    AssertTrue('TabSheet5 should stream its production siblings frame.',
      Assigned(mainForm.SiblingsFrame));
    AssertTrue('The siblings frame should be parented by TabSheet5.',
      mainForm.SiblingsFrame.Parent = mainForm.TabSheet5);
    AssertEquals('The siblings tab caption should remain unchanged.',
      'Geschwister', mainForm.TabSheet5.Caption);
    AssertEquals('The siblings tab image index should remain unchanged.',
      4, mainForm.TabSheet5.ImageIndex);
    AssertEquals('The frame should own the original two tab controls.',
      2, mainForm.SiblingsFrame.ComponentCount);
    AssertEquals('The caption label should retain its original horizontal position.',
      267, mainForm.SiblingsFrame.Label26.Left);
    AssertEquals('The caption label should retain its original vertical position.',
      36, mainForm.SiblingsFrame.Label26.Top);
    AssertEquals('The grid should retain its original horizontal position.',
      260, mainForm.SiblingsFrame.StringGrid4.Left);
    AssertEquals('The grid should retain its original vertical position.',
      105, mainForm.SiblingsFrame.StringGrid4.Top);
    AssertEquals('The grid should retain its original width.',
      531, mainForm.SiblingsFrame.StringGrid4.Width);
    AssertEquals('The grid should retain its original height.',
      408, mainForm.SiblingsFrame.StringGrid4.Height);
    AssertEquals('The first column should retain its width.',
      72, mainForm.SiblingsFrame.StringGrid4.ColWidths[0]);
    AssertEquals('The name column should retain its width.',
      327, mainForm.SiblingsFrame.StringGrid4.ColWidths[1]);
    AssertEquals('The birth-year column should retain its width.',
      85, mainForm.SiblingsFrame.StringGrid4.ColWidths[2]);
    AssertEquals('The additional data column should retain its width.',
      85, mainForm.SiblingsFrame.StringGrid4.ColWidths[3]);
    AssertEquals('The ID column should retain its width.',
      44, mainForm.SiblingsFrame.StringGrid4.ColWidths[4]);
    AssertEquals('The grid should retain its activation hint.',
      'Doppelclick auf Name (oder Eingabetaste) wechselt zur ausgewählten Person',
      mainForm.SiblingsFrame.StringGrid4.Hint);
    AssertEquals('The grid should retain its initial row count.',
      1, mainForm.SiblingsFrame.StringGrid4.RowCount);
    AssertTrue('The grid double-click event should belong to the frame.',
      mainForm.SiblingsFrame.StringGrid4.OnDblClick =
        @mainForm.SiblingsFrame.StringGrid4DblClick);
    AssertTrue('Tab enter should dispatch through the siblings frame.',
      mainForm.TabSheet5.OnEnter =
        @mainForm.SiblingsFrame.TabSheet5Enter);
  finally
    mainForm.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52SiblingsFrame);

end.
