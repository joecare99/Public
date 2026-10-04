unit AHW52PersonDetailsFrameTests;

{$mode objfpc}{$H+}

interface

uses
  AHW52PersonDetailsFrame, Controls, fpcunit, testregistry;

type
  TTestAHW52PersonDetailsFrame = class(TTestCase)
  private
    FLastAction: TPersonDetailsTabHostAction;
    FLastSender: TObject;
    procedure RecordHostAction(Sender: TObject;
      Action: TPersonDetailsTabHostAction);
  published
    procedure TestMainFormStreamsDetailsFrameAndPreservesBindings;
    procedure TestOnlyExecutableRelationshipChangeForwardsToHost;
  end;

implementation

uses
  Forms, frmAhnenWinMain;

procedure TTestAHW52PersonDetailsFrame.RecordHostAction(Sender: TObject;
  Action: TPersonDetailsTabHostAction);
begin
  FLastAction := Action;
  FLastSender := Sender;
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
    AssertEquals('The frame should own the original 71 tab controls.',
      71, mainForm.PersonDetailsFrame.ComponentCount);
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
    AssertTrue('The relationship change should retain its host action.',
      Assigned(mainForm.PersonDetailsFrame.OnHostAction));
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
  TestOnlyExecutableRelationshipChangeForwardsToHost;
var
  detailsFrame: TAHW52PersonDetailsFrame;
  key: Char;
begin
  Application.Initialize;
  detailsFrame := TAHW52PersonDetailsFrame.Create(nil);
  try
    detailsFrame.OnHostAction := @RecordHostAction;

    detailsFrame.ComboBox5Change(detailsFrame.ComboBox5);
    AssertEquals(Ord(pdaComboBox5Change), Ord(FLastAction));
    AssertTrue(FLastSender = detailsFrame.ComboBox5);

    detailsFrame.TabSheet3Enter(detailsFrame);
    detailsFrame.DBEdit55Exit(detailsFrame.DBEdit55);
    detailsFrame.ComboBox1Exit(detailsFrame.ComboBox1);
    detailsFrame.ComboBox10Exit(detailsFrame.ComboBox10);
    detailsFrame.ComboBox11Exit(detailsFrame.ComboBox11);
    detailsFrame.ComboBox19Exit(detailsFrame.ComboBox19);
    key := 'A';
    detailsFrame.ComboBox1KeyPress(detailsFrame.ComboBox1, key);
    AssertEquals('The inert local handlers should not dispatch to the host.',
      Ord(pdaComboBox5Change), Ord(FLastAction));
    AssertTrue('The inert local handlers should not replace the last sender.',
      FLastSender = detailsFrame.ComboBox5);
    AssertEquals('The unresolved legacy key event must leave its key intact.',
      'A', key);
  finally
    detailsFrame.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52PersonDetailsFrame);

end.
