unit testfvdriver;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry;

type

  { TTestFVDrivers }

  TTestFVDrivers= class(TTestCase)
  protected
    Procedure TearDown; override;
  published
    procedure TestDetectVideo;
  end;

implementation

uses drivers;

procedure TTestFVDrivers.TearDown;
begin
  drivers.DoneVideo;
end;

procedure TTestFVDrivers.TestDetectVideo;
begin
  DetectVideo;
  CheckEquals(80,drivers.ScreenMode.Col,'Detected Screenwidth: 80');
  CheckEquals(63,drivers.ScreenMode.Row,'Detected ScreenHeight: 63');
  CheckEquals(true,drivers.ScreenMode.Color,'Detected Screencolor: true');
end;


initialization

  RegisterTest(TTestFVDrivers);
end.

