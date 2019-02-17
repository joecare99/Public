unit tst_AddPage;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry, Frm_AddpageMAIN;

type

  { TTestAddPage }

  TTestAddPage= class(TTestCase)
  private
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSetUp;
    PROCEDURE TestFormMain;
    Procedure TestForm;
    procedure TestAddPage;
    procedure TestAddComponent;
  end;

implementation

uses forms;

procedure TTestAddPage.SetUp;
begin
  IF not assigned(frmAddPageMain) THEN
    Application.CreateForm(TfrmAddPageMain, frmAddPageMain);
end;

procedure TTestAddPage.TearDown;
begin
  frmAddPageMain.hide;
  freeandnil(frmAddPageMain);
end;

procedure TTestAddPage.TestSetUp;
begin
   CheckNotNull(frmAddPageMain, 'AddPage Mainform is initialized');
  CheckFalse(frmAddPageMain.Visible, 'MainForm is not visible at the moment');
end;

procedure TTestAddPage.TestFormMain;
begin
  CheckFalse(frmAddPageMain.Visible, 'MainForm is not visible at the moment');
  frmAddPageMain.Show;
  Application.ProcessMessages;
  sleep(100);
  CheckTrue(frmAddPageMain.Visible, 'MainForm is visible now');
  frmAddPageMain.Cascade;
  Application.ProcessMessages;
  sleep(100);
  CheckTrue(frmAddPageMain.Visible, 'MainForm is visible now');
  frmAddPageMain.Tile;
  Application.ProcessMessages;
  sleep(100);
  CheckTrue(frmAddPageMain.Visible, 'MainForm is visible now');
  frmAddPageMain.hide;
  Application.ProcessMessages;
  sleep(100);
  CheckFalse(frmAddPageMain.Visible, 'MainForm is visible now');
end;

procedure TTestAddPage.TestForm;
begin
CheckFalse(frmAddPageMain.Visible, 'MainForm is not visible at the moment');
frmAddPageMain.Show;
while frmAddPageMain.Visible do
begin
      Application.HandleMessage;
      sleep(1);
   end;
end;

procedure TTestAddPage.TestAddPage;
begin
CheckFalse(frmAddPageMain.Visible, 'MainForm is not visible at the moment');
frmAddPageMain.Show;
Application.ProcessMessages;
sleep(100);
CheckTrue(frmAddPageMain.Visible, 'MainForm is visible now');
CheckEquals(1,frmAddPageMain.TabbedNotebook1.PageCount,'PageCount := 1');
frmAddPageMain.AddPageButtonClick(frmAddPageMain.AddPageButton);
Application.ProcessMessages;
sleep(100);
CheckEquals(2,frmAddPageMain.TabbedNotebook1.PageCount,'PageCount := 2');
frmAddPageMain.AddPageButtonClick(frmAddPageMain.AddPageButton);
Application.ProcessMessages;
sleep(100);
CheckEquals(3,frmAddPageMain.TabbedNotebook1.PageCount,'PageCount := 3');
frmAddPageMain.AddPageButtonClick(frmAddPageMain.AddPageButton);
Application.ProcessMessages;
sleep(100);
CheckEquals(4,frmAddPageMain.TabbedNotebook1.PageCount,'PageCount := 4');
frmAddPageMain.AddPageButtonClick(frmAddPageMain.AddPageButton);
Application.ProcessMessages;
sleep(100);
CheckEquals(5,frmAddPageMain.TabbedNotebook1.PageCount,'PageCount := 5');
frmAddPageMain.TabbedNotebook1.ActivePageIndex:=4;
Application.ProcessMessages;
sleep(100);
CheckEquals('Page 3',frmAddPageMain.TabbedNotebook1.ActivePage.Caption,'PageCount := 5');
frmAddPageMain.TabbedNotebook1.ActivePageIndex:=3;
Application.ProcessMessages;
sleep(100);
CheckEquals('Page 2',frmAddPageMain.TabbedNotebook1.ActivePage.Caption,'PageCount := 5');
frmAddPageMain.TabbedNotebook1.ActivePageIndex:=2;
Application.ProcessMessages;
sleep(100);
CheckEquals('Page 1',frmAddPageMain.TabbedNotebook1.ActivePage.Caption,'PageCount := 5');
frmAddPageMain.TabbedNotebook1.ActivePageIndex:=1;
Application.ProcessMessages;
sleep(100);
CheckEquals('Page 0',frmAddPageMain.TabbedNotebook1.ActivePage.Caption,'PageCount := 5');
frmAddPageMain.TabbedNotebook1.ActivePageIndex:=0;
Application.ProcessMessages;
sleep(100);
CheckEquals('Default',frmAddPageMain.TabbedNotebook1.ActivePage.Caption,'PageCount := 5');

end;

procedure TTestAddPage.TestAddComponent;
begin
CheckFalse(frmAddPageMain.Visible, 'MainForm is not visible at the moment');
frmAddPageMain.Show;
Application.ProcessMessages;
sleep(100);
CheckTrue(frmAddPageMain.Visible, 'MainForm is visible now');
CheckEquals(1,frmAddPageMain.TabbedNotebook1.PageCount,'PageCount := 1');
CheckEquals('Default',frmAddPageMain.TabbedNotebook1.ActivePage.Caption,'PageCount := 5');
frmAddPageMain.AddPageButtonClick(frmAddPageMain.AddPageButton);
Application.ProcessMessages;
sleep(100);
CheckEquals(2,frmAddPageMain.TabbedNotebook1.PageCount,'PageCount := 2');
CheckEquals('Default',frmAddPageMain.TabbedNotebook1.ActivePage.Caption,'ActivePage := Default');
frmAddPageMain.TabbedNotebook1.ActivePageIndex:=1;
Application.ProcessMessages;
sleep(100);
CheckEquals('Page 0',frmAddPageMain.TabbedNotebook1.ActivePage.Caption,'ActivePage := Page 0');
frmAddPageMain.AddControlButtonClick(frmAddPageMain.AddControlButton);
Application.ProcessMessages;
sleep(100);
CheckEquals(2,frmAddPageMain.TabbedNotebook1.PageCount,'PageCount := 2');
CheckEquals('Page 0',frmAddPageMain.TabbedNotebook1.ActivePage.Caption,'ActivePage := Page 0');
CheckEquals('',frmAddPageMain.ActiveControl.Caption,'ActiveControl := Page 0');
frmAddPageMain.AddPageButtonClick(frmAddPageMain.AddControlButton);
Application.ProcessMessages;
sleep(100);
CheckEquals(3,frmAddPageMain.TabbedNotebook1.PageCount,'PageCount := 3');
frmAddPageMain.TabbedNotebook1.ActivePageIndex:=2;
Application.ProcessMessages;
sleep(100);
CheckEquals('Page 1',frmAddPageMain.TabbedNotebook1.ActivePage.Caption,'ActivePage := Page 1');
frmAddPageMain.AddControlButtonClick(frmAddPageMain.AddControlButton);
Application.ProcessMessages;
sleep(100);
CheckEquals(3,frmAddPageMain.TabbedNotebook1.PageCount,'PageCount := 3');
CheckEquals('Page 1',frmAddPageMain.TabbedNotebook1.ActivePage.Caption,'ActivePage := Page 1');
CheckEquals('',frmAddPageMain.ActiveControl.Caption,'ActiveControl := Page 0');
frmAddPageMain.AddPageButtonClick(frmAddPageMain.AddPageButton);
Application.ProcessMessages;
sleep(100);
CheckEquals(4,frmAddPageMain.TabbedNotebook1.PageCount,'PageCount := 4');
frmAddPageMain.AddPageButtonClick(frmAddPageMain.AddPageButton);
Application.ProcessMessages;
sleep(100);
CheckEquals(5,frmAddPageMain.TabbedNotebook1.PageCount,'PageCount := 5');
frmAddPageMain.TabbedNotebook1.ActivePageIndex:=4;
Application.ProcessMessages;
sleep(100);
CheckEquals('Page 3',frmAddPageMain.TabbedNotebook1.ActivePage.Caption,'PageCount := 5');
frmAddPageMain.TabbedNotebook1.ActivePageIndex:=3;
Application.ProcessMessages;
sleep(100);
CheckEquals('Page 2',frmAddPageMain.TabbedNotebook1.ActivePage.Caption,'PageCount := 5');
frmAddPageMain.TabbedNotebook1.ActivePageIndex:=2;
Application.ProcessMessages;
sleep(100);
CheckEquals('Page 1',frmAddPageMain.TabbedNotebook1.ActivePage.Caption,'PageCount := 5');
frmAddPageMain.TabbedNotebook1.ActivePageIndex:=1;
Application.ProcessMessages;
sleep(100);
CheckEquals('Page 0',frmAddPageMain.TabbedNotebook1.ActivePage.Caption,'PageCount := 5');
frmAddPageMain.TabbedNotebook1.ActivePageIndex:=0;
Application.ProcessMessages;
sleep(100);
CheckEquals('Default',frmAddPageMain.TabbedNotebook1.ActivePage.Caption,'PageCount := 5');

end;

initialization

  RegisterTest(TTestAddPage);
end.

