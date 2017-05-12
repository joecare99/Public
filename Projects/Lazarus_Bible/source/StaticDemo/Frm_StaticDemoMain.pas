unit Frm_StaticDemoMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TMainForm = class(TForm)
    StaticText2: TStaticText;
    StaticText1: TStaticText;
    StaticText3: TStaticText;
    BitBtn1: TBitBtn;
    procedure StaticText1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure StaticText1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure StaticText1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

var
  SavedStyle: TStaticBorderStyle;

{ Change static text border style to indicate its selection }
procedure TMainForm.StaticText1MouseDown(Sender: TObject;
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
procedure TMainForm.StaticText1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  with Sender as TStaticText do
    BorderStyle := SavedStyle;
end;

{ Make a sound when text object is clicked }
procedure TMainForm.StaticText1Click(Sender: TObject);
var
  S: String;
begin
  MessageBeep(0);
  S := TStaticText(Sender).Name;
  ShowMessage('You selected ' + S);
end;

end.
