unit tst_AHW52UICloseFlowTests;

{$mode objfpc}{$H+}
{$codepage utf8}

interface

uses
  AHW52UICloseFlow, fpcunit, testregistry;

type
  TTestAHW52UICloseFlow = class(TTestCase)
  published
    procedure TestClassifiesApplicationExitPrompt;
    procedure TestClassifiesBackupPrompt;
    procedure TestClassifiesEnglishCloseAndBackupPrompts;
    procedure TestClassifiesObservedAhnWinExitPrompt;
    procedure TestAllowsOnlyKnownNonWindowedPromptFallback;
    procedure TestRejectsUnrecognizedPrompt;
    procedure TestRecognizesLocalizedYesNoButtons;
    procedure TestDeclinesBackupAndAcceptsExit;
    procedure TestRejectsChoiceForUnknownPrompt;
  end;

implementation

uses
  SysUtils;

procedure TTestAHW52UICloseFlow.TestClassifiesApplicationExitPrompt;
begin
  AssertEquals(Ord(cpkExit),
    Ord(ClassifyClosePrompt('AHNENWIN 5.1 beenden ?')));
end;

procedure TTestAHW52UICloseFlow.TestClassifiesBackupPrompt;
begin
  AssertEquals(Ord(cpkBackup),
    Ord(ClassifyClosePrompt('Datensicherung ?')));
end;

procedure TTestAHW52UICloseFlow.TestClassifiesEnglishCloseAndBackupPrompts;
begin
  AssertEquals(Ord(cpkExit), Ord(ClassifyClosePrompt('Close?')));
  AssertEquals(Ord(cpkBackup), Ord(ClassifyClosePrompt('Backup?')));
end;

procedure TTestAHW52UICloseFlow.TestClassifiesObservedAhnWinExitPrompt;
begin
  AssertEquals(Ord(cpkExit),
    Ord(ClassifyClosePrompt('Bestätigen Ahenewin5.1 beenden')));
end;

procedure TTestAHW52UICloseFlow.TestAllowsOnlyKnownNonWindowedPromptFallback;
begin
  CheckTrue(CanUseKnownPromptSequenceFallback(
    'TMessageForm', 'Bestätigung', ''));
  CheckFalse(CanUseKnownPromptSequenceFallback(
    'TMessageForm', 'Unbekannt', ''));
  CheckFalse(CanUseKnownPromptSequenceFallback(
    '#32770', 'Bestätigung', ''));
  CheckFalse(CanUseKnownPromptSequenceFallback(
    'TMessageForm', 'Bestätigung', 'Unexpected message'));
end;

procedure TTestAHW52UICloseFlow.TestRejectsUnrecognizedPrompt;
begin
  AssertEquals(Ord(cpkUnknown),
    Ord(ClassifyClosePrompt('Person speichern?')));
end;

procedure TTestAHW52UICloseFlow.TestRecognizesLocalizedYesNoButtons;
begin
  AssertEquals(Ord(ccYes), Ord(ClassifyConfirmationButton('&Ja')));
  AssertEquals(Ord(ccYes), Ord(ClassifyConfirmationButton('&Yes')));
  AssertEquals(Ord(ccNo), Ord(ClassifyConfirmationButton('&Nein')));
  AssertEquals(Ord(ccNo), Ord(ClassifyConfirmationButton('&No')));
  AssertEquals(Ord(ccUnknown), Ord(ClassifyConfirmationButton('Abbrechen')));
end;

procedure TTestAHW52UICloseFlow.TestDeclinesBackupAndAcceptsExit;
begin
  AssertEquals(Ord(ccYes), Ord(RequiredCloseChoice(cpkExit)));
  AssertEquals(Ord(ccNo), Ord(RequiredCloseChoice(cpkBackup)));
end;

procedure TTestAHW52UICloseFlow.TestRejectsChoiceForUnknownPrompt;
begin
  try
    RequiredCloseChoice(cpkUnknown);
    Fail('An unknown dialog must not be answered automatically.');
  except
    on E: EArgumentException do
      CheckNotEquals('', E.Message);
  end;
end;

initialization
  RegisterTest(TTestAHW52UICloseFlow);

end.
