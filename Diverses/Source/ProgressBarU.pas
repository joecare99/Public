unit ProgressBarU;

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
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TProgessForm = class(TForm)
    ProgressBar1: TProgressBar;
    Label1: TLabel;
    procedure SetPercentage(Percent:byte);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  ProgessForm: TProgessForm;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

procedure TProgessForm.SetPercentage(Percent:byte);

var s:string;
begin
   s:=IntToStr(percent)+' %';
   label1.caption:=s;
   label1.update;
   ProgressBar1.Position :=Percent;

end;



end.
