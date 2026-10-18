unit tst_AHW52_RelationshipCaptionNormalizationTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52RelationshipCaptionNormalization = class(TTestCase)
  published
    procedure TestNormalizesMarriageCaption;
    procedure TestNormalizesOtherRelationshipCaption;
    procedure TestLeavesUnmatchedCaptionUnchanged;
    procedure TestMatchingIsCaseSensitive;
  end;

implementation

uses
  Forms, StdCtrls, frmAhnenWinMain;

function CreateMainFormWithRelationshipComboBox(
  out relationshipComboBox: TComboBox): TForm1;
begin
  Result := TForm1.CreateNew(nil);
  relationshipComboBox := TComboBox.Create(Result);
  relationshipComboBox.Parent := Result;
  Result.ComboBox5 := relationshipComboBox;
end;

procedure TTestAHW52RelationshipCaptionNormalization.TestNormalizesMarriageCaption;
var
  mainForm: TForm1;
  relationshipComboBox: TComboBox;
begin
  mainForm := CreateMainFormWithRelationshipComboBox(relationshipComboBox);
  try
    relationshipComboBox.Text := 'vorherige heschl. Verbindung';

    mainForm.ComboBox5Exit(nil);

    AssertEquals('Eheschliessung', relationshipComboBox.Text);
  finally
    mainForm.Free;
  end;
end;

procedure TTestAHW52RelationshipCaptionNormalization.TestNormalizesOtherRelationshipCaption;
var
  mainForm: TForm1;
  relationshipComboBox: TComboBox;
begin
  mainForm := CreateMainFormWithRelationshipComboBox(relationshipComboBox);
  try
    relationshipComboBox.Text := 'andere Bez. zur Familie';

    mainForm.ComboBox5Exit(nil);

    AssertEquals('andere Beziehung', relationshipComboBox.Text);
  finally
    mainForm.Free;
  end;
end;

procedure TTestAHW52RelationshipCaptionNormalization.TestLeavesUnmatchedCaptionUnchanged;
var
  mainForm: TForm1;
  relationshipComboBox: TComboBox;
begin
  mainForm := CreateMainFormWithRelationshipComboBox(relationshipComboBox);
  try
    relationshipComboBox.Text := 'Verlobung';

    mainForm.ComboBox5Exit(nil);

    AssertEquals('Verlobung', relationshipComboBox.Text);
  finally
    mainForm.Free;
  end;
end;

procedure TTestAHW52RelationshipCaptionNormalization.TestMatchingIsCaseSensitive;
var
  mainForm: TForm1;
  relationshipComboBox: TComboBox;
begin
  mainForm := CreateMainFormWithRelationshipComboBox(relationshipComboBox);
  try
    relationshipComboBox.Text := 'Heschl. Verbindung';

    mainForm.ComboBox5Exit(nil);

    AssertEquals('Heschl. Verbindung', relationshipComboBox.Text);
  finally
    mainForm.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52RelationshipCaptionNormalization);

end.
