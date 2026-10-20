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
  AHW52PersonDetailsFrame, StdCtrls;

function CreateDetailsFrameWithRelationshipComboBox(
  out relationshipComboBox: TComboBox): TAHW52PersonDetailsFrame;
begin
  Result := TAHW52PersonDetailsFrame.Create(nil);
  relationshipComboBox := Result.ComboBox5;
end;

procedure TTestAHW52RelationshipCaptionNormalization.TestNormalizesMarriageCaption;
var
  detailsFrame: TAHW52PersonDetailsFrame;
  relationshipComboBox: TComboBox;
begin
  detailsFrame :=
    CreateDetailsFrameWithRelationshipComboBox(relationshipComboBox);
  try
    relationshipComboBox.Text := 'vorherige heschl. Verbindung';

    detailsFrame.ComboBox5Exit(relationshipComboBox);

    AssertEquals('Eheschliessung', relationshipComboBox.Text);
  finally
    detailsFrame.Free;
  end;
end;

procedure TTestAHW52RelationshipCaptionNormalization.TestNormalizesOtherRelationshipCaption;
var
  detailsFrame: TAHW52PersonDetailsFrame;
  relationshipComboBox: TComboBox;
begin
  detailsFrame :=
    CreateDetailsFrameWithRelationshipComboBox(relationshipComboBox);
  try
    relationshipComboBox.Text := 'andere Bez. zur Familie';

    detailsFrame.ComboBox5Exit(relationshipComboBox);

    AssertEquals('andere Beziehung', relationshipComboBox.Text);
  finally
    detailsFrame.Free;
  end;
end;

procedure TTestAHW52RelationshipCaptionNormalization.TestLeavesUnmatchedCaptionUnchanged;
var
  detailsFrame: TAHW52PersonDetailsFrame;
  relationshipComboBox: TComboBox;
begin
  detailsFrame :=
    CreateDetailsFrameWithRelationshipComboBox(relationshipComboBox);
  try
    relationshipComboBox.Text := 'Verlobung';

    detailsFrame.ComboBox5Exit(relationshipComboBox);

    AssertEquals('Verlobung', relationshipComboBox.Text);
  finally
    detailsFrame.Free;
  end;
end;

procedure TTestAHW52RelationshipCaptionNormalization.TestMatchingIsCaseSensitive;
var
  detailsFrame: TAHW52PersonDetailsFrame;
  relationshipComboBox: TComboBox;
begin
  detailsFrame :=
    CreateDetailsFrameWithRelationshipComboBox(relationshipComboBox);
  try
    relationshipComboBox.Text := 'Heschl. Verbindung';

    detailsFrame.ComboBox5Exit(relationshipComboBox);

    AssertEquals('Heschl. Verbindung', relationshipComboBox.Text);
  finally
    detailsFrame.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52RelationshipCaptionNormalization);

end.
