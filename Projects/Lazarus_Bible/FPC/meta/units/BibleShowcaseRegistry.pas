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
  Frm_ListFontMAIN, Frm_CombosMAIN, Frm_ChecksMAIN, Frm_SpinButtonMAIN;

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
end;

end.
