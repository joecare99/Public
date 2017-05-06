PROGRAM testapp;

{ $UNDEF OS2PM}
{$apptype Console}
{$IFDEF OS2PM}
 {&PMTYPE PM}                                          { FULL GUI MODE }
{$ENDIF OS2PM}

{ ******************************* REMARK ****************************** }
{  This is a basic test program to test the app framework. In use will  }
{  be menus, statuslines, windows, dialogs, scrollbars, statictext,     }
{  radiobuttons, check boxes, list boxes and input lines.               }
{                                                                       }
{  Working compilers:                                                   }
{     WINDOWS BPW, VP2, Delphi1, FPC WIN (0.9912)                       }
{     DOS has draw bugs but works for BP and FPC DOS (GO32V2)           }
{     OS2 dows not work still some PM bits to do                        }
{                                                                       }
{  Not working:                                                         }
{     Delphi3, Delphi5 (sus 4) will compile but Tgroup.ForEach etc U/S. }
{     Sybil2 Win32 should work but to big for demo mode so unsure!      }
{                                                                       }
{  Special things to try out:                                           }
{    Check out the standard windows minimize etc icons.                 }
{                                                                       }
{                                                                       }
{  Comments:                                                            }
{    There is alot that may seem more complex than it needs to but      }
{    I have much more elaborate objects operating such as bitmaps,      }
{    bitmap buttons, percentage bars etc and they need these hooks.     }
{    Basically the intention is to be able to port existing TV apps     }
{    as a start point and then start to optimize and use the new        }
{    GUI specific objects. I will try to get some documentation         }
{    done on how everything works because some things are hard to       }
{    follow in windows.                                                 }
{ ****************************** END REMARK *** Leon de Boer, 06Nov99 * }

{$I platform.inc}
  USES
{$IFDEF OS2PM}
     {$IFDEF OS_OS2} Os2Def, os2PmApi,  {$ENDIF}
{$ENDIF OS2PM}
     Classes, types, sysutils, fv2drivers, fv2views, fv2editors, fv2menus, fv2dialogs, fv2app,             { Standard GFV units }
     fv2consts, fv2asciitab, fv2gadgets, fv2timeddlg, fv2msgbox, fv2stddlg,fv2RectHelper;


CONST cmAppToolbar = 1000;
      cmWindow1    = 1001;
      cmWindow2    = 1002;
      cmWindow3    = 1003;
      cmTimedBox   = 1004;
      cmAscii      = 1010;
      cmCloseWindow1    = 1101;
      cmCloseWindow2    = 1102;
      cmCloseWindow3    = 1103;

{$ifdef DEBUG}
CONST
     WriteDebugInfo : boolean = true;
{$endif DEBUG}

{---------------------------------------------------------------------------}
{          TTestAppp OBJECT - STANDARD APPLICATION WITH MENU                }
{---------------------------------------------------------------------------}
TYPE
//   PTVDemo = ^TTVDemo;

   { TTVDemo }

   TTVDemo = class(TApplication)
      private
        ClipboardWindow: TEditWindow;
        Clock: tClockView;
        Heap: tHeapView;
        P1,P2,P3 : TGroup;
        ASCIIChart : TAsciiChart;
      public
      CONSTRUCTOR Create;
      PROCEDURE Idle; override;
      PROCEDURE HandleEvent(var Event : TEvent);Override;
      PROCEDURE InitMenuBar; Override;
      PROCEDURE InitDeskTop; override;
      PROCEDURE InitStatusLine; override;
      PROCEDURE Window1;
      PROCEDURE Window2;
      PROCEDURE Window3;
      PROCEDURE TimedBox;
      PROCEDURE AsciiWindow;
      PROCEDURE ShowAboutBox;
      PROCEDURE NewEditWindow;
      PROCEDURE OpenFile;
      PROCEDURE CloseWindow(var P : TGroup);
    End;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                           TTvDemo OBJECT METHODS                          }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

constructor TTVDemo.Create;
VAR R: TRect;
BEGIN
  EditorDialog := @StdEditorDialog;
  Inherited ;
  { Initialize demo gadgets }

  GetExtent(R);
  R.BottomRight.x := R.TopLeft.X - 9;
  R.BottomRight.Y := R.TopLeft.Y + 1;
  Clock := TClockView.Create(Self,R);
  Insert(Clock);

  GetExtent(R);
  ClipboardWindow := TEditWindow.Create(Desktop,R, '', wnNoNumber);
  if ValidView(ClipboardWindow) <> nil then
  begin
    ClipboardWindow.Hide;
    ClipboardWindow.Editor.CanUndo := False;
    InsertWindow(ClipboardWindow);
    Clipboard := ClipboardWindow.Editor;
  end;
END;

procedure TTVDemo.Idle;

function IsTileable(P: TComponent): Boolean;
begin
  result := false;
  if p.InheritsFrom(TView) then
    result := (TView(P).Options and ofTileable <> 0) and
      (TView(P).State and sfVisible <> 0);
end;

{$ifdef DEBUG}
Var
   WasSet : boolean;
{$endif DEBUG}
var
  lview: TView;
  flag: Boolean;
begin
  inherited Idle;
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

  flag:=false;
  for lview in Desktop do
    if IsTileable(lview) then
      begin
       flag := true;
       break;
      end;

  if Flag then
    EnableCommands([cmTile, cmCascade])
  else
    DisableCommands([cmTile, cmCascade]);
end;

procedure TTVDemo.HandleEvent(var Event: TEvent);
BEGIN
   Inherited HandleEvent(Event);                      { Call ancestor }
   If (Event.What = evCommand) Then Begin
     Case Event.Command Of
       cmClipBoard:
         begin
           ClipboardWindow.Select;
           ClipboardWindow.Show;
         end;
       cmNew     : NewEditWindow;
       cmOpen    : OpenFile;
       cmWindow1 : Window1;
       cmWindow2 : Window2;
       cmWindow3 : Window3;
       cmTimedBox: TimedBox;
       cmAscii   : AsciiWindow;
       cmCloseWindow1 : CloseWindow(P1);
       cmCloseWindow2 : CloseWindow(P2);
       cmCloseWindow3 : CloseWindow(P3);
       cmAbout: ShowAboutBox;
       Else Exit;                                     { Unhandled exit }
     End;
   End;
   ClearEvent(Event);
END;

{--TTvDemo------------------------------------------------------------------}
{  InitMenuBar -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 05Nov99 LdB       }
{---------------------------------------------------------------------------}
procedure TTVDemo.InitMenuBar;
VAR R: TRect;
BEGIN
   GetExtent(R);                                      { Get view extents }
   R.BottomRight.Y := R.TopLeft.Y + 1;                                { One line high  }
   MenuBar := TMenuBar.Create(self, R, NewMenu(nil,
    NewSubMenu('~F~ile', 0, NewMenu(nil,
      StdFileMenuItems(Nil)),                         { Standard file menu }
    NewSubMenu('~E~dit', 0, NewMenu(nil,
      StdEditMenuItems(
      NewLine(
      NewItem('~V~iew Clipboard', '', kbNoKey, cmClipboard, hcNoContext,
      nil)))),                 { Standard edit menu plus view clipboard}
    NewSubMenu('~T~est', 0, NewMenu(nil,
      NewItem('~A~scii Chart','',kbNoKey,cmAscii,hcNoContext,
      NewItem('Window ~1~','',kbNoKey,cmWindow1,hcNoContext,
      NewItem('Window ~2~','',kbNoKey,cmWindow2,hcNoContext,
      NewItem('Window ~3~','',kbNoKey,cmWindow3,hcNoContext,
      NewItem('~T~imed Box','',kbNoKey,cmTimedBox,hcNoContext,
      NewItem('Close Window 1','',kbNoKey,cmCloseWindow1,hcNoContext,
      NewItem('Close Window 2','',kbNoKey,cmCloseWindow2,hcNoContext,
      NewItem('Close Window 3','',kbNoKey,cmCloseWindow3,hcNoContext,
      Nil))))))))),
    NewSubMenu('~W~indow', 0, NewMenu(nil,
      StdWindowMenuItems(Nil)),        { Standard window  menu }
    NewSubMenu('~H~elp', hcNoContext, NewMenu(nil,
      NewItem('~A~bout...','',kbNoKey,cmAbout,hcNoContext,
      nil)),
    nil))))) //end NewSubMenus
   )); //end MenuBar
END;

{--TTvDemo------------------------------------------------------------------}
{  InitDesktop -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 08Nov99 LdB       }
{---------------------------------------------------------------------------}
procedure TTVDemo.InitDeskTop;
VAR R: TRect; {ToolBar: PToolBar;}
BEGIN
   GetExtent(R);                                      { Get app extents }
   Inc(R.TopLeft.Y);               { Adjust top down }
   Dec(R.BottomRight.Y);            { Adjust bottom up }
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
   Desktop := TDeskTop.Create(Self,R);
END;

procedure TTVDemo.InitStatusLine;
var
   R: TRect;
begin
  GetExtent(R);
  R.TopLeft.Y := R.BottomRight.Y - 1;
  R.BottomRight .X := R.BottomRight.X - 12;
  StatusLine:= TStatusLine.Create(self,R,
      NewStatusDef(0, $EFFF,
        NewStatusKey('~F3~ Open', kbF3, cmOpen,
        NewStatusKey('~F4~ New', kbF4, cmNew,
        NewStatusKey('~Alt+F3~ Close', kbAltF3, cmClose,
        StdStatusKeys(nil
        )))),nil
      )
    )
  ;

  GetExtent(R);
  R.A.X := R.B.X - 12; R.A.Y := R.B.Y - 1;
  Heap := THeapView.Create(self,R);
  Insert(Heap);
end;

procedure TTVDemo.Window1;
VAR R: TRect; P: TGroup;
BEGIN
   { Create a basic window with static text and radio }
   { buttons. The buttons should be orange and white  }
   R.Assign(5, 1, 35, 16);                            { Assign area }
   P :=TWindow.Create(self,R, 'TEST WINDOW 1', 1);    { Create a window }
   If (P <> Nil) Then Begin                           { Window valid }
     R.Assign(5, 5, 20, 6);                           { Assign area }
     P.Insert(TInputLine.Create(P,R, 30));
     R.Assign(5, 8, 20, 9);                           { Assign area }
     P.Insert(TRadioButtons.Create(P,R,['Test','Item 2']));                   { Red radio button }
     R.Assign(5, 10, 28, 11);                         { Assign area }
     P.Insert(TStaticText.Create(p,R,'SOME STATIC TEXT'));                         { Insert static text }
   End;
   Desktop.Insert(P);                                { Insert into desktop }
   P1:=P;
END;

procedure TTVDemo.AsciiWindow;
begin
  if ASCIIChart=nil then
    begin
      ASCIIChart:=TASCIIChart.create(Desktop);
    end
  else
    ASCIIChart.Focus;
end;

procedure TTVDemo.ShowAboutBox;
begin
  MessageBox(#3'Free Vision TUI Framework'#13 +
    #3'Test/Demo Application'#13+
    #3'(www.freepascal.org)',
    [], mfInformation or mfOKButton);
end;

procedure TTVDemo.NewEditWindow;
var
  R: TRect;
begin
  R.Assign(0, 0, 60, 20);
  InsertWindow(TEditWindow.Create(nil,R, '', wnNoNumber));
end;

procedure TTVDemo.OpenFile;
var
  R: TRect;
  FileDialog: TFileDialog;
  FileName: String;
const
  FDOptions: Word = fdOKButton or fdOpenButton;
begin
  FileName := '*.*';
  FileDialog:=TFileDialog.Create(self,FileName, 'Open file', '~F~ile name', FDOptions, 1);
  if ExecuteDialog(FileDialog, FileName) <> cmCancel then
  begin
    R.Assign(0, 0, 75, 20);
    InsertWindow(TEditWindow.Create(nil,R, FileName, wnNoNumber));
  end;
end;

procedure TTVDemo.TimedBox;
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

procedure TTVDemo.CloseWindow(var P: TGroup);
BEGIN
  If Assigned(P) then
    BEGIN
      Desktop.Delete(P);
      freeandnil(P);
    END;
END;

procedure TTVDemo.Window2;
VAR R: TRect; P: TGroup;
BEGIN
   { Create a basic window with check boxes. The  }
   { check boxes should be orange and white       }
   R.Assign(15, 3, 45, 18);                           { Assign area }
   P := TWindow.Create(self,R, 'TEST WINDOW 2', 2);    { Create window 2 }
   If (P <> Nil) Then Begin                           { Window valid }
     R.Assign(5, 5, 20, 7);                           { Assign area }
     P.Insert(TCheckBoxes.create(P,R,['Test check','Item 2']));                   { Create check box }
   End;
   Desktop.Insert(P);                                { Insert into desktop }
   P2:=P;
END;

procedure TTVDemo.Window3;
VAR R: TRect; P: TGroup; B: TScrollBar;
    List: TStrings; Lb: TListBox;
BEGIN
   { Create a basic dialog box. In it are buttons,  }
   { list boxes, scrollbars, inputlines, checkboxes }
   R.Assign(32, 2, 77, 18);                           { Assign screen area }
   P := TDialog.Create(self,R, 'TEST DIALOG');         { Create dialog }
   If (P <> Nil) Then Begin                           { Dialog valid }
     R.Assign(5, 5, 20, 7);                          { Allocate area }
     P.Insert(TCheckBoxes.Create(P,R,['Test','Item 2']));                   { Insert check box }
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
     Lb := TListBox.Create(p,R, 1, B);              { Create listbox }
     P.Insert(Lb);                                   { Insert listbox }
     List := TStringList.create;        { Create string list }
     List.add('Zebra');              { Insert text }
     List.add('Apple');              { Insert text }
     List.add('Third');              { Insert text }
     List.add('Peach');              { Insert text }
     List.add('Rabbit');             { Insert text }
     List.add('Item six');           { Insert text }
     List.add('Jaguar');             { Insert text }
     List.add('Melon');              { Insert text }
     List.add('Ninth');              { Insert text }
     List.add('Last item');          { Insert text }
     Lb.Newlist(List);                               { Give list to listbox }
     R.Assign(30, 2, 40, 4);                          { Assign area }
     P.Insert(TButton.create(P,R, '~O~k', 100, bfGrabFocus));{ Create okay button }
     R.Assign(30, 15, 40, 17);                        { Assign area }
     Desktop.Insert(P);                              { Insert dialog }
     P3:=P;
   End;
END;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                             MAIN PROGRAM START                            }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
VAR I: Integer; R: TRect; P: TGroup; MyApp: TTvDemo;
{$IFDEF OS2PM}
    {$IFDEF OS_OS2} Message: QMSg; Event: TEvent; {$ENDIF}
{$ENDIF OS2PM}
BEGIN
   (*SystemPalette := CreateRGBPalette(256);            { Create palette }
   For I := 0 To 15 Do Begin
     GetSystemRGBEntry(I, RGB);                       { Get palette entry }
     AddToRGBPalette(RGB, SystemPalette);             { Add entry to palette }
   End;*)

   MyApp:=TTVDemo.Create;                                        { Initialize app }
   try
   MyApp.Run;                                         { Run the app }
{$IFDEF OS2PM}
   {$IFDEF OS_OS2}
   while (MyApp.EndState = 0)
   AND WinGetMsg(Anchor, Message, 0, 0, 0) Do Begin
       WinDispatchMsg(Anchor, Message);
       NextQueuedEvent(Event);
       If (event.What <>  evNothing)
         Then MyApp.handleEvent(Event);
   End;
   {$ENDIF}
{$ENDIF OS2PM}

   finally
   FreeAndNil(MyApp);                                        { Dispose of app }
   end;
   {DisposeRGBPalette(SystemPalette);}
END.
