unit tst_BarTest2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry, Frm_BartestMain2;

type

  { TTestBarTest2 }

  TTestBarTest2= class(TTestCase)
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

uses Forms;
procedure TTestBarTest2.SetUp;
begin
  if not assigned(frmBarTestMain2) then
  Application.CreateForm(TfrmBarTestMain2,frmBarTestMain2);
end;

procedure TTestBarTest2.TearDown;
begin
  frmBarTestMain2.hide;
end;

procedure TTestBarTest2.TestSetUp;
begin
  CheckNotNull(frmBarTestMain2,'BarTest2 Mainform is initialized');
  CheckFalse(frmBarTestMain2.Visible,'MainForm is not visible at the moment');
end;

procedure TTestBarTest2.TestMainForm;
begin
  CheckFalse(frmBarTestMain2.Visible,'MainForm is not visible at the moment');
  frmBarTestMain2.Show;
  Application.ProcessMessages;
  sleep(100);
  CheckTrue(frmBarTestMain2.Visible,'MainForm is visible now');
  frmBarTestMain2.Cascade;
  Application.ProcessMessages;
  sleep(100);
  CheckTrue(frmBarTestMain2.Visible,'MainForm is visible now');
  frmBarTestMain2.Tile;
  Application.ProcessMessages;
  sleep(100);
  CheckTrue(frmBarTestMain2.Visible,'MainForm is visible now');
  frmBarTestMain2.hide;
  Application.ProcessMessages;
  sleep(100);
  CheckFalse(frmBarTestMain2.Visible,'MainForm is visible now');
end;

procedure TTestBarTest2.TestDataChange;
var
  i: Integer;
begin
  CheckFalse(frmBarTestMain2.Visible,'MainForm is not visible at the moment');
  frmBarTestMain2.Show;
  Application.ProcessMessages;
  for i := 0 to 1000 do
     begin
       frmBarTestMain2.BarChart1.Data[0]:=
          FloatToStr(i/10);
       frmBarTestMain2.BarChart1.Data[random(frmBarTestMain2.BarChart1.Data.Count-1)+1]:=
          FloatToStr(random(10000)/100);
       Application.ProcessMessages;
       sleep(20);
     end;

end;

procedure TTestBarTest2.TestOwnDataSet;
var
  i: Integer;
begin
  CheckFalse(frmBarTestMain2.Visible,'MainForm is not visible at the moment');
  frmBarTestMain2.Show;
  Application.ProcessMessages;
  frmBarTestMain2.BarChart1.Data.Clear;
  frmBarTestMain2.BarChart1.Data.Add('0');
  for i := 0 to 999 do
     begin
       frmBarTestMain2.BarChart1.Data[0]:=
          FloatToStr(i/20);
       if i mod 20 =0 then
       frmBarTestMain2.BarChart1.Data.Add('0');
       frmBarTestMain2.BarChart1.Data[random(frmBarTestMain2.BarChart1.Data.Count-1)+1]:=
          FloatToStr(random(10000)/100);
       Application.ProcessMessages;
       sleep(10);
     end;
  for i := 1000 to 1999 do
     begin
       frmBarTestMain2.BarChart1.Data[0]:=
          FloatToStr(i/20);
       if (i mod 20 =0) and (frmBarTestMain2.BarChart1.Data.Count>2) then
         frmBarTestMain2.BarChart1.Data.Delete(random(frmBarTestMain2.BarChart1.Data.Count-1)+1);
       frmBarTestMain2.BarChart1.Data[random(frmBarTestMain2.BarChart1.Data.Count-1)+1]:=
          FloatToStr(random(10000)/100);
       Application.ProcessMessages;
       sleep(10);
     end;

end;

procedure TTestBarTest2.Demo;
begin
  // Todo:
end;


initialization

  RegisterTest(TTestBarTest2);
end.

