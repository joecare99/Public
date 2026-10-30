{ Registrierung der einbettbaren Demos fuer den BibleExplorer.

  Jede Demo, die in der Meta-App laufen soll, braucht eine Fabrikfunktion,
  die das Hauptformular erzeugt. Die Formulare werden dabei nicht global
  erzeugt, sondern mit dem Eigentuemer der Meta-App - so koennen sie
  mehrfach geoeffnet werden. }

unit BibleShowcaseRegistry;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  Classes, SysUtils, Forms, BibleShowcase;

type
  { TShowcaseRegistry }
  TShowcaseRegistry = class
  private
    FShowcase: TShowcase;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    { Registriert alle Demos, die eingebettet werden koennen. }
    procedure RegisterAll;
    property Showcase: TShowcase read FShowcase;
  end;

implementation

uses
  Frm_HelloMAIN, Frm_CALC, Frm_ReadMeMain, Frm_EnumFonMAIN, Frm_PrintgrMAIN,
  Frm_ListFontMAIN, Frm_CombosMAIN, Frm_ChecksMAIN, Frm_SpinButtonMAIN,
  Frm_ActionsMain, Frm_AddpageMAIN, Frm_GlyphListMain, Frm_ListTextMAIN,
  Frm_MultiWayMAIN, Frm_OptionsMain, Frm_PaletteMain, Frm_SketchMAIN,
  frm_ConstraintMain, frm_ContCompMAIN, Frm_FancyMAIN, Frm_FileMenuMAIN,
  Frm_ObjListMAIN, Frm_Toolbar3MAIN,
  Frm_StrlistMAIN, Frm_StrresMAIN, Frm_StatusMain, Frm_StatusODMain,
  Frm_TabsMAIN, Frm_OPTIONS, TABS_Frm_ABOUT, Frm_TelnameMAIN,
  Frm_Toolbar1MAIN, Frm_Toolbar2MAIN, Frm_UpDownDemoMain;

{ Fabrikfunktionen der Demos }

function CreateHelloForm: TForm;
begin
  Result := TForm1.Create(nil);
end;

function CreateCalc32Form: TForm;
begin
  Result := TfrmCalcMain.Create(nil);
end;

function CreateReadmeForm: TForm;
begin
  Result := TMainForm.Create(nil);
end;

function CreateEnumfonForm: TForm;
begin
  Result := TfrmEnumFontsMain.Create(nil);
end;

function CreatePrintgrForm: TForm;
begin
  Result := TfrmPrintgrMain.Create(nil);
end;

function CreateListfontForm: TForm;
begin
  Result := TfrmListfontMain.Create(nil);
end;

function CreateCombosForm: TForm;
begin
  Result := TfrmCombosMain.Create(nil);
end;

function CreateChecksForm: TForm;
begin
  Result := TfrmChecksMain.Create(nil);
end;

function CreateSpinbuttonForm: TForm;
begin
  Result := TfrmSpinButtonMain.Create(nil);
end;

function CreateActionsForm: TForm;
begin
  Result := TFrmActionsMain.Create(nil);
end;

function CreateAddpageForm: TForm;
begin
  Result := TfrmAddPageMain.Create(nil);
end;

function CreateGlypListForm: TForm;
begin
  Result := TfrmGlyphListMain.Create(nil);
end;

function CreateListTextForm: TForm;
begin
  Result := TfrmListTextMain.Create(nil);
end;

function CreateMultiWayForm: TForm;
begin
  Result := TfrmMultiWayMain.Create(nil);
end;

function CreateOptionsForm: TForm;
begin
  Result := TfrmOptionsMain.Create(nil);
end;

function CreatePaletteForm: TForm;
begin
  Result := TfrmPaletteMain.Create(nil);
end;

function CreateSketchForm: TForm;
begin
  Result := TfrmSketchMain.Create(nil);
end;

function CreateConstraintForm: TForm;
begin
  Result := TfrmConstraintMain.Create(nil);
end;

function CreateContCompForm: TForm;
begin
  Result := TfrmContCompMain.Create(nil);
end;

function CreateFancyForm: TForm;
begin
  Result := TfrmFancyMain.Create(nil);
end;

function CreateFileMenuForm: TForm;
begin
  Result := TfrmFileMenuMain.Create(nil);
end;

function CreateObjListForm: TForm;
begin
  Result := TfrmObjListMain.Create(nil);
end;

function CreateToolbar3Form: TForm;
begin
  Result := TfrmToolbar3Main.Create(nil);
end;

function CreateStrlistForm: TForm;
begin
  Result := TfrmStrlistMain.Create(nil);
end;

function CreateStrresForm: TForm;
begin
  Result := TfrmStrresMain.Create(nil);
end;

function CreateStatusForm: TForm;
begin
  Result := TfrmStatusMain.Create(nil);
end;

function CreateStatusodForm: TForm;
begin
  Result := TfrmStatusODMain.Create(nil);
end;

function CreateTabsForm: TForm;
begin
  Result := TfrmTabsMain.Create(nil);
end;

function CreateTelnameForm: TForm;
begin
  Result := TfrmTelnameMain.Create(nil);
end;

function CreateToolbar1Form: TForm;
begin
  Result := TfrmToolbar1Main.Create(nil);
end;

function CreateToolbar2Form: TForm;
begin
  Result := TfrmToolbar2Main.Create(nil);
end;

function CreateUpDownDemoForm: TForm;
begin
  Result := TfrmUpDownDemoMain.Create(nil);
end;

constructor TShowcaseRegistry.Create;
begin
  inherited Create;
  FShowcase := TShowcase.Create;
end;

destructor TShowcaseRegistry.Destroy;
begin
  FreeAndNil(FShowcase);
  inherited Destroy;
end;

procedure TShowcaseRegistry.RegisterAll;
begin
  FShowcase.Register('HELLO', 'Hallo Delphi Programmer', @CreateHelloForm);
  FShowcase.Register('Calc32', 'Taschenrechner', @CreateCalc32Form);
  FShowcase.Register('README', 'Readme anzeigen', @CreateReadmeForm);
  FShowcase.Register('Enumfon', 'Schriften auflisten', @CreateEnumfonForm);
  FShowcase.Register('Printgr', 'Grafik drucken', @CreatePrintgrForm);
  FShowcase.Register('Listfont', 'Schriftgroesse und Beispiele', @CreateListfontForm);
  FShowcase.Register('Combos', 'Kombinationsfelder', @CreateCombosForm);
  FShowcase.Register('Checks', 'Ankreuzfelder und Menue-Ebenen', @CreateChecksForm);
  FShowcase.Register('Spinbutt', 'Spin-Knoepfe und Zaehler', @CreateSpinbuttonForm);
  FShowcase.Register('Actions', 'Aktionen und Tasten', @CreateActionsForm);
  FShowcase.Register('Addpage', 'Seiten hinzufuegen', @CreateAddpageForm);
  FShowcase.Register('GlyphLst', 'Symbol-Liste', @CreateGlypListForm);
  FShowcase.Register('Listtext', 'Text in Listen', @CreateListTextForm);
  FShowcase.Register('Multimen', 'Mehrstufiges Menue', @CreateMultiWayForm);
  FShowcase.Register('Options', 'Optionsdialog', @CreateOptionsForm);
  FShowcase.Register('Palette', 'Farbpalette', @CreatePaletteForm);
  FShowcase.Register('Sketch', 'Zeichnen mit der Maus', @CreateSketchForm);
  FShowcase.Register('Constraint', 'Anordnungsregeln', @CreateConstraintForm);
  FShowcase.Register('Contcomp', 'Containersteuerelemente', @CreateContCompForm);
  FShowcase.Register('Fancy', 'Verschachtelte Formulare', @CreateFancyForm);
  FShowcase.Register('Filemenu', 'Dateimenue', @CreateFileMenuForm);
  FShowcase.Register('Objlist', 'Objektliste', @CreateObjListForm);
  FShowcase.Register('Toolbar3', 'Werkzeugleiste', @CreateToolbar3Form);
  FShowcase.Register('Strlist', 'String-Liste', @CreateStrlistForm);
  FShowcase.Register('Strres', 'String-Ressourcen', @CreateStrresForm);
  FShowcase.Register('Status', 'Statuszeile', @CreateStatusForm);
  FShowcase.Register('StatusOD', 'Statuszeile anpassbar', @CreateStatusodForm);
  FShowcase.Register('Tabs', 'Registerkarten', @CreateTabsForm);
  FShowcase.Register('Telname', 'Telefonnamen', @CreateTelnameForm);
  FShowcase.Register('Toolbar1', 'Werkzeugleiste 1', @CreateToolbar1Form);
  FShowcase.Register('Toolbar2', 'Werkzeugleiste 2', @CreateToolbar2Form);
  FShowcase.Register('UpDownDemo', 'Dreher-Button', @CreateUpDownDemoForm);
end;

end.
