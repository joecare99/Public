unit app_TestFvMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fvAppExt,fvForms, Editors, Menus, Dialogs, FVConsts, AsciiTab,
     Gadgets, TimedDlg, MsgBox, StdDlg,Views,drivers,objects;

type

{ TTVDemo }

  TTVDemo = class(TfvForm)
      public
        ClipboardWindow: PEditWindow;
        Clock: PClockView;
        Heap: PHeapView;
        P1,P2,P3 : PGroup;
        ASCIIChart : PAsciiChart;
      CONSTRUCTOR create(AOwner:Tobject);
      destructor Destroy; override;
      PROCEDURE Idle(Sender:TObject;const Event:TEvent); Virtual;
      PROCEDURE InitMenuBar; Virtual;
      PROCEDURE InitDeskTop; Virtual;
      PROCEDURE InitStatusLine; Virtual;
      public
      PROCEDURE Window1(Sender:TObject;const Event:TEvent);
      PROCEDURE Window2(Sender:TObject;const Event:TEvent);
      PROCEDURE Window3(Sender:TObject;const Event:TEvent);
      PROCEDURE TimedBox(Sender:TObject;const Event:TEvent);
      PROCEDURE AsciiWindow(Sender:TObject;const Event:TEvent);
      PROCEDURE ShowAboutBox(Sender:TObject;const Event:TEvent);
      PROCEDURE NewEditWindow(Sender:TObject;const Event:TEvent);
      PROCEDURE OpenFile(Sender:TObject;const Event:TEvent);
      PROCEDURE CloseWindow(Sender:TObject;const Event:TEvent);
      procedure ShowClippboard(sender:TObject;const event:TEvent);
      Procedure FormCreate(Sender: system.TObject); override;
    End;

var TVDemo:TTVDemo;

implementation

uses app;
const
  cmCloseWindow1    = 1101;
  cmCloseWindow2    = 1102;
  cmCloseWindow3    = 1103;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                           TTvDemo OBJECT METHODS                          }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}


constructor TTVDemo.create(AOwner: Tobject);
begin
  Inherited Create(AOwner);
end;

destructor TTVDemo.Destroy;
begin
  dispose(StatusLine,done);
  dispose(MenuBar,done);
  dispose(Desktop,done);
  inherited Destroy;
end;

procedure TTVDemo.Idle(Sender: TObject; const Event: TEvent);

function IsTileable(P: PView): Boolean; far;
begin
  IsTileable := (P^.Options and ofTileable <> 0) and
    (P^.State and sfVisible <> 0);
end;

{$ifdef DEBUG}
Var
   WasSet : boolean;
{$endif DEBUG}
begin
{$ifdef DEBUG}
   if WriteDebugInfo then
     begin
      WasSet:=true;
      WriteDebugInfo:=false;
     end
   else
      WasSet:=false;
   if WriteDebugInfo then
{$endif DEBUG}
  Clock^.Update;
  Heap^.Update;
{$ifdef DEBUG}
   if WasSet then
     WriteDebugInfo:=true;
{$endif DEBUG}
  if Desktop^.FirstThat(@IsTileable) <> nil then
    application{$Ifdef FPC_OBJFPC}^{$endif}.EnableCommands([cmTile, cmCascade])
  else
    application{$Ifdef FPC_OBJFPC}^{$endif}.DisableCommands([cmTile, cmCascade]);
end;

{--TTvDemo------------------------------------------------------------------}
{  InitMenuBar -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 05Nov99 LdB       }
{---------------------------------------------------------------------------}
procedure TTVDemo.InitMenuBar;
VAR R: TRect;
BEGIN
   application{$Ifdef FPC_OBJFPC}^{$endif}.GetExtent(R);                                      { Get view extents }
   R.B.Y := R.A.Y + 1;                                { One line high  }
   MenuBar := New(PMenuBar, Init(R, NewMenu(
    NewSubMenu('~F~ile', 0, NewMenu(
      StdFileMenuItems(Nil)),                         { Standard file menu }
    NewSubMenu('~E~dit', 0, NewMenu(
      StdEditMenuItems(
      NewLine(
      NewItem('~V~iew Clipboard', '', kbNoKey,RegCmd({$ifdef FPC_OBJFPC}@{$endif}ShowClippboard,  cmClipboard), hcNoContext,
      nil)))),                 { Standard edit menu plus view clipboard}
    NewSubMenu('~T~est', 0, NewMenu(
      NewItem('~A~scii Chart','',kbNoKey,RegCmd({$ifdef FPC_OBJFPC}@{$endif}AsciiWindow),hcNoContext,
      NewItem('Window ~1~','',kbNoKey,RegCmd({$ifdef FPC_OBJFPC}@{$endif}Window1),hcNoContext,
      NewItem('Window ~2~','',kbNoKey,RegCmd({$ifdef FPC_OBJFPC}@{$endif}Window2),hcNoContext,
      NewItem('Window ~3~','',kbNoKey,RegCmd({$ifdef FPC_OBJFPC}@{$endif}Window3),hcNoContext,
      NewItem('~T~imed Box','',kbNoKey,RegCmd({$ifdef FPC_OBJFPC}@{$endif}TimedBox),hcNoContext,
      NewItem('Close Window 1','',kbNoKey,RegCmd({$ifdef FPC_OBJFPC}@{$endif}CloseWindow,cmCloseWindow1),hcNoContext,
      NewItem('Close Window 2','',kbNoKey,RegCmd({$ifdef FPC_OBJFPC}@{$endif}CloseWindow,cmCloseWindow2),hcNoContext,
      NewItem('Close Window 3','',kbNoKey,RegCmd({$ifdef FPC_OBJFPC}@{$endif}CloseWindow,cmCloseWindow3),hcNoContext,
      Nil))))))))),
    NewSubMenu('~W~indow', 0, NewMenu(
      StdWindowMenuItems(Nil)),        { Standard window  menu }
    NewSubMenu('~H~elp', hcNoContext, NewMenu(
      NewItem('~A~bout...','',kbNoKey,RegCmd({$ifdef FPC_OBJFPC}@{$endif}ShowAboutBox,cmAbout),hcNoContext,
      nil)),
    nil))))) //end NewSubMenus
   ))); //end MenuBar
   application{$Ifdef FPC_OBJFPC}^{$endif}.Insert(MenuBar);
END;

{--TTvDemo------------------------------------------------------------------}
{  InitDesktop -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 08Nov99 LdB       }
{---------------------------------------------------------------------------}
procedure TTVDemo.InitDeskTop;
VAR R: TRect; {ToolBar: PToolBar;}
BEGIN
   application{$Ifdef FPC_OBJFPC}^{$endif}.GetExtent(R);                                      { Get app extents }
   Inc(R.A.Y);               { Adjust top down }
   Dec(R.B.Y);            { Adjust bottom up }
(*   ToolBar := New(PToolBar, Init(R.A.X*FontWidth,
     R.A.Y*FontHeight, (R.B.X-R.A.X)*FontWidth, 20,
     cmAppToolBar));
   If (ToolBar <> Nil) Then Begin
     R.A.X := R.A.X*FontWidth;
     R.A.Y := R.A.Y*FontHeight + 25;
     R.B.X := -R.B.X*FontWidth;
     R.B.Y := -R.B.Y*Fontheight;
     ToolBar^.AddTool(NewToolEntry(cmQuit, True,
       '20X20EXIT', 'ToolBar.Res'));
     ToolBar^.AddTool(NewToolEntry(cmNew, True,
       '20X20NEW', 'ToolBar.Res'));
     ToolBar^.AddTool(NewToolEntry(cmOpen, True,
       '20X20LOAD', 'ToolBar.Res'));
     Insert(ToolBar);
   End;*)
   Desktop := New(PDeskTop, Init(R));
   application{$Ifdef FPC_OBJFPC}^{$endif}.Insert(Desktop);
END;

procedure TTVDemo.InitStatusLine;
var
   R: TRect;
begin
  application{$Ifdef FPC_OBJFPC}^{$endif}.GetExtent(R);
  R.A.Y := R.B.Y - 1;
  R.B.X := R.B.X - 12;
  New(StatusLine,
    Init(R,
      NewStatusDef(0, $EFFF,
        NewStatusKey('~F3~ Open', kbF3, regcmd({$ifdef FPC_OBJFPC}@{$endif}OpenFile ,cmOpen),
        NewStatusKey('~F4~ New', kbF4, regcmd({$ifdef FPC_OBJFPC}@{$endif}NewEditWindow, cmNew),
        NewStatusKey('~Alt+F3~ Close', kbAltF3,  cmClose, // handled internally
        StdStatusKeys(nil
        )))),nil
      )
    )
  );
   application{$Ifdef FPC_OBJFPC}^{$endif}.Insert(StatusLine);
  application{$Ifdef FPC_OBJFPC}^{$endif}.GetExtent(R);
  R.A.X := R.B.X - 12; R.A.Y := R.B.Y - 1;
  Heap := New(PHeapView, Init(R));
  application{$Ifdef FPC_OBJFPC}^{$endif}.Insert(Heap);
end;

procedure TTVDemo.Window1(Sender: TObject; const Event: TEvent);
VAR R: TRect; P: PGroup;
BEGIN
   { Create a basic window with static text and radio }
   { buttons. The buttons should be orange and white  }
   R.Assign(5, 1, 35, 16);                            { Assign area }
   P := New(PWindow, Init(R, 'TEST WINDOW 1', 1));    { Create a window }
   If (P <> Nil) Then Begin                           { Window valid }
     R.Assign(5, 5, 20, 6);                           { Assign area }
     P^.Insert(New(PInputLine, Init(R, 30)));
     R.Assign(5, 8, 20, 9);                           { Assign area }
     P^.Insert(New(PRadioButtons, Init(R,
       NewSItem('Test',
       NewSITem('Item 2', Nil)))));                   { Red radio button }
     R.Assign(5, 10, 28, 11);                         { Assign area }
     P^.Insert(New(PStaticText, Init(R,
       'SOME STATIC TEXT')));                         { Insert static text }
   End;
   Desktop^.Insert(P);                                { Insert into desktop }
   P1:=P;
END;

procedure TTVDemo.AsciiWindow(Sender: TObject; const Event: TEvent);
begin
  if ASCIIChart=nil then
    begin
      New(ASCIIChart, Init);
      Desktop^.Insert(ASCIIChart);
    end
  else
    ASCIIChart^.Focus;
end;

procedure TTVDemo.ShowAboutBox(Sender: TObject; const Event: TEvent);
begin
  MessageBox(#3'Free Vision TUI Framework'#13 +
    #3'Test/Demo Application'#13+
    #3'(www.freepascal.org)',
    nil, mfInformation or mfOKButton);
end;

procedure TTVDemo.NewEditWindow(Sender: TObject; const Event: TEvent);
var
  R: TRect;
begin
  R.Assign(0, 0, 60, 20);
  application{$Ifdef FPC_OBJFPC}^{$endif}.InsertWindow(New(PEditWindow, Init(R, '', wnNoNumber)));
end;

procedure TTVDemo.OpenFile(Sender: TObject; const Event: TEvent);
var
  R: TRect;
  FileDialog: PFileDialog;
  FileName: FNameStr;
const
  FDOptions: Word = fdOKButton or fdOpenButton;
begin
  FileName := '*.*';
  New(FileDialog, Init(FileName, 'Open file', '~F~ile name', FDOptions, 1));
  if application{$Ifdef FPC_OBJFPC}^{$endif}.ExecuteDialog(FileDialog, @FileName) <> cmCancel then
  begin
    R.Assign(0, 0, 75, 20);
    application{$Ifdef FPC_OBJFPC}^{$endif}.InsertWindow(New(PEditWindow, Init(R, FileName, wnNoNumber)));
  end;
end;

procedure TTVDemo.TimedBox(Sender: TObject; const Event: TEvent);
var
  X: longint;
  S: string;
begin
  X := TimedMessageBox ('Everything OK?', nil, mfConfirmation or mfOKCancel, 10);
  case X of
   cmCancel: MessageBox ('cmCancel', nil, mfOKButton);
   cmOK: MessageBox ('cmOK', nil, mfOKButton);
  else
   begin
    Str (X, S);
    MessageBox (S, nil, mfOKButton);
   end;
  end;
end;

procedure TTVDemo.CloseWindow(Sender: TObject; const Event: TEvent);
type PPGroup=^PGroup;
var
  P: PPGroup;
BEGIN
  case event.command of
    cmCloseWindow1:P := @P1;
    cmCloseWindow2:P := @P2;
    cmCloseWindow3:P := @P3;
  else
   p := nil;
  end;
  If Assigned(P^) then
    BEGIN
      Desktop^.Delete(P^);
      Dispose(P^,Done);
      P^:=Nil;
    END;
END;

procedure TTVDemo.ShowClippboard(sender: TObject; const event: TEvent);
begin
  ClipboardWindow^.Select;
  ClipboardWindow^.Show;
end;

procedure TTVDemo.FormCreate(Sender: system.TObject);
VAR R: TRect;
BEGIN
  EditorDialog := @StdEditorDialog;
  Inherited;
  { Initialize demo gadgets }
  initDesktop;
  InitMenuBar;
  InitStatusLine;

  application{$Ifdef FPC_OBJFPC}^{$endif}.GetExtent(R);
  R.A.X := R.B.X - 9; R.B.Y := R.A.Y + 1;
  Clock := New(PClockView, Init(R));
  application{$Ifdef FPC_OBJFPC}^{$endif}.Insert(Clock);

  application{$Ifdef FPC_OBJFPC}^{$endif}.GetExtent(R);
  ClipboardWindow := New(PEditWindow, Init(R, '', wnNoNumber));
  if application{$Ifdef FPC_OBJFPC}^{$endif}.ValidView(ClipboardWindow) <> nil then
  begin
    ClipboardWindow{$Ifdef FPC_OBJFPC}^{$endif}.Hide;
    ClipboardWindow{$Ifdef FPC_OBJFPC}^{$endif}.Editor{$Ifdef FPC_OBJFPC}^{$endif}.CanUndo := False;
    application{$Ifdef FPC_OBJFPC}^{$endif}.InsertWindow(ClipboardWindow);
    Clipboard := ClipboardWindow{$Ifdef FPC_OBJFPC}^{$endif}.Editor;
  end;
end;

procedure TTVDemo.Window2(Sender: TObject; const Event: TEvent);
VAR R: TRect; P: PGroup;
BEGIN
   { Create a basic window with check boxes. The  }
   { check boxes should be orange and white       }
   R.Assign(15, 3, 45, 18);                           { Assign area }
   P := New(PWindow, Init(R, 'TEST WINDOW 2', 2));    { Create window 2 }
   If (P <> Nil) Then Begin                           { Window valid }
     R.Assign(5, 5, 20, 7);                           { Assign area }
     P^.Insert(New(PCheckBoxes, Init(R,
       NewSItem('Test check',
       NewSITem('Item 2', Nil)))));                   { Create check box }
   End;
   Desktop^.Insert(P);                                { Insert into desktop }
   P2:=P;
END;

procedure TTVDemo.Window3(Sender: TObject; const Event: TEvent);
VAR R: TRect; P: PGroup; B: PScrollBar;
    List: PStrCollection; Lb: PListBox;
BEGIN
   { Create a basic dialog box. In it are buttons,  }
   { list boxes, scrollbars, inputlines, checkboxes }
   R.Assign(32, 2, 77, 18);                           { Assign screen area }
   P := New(PDialog, Init(R, 'TEST DIALOG'));         { Create dialog }
   If (P <> Nil) Then Begin                           { Dialog valid }
     R.Assign(5, 5, 20, 7);                          { Allocate area }
     P^.Insert(New(PCheckBoxes, Init(R,
       NewSItem('Test',
       NewSITem('Item 2', Nil)))));                   { Insert check box }
     R.Assign(5, 2, 20, 3);                           { Assign area }
     B := New(PScrollBar, Init(R));                   { Insert scroll bar }
     If (B <> Nil) Then Begin                         { Scrollbar valid }
       B^.SetRange(0, 100);                           { Set scrollbar range }
       B^.SetValue(50);                               { Set position }
       P^.Insert(B);                                  { Insert scrollbar }
     End;
     R.Assign(5, 10, 20, 11);                         { Assign area }
     P^.Insert(New(PInputLine, Init(R, 60)));         { Create input line }
     R.Assign(5, 13, 20, 14);                         { Assign area }
     P^.Insert(New(PInputLine, Init(R, 60)));         { Create input line }
     R.Assign(40, 8, 41, 14);                         { Assign area }
     B := New(PScrollBar, Init(R));                   { Create scrollbar }
     P^.Insert(B);                                    { Insert scrollbar }
     R.Assign(25, 8, 40, 14);                         { Assign area }
     Lb := New(PListBox, Init(R, 1, B));              { Create listbox }
     P^.Insert(Lb);                                   { Insert listbox }
     List := New(PStrCollection, Init(10, 5));        { Create string list }
     List^.AtInsert(0, NewStr('Zebra'));              { Insert text }
     List^.AtInsert(1, NewStr('Apple'));              { Insert text }
     List^.AtInsert(2, NewStr('Third'));              { Insert text }
     List^.AtInsert(3, NewStr('Peach'));              { Insert text }
     List^.AtInsert(4, NewStr('Rabbit'));             { Insert text }
     List^.AtInsert(5, NewStr('Item six'));           { Insert text }
     List^.AtInsert(6, NewStr('Jaguar'));             { Insert text }
     List^.AtInsert(7, NewStr('Melon'));              { Insert text }
     List^.AtInsert(8, NewStr('Ninth'));              { Insert text }
     List^.AtInsert(9, NewStr('Last item'));          { Insert text }
     Lb^.Newlist(List);                               { Give list to listbox }
     R.Assign(30, 2, 40, 4);                          { Assign area }
     P^.Insert(New(PButton, Init(R, '~O~k', 100, bfGrabFocus)));{ Create okay button }
     R.Assign(30, 15, 40, 17);                        { Assign area }
     Desktop^.Insert(P);                              { Insert dialog }
     P3:=P;
   End;
END;




end.

