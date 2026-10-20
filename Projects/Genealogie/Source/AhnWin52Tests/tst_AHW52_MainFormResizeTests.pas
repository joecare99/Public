unit tst_AHW52_MainFormResizeTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52MainFormResize = class(TTestCase)
  published
    procedure TestResizeStoresCurrentHeightAfterScaling;
    procedure TestGridColumnWidthsFollowRecoveredRatios;
  end;

implementation

uses
  Forms, frmAhnenWinMain;

procedure TTestAHW52MainFormResize.TestResizeStoresCurrentHeightAfterScaling;
var
  mainForm: TForm1;
  previousGlobalForm: TForm1;
  previousHeight: LongInt;
begin
  Application.Initialize;
  previousGlobalForm := Form1;
  previousHeight := GlobalVar_02535BA4;
  mainForm := TForm1.Create(nil);
  try
    mainForm.Height := 500;
    Form1 := mainForm;
    GlobalVar_02535BA4 := 400;

    mainForm.FormResize(nil);

    AssertEquals('Resize stores the current global form height.', 500,
      GlobalVar_02535BA4);
  finally
    Form1 := previousGlobalForm;
    GlobalVar_02535BA4 := previousHeight;
    mainForm.Free;
  end;
end;

procedure TTestAHW52MainFormResize.TestGridColumnWidthsFollowRecoveredRatios;
var
  mainForm: TForm1;
begin
  Application.Initialize;
  mainForm := TForm1.Create(nil);
  try
    mainForm.PersonEditFrame.StringGrid1.Width := 531;
    mainForm.PersonEditFrame.StringGrid2.Width := 512;
    mainForm.RelationshipsFrame.StringGrid3.Width := 10;
    mainForm.SiblingsFrame.StringGrid4.Width := 10;
    mainForm.PersonEditFrame.StringGrid5.Width := 100;

    mainForm.gridanp;

    AssertEquals('First-person grid column 1 uses the 13% ratio.', 69,
      mainForm.PersonEditFrame.StringGrid1.ColWidths[1]);
    AssertEquals('First-person grid name column uses the 45% ratio.', 239,
      mainForm.PersonEditFrame.StringGrid1.ColWidths[2]);
    AssertEquals('First-person grid column 3 uses the 11% ratio.', 58,
      mainForm.PersonEditFrame.StringGrid1.ColWidths[3]);
    AssertEquals('First-person grid column 4 uses the same 11% ratio.', 58,
      mainForm.PersonEditFrame.StringGrid1.ColWidths[4]);
    AssertEquals('First-person grid last column uses the 14% ratio.', 74,
      mainForm.PersonEditFrame.StringGrid1.ColWidths[5]);
    AssertEquals('First-person grid column 0 is not modified.', 12,
      mainForm.PersonEditFrame.StringGrid1.ColWidths[0]);
    AssertEquals('Second-person grid column 1 is rounded from 13%.', 67,
      mainForm.PersonEditFrame.StringGrid2.ColWidths[1]);
    AssertEquals('Second-person grid name column is rounded from 45%.', 230,
      mainForm.PersonEditFrame.StringGrid2.ColWidths[2]);
    AssertEquals('Second-person grid column 3 uses the 11% ratio.', 56,
      mainForm.PersonEditFrame.StringGrid2.ColWidths[3]);
    AssertEquals('Second-person grid column 4 uses the 11% ratio.', 56,
      mainForm.PersonEditFrame.StringGrid2.ColWidths[4]);
    AssertEquals('Second-person grid column 5 uses the 14% ratio.', 72,
      mainForm.PersonEditFrame.StringGrid2.ColWidths[5]);
    AssertEquals('Second-person grid column 0 is not modified.', 12,
      mainForm.PersonEditFrame.StringGrid2.ColWidths[0]);
    AssertEquals('Relationship grid column 0 uses the 13% ratio.', 1,
      mainForm.RelationshipsFrame.StringGrid3.ColWidths[0]);
    AssertEquals('Relationship grid uses banker''s rounding for 4.5.', 4,
      mainForm.RelationshipsFrame.StringGrid3.ColWidths[1]);
    AssertEquals('Relationship grid uses the 12% columns.', 1,
      mainForm.RelationshipsFrame.StringGrid3.ColWidths[2]);
    AssertEquals('Relationship grid repeats the 12% ratio.', 1,
      mainForm.RelationshipsFrame.StringGrid3.ColWidths[3]);
    AssertEquals('Relationship grid uses banker''s rounding for 1.5.', 2,
      mainForm.RelationshipsFrame.StringGrid3.ColWidths[4]);
    AssertEquals('Sibling grid column 0 uses the 13% ratio.', 1,
      mainForm.SiblingsFrame.StringGrid4.ColWidths[0]);
    AssertEquals('Sibling grid column 1 uses the 45% ratio.', 4,
      mainForm.SiblingsFrame.StringGrid4.ColWidths[1]);
    AssertEquals('Sibling grid columns 2 and 3 use the 12% ratio.', 1,
      mainForm.SiblingsFrame.StringGrid4.ColWidths[2]);
    AssertEquals('Sibling grid column 3 repeats the 12% ratio.', 1,
      mainForm.SiblingsFrame.StringGrid4.ColWidths[3]);
    AssertEquals('Sibling grid receives the same five-column ratios.', 2,
      mainForm.SiblingsFrame.StringGrid4.ColWidths[4]);
    AssertEquals('Additional-data grid column 0 uses the 13% ratio.', 13,
      mainForm.PersonEditFrame.StringGrid5.ColWidths[0]);
    AssertEquals('Additional-data grid column 1 uses the 53% ratio.', 53,
      mainForm.PersonEditFrame.StringGrid5.ColWidths[1]);
    AssertEquals('Additional-data grid column 2 uses the 12% ratio.', 12,
      mainForm.PersonEditFrame.StringGrid5.ColWidths[2]);
    AssertEquals('Additional-data grid column 3 uses the 16% ratio.', 16,
      mainForm.PersonEditFrame.StringGrid5.ColWidths[3]);
  finally
    mainForm.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52MainFormResize);

end.
