unit AHW52PersonDetailsFrameTests;

{$mode objfpc}{$H+}

interface

uses
  AHW52PersonDetailsFrame, Controls, fpcunit, StdCtrls, testregistry;

type
  TTestAHW52PersonDetailsFrame = class(TTestCase)
  published
    procedure TestMainFormStreamsDetailsFrameAndPreservesBindings;
    procedure TestReligionExitUsesGenealogyInterface;
    procedure TestRelationshipChangeFocusesLocalEditControl;
  end;

implementation

uses
  DB, Forms, GenealogyDataModule, GenealogyDataModuleAccess, MemDS,
  frmAhnenWinMain;

procedure TTestAHW52PersonDetailsFrame.TestReligionExitUsesGenealogyInterface;
var
  dataModule: TGenealogyDataModule;
  dataSet: TMemDataset;
  frame: TAHW52PersonDetailsFrame;
  previousDataModule: IGenealogyDataModule;
begin
  Application.Initialize;
  previousDataModule := GenealogyDataModuleAccess.GenealogyDataModule;
  dataSet := TMemDataset.Create(nil);
  dataSet.FieldDefs.Add('Religion', ftString, 40);
  dataSet.CreateTable;
  dataSet.Open;
  dataSet.Append;
  dataModule := TGenealogyDataModule.CreateNew(nil);
  frame := TAHW52PersonDetailsFrame.Create(nil);
  try
    dataModule.Table1Religion :=
      dataSet.FieldByName('Religion') as TStringField;
    GenealogyDataModuleAccess.GenealogyDataModule :=
      CreateGenealogyDataModuleAdapter(dataModule);
    frame.DBComboBox7.Text := 'Synthetic religion';

    frame.DBComboBox7Exit(frame.DBComboBox7);

    AssertEquals('The religion value is written through the interface-backed field.',
      'Synthetic religion', dataSet.FieldByName('Religion').AsString);
  finally
    GenealogyDataModuleAccess.GenealogyDataModule := previousDataModule;
    frame.Free;
    dataModule.Free;
    dataSet.Free;
  end;
end;

procedure TTestAHW52PersonDetailsFrame.
  TestMainFormStreamsDetailsFrameAndPreservesBindings;
var
  mainForm: TForm1;
begin
  Application.Initialize;
  mainForm := TForm1.Create(nil);
  try
    AssertTrue('TabSheet3 should stream its production details frame.',
      Assigned(mainForm.PersonDetailsFrame));
    AssertTrue('The details frame should be parented by TabSheet3.',
      mainForm.PersonDetailsFrame.Parent = mainForm.TabSheet3);
    AssertEquals('The details tab caption should remain unchanged.',
      'Details', mainForm.TabSheet3.Caption);
    AssertEquals('The frame should own the original 71 controls and Edit4.',
      72, mainForm.PersonDetailsFrame.ComponentCount);
    AssertTrue('Edit4 should stream as a standard TEdit.',
      mainForm.PersonDetailsFrame.Edit4 is TEdit);
    AssertEquals(115, mainForm.PersonDetailsFrame.Edit4.Left);
    AssertEquals(379, mainForm.PersonDetailsFrame.Edit4.Top);
    AssertEquals(25, mainForm.PersonDetailsFrame.Edit4.Width);
    AssertEquals(24, mainForm.PersonDetailsFrame.Edit4.Height);
    AssertEquals(2, mainForm.PersonDetailsFrame.Edit4.MaxLength);
    AssertFalse(mainForm.PersonDetailsFrame.Edit4.AutoSize);
    AssertFalse(mainForm.PersonDetailsFrame.Edit4.Visible);
    AssertEquals('The religion combo should retain its original horizontal position.',
      261, mainForm.PersonDetailsFrame.DBComboBox7.Left);
    AssertEquals('The religion combo should retain its original vertical position.',
      229, mainForm.PersonDetailsFrame.DBComboBox7.Top);
    AssertEquals('DBComboBox7 should retain its religion field binding.',
      'Religion', mainForm.PersonDetailsFrame.DBComboBox7.DataField);
    AssertEquals('DBEdit33 should retain its given-name field binding.',
      'Vornamen', mainForm.PersonDetailsFrame.DBEdit33.DataField);
    AssertTrue('The bound combo exit event should belong to the frame.',
      mainForm.PersonDetailsFrame.DBComboBox7.OnExit =
        @mainForm.PersonDetailsFrame.DBComboBox7Exit);
    AssertTrue('The relationship combo change event should belong to frame.',
      mainForm.PersonDetailsFrame.ComboBox5.OnChange =
        @mainForm.PersonDetailsFrame.ComboBox5Change);
    AssertTrue('The relationship combo exit event should belong to frame.',
      mainForm.PersonDetailsFrame.ComboBox5.OnExit =
        @mainForm.PersonDetailsFrame.ComboBox5Exit);
    AssertTrue('The hidden legacy key handler should retain a typed binding.',
      mainForm.PersonDetailsFrame.ComboBox1.OnKeyPress =
        @mainForm.PersonDetailsFrame.ComboBox1KeyPress);
    AssertTrue('Tab enter should dispatch through the details frame.',
      mainForm.TabSheet3.OnEnter =
        @mainForm.PersonDetailsFrame.TabSheet3Enter);
    AssertTrue('Tab exit should dispatch through the details frame.',
      mainForm.TabSheet3.OnExit =
        @mainForm.PersonDetailsFrame.TabSheet3Exit);
  finally
    mainForm.Free;
  end;
end;

procedure TTestAHW52PersonDetailsFrame.
  TestRelationshipChangeFocusesLocalEditControl;
var
  mainForm: TForm1;
begin
  Application.Initialize;
  mainForm := TForm1.Create(nil);
  try
    AssertTrue('The Details frame should be streamed.',
      Assigned(mainForm.PersonDetailsFrame));
    mainForm.PersonDetailsFrame.ComboBox5Change(
      mainForm.PersonDetailsFrame.ComboBox5);
    AssertTrue('Relationship change should focus the frame-owned Edit4.',
      mainForm.ActiveControl = mainForm.PersonDetailsFrame.Edit4);

    mainForm.PersonDetailsFrame.TabSheet3Enter(
      mainForm.PersonDetailsFrame);
    mainForm.PersonDetailsFrame.DBEdit55Exit(
      mainForm.PersonDetailsFrame.DBEdit55);
    mainForm.PersonDetailsFrame.ComboBox1Exit(
      mainForm.PersonDetailsFrame.ComboBox1);
    mainForm.PersonDetailsFrame.ComboBox10Exit(
      mainForm.PersonDetailsFrame.ComboBox10);
    mainForm.PersonDetailsFrame.ComboBox11Exit(
      mainForm.PersonDetailsFrame.ComboBox11);
    mainForm.PersonDetailsFrame.ComboBox19Exit(
      mainForm.PersonDetailsFrame.ComboBox19);
  finally
    mainForm.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52PersonDetailsFrame);

end.
