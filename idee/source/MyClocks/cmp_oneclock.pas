unit cmp_OneClock;

{$mode objfpc}{$H+}
{$modeswitch ADVANCEDRECORDS}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,ExtCtrls, 
    OpenGLContext, GL, BGRABitmap, BGRABitmapTypes, BGRAOpenGL;

type
  { TEnumMyClockMode }

  TEnumMyClockMode =
    (emcm_NoMode,
     emcm_ActTime, // Setze Zeiger auf aktuelle zeit (ggf. mit Acc/Dcc und Speed)
     emcm_Velocity, // Bewege Zeiger mit const. Speed (ggf. mit Acc/Dcc )
     emcm_Position, // Bewege Zeiger auf angeg. Position (ggf. mit Acc/Dcc und Speed)
     emcm_DelVelo,
     emcm_DelPosition,
     emcm_NormalPosition);// Bewege Ziel Position ist Zeiger Orthog. zu Vector (ggf. mit Acc/Dcc und Speed)

  TEnumPredefTimes =
    (pd12_00,     pd12_07,     pd12_15,     pd12_22,     pd12_30,     pd12_37,    pd12_45,     pd12_52,
     pd01_00,     pd01_07,     pd01_15,     pd01_22,    pd01_30,     pd01_37,     pd01_45,     pd01_52,
     pd03_00,     pd03_07,     pd03_15,     pd03_22,     pd03_30,     pd03_37,    pd03_45,     pd03_52,
     pd04_00,     pd04_07,     pd04_15,     pd04_22,    pd04_30,     pd04_37,     pd04_45,     pd04_52,
     pd06_00,     pd06_07,     pd06_15,     pd06_22,     pd06_30,     pd06_37,    pd06_45,     pd06_52,
     pd07_00,     pd07_07,     pd07_15,     pd07_22,    pd07_30,     pd07_37,     pd07_45,     pd07_52,
     pd08_00,     pd09_07,     pd08_15,     pd09_22,     pd09_30,     pd09_37,    pd09_45,     pd09_52,
     pd10_00,     pd10_07,     pd10_15,     pd10_22,    pd10_30,     pd10_37,     pd10_45,     pd10_52);

  { TMyTimeRecord }

  TMyTimeRecord=record
    h,m:single;
  public
    Procedure SetNTime(Hour,Min:single);
    function getNtime: TTime;
    Procedure SetValues(Hour,Min:single);
    Procedure SetPDefTime(aPD:TEnumPredefTimes);
    Procedure Normalize(Zero:TMyTimeRecord);
    class operator = (const apt1, apt2 : TMyTimeRecord) : Boolean;
    class operator = (const apt1 : TMyTimeRecord;nr:ShortInt) : Boolean;
   class operator <> (const apt1, apt2 : TMyTimeRecord): Boolean;
   class operator + (const apt1, apt2 : TMyTimeRecord): TMyTimeRecord;
   class operator - (const apt1, apt2 : TMyTimeRecord): TMyTimeRecord;
   class operator - (const apt1 : TMyTimeRecord): TMyTimeRecord;
   class operator * (const apt1, apt2: TMyTimeRecord): TMyTimeRecord; // scalar product
   class operator * (const apt1: TMyTimeRecord; afactor: single): TMyTimeRecord;
   class operator * (afactor: single; const apt1: TMyTimeRecord): TMyTimeRecord;
  end;

  { TOneClock }

  TOneClock = class(TOpenGLControl)
  private
    FDelay: integer;
    FInternalTimer: Boolean;
    FMode: TEnumMyClockMode;
    { private declarations }
    FTimer: TTimer;
    FoldTic:QWord;
    FTime,FActSpeed, // Actuelle Position & Bewegung
    FDestTime,FSpeed,Facc,Fdcc:TMyTimeRecord;
    FInitialised:boolean;
    FBgr, FHlBgr, FHourHand, FMinuteHand: TBGLBitmap;
    function getNtime: TTime;
    procedure SetAcc(AValue: TMyTimeRecord);
    procedure SetDcc(AValue: TMyTimeRecord);
    procedure SetDelay(AValue: integer);
    procedure SetDestTime(AValue: TMyTimeRecord);
    procedure SetInternalTimer(AValue: Boolean);
    procedure SetMode(AValue: TEnumMyClockMode);
    procedure SetNTime(AValue: TTime);
    procedure SetSpeed(AValue: TMyTimeRecord);
  protected
    procedure Draw;
    procedure RefreshBitmaps;
  public
    { public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Initialise;
    procedure Paint; override;
    Procedure Resize; override;
    procedure OnTimer(Sender: TObject);
    Class Procedure FillModeList(const List:TStrings);
    Class Procedure FillPDTmList(const List:TStrings);
    Property DestTime:TMyTimeRecord read FDestTime write SetDestTime;
    Property Speed:TMyTimeRecord read FSpeed write SetSpeed;
    property Delay:integer read FDelay write SetDelay;
    Property Acc:TMyTimeRecord read FAcc write SetAcc;
    Property Dcc:TMyTimeRecord read FDcc write SetDcc;
  published
    property ActTime:TTime read getNtime write SetNTime;
    property InternalTimer:Boolean read FInternalTimer write SetInternalTimer;
    property Mode:TEnumMyClockMode read FMode write SetMode;
  end;

const CMString:array[TEnumMyClockMode] of string=(
    'No Mode',
    'Actual Time',
    'Velocity',
    'Position',
    'delayed Velocity',
    'delayed Position',
    'Normal Vector');

Function MyTimeRecord(ah,am:single):TMyTimeRecord;

implementation

uses Math,FPimage;

function MyTimeRecord(ah, am: single): TMyTimeRecord;
begin
  result.SetValues(ah,am);
end;

{ TMyTimeRecord }

procedure TMyTimeRecord.SetNTime(Hour, Min: single);
begin
  h:=Hour/12.0;
  m:=min/60.0;
end;

function TMyTimeRecord.getNtime: TTime;
var
  mm, hh: Single;
begin
  mm:=m/24 ;
  hh:=(h/2 -mm+0.5/24);
  hh:= hh-floor(hh);
  result := floor(hh*24)/24+mm;
end;

procedure TMyTimeRecord.SetValues(Hour, Min: single);
begin
  h:=Hour;
  m:=min;
end;

procedure TMyTimeRecord.SetPDefTime(aPD: TEnumPredefTimes);
begin
  h := (ord(aPD) div 8) /8;
  m := (ord(aPD) mod 8) /8;
end;

procedure TMyTimeRecord.Normalize(Zero: TMyTimeRecord);
begin
  h := h - floor(h*0.5+0.5-Zero.h*0.5)*2;
  m := m - floor(m*0.5+0.5-Zero.m*0.5)*2;
end;

class operator TMyTimeRecord.=(const apt1, apt2: TMyTimeRecord): Boolean;
begin
  result := SameValue(apt1.h,apt2.h,1e-6) and SameValue(apt1.m,apt2.m,1e-6);
end;

class operator TMyTimeRecord.=(const apt1: TMyTimeRecord; nr: ShortInt
  ): Boolean;
begin
  if nr=0 then
    result := SameValue(apt1.h,0,1e-6) and SameValue(apt1.m,0,1e-6)
  else
    result := false;
end;

class operator TMyTimeRecord.<>(const apt1, apt2: TMyTimeRecord): Boolean;
begin
  result := not SameValue(apt1.h,apt2.h,1e-6) or not SameValue(apt1.m,apt2.m,1e-6);
end;

class operator TMyTimeRecord.+(const apt1, apt2: TMyTimeRecord): TMyTimeRecord;
begin
  result.h:=apt1.h+apt2.h;
  result.m:=apt1.m+apt2.m;
end;

class operator TMyTimeRecord.-(const apt1, apt2: TMyTimeRecord): TMyTimeRecord;
begin
  result.h:=apt1.h-apt2.h;
  result.m:=apt1.m-apt2.m;
end;

class operator TMyTimeRecord.-(const apt1: TMyTimeRecord): TMyTimeRecord;
begin
  result.h:=-apt1.h;
  result.m:=-apt1.m;
end;

class operator TMyTimeRecord.*(const apt1, apt2: TMyTimeRecord): TMyTimeRecord;
begin
  result.h:=apt1.h*apt2.h;
  result.m:=apt1.m*apt2.m;
end;

class operator TMyTimeRecord.*(const apt1: TMyTimeRecord; afactor: single
  ): TMyTimeRecord;
begin
  result.h:=apt1.h*afactor;
  result.m:=apt1.m*afactor;
end;

class operator TMyTimeRecord.*(afactor: single; const apt1: TMyTimeRecord
  ): TMyTimeRecord;
begin
  result.h:=apt1.h*afactor;
  result.m:=apt1.m*afactor;
end;

{ TOneClock }

procedure TOneClock.OnTimer(Sender: TObject);
var
  ActTic, dt: QWord;
  lDestMode: Boolean;
begin
  ActTic:=GetTickCount64;
  dt := Acttic-FoldTic;
  FoldTic:=Acttic;
  if dt>1000 then dt :=1;
  case FMode of
    emcm_NoMode:begin
      FSpeed.SetValues(0.0,0.0);
      FActSpeed.SetValues(0,0);
    end;
    emcm_ActTime:begin
      SetNTime(now());
      if FSpeed=0 then
       FSpeed.SetValues(0.2,0.2);
    end;
    emcm_Velocity:begin
    end;
  end;
  lDestMode := Fmode in [emcm_ActTime,emcm_Position,emcm_DelPosition];
  if (FTime <> FDestTime) or not lDestMode then
    begin
      // Calc new Actspeed if ness.
      if Facc=0 then
        FActSpeed:=FSpeed;
      // Handle Delay
      if FDelay > 0 then
        if (FDelay-int64(dt)) < 0 then Fdelay:=0
          else Fdelay := Fdelay -dt;

      // Destnation reached
      if lDestMode and (Fdelay=0 ) then
        begin
      if (Ftime.h < FDestTime.h) and
        (Ftime.h+FActSpeed.h*(dt*0.001) > FDestTime.h) then
          begin
            Ftime.h := FDestTime.h;
            FActSpeed.h:=0;
            FSpeed.h:=0;
          end
      else if Ftime.h > FDestTime.h then
        if  (Ftime.h+FActSpeed.h*(dt*0.001) < FDestTime.h) then
          begin
            Ftime.h := FDestTime.h;
            FActSpeed.h:=0;
            FSpeed.h:=0;
          end;

      if (Ftime.m < FDestTime.m)
        and (Ftime.m+FActSpeed.m*(dt*0.001) > FDestTime.m) then
          begin
            Ftime.m := FDestTime.m;
            FActSpeed.m:=0;
            FSpeed.m:=0;
          end
      else if (Ftime.m > FDestTime.m )  then
        if Ftime.m+FActSpeed.m*(dt*0.001) < FDestTime.m then
          begin
            Ftime.m := FDestTime.m;
            FActSpeed.m:=0;
            FSpeed.m:=0;
          end;
        end;
      Ftime := fTime + FActSpeed*(dt*0.001);
      FTime.Normalize(FDestTime);
      Invalidate;
    end;
end;

class procedure TOneClock.FillModeList(const List: TStrings);
var
  i: TEnumMyClockMode;
begin
  list.Clear;
  for i in TEnumMyClockMode do
      list.AddObject(CMString[i],Tobject(ptrint(ord(i))));
end;

class procedure TOneClock.FillPDTmList(const List: TStrings);
var
  i: TEnumPredefTimes;
  tm:TMyTimeRecord;
begin
  list.Clear;
  for i in TEnumPredefTimes do
     begin
       tm.SetPDefTime(i);
       list.AddObject(FormatDateTime('HH:mm',tm.getNtime),Tobject(ptrint(ord(i))));
     end;
end;

function TOneClock.getNtime: TTime;
begin
  result := FTime.getNTime;
end;

procedure TOneClock.SetAcc(AValue: TMyTimeRecord);
begin
  if FAcc=AValue then Exit;
  FAcc:=AValue;
end;

procedure TOneClock.SetDcc(AValue: TMyTimeRecord);
begin
  if FDcc=AValue then Exit;
  FDcc:=AValue;
end;

procedure TOneClock.SetDelay(AValue: integer);
begin
  if FDelay=AValue then Exit;
  FDelay:=AValue;
end;

procedure TOneClock.SetDestTime(AValue: TMyTimeRecord);
begin
  if FDestTime=AValue then Exit;
  FDestTime:=AValue;
end;

procedure TOneClock.SetInternalTimer(AValue: Boolean);
begin
  if FInternalTimer=AValue then Exit;
  FInternalTimer:=AValue;
  if AValue then
    begin
    FTimer.Interval:=20;
    FTimer.OnTimer:=@OnTimer;
    end;
  FTimer.Enabled:=AValue;
end;

procedure TOneClock.SetMode(AValue: TEnumMyClockMode);
begin
  if FMode=AValue then Exit;
  FMode:=AValue;
end;

procedure TOneClock.SetNTime(AValue: TTime);
var
  tt: TTime;
begin
  tt := AValue-floor(AValue);
  FDestTime.h:=tt*2;
  FDestTime.m:=tt *24 -floor(tt*24);
end;

procedure TOneClock.SetSpeed(AValue: TMyTimeRecord);
begin
  if FSpeed=AValue then Exit;
  FSpeed:=AValue;
end;

procedure TOneClock.Draw;

  procedure DrawHand(Bmp: TBGLBitmap; Angle: single);
  var
     x, y: integer;
  begin
    x := round((width - Bmp.Width ) * 0.5);
    y := round((height - Bmp.Width ) *0.5);
    Bmp.Texture.DrawAngle(x, y, Angle* 360+180, PointF(Bmp.Width* 0.5, Bmp.Width *0.5), True);
  end;

begin
  if csFocusing in ControlState then
    FHlBgr.Texture.Draw(0, 0)
  else
    FBgr.Texture.Draw(0, 0);
  DrawHand(FHourHand, FTime.h  );
  DrawHand(FMinuteHand, FTime.m );
end;

procedure TOneClock.RefreshBitmaps;

  Procedure DrawBackGr(bmp:TBGLBitmap;rad,light:single);
  var
  i, j: Integer;
  r, dd, nzz, rzz,
  Nom,rOm,na, ra: single;
  cc: TFPColor;
  pp,npp,rpp:TPointf;

const r1= 0.87;
      r2= 0.26;

  begin
     for i := 0 to bmp.Width do
    for j := 0 to bmp.Height do
      begin
        r:=sqrt(sqr( i-rad)+sqr(j-rad));
        dd := rad*r2*0.5-abs(r-rad*r1);
        if dd>1.0 then
          dd:=1.0
        else if dd<0.0 then
          dd:=0.0;
        if dd>0.0 then
          begin
            pp := PointF(i-rad,j-rad)*(1/r);
            nOm:=arcSin((r-rad*r1)/(rad*r2*0.5));
            rOm:=arcSin((r-rad*r1)/(rad*r2*0.5))*2;
            npp:=pp*sin(-nom);
            nzz:=cos(nOm);
            na:=light+(0.5*nzz+npp.x*0.5+npp.Y*sqrt(0.5))*0.4;
            rpp:=pp*sin(-rOm);
            rzz:=cos(rOm);
            ra :=(0.5*rzz+npp.x*0.5+rpp.Y*sqrt(0.5));
            if ra>0.9 then
              na:=1.0
            else if ra >0.8 then
              na := max(na,(ra-0.8)*10.0);
            na := na;
            cc:=FPColor(round(na*65535),round(na*65535),round(na*65535),round(dd*65535));
            bmp.CanvasBGRA.Colors[i,j]:=cc;
          end;
     end;

  end;

  var
    r, w, h: single;
    col: TBGRAPixel;
begin
  r := Height / 2;
     FBgr.SetSize(Height, Height);
     DrawBackGr(Fbgr,r,0.4);
     r := Height / 2;
     FHlBgr.SetSize(Height, Height);
     DrawBackGr(FHlBgr,r,0.5);
     h := r*0.75;
     w := max(0.15 * r,5);
     col := BGRABlack;
     FHourHand.SetSize(round(w), round(h));
     FHourHand.Rectangle(1, FHourHand.Width div 2, FHourHand.Width - 1, FHourHand.Height - FHourHand.Width div 2, BGRABlack, BGRABlack, dmSet);
     FHourHand.FillEllipseInRect(rect(1, 1, FHourHand.Width - 1, FHourHand.Width -1), BGRABlack);
     FHourHand.FillEllipseInRect(rect(1, FHourHand.Height-FHourHand.Width, FHourHand.Width -1, FHourHand.Height -1), BGRABlack);
     h := r*0.83 ;
     w := max(0.15 * r,5);
   col := BGRABlack;
     FMinuteHand.SetSize(round(w), round(h));
     FMinuteHand.Rectangle(1, FMinuteHand.Width div 2, FMinuteHand.Width - 1, FMinuteHand.Height - 1, col, col, dmSet);
end;

constructor TOneClock.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Fbgr:=TBGLBitmap.Create;
  FHlBgr:=TBGLBitmap.Create;
  FHourHand:=TBGLBitmap.Create;
  FMinuteHand:=TBGLBitmap.Create;
  FTimer:=TTimer.Create(self);
  ControlStyle:=ControlStyle><[csNoFocus];
end;

destructor TOneClock.Destroy;
begin
  FreeAndNil(FBgr);
  FreeAndNil(FhlBgr);
  FreeAndNil(FHourHand);
  FreeAndNil(FMinuteHand);
  inherited Destroy;
end;

procedure TOneClock.Initialise;


begin
  FInitialised:=true;
  RefreshBitmaps;
end;

procedure TOneClock.Paint;
begin
  inherited Paint;
  if not FInitialised then
    Initialise;
  BGLViewPort(Width, Height, BGRAWhite);
  Draw;
  SwapBuffers;
end;

procedure TOneClock.Resize;
begin
  inherited Resize;
  if FInitialised then
    RefreshBitmaps;
end;

end.

