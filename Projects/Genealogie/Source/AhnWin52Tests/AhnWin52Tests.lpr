program AhnWin52Tests;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, Forms, consoletestrunner,
  tst_AHW52_AboutFormTests,
  tst_AHW52_BrowserFormTests,
  tst_AHW52_AttributeMaintenanceCancelTests,
  tst_AHW52_DBTablesCompatTests,
  tst_AHW52_FokoRowDeletionTests,
  tst_AHW52_FamilyNameListSelectionTests,
  tst_AHW52_FamilyNameDialogFinishTests,
  tst_AHW52_ComparisonParameterCancelTests,
  tst_AHW52_ComparisonParameterRadioTests,
  tst_AHW52_ComparisonParameterAcceptTests,
  tst_AHW52_HofnameListDoubleClickTests,
  tst_AHW52_FokoAbbreviationViewerTests,
  tst_AHW52_ProfessionDialogFinishTests,
  tst_AHW52_ProfessionListSelectionTests,
  tst_AHW52_FokoDialogCancelTests,
  tst_AHW52_GedcomDialogCancelTests,
  tst_AHW52_GraphicFormTests,
  tst_AHW52_GraphicsParameterDialogTests,
  tst_AHW52_HofnameFormTests,
  tst_AHW52_GregorianCalendarModelTests,
  tst_AHW52_GregorianCalendarCounterTests,
  tst_AHW52_InertMainFormHandlers,
  tst_AHW52_MainFormFocusHandlers,
  tst_AHW52_MainFormCloseTests,
  tst_AHW52_MainFormExitTests,
  tst_AHW52_MainFormDatasetControlsTests,
  tst_AHW52_MainFormKeyPressTests,
  tst_AHW52_MainRecordPersistenceTests,
  tst_AHW52_PersonEntryChoiceTests,
  tst_AHW52_ParentSelectionTests,
  tst_AHW52_ParentUnlinkTests,
  tst_AHW52_PlaceDialogKeyPressTests,
  tst_AHW52_PlaceSearchSelectionTests,
  tst_AHW52_PrivacyModeTests,
  tst_AHW52_RevolutionCalendarFormTests,
  tst_AHW52_SQLDBLocateTests,
  tst_AHW52_SourceDialogKeyPressTests,
  tst_AHW52_SourceDialogCancelTests,
  tst_AHW52_SourceListSelectionTests,
  tst_AHW52_FieldListCounterTests,
  tst_AHW52_ChoiceDialogCounterTests,
  tst_AHW52_FokoDialogCounterTests,
  tst_AHW52_TinyTafelDialogCancelTests,
  tst_AHW52_DataModuleCounterTests,
  tst_AHW52_DescendantParameterPresetsTests,
  tst_AHW52_DescendantParameterCounterTests,
  tst_AHW52_FamilySheetCounterTests,
  tst_AHW52_ChoiceDialogCheckboxPresetTests,
  tst_AHW52_QuickReportCompatTests;

var
  TestRunner: TTestRunner;
begin
  Application.Initialize;
  TestRunner := TTestRunner.Create(nil);
  try
    TestRunner.Initialize;
    TestRunner.Run;
  finally
    TestRunner.Free;
  end;
end.
