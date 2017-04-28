unit app_testfv2main;

{$mode objfpc}

interface

uses
  Classes, SysUtils, fv2appext,fv2forms, fv2Editors, fv2Menus, fv2Dialogs, FV2Consts, fv2AsciiTab,
     fv2Gadgets, fv2TimedDlg, fv2MsgBox, fv2StdDlg,fv2Views,fv2drivers;

type

{ TTVDemo }

  TTVDemo = class(TfvForm)
      public
        ClipboardWindow: TEditWindow;
        Clock: TClockView;
        Heap: THeapView;
        P1,P2,P3 : TGroup;
        ASCIIChart : TAsciiChart;
      CONSTRUCTOR create(AOwner:TGroup);reintroduce;
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

uses fv2app,fv2RectHelper;

const
  cmCloseWindow1    = 1101;
  cmCloseWindow2    = 1102;
  cmCloseWindow3    = 1103;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                           TTvDemo OBJECT METHODS                          }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}


constructor TTVDemo.create(AOwner: TGroup);
begin
  Inherited Create(AOwner);
end;

procedure TTVDemo.Idle(Sender: TObject; const Event: TEvent);

function IsTileable(P: TView): Boolean;
begin
  IsTileable := (P.Options and ofTileable <> 0) and
    (P.State and sfVisible <> 0);
end;

{$ifdef DEBUG}
Var
   WasSet : boolean;
{$endif DEBUG}
var
  p: TView;
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
  Clock.Update;
  Heap.Update;
{$ifdef DEBUG}
   if WasSet then
     WriteDebugInfo:=true;
{$endif DEBUG}
  for TComponent(p) in Desktop do
    if IsTileable(p) then
      begin
        application.EnableCommands([cmTile, cmCascade]);
        exit;
      end;
  application.DisableCommands([cmTile, cmCascade]);
end;

{--TTvDemo------------------------------------------------------------------}
{  InitMenuBar -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 05Nov99 LdB       }
{---------------------------------------------------------------------------}
procedure TTVDemo.InitMenuBar;
VAR R: TRect;
BEGIN
   application.GetExtent(R);                                      { Get view extents }
   R.B.Y := R.A.Y + 1;                                { One line high  }
   MenuBar := TMenuBar.Create(nil,R, NewMenu(nil,
    NewSubMenu('~F~ile', 0, NewMenu(nil,
      StdFileMenuItems(Nil)),                         { Standard file menu }
    NewSubMenu('~E~dit', 0, NewMenu(nil,
      StdEditMenuItems(
      NewLine(
      NewItem('~V~iew Clipboard', '', kbNoKey,RegCmd({$ifdef FPC_OBJFPC}@{$endif}ShowClippboard,  cmClipboard), hcNoContext,
      nil)))),                 { Standard edit menu plus view clipboard}
    NewSubMenu('~T~est', 0, NewMenu(nil,
      NewItem('~A~scii Chart','',kbNoKey,RegCmd({$ifdef FPC_OBJFPC}@{$endif}AsciiWindow),hcNoContext,
      NewItem('Window ~1~','',kbNoKey,RegCmd({$ifdef FPC_OBJFPC}@{$endif}Window1),hcNoContext,
      NewItem('Window ~2~','',kbNoKey,RegCmd({$ifdef FPC_OBJFPC}@{$endif}Window2),hcNoContext,
      NewItem('Window ~3~','',kbNoKey,RegCmd({$ifdef FPC_OBJFPC}@{$endif}Window3),hcNoContext,
      NewItem('~T~imed Box','',kbNoKey,RegCmd({$ifdef FPC_OBJFPC}@{$endif}TimedBox),hcNoContext,
      NewItem('Close Window 1','',kbNoKey,RegCmd({$ifdef FPC_OBJFPC}@{$endif}CloseWindow,cmCloseWindow1),hcNoContext,
      NewItem('Close Window 2','',kbNoKey,RegCmd({$ifdef FPC_OBJFPC}@{$endif}CloseWindow,cmCloseWindow2),hcNoContext,
      NewItem('Close Window 3','',kbNoKey,RegCmd({$ifdef FPC_OBJFPC}@{$endif}CloseWindow,cmCloseWindow3),hcNoContext,
      Nil))))))))),
    NewSubMenu('~W~indow', 0, NewMenu(nil,
      StdWindowMenuItems(Nil)),        { Standard window  menu }
    NewSubMenu('~H~elp', hcNoContext, NewMenu(nil,
      NewItem('~A~bout...','',kbNoKey,RegCmd({$ifdef FPC_OBJFPC}@{$endif}ShowAboutBox,cmAbout),hcNoContext,
      nil)),
    nil))))) //end NewSubMenus
   )); //end MenuBar
   application.Insert(MenuBar);
END;

{--TTvDemo------------------------------------------------------------------}
{  InitDesktop -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 08Nov99 LdB       }
{---------------------------------------------------------------------------}
procedure TTVDemo.InitDeskTop;
VAR R: TRect; {ToolBar: PToolBar;}
BEGIN
   application.GetExtent(R);                                      { Get app extents }
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
   Desktop := TDeskTop.Create(Application, R);
   application.Insert(Desktop);
END;

procedure TTVDemo.InitStatusLine;
var
   R: TRect;
begin
  application.GetExtent(R);
  R.A.Y := R.B.Y - 1;
  R.B.X := R.B.X - 12;
  StatusLine := TStatusLine.Create(Application,R,
      NewStatusDef(0, $EFFF,
        NewStatusKey('~F3~ Open', kbF3, regcmd({$ifdef FPC_OBJFPC}@{$endif}OpenFile ,cmOpen),
        NewStatusKey('~F4~ New', kbF4, regcmd({$ifdef FPC_OBJFPC}@{$endif}NewEditWindow, cmNew),
        NewStatusKey('~Alt+F3~ Close', kbAltF3,  cmClose, // handled internally
        StdStatusKeys(nil
        )))),nil
      )
    );
   application.Insert(StatusLine);
  application.GetExtent(R);
  R.A.X := R.B.X - 12; R.A.Y := R.B.Y - 1;
  Heap := THeapView.Create(Application,R);
  application.Insert(Heap);
end;

procedure TTVDemo.Window1(Sender: TObject; const Event: TEvent);
VAR R: TRect; P: TGroup;
BEGIN
   { Create a basic window with static text and radio }
   { buttons. The buttons should be orange and white  }
   R.Assign(5, 1, 35, 16);                            { Assign area }
   P := TWindow.Create(Desktop ,R, 'TEST WINDOW 1', 1);    { Create a window }
   If (P <> Nil) Then Begin                           { Window valid }
     R.Assign(5, 5, 20, 6);                           { Assign area }
     P.Insert(TInputLine.Create(P, R, 30));
     R.Assign(5, 8, 20, 9);                           { Assign area }
     P.Insert(TRadioButtons.Create(P,R,
       ['Test',
       'Item 2']));                   { Red radio button }
     R.Assign(5, 10, 28, 11);                         { Assign area }
     P.Insert(TStaticText.Create(P,R,
       'SOME STATIC TEXT'));                         { Insert static text }
   End;
   Desktop.Insert(P);                                { Insert into desktop }
   P1:=P;
END;

procedure TTVDemo.AsciiWindow(Sender: TObject; const Event: TEvent);
begin
  if ASCIIChart=nil then
    begin
      ASCIIChart:=TASCIIChart.create(Application);
      Desktop.Insert(ASCIIChart);
    end
  else
    ASCIIChart.Focus;
end;

procedure TTVDemo.ShowAboutBox(Sender: TObject; const Event: TEvent);
begin
  MessageBox(#3'Free Vision TUI Framework'#13 +
    #3'Test/Demo Application'#13+
    #3'(www.freepascal.org)',
    [], mfInformation or mfOKButton);
end;

procedure TTVDemo.NewEditWindow(Sender: TObject; const Event: TEvent);
var
  R: TRect;
begin
  R.Assign(0, 0, 60, 20);
  application.InsertWindow(TEditWindow.Create(Desktop,R, '', wnNoNumber));
end;

procedure TTVDemo.OpenFile(Sender: TObject; const Event: TEvent);
var
  R: TRect;
  FileDialog: TFileDialog;
  FileName: String;
const
  FDOptions: Word = fdOKButton or fdOpenButton;
begin
  FileName := '*.*';
  FileDialog := TFileDialog.Create(nil,FileName, 'Open file', '~F~ile name', FDOptions, 1);
  if application.ExecuteDialog(FileDialog, FileName) <> cmCancel then
  begin
    R.Assign(0, 0, 75, 20);
    application.InsertWindow(TEditWindow.Create(nil,R, FileName, wnNoNumber));
  end;
end;

procedure TTVDemo.TimedBox(Sender: TObject; const Event: TEvent);
var
  X: longint;
  S: string;
begin
  X := TimedMessageBox ('Everything OK?', [], mfConfirmation or mfOKCancel, 10);
  case X of
   cmCancel: MessageBox ('cmCancel', [], mfOKButton);
   cmOK: MessageBox ('cmOK', [], mfOKButton);
  else
   begin
    Str (X, S);
    MessageBox (S, [], mfOKButton);
   end;
  end;
end;

procedure TTVDemo.CloseWindow(Sender: TObject; const Event: TEvent);
type PPGroup=^TGroup;
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
  If Assigned(P) then
    BEGIN
      Desktop.Delete(P^);
      Freeandnil(P^);
    END;
END;

procedure TTVDemo.ShowClippboard(sender: TObject; const event: TEvent);
begin
  ClipboardWindow.Select;
  ClipboardWindow.Show;
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

  application.GetExtent(R);
  R.A.X := R.B.X - 9; R.B.Y := R.A.Y + 1;
  Clock := TClockView.Create(Application, R);
  application.Insert(Clock);

  application.GetExtent(R);
  ClipboardWindow := TEditWindow.Create(Application,R, '', wnNoNumber);
  if application.ValidView(ClipboardWindow) <> nil then
  begin
    ClipboardWindow.Hide;
    ClipboardWindow.Editor.CanUndo := False;
    application.InsertWindow(ClipboardWindow);
    Clipboard := ClipboardWindow.Editor;
  end;
end;

procedure TTVDemo.Window2(Sender: TObject; const Event: TEvent);
VAR R: TRect; P: TGroup;
BEGIN
   { Create a basic window with check boxes. The  }
   { check boxes should be orange and white       }
   R.Assign(15, 3, 45, 18);                           { Assign area }
   P := TWindow.Create(Desktop,R, 'TEST WINDOW 2', 2);    { Create window 2 }
   If (P <> Nil) Then Begin                           { Window valid }
     R.Assign(5, 5, 20, 7);                           { Assign area }
     P.Insert(TCheckBoxes.Create(P,R,
       ['Test check',
       'Item 2']));                   { Create check box }
   End;
   Desktop.Insert(P);                                { Insert into desktop }
   P2:=P;
END;

procedure TTVDemo.Window3(Sender: TObject; const Event: TEvent);
VAR R: TRect; P: TGroup; B: TScrollBar;
    List: TStrings; Lb: TListBox;
BEGIN
   { Create a basic dialog box. In it are buttons,  }
   { list boxes, scrollbars, inputlines, checkboxes }
   R.Assign(32, 2, 77, 18);                           { Assign screen area }
   P := TDialog.Create(Desktop, R, 'TEST DIALOG');         { Create dialog }
   If (P <> Nil) Then Begin                           { Dialog valid }
     R.Assign(5, 5, 20, 7);                          { Allocate area }
     P.Insert(TCheckBoxes.Create(P,R,
       ['Test',
       'Item 2']));                   { Insert check box }
     R.Assign(5, 2, 20, 3);                           { Assign area }
     B := TScrollBar.Create(P,R);                   { Insert scroll bar }
     If (B <> Nil) Then Begin                         { Scrollbar valid }
       B.SetRange(0, 100);                           { Set scrollbar range }
       B.SetValue(50);                               { Set position }
       P.Insert(B);                                  { Insert scrollbar }
     End;
     R.Assign(5, 10, 20, 11);                         { Assign area }
     P.Insert(TInputLine.Create(P,R, 60));         { Create input line }
     R.Assign(5, 13, 20, 14);                         { Assign area }
     P.Insert(TInputLine.Create(P,R, 60));         { Create input line }
     R.Assign(40, 8, 41, 14);                         { Assign area }
     B := TScrollBar.Create(P,R);                   { Create scrollbar }
     P.Insert(B);                                    { Insert scrollbar }
     R.Assign(25, 8, 40, 14);                         { Assign area }
     Lb := TListBox.Create(P,R, 1, B);              { Create listbox }
     P.Insert(Lb);                                   { Insert listbox }
     List := TStringList.Create;        { Create string list }
     List.insert(0, 'Zebra');              { Insert text }
     List.insert(1, 'Apple');              { Insert text }
     List.insert(2, 'Third');              { Insert text }
     List.insert(3, 'Peach');              { Insert text }
     List.insert(4, 'Rabbit');             { Insert text }
     List.insert(5, 'Item six');           { Insert text }
     List.insert(6, 'Jaguar');             { Insert text }
     List.insert(7, 'Melon');              { Insert text }
     List.insert(8, 'Ninth');              { Insert text }
     List.insert(9, 'Last item');          { Insert text }
     Lb.Newlist(List);                               { Give list to listbox }
     R.Assign(30, 2, 40, 4);                          { Assign area }
     P.Insert(TButton.Create(P,R, '~O~k', 100, bfGrabFocus));{ Create okay button }
     R.Assign(30, 15, 40, 17);                        { Assign area }
     Desktop.Insert(P);                              { Insert dialog }
     P3:=P;
   End;
END;




end.

