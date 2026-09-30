unit NoteStorage;

{$mode objfpc}{$H+}

interface

uses
  Services;

type
  TInMemoryNoteStorage = class(TInterfacedObject, INoteStorage)
  private
    FText: string;
  public
    constructor Create;
    function LoadText: string;
    procedure SaveText(const AText: string);
  end;

implementation

constructor TInMemoryNoteStorage.Create;
begin
  FText := 'Welcome to the Lazarus MVVM showcase.' + LineEnding +
    'Try the calculator, calendar, notepad, and alarm clock.';
end;

function TInMemoryNoteStorage.LoadText: string;
begin
  Result := FText;
end;

procedure TInMemoryNoteStorage.SaveText(const AText: string);
begin
  FText := AText;
end;

end.
