unit Frm_SplashinMAIN;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  windows,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls;

type
  TMainForm = class(TForm)
    ExitButton: TButton;
    procedure ExitButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses Frm_SPLASH;
{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

procedure TMainForm.ExitButtonClick(Sender: TObject);
begin
  Close;
end;

{ The following procedure pauses for a few seconds so
  the Splash dialog remains visible for a predetermined
  length of time. }

procedure TMainForm.FormCreate(Sender: TObject);
  {$ifndef FPC}const FPC_VERSION=0;{$ENDIF}
var
  {$IF FPC_VERSION >= 3}
  ActTime,
  CurrentTime: QWord;
  {$ELSE}
  ActTime,
  CurrentTime: LongInt;
  {$IFEND}
begin
  CurrentTime := {$IF FPC_VERSION >= 3} GetTickCount64 {$ELSE} GetTickCount {$IFEND};
  Acttime := CurrentTime;
  while Acttime < (CurrentTime + 4000) do
    begin
      Sleep(1);
      Acttime := {$IF FPC_VERSION >= 3} GetTickCount64 {$ELSE} GetTickCount {$IFEND} ;
      SplashForm.Progress :=100-(CurrentTime + 4000 - Acttime) Div 40;
    end;
end;

end.

