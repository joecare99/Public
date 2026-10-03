unit tst_AHW52_PlaceDialogKeyPressTests;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry;

type
  TTestAHW52PlaceDialogKeyPress = class(TTestCase)
  published
    procedure TestEnterPostsNextDialogControlAndIsConsumed;
    procedure TestOtherKeyIsPreserved;
    procedure TestActivateCopiesSelectedPlaceToEdit;
    procedure TestCancelActivatesMainPageAndClosesGlobalFormsInOrder;
    procedure TestUnboundCounterIncrement;
    procedure TestUnboundCounterDecrement;
  end;

implementation

uses
  ComCtrls, Windows, Forms, Messages, StdCtrls, SysUtils, Unit14, Unit33,
  FokoAbbreviationsForm, frmAhnenWinMain;

type
  TPlaceDialogCloseRecorder = class
  public
    MainForm: TForm1;
    TargetPage: TTabSheet;
    Sequence: string;
    PlaceClosedOnTargetPage: Boolean;
    AbbreviationClosedOnTargetPage: Boolean;
    procedure RecordPlaceClose(Sender: TObject; var Action: TCloseAction);
    procedure RecordAbbreviationClose(Sender: TObject;
      var Action: TCloseAction);
  end;

procedure TPlaceDialogCloseRecorder.RecordPlaceClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Sequence := Sequence + 'P';
  PlaceClosedOnTargetPage := MainForm.PageControl1.ActivePage = TargetPage;
end;

procedure TPlaceDialogCloseRecorder.RecordAbbreviationClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Sequence := Sequence + 'A';
  AbbreviationClosedOnTargetPage :=
    MainForm.PageControl1.ActivePage = TargetPage;
end;

procedure TTestAHW52PlaceDialogKeyPress.
  TestActivateCopiesSelectedPlaceToEdit;
var
  placeForm: TForm33;
  previousSelector: TForm14;
  selector: TForm14;
begin
  Application.Initialize;
  previousSelector := Unit14.Form14;
  selector := TForm14.CreateNew(nil);
  placeForm := TForm33.CreateNew(nil);
  try
    Unit14.Form14 := selector;
    selector.ListBox1 := TListBox.Create(selector);
    selector.ListBox1.Parent := selector;
    selector.ListBox1.Items.Add('First place');
    selector.ListBox1.Items.Add('Selected place');
    selector.ListBox1.ItemIndex := 1;
    placeForm.Edit1 := TEdit.Create(placeForm);
    placeForm.Edit1.Parent := placeForm;

    placeForm.FormActivate(placeForm);

    AssertEquals('Selected place', placeForm.Edit1.Text);
  finally
    Unit14.Form14 := previousSelector;
    placeForm.Free;
    selector.Free;
  end;
end;

procedure TTestAHW52PlaceDialogKeyPress.
  TestCancelActivatesMainPageAndClosesGlobalFormsInOrder;
var
  previousMainForm: TForm1;
  previousPlaceForm: TForm33;
  previousAbbreviationForm: TFokoAbbreviationsForm;
  mainForm: TForm1;
  globalPlaceForm: TForm33;
  eventReceiver: TForm33;
  abbreviationForm: TFokoAbbreviationsForm;
  pageControl: TPageControl;
  initialPage: TTabSheet;
  targetPage: TTabSheet;
  closeRecorder: TPlaceDialogCloseRecorder;
begin
  Application.Initialize;
  previousMainForm := frmAhnenWinMain.Form1;
  previousPlaceForm := Unit33.Form33;
  previousAbbreviationForm := FokoAbbreviationsForm.Form38;
  mainForm := TForm1.CreateNew(nil);
  globalPlaceForm := TForm33.CreateNew(nil);
  eventReceiver := TForm33.CreateNew(nil);
  abbreviationForm := TFokoAbbreviationsForm.CreateNew(nil);
  closeRecorder := TPlaceDialogCloseRecorder.Create;
  try
    frmAhnenWinMain.Form1 := mainForm;
    Unit33.Form33 := globalPlaceForm;
    FokoAbbreviationsForm.Form38 := abbreviationForm;

    pageControl := TPageControl.Create(mainForm);
    pageControl.Parent := mainForm;
    mainForm.PageControl1 := pageControl;
    initialPage := TTabSheet.Create(mainForm);
    initialPage.PageControl := pageControl;
    targetPage := TTabSheet.Create(mainForm);
    targetPage.PageControl := pageControl;
    mainForm.TabSheet2 := targetPage;
    pageControl.ActivePage := initialPage;

    closeRecorder.MainForm := mainForm;
    closeRecorder.TargetPage := targetPage;
    globalPlaceForm.OnClose := @closeRecorder.RecordPlaceClose;
    abbreviationForm.OnClose := @closeRecorder.RecordAbbreviationClose;

    eventReceiver.BitBtn2Click(eventReceiver);

    AssertTrue(mainForm.PageControl1.ActivePage = targetPage);
    AssertEquals('PA', closeRecorder.Sequence);
    AssertTrue(closeRecorder.PlaceClosedOnTargetPage);
    AssertTrue(closeRecorder.AbbreviationClosedOnTargetPage);
  finally
    frmAhnenWinMain.Form1 := previousMainForm;
    Unit33.Form33 := previousPlaceForm;
    FokoAbbreviationsForm.Form38 := previousAbbreviationForm;
    closeRecorder.Free;
    abbreviationForm.Free;
    eventReceiver.Free;
    globalPlaceForm.Free;
    mainForm.Free;
  end;
end;

procedure TTestAHW52PlaceDialogKeyPress.
  TestEnterPostsNextDialogControlAndIsConsumed;
var
  placeForm: TForm33;
  key: Char;
  message: TMsg;
begin
  Application.Initialize;
  placeForm := TForm33.CreateNew(nil);
  try
    message := Default(TMsg);
    key := #13;
    placeForm.FormKeyPress(placeForm, key);

    if key <> #0 then
      raise Exception.Create('Enter should be consumed.');
    if not PeekMessage(message, placeForm.Handle, WM_NEXTDLGCTL,
      WM_NEXTDLGCTL, PM_REMOVE) then
      raise Exception.Create('Enter should post WM_NEXTDLGCTL.');
  finally
    placeForm.Free;
  end;
end;

procedure TTestAHW52PlaceDialogKeyPress.TestOtherKeyIsPreserved;
var
  placeForm: TForm33;
  key: Char;
  message: TMsg;
begin
  Application.Initialize;
  placeForm := TForm33.CreateNew(nil);
  try
    message := Default(TMsg);
    key := 'X';
    placeForm.FormKeyPress(placeForm, key);

    if key <> 'X' then
      raise Exception.CreateFmt('Expected key X to remain unchanged, got %s.',
        [key]);
    if PeekMessage(message, placeForm.Handle, WM_NEXTDLGCTL, WM_NEXTDLGCTL,
      PM_REMOVE) then
      raise Exception.Create('A non-Enter key must not post WM_NEXTDLGCTL.');
  finally
    placeForm.Free;
  end;
end;

procedure TTestAHW52PlaceDialogKeyPress.TestUnboundCounterIncrement;
var
  placeForm: TForm33;
begin
  placeForm := TForm33.CreateNew(nil);
  try
    GlobalVar_0061DFB0 := 31;
    placeForm._PROC_0053B6C4(placeForm);
    AssertEquals('Increment callback should add one.', 32,
      GlobalVar_0061DFB0);
  finally
    GlobalVar_0061DFB0 := 0;
    placeForm.Free;
  end;
end;

procedure TTestAHW52PlaceDialogKeyPress.TestUnboundCounterDecrement;
var
  placeForm: TForm33;
begin
  placeForm := TForm33.CreateNew(nil);
  try
    GlobalVar_0061DFB0 := 31;
    placeForm._PROC_0053B6F4(placeForm);
    AssertEquals('Decrement callback should subtract one.', 30,
      GlobalVar_0061DFB0);
  finally
    GlobalVar_0061DFB0 := 0;
    placeForm.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52PlaceDialogKeyPress);

end.
