unit Frm_KeyCountMAIN;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, StdCtrls;

type
  TMainForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Timer1: TTimer;
    procedure FormCreate({%H-}Sender: TObject);
    procedure FormKeyDown({%H-}Sender: TObject; var Key: Word;
      {%H-}Shift: TShiftState);
    procedure FormKeyUp({%H-}Sender: TObject; var {%H-}Key: Word;
      {%H-}Shift: TShiftState);
    procedure Timer1Timer({%H-}Sender: TObject);
  private
    { Private declarations }
    Count: Integer;
    KeyPressed: Word;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Count := 0;
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ((Key = vk_up) or (Key = vk_down)) then
  begin
    KeyPressed := Key;
    Timer1.Enabled := True;
  end;
end;

procedure TMainForm.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Timer1.Enabled := False;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  if KeyPressed = vk_up then
    Inc(Count)
  else if KeyPressed = vk_down then
    Dec(Count);
  Label1.Caption := IntToStr(Count);
end;

end.

