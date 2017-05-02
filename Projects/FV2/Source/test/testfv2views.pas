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

implementation

uses fv2app,fv2drivers;

procedure TTestfv2Views.SetUp;
begin
  InitVideo;
  FDesktop := TDeskTop.Create(nil,rect(0,0,79,50));
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
  LV:= TFrame.Create(FDesktop,rect(5,5,60,20));
  for I := 0 to 100 do
    begin
      FDesktop.GetEvent(evt);
      FDesktop.HandleEvent(evt);
    end;
end;



initialization

  RegisterTest(TTestfv2Views);
end.

