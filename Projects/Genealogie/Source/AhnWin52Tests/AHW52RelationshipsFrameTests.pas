unit AHW52RelationshipsFrameTests;

{$mode objfpc}{$H+}

interface

uses
  AHW52RelationshipsFrame, fpcunit, testregistry;

type
  TTestAHW52RelationshipsFrame = class(TTestCase)
  published
    procedure TestMainFormStreamsRelationshipsFrameAndPreservesBindings;
  end;

implementation

uses
  Forms, frmAhnenWinMain;

procedure TTestAHW52RelationshipsFrame.
  TestMainFormStreamsRelationshipsFrameAndPreservesBindings;
var
  mainForm: TForm1;
begin
  Application.Initialize;
  mainForm := TForm1.Create(nil);
  try
    AssertTrue('TabSheet4 should stream its production relationships frame.',
      Assigned(mainForm.RelationshipsFrame));
    AssertTrue('The relationships frame should be parented by TabSheet4.',
      mainForm.RelationshipsFrame.Parent = mainForm.TabSheet4);
    AssertEquals('The relationships tab caption should remain unchanged.',
      'Ehen u.a.', mainForm.TabSheet4.Caption);
    AssertEquals('The relationships tab image index should remain unchanged.',
      3, mainForm.TabSheet4.ImageIndex);
    AssertEquals('The frame should own the original 37 tab controls.',
      37, mainForm.RelationshipsFrame.ComponentCount);
    AssertEquals('The spouse grid should retain its original horizontal position.',
      55, mainForm.RelationshipsFrame.StringGrid3.Left);
    AssertEquals('The spouse grid should retain its original width.',
      531, mainForm.RelationshipsFrame.StringGrid3.Width);
    AssertEquals('The church marriage day should retain its field binding.',
      'Htag', mainForm.RelationshipsFrame.DBEdit35.DataField);
    AssertEquals('The church marriage month should retain its field binding.',
      'Hmonat', mainForm.RelationshipsFrame.DBEdit36.DataField);
    AssertEquals('The church marriage year should retain its field binding.',
      'Hjahr', mainForm.RelationshipsFrame.DBEdit37.DataField);
    AssertEquals('The church witnesses should retain their field binding.',
      'Trauz', mainForm.RelationshipsFrame.DBEdit38.DataField);
    AssertEquals('The civil marriage day should retain its field binding.',
      'Satag', mainForm.RelationshipsFrame.DBEdit39.DataField);
    AssertEquals('The civil marriage month should retain its field binding.',
      'Samonat', mainForm.RelationshipsFrame.DBEdit41.DataField);
    AssertEquals('The civil marriage year should retain its field binding.',
      'Sajahr', mainForm.RelationshipsFrame.DBEdit45.DataField);
    AssertEquals('The civil witnesses should retain their field binding.',
      'Satrauz', mainForm.RelationshipsFrame.DBEdit46.DataField);
    AssertEquals('The relationship type should retain its field binding.',
      'Verbind', mainForm.RelationshipsFrame.DBComboBox1.DataField);
    AssertEquals('The separation day should retain its field binding.',
      'Schtag', mainForm.RelationshipsFrame.DBEdit61.DataField);
    AssertEquals('The separation month should retain its field binding.',
      'Schmonat', mainForm.RelationshipsFrame.DBEdit62.DataField);
    AssertEquals('The separation year should retain its field binding.',
      'Schjahr', mainForm.RelationshipsFrame.DBEdit63.DataField);
    AssertTrue('The spouse-grid click event should belong to the frame.',
      mainForm.RelationshipsFrame.StringGrid3.OnClick =
        @mainForm.RelationshipsFrame.StringGrid3Click);
    AssertTrue('The church-marriage year exit event should belong to the frame.',
      mainForm.RelationshipsFrame.DBEdit37.OnExit =
        @mainForm.RelationshipsFrame.DBEdit37Exit);
    AssertTrue('The civil-marriage year exit event should belong to the frame.',
      mainForm.RelationshipsFrame.DBEdit45.OnExit =
        @mainForm.RelationshipsFrame.DBEdit45Exit);
    AssertTrue('The separation-year exit event should belong to the frame.',
      mainForm.RelationshipsFrame.DBEdit63.OnExit =
        @mainForm.RelationshipsFrame.DBEdit63Exit);
    AssertTrue('The relationship-type exit event should belong to the frame.',
      mainForm.RelationshipsFrame.DBComboBox1.OnExit =
        @mainForm.RelationshipsFrame.DBComboBox1Exit);
    AssertTrue('The church-marriage date combo should retain its exit event.',
      mainForm.RelationshipsFrame.ComboBox20.OnExit =
        @mainForm.RelationshipsFrame.ComboBox20Exit);
    AssertTrue('The civil-marriage date combo should retain its exit event.',
      mainForm.RelationshipsFrame.ComboBox21.OnExit =
        @mainForm.RelationshipsFrame.ComboBox20Exit);
    AssertTrue('The separation date combo should retain its exit event.',
      mainForm.RelationshipsFrame.ComboBox22.OnExit =
        @mainForm.RelationshipsFrame.ComboBox20Exit);
    AssertTrue('The church-witness combo should retain its exit event.',
      mainForm.RelationshipsFrame.ComboBox23.OnExit =
        @mainForm.RelationshipsFrame.ComboBox11Exit);
    AssertTrue('The civil-witness combo should retain its exit event.',
      mainForm.RelationshipsFrame.ComboBox24.OnExit =
        @mainForm.RelationshipsFrame.ComboBox11Exit);
    AssertTrue('The separation-source combo should retain its exit event.',
      mainForm.RelationshipsFrame.ComboBox25.OnExit =
        @mainForm.RelationshipsFrame.ComboBox11Exit);
    AssertTrue('Tab enter should dispatch through the relationships frame.',
      mainForm.TabSheet4.OnEnter =
        @mainForm.RelationshipsFrame.TabSheet4Enter);
    AssertTrue('Tab exit should dispatch through the relationships frame.',
      mainForm.TabSheet4.OnExit =
        @mainForm.RelationshipsFrame.TabSheet4Exit);
    AssertTrue('Tab show should dispatch through the relationships frame.',
      mainForm.TabSheet4.OnShow =
        @mainForm.RelationshipsFrame.TabSheet4Show);
  finally
    mainForm.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52RelationshipsFrame);

end.
