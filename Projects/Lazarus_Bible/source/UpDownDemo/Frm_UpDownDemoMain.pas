unit Frm_UpDownDemoMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, ComCtrls, Buttons;

type
  TMainForm = class(TForm)
    UpDown1: TUpDown;
    SpinButton1: TSpinButton;
    Label1: TLabel;
    Label2: TLabel;
    BitBtn1: TBitBtn;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    procedure SpinButton1UpClick(Sender: TObject);
    procedure SpinButton1DownClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

{ These constants and the two event handlers are needed
  by SpinButton components to associate them with another
  control, a StaticText object in this demonstration. The
  new UpDown component needs none of this programming because
  it can be automatically associated with another control. }
const
  Min = -10;
  Max = +10;

{ Respond to user clicking the SpinButton's Up button }
procedure TMainForm.SpinButton1UpClick(Sender: TObject);
var
  V: Integer;
begin
  V := StrToInt(StaticText2.Caption);
  if V = Max
    then V := Min
    else inc(V);
  StaticText2.Caption := IntToStr(V);
end;

{ Respond to user clicking the SpinButton's Down button }
procedure TMainForm.SpinButton1DownClick(Sender: TObject);
var
  V: Integer;
begin
  V := StrToInt(StaticText2.Caption);
  if V = Min
    then V := Max
    else dec(V);
  StaticText2.Caption := IntToStr(V);
end;

end.
