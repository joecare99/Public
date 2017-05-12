unit Frm_SPLASH;

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
  Forms, Dialogs, StdCtrls, ExtCtrls, ComCtrls;

type
  TSplashForm = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Bevel1: TBevel;
    ProgressBar1: TProgressBar;
  private
  { Private declarations }
  strict private
    function GetProgress : Integer;
    procedure SetProgress(val : Integer);
  public
    property Progress : Integer read GetProgress write SetProgress;
  { Public declarations }

  end;

var
  SplashForm: TSplashForm;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}
function TSplashForm.GetProgress: Integer;
begin
  result:=ProgressBar1.Position;
end;

procedure TSplashForm.SetProgress(val : Integer);
begin
  if ProgressBar1.Position <> val then
    begin
      ProgressBar1.Position :=val;
      Update;
    end;
end;

end.
