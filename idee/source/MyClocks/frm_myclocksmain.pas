unit frm_MyClocksMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, DateTimePicker, Forms, Controls, Graphics,
  Dialogs, Buttons, ExtCtrls, StdCtrls, Spin, cmp_OneClock, rxdice, rxclock;

type

  { TForm1 }

  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    chbUseInternalTmr: TCheckBox;
    cbxClockMode: TComboBox;
    DateTimePicker1: TDateTimePicker;
    FloatSpinEdit1: TFloatSpinEdit;
    FloatSpinEdit2: TFloatSpinEdit;
    FloatSpinEdit3: TFloatSpinEdit;
    FloatSpinEdit4: TFloatSpinEdit;
    RxClock1: TRxClock;
    RxDice1: TRxDice;
    SpeedButton1: TSpeedButton;
    StaticText1: TStaticText;
    Timer1: TTimer;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure cbxClockModeChange(Sender: TObject);
    procedure chbUseInternalTmrClick(Sender: TObject);
    procedure FloatSpinEdit4Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
    FMyClock:TOneClock;
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

uses math,GraphMath,frm_MyClockDef;

{ TForm1 }

procedure TForm1.BitBtn1Click(Sender: TObject);
var
  i, j: Integer;
  r, dd, nzz, rzz: ValReal;
  c0,cc: TColor;
  pp,npp,rpp:TFloatPoint;
  Nom,rOm,na, ra: Extended;

const r1= 21.50;
      r2= 6.5;

begin
  for i := 0 to 50 do
    for j := 0 to 50 do
      begin
        r:=sqrt(sqr( i-25)+sqr(j-25));
        dd := r2*0.5-abs(r-r1);
        if dd>1.0 then
          dd:=1.0
        else if dd<0.0 then
          dd:=0.0;
        if dd>0.0 then
          begin
            pp := Point(i-25,j-25)/r;
            nOm:=arcSin((r-r1)/(r2*0.5));
            rOm:=arcSin((r-r1)/(r2*0.5))*2;
            npp:=pp*sin(-nom);
            nzz:=cos(nOm);
            na:=0.4+(0.5*nzz+npp.x*0.5+npp.Y*sqrt(0.5))*0.4;
            rpp:=pp*sin(-rOm);
            rzz:=cos(rOm);
            ra :=(0.5*rzz+npp.x*0.5+rpp.Y*sqrt(0.5));
            if ra>0.9 then
              na:=1.0
            else if ra >0.8 then
              na := max(na,(ra-0.8)*10.0);
        c0 := Canvas.Pixels[i,j];
        na := dd*na+(1.0-dd)*(c0 and $ff)/255;
        cc := RGBToColor(round(na*255),round(na*255),round(na*255));
        Canvas.Pixels[i,j]:=cc;
          end;
      end;
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin

end;

procedure TForm1.BitBtn3Click(Sender: TObject);
begin
  frmMyClockDef.show;
end;

procedure TForm1.cbxClockModeChange(Sender: TObject);
begin
  FMyClock.Mode:=TEnumMyClockMode(ptrint(cbxClockMode.Items.Objects[cbxClockMode.ItemIndex]));
end;

procedure TForm1.chbUseInternalTmrClick(Sender: TObject);
begin
  FMyClock.InternalTimer:=chbUseInternalTmr.Checked;
end;

procedure TForm1.FloatSpinEdit4Change(Sender: TObject);
begin
  StaticText1.Caption:=FloatToStr(
    Floatspinedit4.Value - floor(Floatspinedit4.Value*0.5+0.5-Floatspinedit3.Value*0.5)*2);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FMyClock:=ToneClock.create(self);
  FMyClock.parent:=self;
  with FMyClock do
    begin
    top:= 20;
    left := 20;
    width:=100;
    height:=100;
    Mode := emcm_ActTime;
    end;
  FMyClock.FillModeList(cbxClockMode.Items);
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
var
  lTime: TMyTimeRecord;
begin
  lTime.Setvalues(FloatSpinEdit1.Value,FloatSpinEdit2.Value);
  FMyClock.Delay:=100;
  FMyClock.Speed:=lTime;

end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if not FMyClock.InternalTimer then
    FMyClock.OnTimer(sender);
  DateTimePicker1.Time:=FMyClock.ActTime;
end;

end.

