unit tc_BGIDemo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry, Unt_BGIDemo, graph, int_Graph;

type

  { TTestBGIDemo }

  TTestBGIDemo= class(TTestCase)
  private
    FGraphWindow:TGraphForm;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  public
    destructor Destroy; override;
  published
    procedure TestHookUp;
Procedure TestReportStatus;
Procedure TestAspectRatioPlay;
Procedure TestFillEllipsePlay;
Procedure TestSectorPlay;
Procedure TestWriteModePlay;
Procedure TestColorPlay;
Procedure TestPalettePlay;
Procedure TestPutPixelPlay;
Procedure TestPutImagePlay;
Procedure TestRandBarPlay;
Procedure TestBarPlay;
Procedure TestBar3DPlay;
Procedure TestArcPlay;
Procedure TestCirclePlay;
Procedure TestPiePlay;
Procedure TestLineToPlay;
Procedure TestLineRelPlay;
Procedure TestLineStylePlay;
Procedure TestUserLineStylePlay;
Procedure TestTextDump;
Procedure TestTextPlay;
Procedure TestCrtModePlay;
Procedure TestFillStylePlay;
Procedure TestFillPatternPlay;
Procedure TestPolyPlay;
Procedure TestSayGoodbye;
  end;

implementation

procedure TTestBGIDemo.TestHookUp;
begin
//  Fail('Write your own test');
end;

procedure TTestBGIDemo.TestReportStatus;
begin
  FGraphWindow.Caption:='ReportStatus';
  ReportStatus
end;

procedure TTestBGIDemo.TestAspectRatioPlay;
begin
  FGraphWindow.Caption:='AspectRatioPlay';
  AspectRatioPlay
end;

procedure TTestBGIDemo.TestFillEllipsePlay;
begin
  FGraphWindow.Caption:='FillEllipsePlay';
  FillEllipsePlay
end;

procedure TTestBGIDemo.TestSectorPlay;
begin
  FGraphWindow.Caption:='SectorPlay';
  SectorPlay
end;

procedure TTestBGIDemo.TestWriteModePlay;
begin
  FGraphWindow.Caption:='WriteModePlay';
  WriteModePlay
end;

procedure TTestBGIDemo.TestColorPlay;
begin
  FGraphWindow.Caption:='ColorPlay';
  ColorPlay
end;

procedure TTestBGIDemo.TestPalettePlay;
begin
  FGraphWindow.Caption:='PalettePlay';
  PalettePlay
end;

procedure TTestBGIDemo.TestPutPixelPlay;
begin
  FGraphWindow.Caption:='PutPixelPlay';
  PutPixelPlay
end;

procedure TTestBGIDemo.TestPutImagePlay;
begin
  FGraphWindow.Caption:='PutImagePlay';
  PutImagePlay
end;

procedure TTestBGIDemo.TestRandBarPlay;
begin
  FGraphWindow.Caption:='RandBarPlay';
  RandBarPlay
end;

procedure TTestBGIDemo.TestBarPlay;
begin
  FGraphWindow.Caption:='BarPlay';
  BarPlay
end;

procedure TTestBGIDemo.TestBar3DPlay;
begin
  FGraphWindow.Caption:='Bar3DPlay';
  Bar3DPlay
end;

procedure TTestBGIDemo.TestArcPlay;
begin
  FGraphWindow.Caption:='ArcPlay';
  ArcPlay
end;

procedure TTestBGIDemo.TestCirclePlay;
begin
  FGraphWindow.Caption:='CirclePlay';
  CirclePlay
end;

procedure TTestBGIDemo.TestPiePlay;
begin
  FGraphWindow.Caption:='PiePlay';
  PiePlay
end;

procedure TTestBGIDemo.TestLineToPlay;
begin
  FGraphWindow.Caption:='LineToPlay';
  LineToPlay
end;

procedure TTestBGIDemo.TestLineRelPlay;
begin
  FGraphWindow.Caption:='LineRelPlay';
  LineRelPlay
end;

procedure TTestBGIDemo.TestLineStylePlay;
begin
  FGraphWindow.Caption:='LineStylePlay';
  LineStylePlay
end;

procedure TTestBGIDemo.TestUserLineStylePlay;
begin
  FGraphWindow.Caption:='UserLineStylePlay';
  UserLineStylePlay
end;

procedure TTestBGIDemo.TestTextDump;
begin
  FGraphWindow.Caption:='TextDump';
  TextDump
end;

procedure TTestBGIDemo.TestTextPlay;
begin
  FGraphWindow.Caption:='TextPlay';
  TextPlay
end;

procedure TTestBGIDemo.TestCrtModePlay;
begin
  FGraphWindow.Caption:='CrtModePlay';
  CrtModePlay
end;

procedure TTestBGIDemo.TestFillStylePlay;
begin
  FGraphWindow.Caption:='FillStylePlay';
  FillStylePlay
end;

procedure TTestBGIDemo.TestFillPatternPlay;
begin
  FGraphWindow.Caption:='FillPatternPlay';
  FillPatternPlay
end;

procedure TTestBGIDemo.TestPolyPlay;
begin
  FGraphWindow.Caption:='PolyPlay';
  PolyPlay
end;

procedure TTestBGIDemo.TestSayGoodbye;
begin
  FGraphWindow.Caption:='SayGoodbye';
  SayGoodbye
end;

procedure TTestBGIDemo.SetUp;
var
  grm, grd: integer;
begin
  if not assigned(FGraphWindow) then
    begin
      if not assigned(GraphForm) then
        GraphForm:=TGraphForm.Create(nil);
      FGraphWindow:=GraphForm;
      Initializedmo;
    end;
end;

procedure TTestBGIDemo.TearDown;
begin
end;

destructor TTestBGIDemo.Destroy;
begin
//  freeandnil(FGraphWindow);
  inherited Destroy;
end;

initialization

  RegisterTest(TTestBGIDemo);
end.

