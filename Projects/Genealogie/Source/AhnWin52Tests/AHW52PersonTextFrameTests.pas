unit AHW52PersonTextFrameTests;

{$mode objfpc}{$H+}

interface

uses
  AHW52PersonTextFrame, Controls, fpcunit, testregistry;

type
  TTestAHW52PersonTextFrame = class(TTestCase)
  private
    FSaveSender: TObject;
    procedure RecordSaveRequest(Sender: TObject);
  published
    procedure TestMainFormStreamsPersonTextFrameAndPreservesBindings;
    procedure TestMemoExitRequestsSharedSave;
  end;

implementation

uses
  Forms, frmAhnenWinMain;

procedure TTestAHW52PersonTextFrame.RecordSaveRequest(Sender: TObject);
begin
  FSaveSender := Sender;
end;

procedure TTestAHW52PersonTextFrame.
  TestMainFormStreamsPersonTextFrameAndPreservesBindings;
var
  mainForm: TForm1;
begin
  Application.Initialize;
  mainForm := TForm1.Create(nil);
  try
    AssertTrue('TabSheet6 should stream its production person-text frame.',
      Assigned(mainForm.PersonTextFrame));
    AssertTrue('The person-text frame should be parented by TabSheet6.',
      mainForm.PersonTextFrame.Parent = mainForm.TabSheet6);
    AssertEquals('The text tab caption should remain unchanged.',
      'Text', mainForm.TabSheet6.Caption);
    AssertEquals('The text tab image index should remain unchanged.',
      5, mainForm.TabSheet6.ImageIndex);
    AssertEquals('The frame should own the original two tab controls.',
      2, mainForm.PersonTextFrame.ComponentCount);
    AssertEquals('The text label should retain its original horizontal position.',
      64, mainForm.PersonTextFrame.Label21.Left);
    AssertEquals('The text memo should retain its original horizontal position.',
      64, mainForm.PersonTextFrame.DBMemo1.Left);
    AssertEquals('The text memo should retain its original vertical position.',
      53, mainForm.PersonTextFrame.DBMemo1.Top);
    AssertEquals('The text memo should retain its original width.',
      823, mainForm.PersonTextFrame.DBMemo1.Width);
    AssertEquals('The text memo should retain its original height.',
      577, mainForm.PersonTextFrame.DBMemo1.Height);
    AssertEquals('The text memo should retain its comment field binding.',
      'Kommentar', mainForm.PersonTextFrame.DBMemo1.DataField);
    AssertEquals('The text memo should retain its activation hint.',
      'Zeilenumbruch mit [Strg][Eingabetaste]',
      mainForm.PersonTextFrame.DBMemo1.Hint);
    AssertTrue('The memo exit event should belong to the frame.',
      mainForm.PersonTextFrame.DBMemo1.OnExit =
        @mainForm.PersonTextFrame.DBMemo1Exit);
    AssertTrue('Memo exit should request the existing shared save workflow.',
      mainForm.PersonTextFrame.OnSaveRequested = @mainForm.speich1);
    AssertTrue('Tab enter should dispatch through the person-text frame.',
      mainForm.TabSheet6.OnEnter =
        @mainForm.PersonTextFrame.TabSheet6Enter);
  finally
    mainForm.Free;
  end;
end;

procedure TTestAHW52PersonTextFrame.TestMemoExitRequestsSharedSave;
var
  personTextFrame: TAHW52PersonTextFrame;
begin
  Application.Initialize;
  FSaveSender := nil;
  personTextFrame := TAHW52PersonTextFrame.Create(nil);
  try
    personTextFrame.OnSaveRequested := @RecordSaveRequest;
    personTextFrame.DBMemo1Exit(personTextFrame.DBMemo1);
    AssertTrue('Memo exit should preserve the memo as save sender.',
      FSaveSender = personTextFrame.DBMemo1);
  finally
    personTextFrame.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52PersonTextFrame);

end.
