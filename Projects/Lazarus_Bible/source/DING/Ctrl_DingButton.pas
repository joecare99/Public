unit Ctrl_DingButton;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType, LCLVersion, LMessages,
{$ENDIF}
   SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls;

type
  TDingButton = class(TButton)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    procedure Click; override;
    { Public declarations }
  published
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TDingButton]);
end;

procedure TDingButton.Click;
begin
  {$IFDEF FPC}
  Beep;
  {$ELSE}
  MessageBeep(0);
  {$ENDIF}
  inherited Click;
end;


end.
