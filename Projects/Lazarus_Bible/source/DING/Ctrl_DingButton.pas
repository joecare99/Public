unit Ctrl_DingButton;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}

{$ELSE}
  LCLIntf, LCLType, LCLVersion,
{$ENDIF}
  Windows,        SysUtils, Classes, Graphics, Controls,
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
  MessageBeep(0);
  inherited Click;
end;


end.
