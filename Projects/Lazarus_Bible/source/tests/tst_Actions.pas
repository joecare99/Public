UNIT tst_Actions;

{$IFDEF FPC}
{$mode delphi}{$H+}
{$EndIF}

INTERFACE

USES
  Classes, Forms, SysUtils, {$IFNDEF FPC}TestFramework, {$Else} fpcunit, testutils, testregistry, {$endif} Frm_ActionsMain;

TYPE

  { TTestActions }

  TTestActions = CLASS(TTestCase)
  private
    fIdleCnt:integer;
    procedure AppIdleEnd(Sender: TObject);
    procedure AppUserInput(Sender: TObject; Msg: Cardinal);
    procedure MouseMove(Data: NativeInt);
  protected
    PROCEDURE SetUp; override;
    PROCEDURE TearDown; override;
  published
    PROCEDURE TestSetUp;
    PROCEDURE TestFormMain;
    Procedure TestForm;
    PROCEDURE TestAction;
  END;

IMPLEMENTATION

uses strutils;

CONST
  CTestData: ARRAY[0..160] OF String =
    ('but', 'WITHOUT', 'ANY', 'WARRANTY; without', 'even', 'the', 'implied',
    'warranty', 'of', 'MERCHANTABILITY', 'or', 'FITNESS', 'FOR', 'A', 'PARTICULAR',
    'PURPOSE', 'See', 'the', 'GNU', 'General', 'Public', 'License',
    'for', 'more', 'details', 'You', 'should', 'have', 'received', 'a',
    'copy', 'of', 'the', 'GNU', 'General', 'Public', 'License', 'along',
    'with', 'this', 'program', 'If', 'not, see', 'This', 'script', 'compiles',
    'the', 'builder', 'and', 'the', 'examples', 'It', 'is', 'meant',
    'to', 'run', 'during', 'the', 'ci', 'process', 'Copyright',
    '(c) 2003-2018', ' Joe', 'Care', 'All', 'Rights', 'Reserved', 'This',
    'program', 'is', 'free', 'software', 'you', 'can', 'redistribute',
    'it', 'and/or', 'modify', 'it', 'under', 'the', 'terms', 'of', 'the',
    'GNU', 'General', 'Public', 'License', 'as', 'published', 'by',
    'the', 'Free', 'Software', 'Foundation', 'either', 'version', '3 of',
    'the', 'License, or', '(at', 'your', 'option)','any', 'later', 'version',
    'This', 'program', 'is', 'distributed', 'in', 'the', 'hope', 'that',
    'it', 'will', 'be', 'useful',
    'but', 'WITHOUT', 'ANY', 'WARRANTY; without', 'even', 'the', 'implied',
    'warranty', 'of', 'MERCHANTABILITY', 'or', 'FITNESS', 'FOR', 'A',
    'PARTICULAR', 'PURPOSE', 'See', 'the', 'GNU', 'General', 'Public',
    'License', 'for', 'more', 'details', 'You', 'should', 'have',
    'received', 'a', 'copy', 'of', 'the', 'GNU', 'General', 'Public',
    'License', 'along', 'with', 'this', 'program', 'If', 'not, see');

procedure TTestActions.TestSetUp;
BEGIN
  CheckNotNull(FrmActionsMain, 'Actions Mainform is initialized');
  CheckFalse(FrmActionsMain.Visible, 'MainForm is not visible at the moment');
END;

procedure TTestActions.TestFormMain;
BEGIN
  CheckFalse(FrmActionsMain.Visible, 'MainForm is not visible at the moment');
  FrmActionsMain.Show;
  Application.ProcessMessages;
  sleep(100);
  CheckTrue(FrmActionsMain.Visible, 'MainForm is visible now');
  FrmActionsMain.Cascade;
  Application.ProcessMessages;
  sleep(100);
  CheckTrue(FrmActionsMain.Visible, 'MainForm is visible now');
  FrmActionsMain.Tile;
  Application.ProcessMessages;
  sleep(100);
  CheckTrue(FrmActionsMain.Visible, 'MainForm is visible now');
  FrmActionsMain.hide;
  Application.ProcessMessages;
  sleep(100);
  CheckFalse(FrmActionsMain.Visible, 'MainForm is visible now');
END;

procedure TTestActions.TestForm;
begin
CheckFalse(FrmActionsMain.Visible, 'MainForm is not visible at the moment');
FrmActionsMain.Show;
{$IFDEF FPC}
Application.OnUserInput:=AppUserInput;
{$EndIF}
while FrmActionsMain.Visible do
   begin
    {$IFDEF FPC}
    Application.Idle(false);
    {$endif}
      Application.ProcessMessages;
      inc(fIdleCnt);
      sleep(10);
      if fIdleCnt> 300 then
        FrmActionsMain.Hide
      else
        frmActionsMain.Caption := 'Actions ['+DupeString('|',30-fIdleCnt div 10)+DupeString(' ',fIdleCnt div 10)+']';
   end;
end;

procedure TTestActions.TestAction;
var
  i: Integer;
  ltweak: Boolean;
BEGIN
  CheckFalse(FrmActionsMain.Visible, 'MainForm is not visible at the moment');
  FrmActionsMain.Show;
  Application.ProcessMessages;
    {$IFDEF FPC}
    Application.Idle(false);
    {$endif}
  sleep(10);
  CheckTrue(FrmActionsMain.Visible, 'MainForm is visible now');
  CheckFalse(FrmActionsMain.actDemoExit.Enabled, 'DemoExit is not Enabled');
  FrmActionsMain.edtEnterQuit.Text:='Test';
  Application.ProcessMessages;
    {$IFDEF FPC}
    Application.Idle(false);
    {$endif}
  sleep(10);
  CheckFalse(FrmActionsMain.actDemoExit.Enabled, 'DemoExit is not Enabled with ''Test''');
  FrmActionsMain.edtEnterQuit.Text:='Quit';
  Application.ProcessMessages;
    {$IFDEF FPC}
    Application.Idle(false);
    {$endif}
  sleep(10);
  CheckTrue(FrmActionsMain.actDemoExit.Enabled, 'DemoExit is Enabled with ''Quit''');
for i := 0 to 10000 do
begin
    ltweak:=random(10)=0;
    if ltweak then
      FrmActionsMain.edtEnterQuit.Text:='quit'
    else
      FrmActionsMain.edtEnterQuit.Text:=CTestData[random(length(CTestData))];
    Application.ProcessMessages;
    {$IFDEF FPC}
    Application.Idle(false);
    {$endif}
      sleep(0);
      if ltweak then
        CheckTrue(FrmActionsMain.actDemoExit.Enabled, 'DemoExit['+inttostr(i)+'] is Enabled with ''Quit''')
      else
        CheckFalse(FrmActionsMain.actDemoExit.Enabled, 'DemoExit['+inttostr(i)+'] is not Enabled with '''+
         FrmActionsMain.edtEnterQuit.Text+'''');

  end;

END;

procedure TTestActions.AppIdleEnd(Sender: TObject);
begin
end;

procedure TTestActions.AppUserInput(Sender: TObject; Msg: Cardinal);
begin
  FIdleCnt  := 0;
end;

procedure TTestActions.MouseMove(Data: NativeInt);
begin
//  KeyInput.Press(32);
//  MouseInput.Move([],FrmActionsMain,20+random(2),20+random(2));
end;

procedure TTestActions.SetUp;
BEGIN
  IF not assigned(FrmActionsMain) THEN
    Application.CreateForm(TFrmActionsMain, FrmActionsMain);
  FrmActionsMain.edtEnterQuit.Text:='';
END;

procedure TTestActions.TearDown;
var
  i: Integer;
BEGIN
  FrmActionsMain.hide;
END;

INITIALIZATION

  RegisterTest(TTestActions{$IFNDEF FPC}.Suite{$endif});
END.
