unit Frm_StaticDemoMain;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}
interface

uses
 Messages,
 SysUtils,
 Classes,
 Graphics,
 Controls,
 Forms,
 Dialogs,

  StdCtrls,
 Buttons,
{$IFnDEF FPC}
  Windows,
{$ELSE}
  LCLIntf,
  LCLType,
  LMessages
{$ENDIF};

type
  TStaticDemoForm = class(TForm)
    StaticText2: TStaticText;
    StaticText1: TStaticText;
    StaticText3: TStaticText;
    BitBtn1: TBitBtn;
    procedure StaticText1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure StaticText1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure StaticText1Click(Sender: TObject);
  end;

var
  StaticDemoForm: TStaticDemoForm;

implementation

{$IFnDEF FPC}

  {$R *.dfm}

{$ELSE}

  {$R *.lfm}

{$ENDIF}
var
  SavedStyle: TStaticBorderStyle;

{ Change static text border style to indicate its selection }
procedure TStaticDemoForm.StaticText1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  with Sender as TStaticText do
  begin
    SavedStyle := BorderStyle;
    if BorderStyle = sbsSunken
      then BorderStyle := sbsSingle
      else BorderStyle := sbsSunken;
  end;
end;

{ Reset static text border style when mouse button released }
procedure TStaticDemoForm.StaticText1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  with Sender as TStaticText do
    BorderStyle := SavedStyle;
end;

{ Make a sound when text object is clicked }
procedure TStaticDemoForm.StaticText1Click(Sender: TObject);
var
  S: String;
begin
  Beep;
  S := TStaticText(Sender).Name;
  ShowMessage('You selected ' + S);
end;

end.
