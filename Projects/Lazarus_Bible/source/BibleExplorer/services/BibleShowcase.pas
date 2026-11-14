{ Showcase - bettet die Demos in die Meta-App ein.

  Fuer jede Demo, die eingebettet werden kann, existiert ein Eintrag mit
  einer Fabrikfunktion. Die Fabrik erzeugt das Hauptformular der Demo; die
  Meta-App setzt es als Kind in den Tab "Verhalten". }

unit BibleShowcase;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  Classes, SysUtils, contnrs, Forms;

type
  { Fabrikfunktion: erzeugt das Hauptformular einer Demo. }
  TShowcaseFactory = function: TForm;

  { TShowcaseEntry - eine einbettbare Demo. }
  TShowcaseEntry = class
  private
    FKey: string;
    FTitle: string;
    FFactory: TShowcaseFactory;
  public
    constructor Create(const AKey, ATitle: string; AFactory: TShowcaseFactory);
    property Key: string read FKey;
    property Title: string read FTitle;
    property Factory: TShowcaseFactory read FFactory;
  end;

  { TShowcase - Verzeichnis aller einbettbaren Demos. }
  TShowcase = class
  private
    FEntries: TObjectList;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    { Meldet eine Demo an. }
    procedure Register(const AKey, ATitle: string; AFactory: TShowcaseFactory);
    { Erzeugt das Formular der Demo (nil, wenn nicht einbettbar). }
    function CreateForm(const AKey: string): TForm;
    function HasEntry(const AKey: string): Boolean;
    property Entries: TObjectList read FEntries;
  end;

implementation

{ TShowcaseEntry }

constructor TShowcaseEntry.Create(const AKey, ATitle: string;
  AFactory: TShowcaseFactory);
begin
  inherited Create;
  FKey := AKey;
  FTitle := ATitle;
  FFactory := AFactory;
end;

{ TShowcase }

constructor TShowcase.Create;
begin
  inherited Create;
  FEntries := TObjectList.Create(True);
end;

destructor TShowcase.Destroy;
begin
  FreeAndNil(FEntries);
  inherited Destroy;
end;

procedure TShowcase.Register(const AKey, ATitle: string;
  AFactory: TShowcaseFactory);
begin
  FEntries.Add(TShowcaseEntry.Create(AKey, ATitle, AFactory));
end;

function TShowcase.HasEntry(const AKey: string): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to FEntries.Count - 1 do
    if CompareText(TShowcaseEntry(FEntries[I]).Key, AKey) = 0 then
      Exit(True);
end;

function TShowcase.CreateForm(const AKey: string): TForm;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to FEntries.Count - 1 do
    if CompareText(TShowcaseEntry(FEntries[I]).Key, AKey) = 0 then
    begin
      Result := TShowcaseEntry(FEntries[I]).Factory();
      Exit;
    end;
end;

end.
