unit testfv2Views;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry, fv2views;

type

  { TTestfv2Views }

  TTestfv2Views= class(TTestCase)
    FDesktop : TGroup;
  protected
    Procedure SetUp; override;
    Procedure TearDown; override;
  published
    procedure TestSetUp;
    procedure TestHookUp;
  end;

  { TTestView }

  TTestView=Class(TView)
    procedure Draw; override;
  end;


implementation

uses fv2app,fv2drivers, Dialogs;

type

   { TMyDesktop }

   TMyDesktop=Class(TDeskTop)
    Function GetPalette: PPalette; override;
  end;

{ TMyDesktop }

function TMyDesktop.GetPalette: PPalette;
CONST P: String[Length(CAppColor)] = CAppColor;
BEGIN
   GetPalette := PPalette(@P);
end;


{ TTestView }

procedure TTestView.Draw;
begin
  inherited Draw;

end;

procedure TTestfv2Views.SetUp;
begin
  InitVideo;
  FDesktop := TMyDesktop.Create(nil,rect(0,0,79,50));
end;

procedure TTestfv2Views.TearDown;
begin
 FreeAndNil(FDesktop);
 DoneVideo;
end;

procedure TTestfv2Views.TestSetUp;
begin
  CheckNotNull(FDesktop,'Desktop is initialized');
  CheckNotNull(FDesktop.canvas,'canvas is initialized');
end;

procedure TTestfv2Views.TestHookUp;
var
  LV: TFrame;
  evt: TEvent;
  I: Integer;
begin

  FDesktop.setstate(sfVisible,true);
  FDesktop.setstate(sfExposed,true);
  FDesktop.Draw;
  FDesktop.DrawView;
  CheckEquals(6, MessageDlg('Please Verify', 'There is a gray background on the Screen',
    mtConfirmation, mbYesNo, 0), 'Err: No confirm');

  LV:= TFrame.Create(FDesktop,rect(5,5,60,20));
  lv.parent := FDesktop;
  lv.setstate(sfVisible,true);
  lv.setstate(sfExposed,true);
  lv.BackgroundChar:=' ';

  FDesktop.Draw;
  FDesktop.DrawView;
  CheckEquals(6, MessageDlg('Please Verify', 'There is a LightGray filled rectangle with black borderline on a gray background on the Screen',
    mtConfirmation, mbYesNo, 0), 'Err: No confirm');
end;



initialization

  RegisterTest(TTestfv2Views);
end.

