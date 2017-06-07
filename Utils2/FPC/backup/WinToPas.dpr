program WinToPas;

uses
  Forms, Interfaces,
  fScanLog in '..\Source\ToPas\fScanLog.pas' {ScanLog},
  uUI in '..\Source\ToPas\uUI.pas',
  uParseC in '..\Source\ToPas\uParseC.pas',
  uTablesC in '..\Source\ToPas\uTablesC.pas',
  uXStrings in '..\Source\ToPas\uXStrings.pas',
  uMacros in '..\Source\ToPas\uMacros.pas',
  uScanC in '..\Source\ToPas\uScanC.pas',
  fTypes in '..\Source\ToPas\fTypes.pas' {TypeDefList},
  uToPas in '..\Source\ToPas\uToPas.pas',
  uDirectives in '..\Source\ToPas\uDirectives.pas',
  uFiles in '..\Source\ToPas\uFiles.pas',
  uHashList in '..\Source\ToPas\uHashList.pas',
  uTablesPrep in '..\Source\ToPas\uTablesPrep.pas',
  uTokenC in '..\Source\ToPas\uTokenC.pas',
  fScopeView in '..\Source\ToPas\fScopeView.pas' {ScopeView},
  uLineScan in '..\Source\ToPas\uLineScan.pas',
  fConfiguration in '..\Source\ToPas\fConfiguration.pas' {ConfigViewer},
  fSymView in '..\Source\ToPas\fSymView.pas' {SymView},
  uTranslator in '..\Source\ToPas\uTranslator.pas',
  fMacros in '..\Source\ToPas\fMacros.pas' {MacroChecker};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TScanLog, ScanLog);
  Application.CreateForm(TTypeDefList, TypeDefList);
  Application.CreateForm(TScopeView, ScopeView);
  Application.CreateForm(TConfigViewer, ConfigViewer);
  Application.CreateForm(TSymView, SymView);
  Application.CreateForm(TMacroChecker, MacroChecker);
  Application.Run;
end.
