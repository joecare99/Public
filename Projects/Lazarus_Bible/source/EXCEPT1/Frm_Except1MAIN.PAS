unit Frm_Except1MAIN;

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
  Forms, Dialogs, StdCtrls;

type
  TMainForm = class(TForm)
    Button1: TButton;
    ScrollBar1: TScrollBar;
    ScrollBar2: TScrollBar;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
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

procedure TMainForm.Button1Click(Sender: TObject);
begin
  try
    ScrollBar1.SetParams(0, 500, 0);
    ScrollBar2.SetParams(0, 500, 0);
  except
    on E: Exception do
      ShowMessage(E.Message);
  end;
end;

end.
