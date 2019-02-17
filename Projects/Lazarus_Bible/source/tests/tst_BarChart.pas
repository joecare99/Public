unit tst_BarChart;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry, Forms,BarChart;

type

  { TTestBarChart }

  TTestBarChart= class(TTestCase)
  private
    frmTestForm:TForm;
    FBarChart1:TBarChart;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSetUp;
    procedure TestMainForm;
    Procedure TestDataChange;
    procedure TestOwnDataSet;
    Procedure Demo;
  end;

implementation

uses Controls;
procedure TTestBarChart.SetUp;
var
  i: Integer;
begin
  if not assigned(frmTestForm) then
    Application.CreateForm(TForm,frmTestForm);
  frmTestForm.Top := Screen.Height div 10;
  frmTestForm.Left := Screen.Width div 10;
  frmTestForm.Height := Screen.Height div 3;
  frmTestForm.Width := Screen.Width div 3;
  frmTestForm.Caption:=TestName;
  FBarChart1:=TBarChart.Create(frmTestForm);
  with FBarChart1 do
    begin
      Parent := frmTestForm;
      Align:=alClient;
      BorderSpacing.Around:=12;
      for i := 0 to 5 do
         FBarChart1.Data.Add(FloatToStr(random(10000)/100));
    end;
end;

procedure TTestBarChart.TearDown;
begin
  freeandnil(FBarChart1);
  frmTestForm.hide;
end;

procedure TTestBarChart.TestSetUp;
begin
  CheckNotNull(frmTestForm,'Test-Mainform is initialized');
  CheckNotNull(FBarChart1,'BarChart is initialized');
  CheckFalse(frmTestForm.Visible,'MainForm is not visible at the moment');
end;

procedure TTestBarChart.TestMainForm;
begin
  CheckFalse(frmTestForm.Visible,'MainForm is not visible at the moment');
  frmTestForm.Show;
  Application.ProcessMessages;
  sleep(100);
  CheckTrue(frmTestForm.Visible,'MainForm is visible now');
  frmTestForm.Cascade;
  Application.ProcessMessages;
  sleep(100);
  CheckTrue(frmTestForm.Visible,'MainForm is visible now');
  frmTestForm.Tile;
  Application.ProcessMessages;
  sleep(100);
  CheckTrue(frmTestForm.Visible,'MainForm is visible now');
  frmTestForm.hide;
  Application.ProcessMessages;
  sleep(100);
  CheckFalse(frmTestForm.Visible,'MainForm is visible now');
end;

procedure TTestBarChart.TestDataChange;
var
  i: Integer;
begin
  CheckFalse(frmTestForm.Visible,'MainForm is not visible at the moment');
  frmTestForm.Show;
  Application.ProcessMessages;
  for i := 0 to 1000 do
     begin
       FBarchart1.Data[0]:=
          FloatToStr(i/10);
       FBarchart1.Data[random(FBarchart1.Data.Count-1)+1]:=
          FloatToStr(random(10000)/100);
       Application.ProcessMessages;
       sleep(20);
     end;

end;

procedure TTestBarChart.TestOwnDataSet;
var
  i: Integer;
begin
  CheckFalse(frmTestForm.Visible,'MainForm is not visible at the moment');
  frmTestForm.Show;
  Application.ProcessMessages;
  FBarchart1.Data.Clear;
  FBarchart1.Data.Add('0');
  for i := 0 to 999 do
     begin
       FBarchart1.Data[0]:=
          FloatToStr(i/20);
       if i mod 20 =0 then
       FBarchart1.Data.Add('0');
       FBarchart1.Data[random(FBarchart1.Data.Count-1)+1]:=
          FloatToStr(random(10000)/100);
       Application.ProcessMessages;
       sleep(10);
     end;
  for i := 1000 to 1999 do
     begin
       FBarchart1.Data[0]:=
          FloatToStr(i/20);
       if (i mod 20 =0) and (FBarchart1.Data.Count>2) then
         FBarchart1.Data.Delete(random(FBarchart1.Data.Count-1)+1);
       FBarchart1.Data[random(FBarchart1.Data.Count-1)+1]:=
          FloatToStr(random(10000)/100);
       Application.ProcessMessages;
       sleep(10);
     end;

end;

procedure TTestBarChart.Demo;
begin
  // Todo:
end;


initialization

  RegisterTest(TTestBarChart);
end.

