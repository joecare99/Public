{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O-,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}

{$MINSTACKSIZE $00004000}

{$MAXSTACKSIZE $00100000}

{$IMAGEBASE $00400000}

{$APPTYPE GUI}

program DeDe;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
  Forms,
{$IFDEF FPC}
  Interfaces,
{$ENDIF}
  AboutUnit in 'View\AboutUnit.pas' {AboutBox},
  LodoUnit in 'View\LodoUnit.pas' {LogoForm},
  MemLocUnit in 'View\MemLocUnit.pas' {ChooseMemLocForm},
  AddClsMemDtaUnit in 'View\AddClsMemDtaUnit.pas' {AddClsMemDtaForm},
  ConverterUnit in 'View\ConverterUnit.pas' {ConverterForm},
  ASMConvertUnit in 'View\ASMConvertUnit.pas' {ASMForm},
  DeDeDisAsm in 'Core\DeDeDisAsm.pas',
  DeDeCoreServices in 'Core\DeDeCoreServices.pas',
  DeDeCore in 'Core\DeDeCore.pas',
  SectionEditUnit in 'View\SectionEditUnit.pas' {FlagsEditForm},
  ShowPEUnit in 'View\ShowPEUnit.pas' {PEIForm},
  AsmTables in 'Core\AsmTables.pas',
  PreferencesUnit in 'View\PreferencesUnit.pas' {PrefsForm},
  DeDeReg in 'ViewModel\DeDeReg.pas',
  BPLUnit in 'View\BPLUnit.pas' {BPL},
  DCUUnit in 'View\DCUUnit.pas' {DCUForm},
  DeDeDCUDumper in 'Core\DeDeDCUDumper.pas',
  DCUOptionUnit in 'View\DCUOptionUnit.pas' {DCUOptionForm},
  DeDeSym in 'Core\DeDeSym.pas',
  DeDeBPL in 'Core\DeDeBPL.pas',
  SymbolsUnit in 'View\SymbolsUnit.pas',
  Windows,
  DeDeHidden in 'Core\DeDeHidden.pas',
  ClassInfoUnit in 'View\ClassInfoUnit.pas' {ClassInfoForm},
  CRC32 in 'Core\CRC32.PAS',
  SelProcessUnit in 'View\SelProcessUnit.pas' {MemDmpForm},
  DeDeMemDumps in 'Core\DeDeMemDumps.pas',
  MainUnit in 'View\MainUnit.pas' {DeDeMainForm},
  EPFindUnit in 'View\EPFindUnit.pas' {EPFindForm},
  DeDeBSS in 'Core\DeDeBSS.pas',
  DeDeClassEmulator in 'Core\DeDeClassEmulator.pas',
  DeDeOffsInf in 'Core\DeDeOffsInf.pas',
  DOIBUnit in 'View\DOIBUnit.pas' {DOIBForm},
  PlugInInterface in 'Model\PlugInInterface.pas',
  custsetunit in 'View\custsetunit.pas' {w32CustSetForm},
  SpyDebugUnit in 'View\SpyDebugUnit.pas' {SpyDebugForm},
  DeDeRes in 'Core\DeDeRes.pas',
  ASMShow in 'View\ASMShow.pas' {ASMShowForm},
  DOIAddDtaUnit in 'View\DOIAddDtaUnit.pas' {DOIAddDataForm},
  SysUtils,
  AnalizUnit in 'View\AnalizUnit.pas' {AnalyzForm},
  DOIParsr in 'View\DOIParsr.pas' {DOIParsFrm},
  DeDeConstants in 'Model\DeDeConstants.pas',
  DeDe_SDK in 'Model\DeDe_SDK.pas' {Unit1},
  ShowPluginUnit in 'View\ShowPluginUnit.pas' {ShowPlugInForm},
  StatsUnit in 'View\StatsUnit.pas' {StatsForm},
  DBLogDlg in 'View\DBLogDlg.pas',
  DBPWDlg in 'View\DBPWDlg.pas',
  EditPropUnit in 'View\EditPropUnit.pas' {EditPropForm},
  TreeViewUnit in 'View\TreeViewUnit.pas' {TreeViewForm},
  asm2opcode in 'Core\asm2opcode.pas',
  DeDeDPJEng in 'Core\DeDeDPJEng.pas',
  DeDeEditText in 'View\DeDeEditText.pas' {EditTextForm},
  Emulator in 'Core\Emulator.pas',
  DeDeELFClasses in 'Model\DeDeELFClasses.pas',
  DeDeExpressions in 'Core\DeDeExpressions.pas',
  EditExprUnit in 'View\EditExprUnit.pas',
  DeDeDUF in 'Core\DeDeDUF.pas',
  DeDeClassHandle in 'Core\DeDeClassHandle.pas',
  DeDePAS in 'Core\DeDePAS.pas',
  DeDeUtils in 'Core\DeDeUtils.pas',
  FatExpression in 'Core\FatExpression.pas';

{$R 'Resources\DeDe.res'}


begin


  LogoForm := TLogoForm.Create(nil);
  try
    LogoForm.Show;
    LogoForm.Update;
    Sleep(500);

    Application.Initialize;
    Application.CreateForm(TDeDeMainForm, DeDeMainForm);
    Application.CreateForm(TAboutBox, AboutBox);
    Application.CreateForm(TConverterForm, ConverterForm);
    Application.CreateForm(TASMForm, ASMForm);
    Application.CreateForm(TFlagsEditForm, FlagsEditForm);
    Application.CreateForm(TPEIForm, PEIForm);
    Application.CreateForm(TPrefsForm, PrefsForm);
    Application.CreateForm(TBPL, BPL);
    Application.CreateForm(TDCUForm, DCUForm);
    Application.CreateForm(TDCUOptionForm, DCUOptionForm);
    Application.CreateForm(TSymbolsForm, SymbolsForm);
    Application.CreateForm(TClassInfoForm, ClassInfoForm);
    Application.CreateForm(TMemDmpForm, MemDmpForm);
    Application.CreateForm(TEPFindForm, EPFindForm);
    Application.CreateForm(TDOIBForm, DOIBForm);
    Application.CreateForm(Tw32CustSetForm, w32CustSetForm);
    Application.CreateForm(TSpyDebugForm, SpyDebugForm);
    Application.CreateForm(TASMShowForm, ASMShowForm);
    Application.CreateForm(TDOIAddDataForm, DOIAddDataForm);
    Application.CreateForm(TAnalyzForm, AnalyzForm);
    Application.CreateForm(TDOIParsFrm, DOIParsFrm);
    Application.CreateForm(TShowPlugInForm, ShowPlugInForm);
    Application.CreateForm(TStatsForm, StatsForm);
    Application.CreateForm(TEditTextForm, EditTextForm);
    Application.CreateForm(TEditExprForm, EditExprForm);
    Application.CreateForm(TEditPropForm, EditPropForm);
    Application.CreateForm(TTreeViewForm, TreeViewForm);
    Application.CreateForm(TChooseMemLocForm, ChooseMemLocForm);
    Application.CreateForm(TAddClsMemDtaForm, AddClsMemDtaForm);

    DeDeMainForm.Caption := 'DeDe ' + TargetDeDeVersion +
      ' (c) 1999-2002 by DaFixer';
    AboutBox.Version.Caption := 'Version ' + TargetDeDeVersion;
  finally
    LogoForm.Free;
  end;

  Application.Run;


end.
