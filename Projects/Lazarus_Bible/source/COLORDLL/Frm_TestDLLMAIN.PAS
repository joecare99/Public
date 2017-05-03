unit Frm_TestDLLMAIN;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
//  ShareMem,  { Not required by this example }
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
    Memo1: TMemo;
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

{- Declare external function in the Colorlib.Dll }
function FBGetColors(var FColor, BColor: TColor): WordBool; far;
  external 'Colorlib.dll';

{- Activate color dialog in the Colorlib.Dll }
procedure TMainForm.Button1Click(Sender: TObject);
var
  FColor, BColor: TColor;
begin
  FColor := Font.Color;    { Form's text color }
  BColor := Color;         { Window background color }
  if FBGetColors(FColor, BColor) then  { Call DLL ! }
  begin
    Memo1.Color := BColor;       { Assign window color }
    Memo1.Font.Color := FColor;  { Assign text color }
  end;
end;

end.
