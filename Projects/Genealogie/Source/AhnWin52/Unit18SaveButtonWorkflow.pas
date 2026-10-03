unit Unit18SaveButtonWorkflow;

{$IFDEF FPC}
{$MODE DELPHI}
{$ENDIF}

interface

type
  TUnit18SaveAction = procedure(Sender: TObject) of object;
  TUnit18MessageAction = procedure(const MessageText: string) of object;

procedure RunUnit18SaveButtonWorkflow(Sender: TObject;
  SaveAction: TUnit18SaveAction; MessageAction: TUnit18MessageAction);

implementation

procedure RunUnit18SaveButtonWorkflow(Sender: TObject;
  SaveAction: TUnit18SaveAction; MessageAction: TUnit18MessageAction);
begin
  SaveAction(Sender);
  MessageAction('Zum Drucken diese Datei in MS-Excel einlesen.');
end;

end.
