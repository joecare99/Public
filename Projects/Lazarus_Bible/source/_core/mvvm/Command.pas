{ Kommando-Objekt: kapselt eine Aktion, damit die View sie an Buttons,
  Menueeintraege oder Tastenkuerzel binden kann (Command-Pattern). }

unit Command;

interface

uses
  Classes, SysUtils;

type
  { Prueft, ob ein Kommando ausgefuehrt werden darf. }
  TCommandExecuteEvent = procedure(Sender: TObject) of object;
  { Prueft, ob ein Kommando ausfuehrbar ist. }
  TCommandCanExecuteEvent = function(Sender: TObject): Boolean; of object;

  { TCommand }
  TCommand = class
  private
    FExecute: TCommandExecuteEvent;
    FCanExecute: TCommandCanExecuteEvent;
    FDescription: string;
  public
    constructor Create(const ADescription: string);
    procedure Execute; virtual;
    function CanExecute: Boolean; virtual;
    property Description: string read FDescription write FDescription;
    property OnExecute: TCommandExecuteEvent read FExecute write FExecute;
    property OnCanExecute: TCommandCanExecuteEvent read FCanExecute write FCanExecute;
  end;

  { TRelayCommand }
  { Leitet an ein weiteres Kommando weiter - nuetzlich fuer die Umleitung
    von Aktionen zwischen View und ViewModel. }
  TRelayCommand = class(TCommand)
  private
    FTarget: TCommand;
  public
    procedure Execute; override;
    function CanExecute: Boolean; override;
    property Target: TCommand read FTarget write FTarget;
  end;

implementation

constructor TCommand.Create(const ADescription: string);
begin
  inherited Create;
  FDescription := ADescription;
end;

procedure TCommand.Execute;
begin
  if Assigned(FExecute) then
    FExecute(Self);
end;

function TCommand.CanExecute: Boolean;
begin
  Result := True;
  if Assigned(FCanExecute) then
    Result := FCanExecute(Self);
end;

procedure TRelayCommand.Execute;
begin
  if Assigned(FTarget) then
    FTarget.Execute
  else
    inherited Execute;
end;

function TRelayCommand.CanExecute: Boolean;
begin
  if Assigned(FTarget) then
    Result := FTarget.CanExecute
  else
    Result := inherited CanExecute;
end;

end.
