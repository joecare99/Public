{ Prozessdienst: Starten externer Programme und Ausfuehren von Shell-
  Aktionen. Unter Free Pascal wird TProcess benutzt, unter Delphi die
  Shell-API - die Schnittstelle ist in beiden Faellen gleich. }

unit ProcessService;

interface

uses
  Classes, SysUtils, ServiceBase;

type
  { Ereignis: der Prozess hat eine Zeile Ausgabe geliefert. }
  TProcessOutputEvent = procedure(Sender: TObject; const ALine: string) of object;

  { TProcessService }
  TProcessService = class(TServiceBase)
  private
    FOutput: TProcessOutputEvent;
  public
    constructor Create;
    { Startet ein Programm und wartet auf das Ende. Liefert den Exitcode. }
    function Run(const AProgram, AParameters: string): Integer;
    { Startet ein Programm, wartet nicht und liefert die Ausgabe in AOutput. }
    function RunAndCapture(const AProgram, AParameters: string;
      AOutput: TStrings): Integer;
    { Oeffnet eine Datei oder URL mit dem Standardprogramm. }
    function Open(const ATarget: string): Boolean;
    property OnOutput: TProcessOutputEvent read FOutput write FOutput;
  end;

implementation

{$IFDEF FPC}
uses
  Process;
{$ELSE}
uses
  Windows, ShellAPI;
{$ENDIF}

constructor TProcessService.Create;
begin
  inherited Create('Prozess');
end;

{$IFDEF FPC}

{ Zerlegt eine Parameterzeile in einzelne Argumente (mit Anfuehrungszeichen). }
procedure SplitParameters(const AParameters: string; AList: TStrings);
var
  I: Integer;
  InQuote: Boolean;
  Current: string;
begin
  AList.Clear;
  Current := '';
  InQuote := False;
  for I := 1 to Length(AParameters) do
  begin
    if AParameters[I] = '"' then
      InQuote := not InQuote
    else if (AParameters[I] = ' ') and not InQuote then
    begin
      if Current <> '' then
        AList.Add(Current);
      Current := '';
    end
    else
      Current := Current + AParameters[I];
  end;
  if Current <> '' then
    AList.Add(Current);
end;

function TProcessService.Run(const AProgram, AParameters: string): Integer;
var
  Proc: TProcess;
begin
  Proc := TProcess.Create(nil);
  try
    Proc.Executable := AProgram;
    SplitParameters(AParameters, Proc.Parameters);
    Proc.Execute;
    Proc.WaitOnExit;
    Result := Proc.ExitCode;
    Log(Format('ausgefuehrt: %s %s -> %d', [AProgram, AParameters, Result]));
  finally
    Proc.Free;
  end;
end;

function TProcessService.RunAndCapture(const AProgram, AParameters: string;
  AOutput: TStrings): Integer;
var
  Proc: TProcess;
  Data: TStringList;
  Idx: Integer;
begin
  AOutput.Clear;
  Proc := TProcess.Create(nil);
  Data := TStringList.Create;
  try
    Proc.Executable := AProgram;
    SplitParameters(AParameters, Proc.Parameters);
    Proc.Options := [poUsePipes];
    Proc.Execute;
    Data.LoadFromStream(Proc.Output);
    Proc.WaitOnExit;
    Result := Proc.ExitCode;
    AOutput.Assign(Data);
    if Assigned(FOutput) then
      for Idx := 0 to Data.Count - 1 do
        FOutput(Self, Data[Idx]);
    Log(Format('ausgefuehrt: %s %s -> %d Zeilen', [AProgram, AParameters, Data.Count]));
  finally
    Data.Free;
    Proc.Free;
  end;
end;

function TProcessService.Open(const ATarget: string): Boolean;
begin
{$IFDEF UNIX}
  { unter Linux mit dem Standardprogramm oeffnen }
  Result := Run('xdg-open', ATarget) = 0;
{$ELSE}
  Result := OpenURL(ATarget);
{$ENDIF}
  Log('geoeffnet: ' + ATarget);
end;

{$ELSE}

function TProcessService.Run(const AProgram, AParameters: string): Integer;
var
  Proc: TProcess;
begin
  Proc := TProcess.Create(nil);
  try
    Result := Proc.Execute(AProgram, AParameters);
    Log(Format('ausgefuehrt: %s %s -> %d', [AProgram, AParameters, Result]));
  finally
    Proc.Free;
  end;
end;

function TProcessService.RunAndCapture(const AProgram, AParameters: string;
  AOutput: TStrings): Integer;
var
  Proc: TProcess;
begin
  AOutput.Clear;
  Proc := TProcess.Create(nil);
  try
    Result := Proc.Execute(AProgram, AParameters);
    Log(Format('ausgefuehrt: %s %s -> %d', [AProgram, AParameters, Result]));
  finally
    Proc.Free;
  end;
end;

function TProcessService.Open(const ATarget: string): Boolean;
begin
{$IFDEF UNIX}
  { unter Linux mit dem Standardprogramm oeffnen }
  Result := Run('xdg-open', ATarget) = 0;
{$ELSE}
  Result := ShellExecute(0, 'open', PChar(ATarget), nil, nil, SW_SHOWNORMAL) > 32;
{$ENDIF}
  Log('geoeffnet: ' + ATarget);
end;

{$ENDIF}

end.
