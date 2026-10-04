unit AHW52PersonEditFrameTests;

{$mode objfpc}{$H+}

interface

uses
  AHW52PersonEditFrame, Classes, Controls, DB, DBGrids, DBCtrls, ComCtrls,
  fpcunit, testregistry;

type
  TTestAHW52PersonEditFrame = class(TTestCase)
  private
    FLastAction: Integer;
    FLastSender: TObject;
    FLastFocusTarget: TWinControl;
    FLastNavigateButton: TDBNavButtonType;
    procedure RecordHostAction(Sender: TObject;
      Action: TPersonEditTabHostAction);
    procedure RecordFocusRequest(Sender: TObject; Target: TWinControl);
    procedure RecordNavigatorBeforeAction(Sender: TObject;
      Button: TDBNavButtonType);
  published
    procedure TestMainFormStreamsEditFrameAndRetainsBoundControls;
    procedure TestFrameForwardsOnlyHostOwnedActions;
    procedure TestGridEscapeAndExitBehaviorStaysInsideFrame;
    procedure TestEditTabShowRequestsFocusThroughHost;
  end;

implementation

uses
  Forms, LCLType, frmAhnenWinMain;

procedure TTestAHW52PersonEditFrame.RecordHostAction(Sender: TObject;
  Action: TPersonEditTabHostAction);
begin
  FLastAction := Ord(Action);
  FLastSender := Sender;
end;

procedure TTestAHW52PersonEditFrame.RecordFocusRequest(Sender: TObject;
  Target: TWinControl);
begin
  FLastFocusTarget := Target;
end;

procedure TTestAHW52PersonEditFrame.RecordNavigatorBeforeAction(
  Sender: TObject; Button: TDBNavButtonType);
begin
  FLastSender := Sender;
  FLastNavigateButton := Button;
end;

procedure TTestAHW52PersonEditFrame.
  TestMainFormStreamsEditFrameAndRetainsBoundControls;
var
  mainForm: TForm1;
begin
  Application.Initialize;
  mainForm := TForm1.Create(nil);
  try
    AssertTrue('TabSheet2 should stream its production edit frame.',
      Assigned(mainForm.PersonEditFrame));
    AssertTrue('The edit frame should be parented by TabSheet2.',
      mainForm.PersonEditFrame.Parent = mainForm.TabSheet2);
    AssertEquals('The edit tab caption should remain unchanged.',
      'Bearbeiten', mainForm.TabSheet2.Caption);
    AssertEquals('The edit frame should own the original 70 controls.',
      70, mainForm.PersonEditFrame.ComponentCount);
    AssertEquals('DBEdit2 should retain its original data field.',
      'Vornamen', mainForm.PersonEditFrame.DBEdit2.DataField);
    AssertEquals('DBComboBox3 should retain its original data field.',
      'Kistat', mainForm.PersonEditFrame.DBComboBox3.DataField);
    AssertTrue('DBGrid3 should retain its double-click binding.',
      Assigned(mainForm.PersonEditFrame.DBGrid3.OnDblClick));
    AssertTrue('DBGrid3 should retain its key-down binding.',
      Assigned(mainForm.PersonEditFrame.DBGrid3.OnKeyDown));
    AssertTrue('The grid should retain its lifecycle event bindings.',
      Assigned(mainForm.PersonEditFrame.DBGrid3.OnExit));
    AssertTrue('The navigator should retain its before-action binding.',
      Assigned(mainForm.PersonEditFrame.DBNavigator1.BeforeAction));
    AssertTrue('Tab enter should dispatch through the frame.',
      mainForm.TabSheet2.OnEnter = @mainForm.PersonEditFrame.TabSheet2Enter);
    AssertTrue('Tab exit should dispatch through the frame.',
      mainForm.TabSheet2.OnExit = @mainForm.PersonEditFrame.TabSheet2Exit);
    AssertTrue('Tab show should dispatch through the frame.',
      mainForm.TabSheet2.OnShow = @mainForm.PersonEditFrame.TabSheet2Show);
  finally
    mainForm.Free;
  end;
end;

procedure TTestAHW52PersonEditFrame.TestFrameForwardsOnlyHostOwnedActions;
var
  editFrame: TAHW52PersonEditFrame;
begin
  Application.Initialize;
  editFrame := TAHW52PersonEditFrame.Create(nil);
  try
    FLastAction := -1;
    FLastSender := nil;
    editFrame.OnHostAction := @RecordHostAction;
    editFrame.OnNavigatorBeforeAction := @RecordNavigatorBeforeAction;

    editFrame.TabSheet2Enter(editFrame);
    AssertEquals(Ord(peaTabSheet2Enter), FLastAction);
    AssertTrue('Tab entry should preserve its original sender.',
      FLastSender = editFrame);

    editFrame.DBEdit69.OnChange(editFrame.DBEdit69);
    AssertEquals(Ord(peaDBEdit69Change), FLastAction);
    AssertTrue('The lookup reset should preserve the control sender.',
      FLastSender = editFrame.DBEdit69);

    editFrame.DBEdit12Exit(editFrame.DBEdit12);
    editFrame.DBEdit13Exit(editFrame.DBEdit13);
    editFrame.DBEdit20Exit(editFrame.DBEdit20);
    editFrame.DBEdit21Exit(editFrame.DBEdit21);
    AssertEquals('Listing-only field exits should not dispatch to the host.',
      Ord(peaDBEdit69Change), FLastAction);
    AssertTrue('Inert exits should not replace the active host sender.',
      FLastSender = editFrame.DBEdit69);

    editFrame.DBNavigator1.BeforeAction(editFrame.DBNavigator1, nbPost);
    AssertTrue('Navigator dispatch should preserve the navigator sender.',
      FLastSender = editFrame.DBNavigator1);
    AssertEquals(Ord(nbPost), Ord(FLastNavigateButton));
  finally
    editFrame.Free;
  end;
end;

procedure TTestAHW52PersonEditFrame.
  TestGridEscapeAndExitBehaviorStaysInsideFrame;
var
  editFrame: TAHW52PersonEditFrame;
  key: Word;
begin
  Application.Initialize;
  editFrame := TAHW52PersonEditFrame.Create(nil);
  try
    FLastFocusTarget := nil;
    editFrame.OnFocusRequest := @RecordFocusRequest;

    editFrame.DBGrid3.Visible := True;
    editFrame.Label81.Visible := True;
    editFrame.DBGrid3Exit(editFrame.DBGrid3);
    AssertFalse(editFrame.DBGrid3.Visible);
    AssertFalse(editFrame.Label81.Visible);
    AssertTrue('Leaving the grid should request focus for DBComboBox3.',
      FLastFocusTarget = editFrame.DBComboBox3);

    editFrame.DBGrid3.Visible := True;
    editFrame.Label81.Visible := True;
    editFrame.DBComboBox3.Text := 'synthetic value';
    key := VK_ESCAPE;
    editFrame.DBGrid3KeyDown(editFrame.DBGrid3, key, []);
    AssertEquals('', editFrame.DBComboBox3.Text);
    AssertFalse(editFrame.DBGrid3.Visible);
    AssertFalse(editFrame.Label81.Visible);
    AssertTrue('Escape should request focus for DBComboBox3.',
      FLastFocusTarget = editFrame.DBComboBox3);
    AssertEquals('The frame should not consume the Escape key.',
      VK_ESCAPE, key);

    editFrame.StringGrid5.Visible := True;
    key := VK_ESCAPE;
    editFrame.StringGrid5KeyDown(editFrame.StringGrid5, key, []);
    AssertFalse(editFrame.StringGrid5.Visible);
    AssertEquals('The string grid handler should not consume Escape.',
      VK_ESCAPE, key);

    editFrame.StringGrid5.Visible := True;
    key := Ord('A');
    editFrame.StringGrid5KeyDown(editFrame.StringGrid5, key, []);
    AssertTrue('Ordinary keys should leave the string grid visible.',
      editFrame.StringGrid5.Visible);
    AssertEquals(Ord('A'), key);
  finally
    editFrame.Free;
  end;
end;

procedure TTestAHW52PersonEditFrame.TestEditTabShowRequestsFocusThroughHost;
var
  mainForm: TForm1;
begin
  Application.Initialize;
  mainForm := TForm1.Create(nil);
  try
    mainForm.TabSheet2.OnShow(mainForm.TabSheet2);
    AssertTrue('Showing the edit tab should focus its primary field.',
      mainForm.ActiveControl = mainForm.PersonEditFrame.DBEdit2);
  finally
    mainForm.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52PersonEditFrame);

end.
