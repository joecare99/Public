unit tst_AHW52_MainFormFocusHandlers;

{$mode objfpc}{$H+}

interface

uses
  fpcunit, testregistry, frmAhnenWinMain;

type
  TTestAHW52MainFormMenuDispatch = class(TTestCase)
  private
    FDispatchOrder: string;
    FMainForm: TForm1;
    procedure RecordFamilyGraphicsMenuClick(Sender: TObject);
    procedure RecordFamilyGraphicsFormShow(Sender: TObject);
  published
    procedure TestFamilyGraphicsMenuSelectsTabClicksMenuAndShowsGlobalForm;
    procedure TestAnzeigenMenuSelectsEditTabAndShowsGrid;
  end;

  TTestAHW52MainFormFocusHandlers = class(TTestCase)
  published
    procedure TestHelpMenuDisplaysManualGuidanceWithoutShowingDialog;
    procedure TestFormActivateFocusesGlobalDBEdit2;
    procedure TestTabSheet2ShowFocusesDBEdit2;
    procedure TestEditTabEnterSkipsRefreshForNewRecordMode;
    procedure TestDBGrid3ExitHidesGridAndLabelAndFocusesDBComboBox3;
  end;

  TTestAHW52MainFormGridKeyDown = class(TTestCase)
  published
    procedure TestEscapeHidesGridAndOtherKeysPreserveIt;
    procedure TestDBGrid3EscapeClearsAndHidesWithoutConsumingKey;
  end;

implementation

uses
  ComCtrls, Controls, DBCtrls, DBGrids, Forms, Grids, InterfaceBase, Menus,
  StdCtrls, Unit11, AncestorChartOptionsForm;

procedure TTestAHW52MainFormMenuDispatch.RecordFamilyGraphicsMenuClick(
  Sender: TObject);
begin
  AssertEquals('The menu click should run before the graphics form is shown.',
    '', FDispatchOrder);
  AssertTrue('The handler should select TabSheet2 before clicking aus1.',
    FMainForm.PageControl1.ActivePage = FMainForm.TabSheet2);
  FDispatchOrder := 'M';
end;

procedure TTestAHW52MainFormMenuDispatch.RecordFamilyGraphicsFormShow(
  Sender: TObject);
begin
  AssertEquals('The menu click should run before the graphics form is shown.',
    'M', FDispatchOrder);
  AssertTrue('TabSheet2 should remain active when the graphics form is shown.',
    FMainForm.PageControl1.ActivePage = FMainForm.TabSheet2);
  FDispatchOrder := FDispatchOrder + 'S';
end;

procedure TTestAHW52MainFormMenuDispatch.
  TestFamilyGraphicsMenuSelectsTabClicksMenuAndShowsGlobalForm;
var
  mainForm: TForm1;
  firstTab: TTabSheet;
  pageControl: TPageControl;
  graphicsForm: TForm11;
  previousGraphicsForm: TForm11;
begin
  Application.Initialize;
  mainForm := TForm1.CreateNew(nil);
  pageControl := TPageControl.Create(mainForm);
  firstTab := TTabSheet.Create(mainForm);
  graphicsForm := TForm11.CreateNew(nil);
  previousGraphicsForm := Unit11.Form11;
  FMainForm := mainForm;
  FDispatchOrder := '';
  Unit11.Form11 := graphicsForm;
  try
    pageControl.Parent := mainForm;
    firstTab.PageControl := pageControl;
    firstTab.Caption := 'Initial';
    mainForm.TabSheet2 := TTabSheet.Create(mainForm);
    mainForm.TabSheet2.PageControl := pageControl;
    mainForm.TabSheet2.Caption := 'Edit';
    pageControl.ActivePage := firstTab;
    mainForm.PageControl1 := pageControl;
    mainForm.aus1 := TMenuItem.Create(mainForm);
    mainForm.aus1.OnClick := @RecordFamilyGraphicsMenuClick;
    graphicsForm.OnShow := @RecordFamilyGraphicsFormShow;
    graphicsForm.AlphaBlend := True;
    graphicsForm.AlphaBlendValue := 0;
    graphicsForm.ShowInTaskBar := stNever;

    mainForm.FamGrafik1Click(mainForm.aus1);

    AssertEquals('Expected the menu click before the form-show event.',
      'MS', FDispatchOrder);
    AssertTrue('The target global graphics form should be visible.',
      graphicsForm.Visible);
  finally
    graphicsForm.Hide;
    Unit11.Form11 := previousGraphicsForm;
    FMainForm := nil;
    graphicsForm.Free;
    mainForm.Free;
  end;
end;

procedure TTestAHW52MainFormMenuDispatch.
  TestAnzeigenMenuSelectsEditTabAndShowsGrid;
var
  mainForm: TForm1;
  pageControl: TPageControl;
  initialTab: TTabSheet;
  editTab: TTabSheet;
begin
  mainForm := TForm1.CreateNew(nil);
  try
    pageControl := TPageControl.Create(mainForm);
    pageControl.Parent := mainForm;
    initialTab := TTabSheet.Create(mainForm);
    initialTab.PageControl := pageControl;
    editTab := TTabSheet.Create(mainForm);
    editTab.PageControl := pageControl;
    pageControl.ActivePage := initialTab;
    mainForm.PageControl1 := pageControl;
    mainForm.TabSheet2 := editTab;
    mainForm.StringGrid5 := TStringGrid.Create(mainForm);
    mainForm.StringGrid5.Parent := editTab;
    mainForm.StringGrid5.Visible := False;

    mainForm.anzeigen1Click(nil);

    AssertTrue('The handler should activate the edit tab.',
      pageControl.ActivePage = editTab);
    AssertTrue('The handler should show StringGrid5.',
      mainForm.StringGrid5.Visible);
  finally
    mainForm.Free;
  end;
end;

var
  HelpPromptDialogCount: Integer;
  HelpPromptDialogText: string;

function RecordHelpPrompt(const DialogCaption, DialogMessage: string;
  DialogType: Longint; Buttons: PLongint; ButtonCount, DefaultIndex,
  EscapeResult: Longint; UseDefaultPos: Boolean; X, Y: Longint): Longint;
begin
  Inc(HelpPromptDialogCount);
  HelpPromptDialogText := DialogMessage;
  Result := 1;
end;

procedure TTestAHW52MainFormFocusHandlers.
  TestHelpMenuDisplaysManualGuidanceWithoutShowingDialog;
var
  mainForm: TForm1;
  previousPromptDialogFunction: TPromptDialogFunction;
begin
  Application.Initialize;
  previousPromptDialogFunction := PromptDialogFunction;
  PromptDialogFunction := @RecordHelpPrompt;
  HelpPromptDialogCount := 0;
  HelpPromptDialogText := '';
  mainForm := nil;
  try
    mainForm := TForm1.CreateNew(nil);
    mainForm.Hilfe1Click(mainForm);

    AssertEquals('The help menu should show the manual guidance once.',
      1, HelpPromptDialogCount);
    AssertEquals(
      'Bitte die beiliegende Datei "Handbuch.pdf" benützen',
      HelpPromptDialogText);
  finally
    mainForm.Free;
    PromptDialogFunction := previousPromptDialogFunction;
  end;
end;

procedure TTestAHW52MainFormFocusHandlers.TestFormActivateFocusesGlobalDBEdit2;
var
  mainForm: TForm1;
begin
  mainForm := TForm1.CreateNew(nil);
  try
    mainForm.DBEdit2 := TDBEdit.Create(mainForm);
    mainForm.DBEdit2.Parent := mainForm;
    Form1 := mainForm;
    try
      mainForm.FormActivate(mainForm);

      AssertTrue('Activating the main form should focus its global DBEdit2.',
        mainForm.ActiveControl = mainForm.DBEdit2);
    finally
      Form1 := nil;
    end;
  finally
    mainForm.Free;
  end;
end;

procedure TTestAHW52MainFormFocusHandlers.TestTabSheet2ShowFocusesDBEdit2;
var
  mainForm: TForm1;
begin
  mainForm := TForm1.CreateNew(nil);
  try
    mainForm.DBEdit2 := TDBEdit.Create(mainForm);
    mainForm.DBEdit2.Parent := mainForm;

    mainForm.TabSheet2Show(nil);

    AssertTrue('Showing the edit tab should focus DBEdit2.',
      mainForm.ActiveControl = mainForm.DBEdit2);
  finally
    mainForm.Free;
  end;
end;

procedure TTestAHW52MainFormFocusHandlers.
  TestEditTabEnterSkipsRefreshForNewRecordMode;
var
  mainForm: TForm1;
  previousMode: string;
begin
  mainForm := TForm1.CreateNew(nil);
  previousMode := AncestorChartOptionsForm.GlobalVar_0253592C;
  try
    AncestorChartOptionsForm.GlobalVar_0253592C := 'dsneu';
    mainForm.Caption := 'unchanged';
    mainForm.TabSheet2Enter(mainForm.TabSheet2);

    AssertEquals('The new-record sentinel should skip the refresh call.',
      'unchanged', mainForm.Caption);
  finally
    AncestorChartOptionsForm.GlobalVar_0253592C := previousMode;
    mainForm.Free;
  end;
end;

procedure TTestAHW52MainFormFocusHandlers.
  TestDBGrid3ExitHidesGridAndLabelAndFocusesDBComboBox3;
var
  mainForm: TForm1;
begin
  mainForm := TForm1.CreateNew(nil);
  try
    mainForm.DBGrid3 := TDBGrid.Create(mainForm);
    mainForm.DBGrid3.Parent := mainForm;
    mainForm.DBGrid3.Visible := True;
    mainForm.Label81 := TLabel.Create(mainForm);
    mainForm.Label81.Parent := mainForm;
    mainForm.Label81.Visible := True;
    mainForm.DBComboBox3 := TDBComboBox.Create(mainForm);
    mainForm.DBComboBox3.Parent := mainForm;

    mainForm.DBGrid3Exit(mainForm.DBGrid3);

    AssertFalse('Leaving DBGrid3 should hide the grid.',
      mainForm.DBGrid3.Visible);
    AssertFalse('Leaving DBGrid3 should hide Label81.',
      mainForm.Label81.Visible);
    AssertTrue('Leaving DBGrid3 should focus DBComboBox3.',
      mainForm.ActiveControl = mainForm.DBComboBox3);
  finally
    mainForm.Free;
  end;
end;

procedure TTestAHW52MainFormGridKeyDown.
  TestEscapeHidesGridAndOtherKeysPreserveIt;
var
  mainForm: TForm1;
  key: Word;
begin
  mainForm := TForm1.CreateNew(nil);
  try
    mainForm.StringGrid5 := TStringGrid.Create(mainForm);
    mainForm.StringGrid5.Parent := mainForm;
    mainForm.StringGrid5.Visible := True;

    key := $001B;
    mainForm.StringGrid5KeyDown(mainForm.StringGrid5, key, []);

    AssertFalse('Escape should hide StringGrid5.',
      mainForm.StringGrid5.Visible);
    AssertEquals('The handler should leave the key unchanged.',
      $001B, key);

    mainForm.StringGrid5.Visible := True;
    key := Ord('A');
    mainForm.StringGrid5KeyDown(mainForm.StringGrid5, key, []);

    AssertTrue('A non-Escape key should leave StringGrid5 visible.',
      mainForm.StringGrid5.Visible);
    AssertEquals('The handler should leave ordinary keys unchanged.',
      Ord('A'), key);
  finally
    mainForm.Free;
  end;
end;

procedure TTestAHW52MainFormGridKeyDown.
  TestDBGrid3EscapeClearsAndHidesWithoutConsumingKey;
var
  mainForm: TForm1;
  key: Word;
begin
  mainForm := TForm1.CreateNew(nil);
  try
    mainForm.DBGrid3 := TDBGrid.Create(mainForm);
    mainForm.DBGrid3.Parent := mainForm;
    mainForm.DBComboBox3 := TDBComboBox.Create(mainForm);
    mainForm.DBComboBox3.Parent := mainForm;
    mainForm.Label81 := TLabel.Create(mainForm);
    mainForm.Label81.Parent := mainForm;
    mainForm.DBComboBox3.Text := 'synthetic value';
    mainForm.DBGrid3.Visible := True;
    mainForm.Label81.Visible := True;

    key := $001B;
    mainForm.DBGrid3KeyDown(mainForm.DBGrid3, key, []);

    AssertEquals('', mainForm.DBComboBox3.Text);
    AssertFalse(mainForm.DBGrid3.Visible);
    AssertFalse(mainForm.Label81.Visible);
    AssertTrue(mainForm.ActiveControl = mainForm.DBComboBox3);
    AssertEquals($001B, key);

    mainForm.DBGrid3.Visible := True;
    mainForm.Label81.Visible := True;
    mainForm.DBComboBox3.Text := 'preserved value';
    mainForm.ActiveControl := mainForm.DBGrid3;
    key := Ord('A');
    mainForm.DBGrid3KeyDown(mainForm.DBGrid3, key, []);

    AssertEquals('preserved value', mainForm.DBComboBox3.Text);
    AssertTrue(mainForm.DBGrid3.Visible);
    AssertTrue(mainForm.Label81.Visible);
    AssertTrue(mainForm.ActiveControl = mainForm.DBGrid3);
    AssertEquals(Ord('A'), key);
  finally
    mainForm.Free;
  end;
end;

initialization
  RegisterTest(TTestAHW52MainFormMenuDispatch);
  RegisterTest(TTestAHW52MainFormFocusHandlers);
  RegisterTest(TTestAHW52MainFormGridKeyDown);

end.
