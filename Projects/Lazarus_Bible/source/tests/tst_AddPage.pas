unit tst_AddPage;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$EndIF}

interface

uses
  Classes, SysUtils, {$IFNDEF FPC}TestFramework, {$Else} fpcunit, testutils, testregistry, {$endif} Frm_AddpageMAIN;

type

  { TTestAddPage }

  TTestAddPage= class(TTestCase)
  private
    FIdleCnt:integer;
    procedure AppUserInput(Sender: TObject; Msg: Cardinal);
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

uses forms,strutils;

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

procedure TTestAddPage.AppUserInput(Sender: TObject; Msg: Cardinal);
begin
  FIdleCnt  := 0;
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
{$IFDEF FPC}
Application.OnUserInput:=AppUserInput;
{$ENDIF}
while frmAddPageMain.Visible do
begin
{$IFDEF FPC}
      Application.Idle(false);
{$ENDIF}
      Application.ProcessMessages;
      inc(fIdleCnt);
      sleep(10);
      if fIdleCnt> 300 then
        frmAddPageMain.Hide
      else
        frmAddPageMain.Caption := 'AddPage ['+DupeString('|',30-fIdleCnt div 10)+DupeString(' ',fIdleCnt div 10)+']';
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
{$IFDEF FPC}
  CheckEquals('',frmAddPageMain.ActiveControl.Caption,'ActiveControl := Page 0');
{$ENDIF}
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
{$IFDEF FPC}
  CheckEquals('',frmAddPageMain.ActiveControl.Caption,'ActiveControl := Page 0');
{$ENDIF}
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

  RegisterTest(TTestAddPage{$IFNDEF FPC}.Suite{$endif});
end.

