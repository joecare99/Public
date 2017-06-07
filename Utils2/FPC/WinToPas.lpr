program WinToPas;

{$MODE Delphi}

uses
  Forms, Interfaces,
  fScanLog in '..\Source\ToPasfScanLog.pas' {ScanLog},
  uUI in '..\Source\ToPasuUI.pas',
  uParseC in '..\Source\ToPasuParseC.pas',
  uTablesC in '..\Source\ToPasuTablesC.pas',
  uXStrings in '..\Source\ToPasuXStrings.pas',
  uMacros in '..\Source\ToPasuMacros.pas',
  uScanC in '..\Source\ToPasuScanC.pas',
  fTypes in '..\Source\ToPasfTypes.pas' {TypeDefList},
  uToPas in '..\Source\ToPasuToPas.pas',
  uDirectives in '..\Source\ToPasuDirectives.pas',
  uFiles in '..\Source\ToPasuFiles.pas',
  uHashList in '..\Source\ToPasuHashList.pas',
  uTablesPrep in '..\Source\ToPasuTablesPrep.pas',
  uTokenC in '..\Source\ToPasuTokenC.pas',
  fScopeView in '..\Source\ToPasfScopeView.pas' {ScopeView},
  uLineScan in '..\Source\ToPasuLineScan.pas',
  fConfiguration in '..\Source\ToPasfConfiguration.pas' {ConfigViewer},
  fSymView in '..\Source\ToPasfSymView.pas' {SymView},
  uTranslator in '..\Source\ToPasuTranslator.pas',
  fMacros in '..\Source\ToPasfMacros.pas' {MacroChecker};

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
