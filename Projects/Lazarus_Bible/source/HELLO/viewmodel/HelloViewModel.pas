{ ViewModel des Hello-Demos.

  Enthaelt die gesamte Logik des Demos: Begruessung, Klickzaehler und die
  Kommandos. Die View (Formular) bindet sich nur an die Eigenschaften und
  fuehrt nichts eigenstaendig aus. }

unit HelloViewModel;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  Classes, SysUtils, ViewModelBase, PropertyChangedEventArgs, Command;

type
  { THelloViewModel }
  THelloViewModel = class(TViewModelBase)
  private
    FGreeting: string;
    FClickCount: Integer;
    FCountCommand: TCommand;
    FCloseCommand: TCommand;
    procedure SetGreeting(const AValue: string);
    procedure SetClickCount(const AValue: Integer);
    procedure DoCountClick(Sender: TObject);
  public
    constructor Create; override;
    destructor Destroy; override;
    { Begruessungstext, der in der View angezeigt wird. }
    property Greeting: string read FGreeting write SetGreeting;
    { Anzahl der bisherigen Klicks auf den Aktionsknopf. }
    property ClickCount: Integer read FClickCount write SetClickCount;
    { Kommando: zaehlt einen Klick. }
    property CountCommand: TCommand read FCountCommand;
    { Kommando: beendet die Anwendung. Die View fuehrt es aus. }
    property CloseCommand: TCommand read FCloseCommand;
  end;

implementation

constructor THelloViewModel.Create;
begin
  inherited Create;
  FGreeting := 'Hello Delphi Programmer!';
  FClickCount := 0;
  FCountCommand := TCommand.Create('Klick zaehlen');
  FCountCommand.OnExecute := DoCountClick;
  FCloseCommand := TCommand.Create('Beenden');
end;

destructor THelloViewModel.Destroy;
begin
  FreeAndNil(FCountCommand);
  FreeAndNil(FCloseCommand);
  inherited Destroy;
end;

procedure THelloViewModel.SetGreeting(const AValue: string);
begin
  SetStringProperty(FGreeting, AValue, 'Greeting');
end;

procedure THelloViewModel.SetClickCount(const AValue: Integer);
begin
  SetIntegerProperty(FClickCount, AValue, 'ClickCount');
end;

procedure THelloViewModel.DoCountClick(Sender: TObject);
begin
  ClickCount := ClickCount + 1;
  Log(Format('Klick %d', [ClickCount]));
end;

end.
