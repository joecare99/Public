{********[ SOURCE FILE OF GRAPHICAL FREE VISION ]**********}
{                                                          }
{   System independent GRAPHICAL clone of MENUS.PAS        }
{                                                          }
{   Interface Copyright (c) 1992 Borland International     }
{                                                          }
{   Copyright (c) 1996, 1997, 1998, 1999 by Leon de Boer   }
{   ldeboer@attglobal.net  - primary e-mail addr           }
{   ldeboer@starwon.com.au - backup e-mail addr            }
{                                                          }
{****************[ THIS CODE IS FREEWARE ]*****************}
{                                                          }
{     This sourcecode is released for the purpose to       }
{   promote the pascal language on all platforms. You may  }
{   redistribute it and/or modify with the following       }
{   DISCLAIMER.                                            }
{                                                          }
{     This SOURCE CODE is distributed "AS IS" WITHOUT      }
{   WARRANTIES AS TO PERFORMANCE OF MERCHANTABILITY OR     }
{   ANY OTHER WARRANTIES WHETHER EXPRESSED OR IMPLIED.     }
{                                                          }
{*****************[ SUPPORTED PLATFORMS ]******************}
{                                                          }
{ Only Free Pascal Compiler supported                      }
{                                                          }
{**********************************************************}

UNIT fv2menus;

{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}
                                  INTERFACE
{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}

{====Include file to sort compiler platform out =====================}
{$I platform.inc}
{====================================================================}

{==== Compiler directives ===========================================}

{$X+} { Extended syntax is ok }
{ $R-} { Disable range checking }
{ $S-} { Disable Stack Checking }
{ $I-} { Disable IO Checking }
{ $Q-} { Disable Overflow Checking }
{ $V-} { Turn off strict VAR strings }
{====================================================================}

USES
  classes, sysutils,
   {$IFDEF OS_WINDOWS}                                { WIN/NT CODE }
     {$IFNDEF PPC_SPEED}                              { NON SPEED COMPILER }
       {$IFDEF PPC_FPC}                               { FPC WINDOWS COMPILER }
//       Windows,                                       { Standard unit }
       {$ELSE}                                        { OTHER COMPILERS }
       WinTypes,WinProcs,                             { Standard units }
       {$ENDIF}
     {$ELSE}                                          { SPEEDSOFT COMPILER }
       WinBase, WinDef,                               { Standard units }
     {$ENDIF}
   {$ENDIF}

   fv2drivers, fv2views, fv2consts, fv2RectHelper;                 { GFV standard units }

{***************************************************************************}
{                              PUBLIC CONSTANTS                             }
{***************************************************************************}

{---------------------------------------------------------------------------}
{                               COLOUR PALETTES                             }
{---------------------------------------------------------------------------}
CONST
   CMenuView   = #2#3#4#5#6#7;                        { Menu colours }
   CStatusLine = #2#3#4#5#6#7;                        { Statusline colours }

{***************************************************************************}
{                            RECORD DEFINITIONS                             }
{***************************************************************************}
TYPE
   TMenuStr = String[31];                             { Menu string }

   PMenu = ^TMenu deprecated 'use TMenu';                                    { Pointer to menu }
   TMenu = Class;
{---------------------------------------------------------------------------}
{                              TMenuItem RECORD                             }
{---------------------------------------------------------------------------}
   PMenuItem = ^TMenuItem deprecated 'use TMenuItem';
   TMenuItem =
{$ifndef FPC_REQUIRES_PROPER_ALIGNMENT}
   PACKED
{$endif FPC_REQUIRES_PROPER_ALIGNMENT}
   Class(TView)
     public
     Caption: String;                                   { Menu item name }
     Command: Word;                                   { Menu item command }
     Disabled: Boolean;                               { Menu item state }
     KeyCode: Word;                                   { Menu item keycode }
     Param: String;
     SubMenu: TMenu;
     destructor destroy;override;
   END;

{---------------------------------------------------------------------------}
{                                TMenu RECORD                               }
{---------------------------------------------------------------------------}
   TMenu =
   Class(TGroup)
     public
//     Items: array of TMenuItem;                                { Menu item list }
     Default: TMenuItem;                              { Default menu }
     destructor destroy;override;
   END;

{---------------------------------------------------------------------------}
{                             TStatusItem RECORD                            }
{---------------------------------------------------------------------------}
TYPE
   PStatusItem = ^TStatusItem;// deprecated 'use TStatusItem';
   TStatusItem =
{$ifndef FPC_REQUIRES_PROPER_ALIGNMENT}
   PACKED
{$endif FPC_REQUIRES_PROPER_ALIGNMENT}
   RECORD
     Next: PStatusItem;                               { Next status item }
     Text: String;                                    { Text of status item }
     KeyCode: Word;                                   { Keycode of item }
     Command: Word;                                   { Command of item }
   END;

{---------------------------------------------------------------------------}
{                             TStatusDef RECORD                             }
{---------------------------------------------------------------------------}
TYPE
   PStatusDef = ^TStatusDef ;//deprecated 'use TStatusDef';
   TStatusDef =
{$ifndef FPC_REQUIRES_PROPER_ALIGNMENT}
   PACKED
{$endif FPC_REQUIRES_PROPER_ALIGNMENT}
   RECORD
     Next: PStatusDef;                                { Next status defined }
     Min, Max: Word;                                  { Range of item }
     Items: PStatusItem;                              { Item list }
   END;

{***************************************************************************}
{                            OBJECT DEFINITIONS                             }
{***************************************************************************}

{---------------------------------------------------------------------------}
{                TMenuView OBJECT - MENU VIEW ANCESTOR OBJECT               }
{---------------------------------------------------------------------------}
TYPE
   PMenuView = ^TMenuView deprecated 'use TMenuView';
   TMenuView = Class (TView)
      public
         ParentMenu: TMenuView;                       { Parent menu }
         Menu      : TMenu;                           { Menu item list }
         Current   : TMenuItem;                       { Current menu item }
         OldItem   : TMenuItem;                       { Old item for draws }
      constructor Init(aOwner: TGroup; var Bounds: TRect);
      constructor Load(aOwner: TGroup; var S: TStream);
      destructor Destroy; override;
      FUNCTION Execute: Word; override;
      FUNCTION GetHelpCtx: Word; override;
      FUNCTION GetPalette: PPalette; override;
      FUNCTION FindItem (Ch: Char): TMenuItem;
      FUNCTION HotKey (KeyCode: Word): TMenuItem;
      function NewSubView(var Bounds: TRect; AMenu: TMenu;
        AParentMenu: TMenuView): TMenuView; Virtual;
      PROCEDURE Store (Var S: TStream);override;
      PROCEDURE HandleEvent (Var Event: TEvent); override;
      PROCEDURE GetItemRect (Item: TMenuItem; out R: TRect); Virtual;
      private
      PROCEDURE GetItemRectX (Item: TMenuItem; out R: TRect); virtual;
   END;

{---------------------------------------------------------------------------}
{                    TMenuBar OBJECT - MENU BAR OBJECT                      }
{---------------------------------------------------------------------------}
TYPE
   TMenuBar = Class(TMenuView)
      public
      constructor Create(aOwner: Tgroup; var Bounds: TRect; AMenu: TMenu);
      DESTRUCTOR Destroy; override;
      PROCEDURE Draw; override;
      private
      PROCEDURE GetItemRectX (Item: TMenuItem; out R: TRect); override;
   END;
   PMenuBar = ^TMenuBar deprecated 'use TMenuBar';

{---------------------------------------------------------------------------}
{                   TMenuBox OBJECT - BOXED MENU OBJECT                     }
{---------------------------------------------------------------------------}
TYPE
   TMenuBox = Class (TMenuView)
      constructor Init(aOwner: TGroup; var Bounds: TRect; AMenu: TMenu;
        AParentMenu: TMenuView);
      PROCEDURE Draw; override;
      private
      PROCEDURE GetItemRectX (Item: TMenuItem; out R: TRect); override;
   END;
   PMenuBox = ^TMenuBox deprecated 'use TMenuBox';

{---------------------------------------------------------------------------}
{                  TMenuPopUp OBJECT - POPUP MENU OBJECT                    }
{---------------------------------------------------------------------------}
TYPE
   TMenuPopup = Class (TMenuBox)
      public
      constructor Init(aOwner: TGroup; var Bounds: TRect; AMenu: TMenu);
      DESTRUCTOR destroy; override;
      PROCEDURE HandleEvent (Var Event: TEvent); Override;
   END;
   PMenuPopup = ^TMenuPopup deprecated 'use TMenuPopup';

{---------------------------------------------------------------------------}
{                    TStatusLine OBJECT - STATUS LINE OBJECT                }
{---------------------------------------------------------------------------}
TYPE
   TStatusLine = Class (TView)
      public
         Items: PStatusItem;                          { Status line items }
         Defs : PStatusDef;                           { Status line default }
      constructor Create(aOwner: TGroup; var Bounds: TRect; ADefs: PStatusDef);
      constructor Load(aOwner: TComponent; var S: TStream);
      DESTRUCTOR Done; Virtual;
      FUNCTION GetPalette: PPalette; Override;
      FUNCTION Hint (AHelpCtx: Word): String; Virtual;
      PROCEDURE Draw; override;
      PROCEDURE Update; Virtual;
      PROCEDURE Store (Var S: TStream);override;
      PROCEDURE HandleEvent (Var Event: TEvent); override;
      PRIVATE
      PROCEDURE FindItems;
      PROCEDURE DrawSelect (Selected: PStatusItem);
   END;
   PStatusLine = ^TStatusLine deprecated 'use TStatusLine';

{***************************************************************************}
{                            INTERFACE ROUTINES                             }
{***************************************************************************}

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                           MENU INTERFACE ROUTINES                         }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{-NewMenu------------------------------------------------------------
Allocates and returns a pointer to a new TMenu record. Sets the Items
and Default fields of the record to the value given by the parameter.
An error creating will return a nil pointer.
14May98 LdB
---------------------------------------------------------------------}
FUNCTION NewMenu (aOwner:TGroup;Items: TMenuItem): TMenu;

{-DisposeMenu--------------------------------------------------------
Disposes of all the elements of the specified menu (and all submenus).
14May98 LdB
---------------------------------------------------------------------}
PROCEDURE DisposeMenu (var Menu: TMenu);

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                             MENU ITEM ROUTINES                            }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{-NewLine------------------------------------------------------------
Allocates and returns a pointer to a new TMenuItem record that
represents a separator line in a menu box.
An error creating will return a nil pointer.
14May98 LdB
---------------------------------------------------------------------}
FUNCTION NewLine (Next: TMenuItem=nil): TMenuItem;

{-NewItem------------------------------------------------------------
Allocates and returns a pointer to a new TMenuItem record that
represents a menu item (using NewStr to allocate the Name and Param).
An error creating will return a nil pointer.
14May98 LdB
---------------------------------------------------------------------}
FUNCTION NewItem (Name, Param: TMenuStr; KeyCode: Word; Command: Word;
  AHelpCtx: Word; Next: TMenuItem=nil): TMenuItem;

{-NewSubMenu---------------------------------------------------------
Allocates and returns a pointer to a new TMenuItem record, which
represents a submenu (using NewStr to allocate the Name).
An error creating will return a nil pointer.
14May98 LdB
---------------------------------------------------------------------}
FUNCTION NewSubMenu (Name: TMenuStr; AHelpCtx: Word; SubMenu: TMenu=nil;
  Next: TMenuItem=nil): TMenuItem;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                          STATUS INTERFACE ROUTINES                        }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{-NewStatusDef-------------------------------------------------------
Allocates and returns a pointer to a new TStatusDef record initialized
with the given parameter values. Calls to NewStatusDef can be nested.
An error creating will return a nil pointer.
15May98 LdB
---------------------------------------------------------------------}
FUNCTION NewStatusDef (AMin, AMax: Word; AItems: PStatusItem;
  ANext: PStatusDef): PStatusDef;

{-NewStatusKey-------------------------------------------------------
Allocates and returns a pointer to a new TStatusItem record initialized
with the given parameter values (using NewStr to allocate the Text).
An error in creating will return a nil pointer.
15May98 LdB
---------------------------------------------------------------------}
FUNCTION NewStatusKey (AText: String; AKeyCode: Word; ACommand: Word;
  ANext: PStatusItem): PStatusItem;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                           OBJECT REGISTER ROUTINES                        }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{-RegisterMenus-------------------------------------------------------
Calls RegisterType for each of the object types defined in this unit.
15May98 LdB
---------------------------------------------------------------------}
PROCEDURE RegisterMenus;

{***************************************************************************}
{                        INITIALIZED PUBLIC VARIABLES                       }
{***************************************************************************}

{---------------------------------------------------------------------------}
{                       INITIALIZED PUBLIC VARIABLES                        }
{---------------------------------------------------------------------------}

{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}
                                IMPLEMENTATION
{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}
USES
  Video;

CONST
  SubMenuChar : array[boolean] of char = ('>',#16);

{ TMenu }

destructor TMenu.destroy;
//var
  //I: TMenuItem;
begin
  inherited destroy;
end;

{ TMenuItem }

destructor TMenuItem.destroy;
begin
  freeandnil(SubMenu);
  inherited destroy;
end;

  { SubMenuChar is the character displayed at right of submenu }

{***************************************************************************}
{                               OBJECT METHODS                              }
{***************************************************************************}

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                          TMenuView OBJECT METHODS                         }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TMenuView----------------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 08May98 LdB              }
{---------------------------------------------------------------------------}
constructor TMenuView.Init(aOwner: TGroup; var Bounds: TRect);
BEGIN
   Inherited create(aOwner,Bounds);                            { Call ancestor }
   EventMask := EventMask OR evBroadcast;             { See broadcast events }
END;

{--TMenuView----------------------------------------------------------------}
{  Load -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Sep99 LdB              }
{---------------------------------------------------------------------------}
constructor TMenuView.Load(aOwner:TGroup;var S: TStream);

   FUNCTION DoLoadMenu: TMenu;
   VAR Tok: Byte; Item: TMenuItem; Last: TMenuItem; HMenu: TMenu;
     r: TRect;
   BEGIN
     HMenu := TMenu.create(self,rect(0,0,0,0));                                       { Create new menu }
                                                      { Start on first item }
     Item := Nil;                                     { Clear pointer }
     Tok :=S.ReadWord;                        { Read token }
     While (Tok <> 0) Do Begin
       Item := TMenuItem.create(HMenu,r);            { Create new item }
       If (Item <> Nil) Then Begin                    { Check item valid }
         With Item Do Begin
           Name := S.ReadAnsiString;                         { Read menu name }
           Command:= S.ReadWord;          { Menu item command }
           Disabled := S.ReadByte <> 0;        { Menu item state }
           KeyCode := S.ReadWord;          { Menu item keycode }
           HelpCtx := S.ReadWord;          { Menu item help ctx }
           If (Name <> '') Then
             If Command = 0 Then
{$ifdef PPC_FPC}
               SubMenu := DoLoadMenu()                  { Load submenu }
{$else not PPC_FPC}
               SubMenu := DoLoadMenu                  { Load submenu }
{$endif not PPC_FPC}
                 Else Param := S.ReadAnsiString;             { Read param string }
         End;
       End;
       S.Read(Tok, SizeOf(Tok));                      { Read token }
     End;
     Last := Nil;                                    { List complete }
     HMenu.Default := Tmenuitem(HMenu.Components[0]);                    { Set menu default }
     result := HMenu;                              { Return menu }
   End;

BEGIN
   Inherited Load(aOwner,S);                                 { Call ancestor }
   Menu := DoLoadMenu;                                { Load menu items }
END;

destructor TMenuView.Destroy;
begin
  freeandnil(Menu);
  inherited Destroy;
end;

{--TMenuView----------------------------------------------------------------}
{  Execute -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 30Sep99 LdB           }
{---------------------------------------------------------------------------}
function TMenuView.Execute: Word;
TYPE MenuAction = (DoNothing, DoSelect, DoReturn);
VAR AutoSelect: Boolean; Action: MenuAction; Ch: Char; Res: Word; R: TRect;
  ItemShown, P: TMenuItem; Target: TMenuView; E: TEvent; MouseActive: Boolean;

   PROCEDURE TrackMouse;
   VAR Mouse: TPoint; R: TRect;
     zMItem: TComponent;
   BEGIN
     Mouse.X := E.Where.X - Origin.X;              { Local x position }
     Mouse.Y := E.Where.Y - oRigin.Y;              { Local y position }
     for zMItem in Menu do                          { Start with current }
       begin
       GetItemRectX(TMenuItem(zMItem), R);                       { Get item rectangle }
       If R.Contains(Mouse) Then Begin                { Contains mouse }
         MouseActive := True;                         { Return true }
         Exit;                                        { Then exit }
       End;
     End;
   END;

   PROCEDURE TrackKey (FindNext: Boolean);

       PROCEDURE NextItem;
       BEGIN
         Current := tMenuItem(Current.Next{%H-});                    { Move to next item }
         If (Current = Nil) Then
           Current := tMenuItem(Menu.First);                    { Return first menu }
       END;

       PROCEDURE PrevItem;
    //   VAR P: TMenuItem;
       BEGIN
         Current := tMenuItem(Current.Prev{%H-});                           { Start on current }
         If (Current = Nil) Then
           Current := tMenuItem(Menu.Last);
       END;

   BEGIN
     If (Current <> Nil) Then                         { Current view valid }
       Repeat
         If FindNext Then NextItem Else PrevItem;     { Find next/prev item }
       Until (Current.Caption <> '');                  { Until we have name }
   END;

   FUNCTION MouseInOwner: Boolean;
   VAR Mouse: TPoint; R: TRect;
   BEGIN
     MouseInOwner := False;                           { Preset false }
     If (ParentMenu <> Nil) AND (ParentMenu.Size.Y = 1)
     Then Begin                                       { Valid parent menu }
       Mouse.X := E.Where.X - ParentMenu.Origin.X;{ Local x position }
       Mouse.Y := E.Where.Y - ParentMenu.Origin.Y;{ Local y position }
       ParentMenu.GetItemRectX(ParentMenu.Current,R);{ Get item rect }
       MouseInOwner := R.Contains(Mouse);             { Return result }
     End;
   END;

   FUNCTION MouseInMenus: Boolean;
   VAR P: TMenuView;
   BEGIN
     P := ParentMenu;                                 { Parent menu }
     While (P <> Nil) AND NOT P.MouseInView(E.Where)
       Do P := P.ParentMenu;                         { Check next menu }
     MouseInMenus := (P <> Nil);                      { Return result }
   END;

   FUNCTION TopMenu: TMenuView;
   VAR P: TMenuView;
   BEGIN
     P := Self;                                      { Start with self }
     While (P.ParentMenu <> Nil) Do
       P := P.ParentMenu;                            { Check next menu }
     TopMenu := P;                                    { Top menu }
   END;

BEGIN
   AutoSelect := False;                               { Clear select flag }
   MouseActive := False;                              { Clear mouse flag }
   Res := 0;                                          { Clear result }
   ItemShown := Nil;                                  { Clear item pointer }
   If (Menu <> Nil) Then Current := Menu.Default     { Set current item }
     Else Current := Nil;                             { No menu = no current }
   Repeat
     Action := DoNothing;                             { Clear action flag }
     GetEvent(E);                                     { Get next event }
     Case E.What Of
       evMouseDown: If MouseInView(E.Where)           { Mouse in us }
         OR MouseInOwner Then Begin                   { Mouse in owner area }
           TrackMouse;                                { Track the mouse }
           If (Size.Y = 1) Then AutoSelect := True;   { Set select flag }
         End Else Action := DoReturn;                 { Set return action }
       evMouseUp: Begin
           TrackMouse;                                { Track the mouse }
           If MouseInOwner Then                       { Mouse in owner }
             Current := Menu.Default                 { Set as current }
           Else If (Current <> Nil) AND
           (Current.caption <> '') Then
             Action := DoSelect                       { Set select action }
           Else If MouseActive OR MouseInView(E.Where)
           Then Action := DoReturn                    { Set return action }
           Else Begin
             Current := Menu.Default;                { Set current item }
             If (Current = Nil) Then
               Current := tMenuItem(Menu.first);                { Select first item }
             Action := DoNothing;                     { Do nothing action }
           End;
         End;
       evMouseMove: If (E.Buttons <> 0) Then Begin    { Mouse moved }
           TrackMouse;                                { Track the mouse }
           If NOT (MouseInView(E.Where) OR MouseInOwner)
           AND MouseInMenus Then Action := DoReturn;  { Set return action }
         End;
       evKeyDown:
         Case CtrlToArrow(E.KeyCode) Of               { Check arrow keys }
           kbUp, kbDown: If (Size.Y <> 1) Then
             TrackKey(CtrlToArrow(E.KeyCode) = kbDown){ Track keyboard }
             Else If (E.KeyCode = kbDown) Then        { Down arrow }
             AutoSelect := True;                      { Select item }
           kbLeft, kbRight: If (ParentMenu = Nil) Then
             TrackKey(CtrlToArrow(E.KeyCode)=kbRight) { Track keyboard }
             Else Action := DoReturn;                 { Set return action }
           kbHome, kbEnd: If (Size.Y <> 1) Then Begin
               Current := tMenuItem(Menu.First);                { Set to first item }
               If (E.KeyCode = kbEnd) Then            { If the 'end' key }
                 TrackKey(False);                     { Move to last item }
             End;
           kbEnter: Begin
               If Size.Y = 1 Then AutoSelect := True; { Select item }
               Action := DoSelect;                    { Return the item }
             End;
           kbEsc: Begin
               Action := DoReturn;                    { Set return action }
               If (ParentMenu = Nil) OR
               (ParentMenu.Size.Y <> 1) Then         { Check parent }
                 ClearEvent(E);                       { Kill the event }
             End;
           Else Target := Self;                      { Set target as self }
           Ch := GetAltChar(E.KeyCode);
           If (Ch = #0) Then Ch := E.CharCode Else
             Target := TopMenu;                       { Target is top menu }
           P := Target.FindItem(Ch);                 { Check for item }
           If (P = Nil) Then Begin
             P := TopMenu.HotKey(E.KeyCode);         { Check for hot key }
             If (P <> Nil) AND                        { Item valid }
             CommandEnabled(P.Command) Then Begin    { Command enabled }
               Res := P.Command;                     { Set return command }
               Action := DoReturn;                    { Set return action }
             End
           End Else If Target = Self Then Begin
             If Size.Y = 1 Then AutoSelect := True;   { Set auto select }
             Action := DoSelect;                      { Select item }
             Current := P;                            { Set current item }
           End Else If (ParentMenu <> Target) OR
           (ParentMenu.Current <> P) Then            { Item different }
              Action := DoReturn;                     { Set return action }
         End;
       evCommand: If (E.Command = cmMenu) Then Begin  { Menu command }
           AutoSelect := False;                       { Dont select item }
           If (ParentMenu <> Nil) Then
             Action := DoReturn;                      { Set return action }
         End Else Action := DoReturn;                 { Set return action }
     End;
     If (ItemShown <> Current) Then Begin             { New current item }
       OldItem := ItemShown;                          { Hold old item }
       ItemShown := Current;                          { Hold new item }
       DrawView;                                      { Redraw the items }
       OldItem := Nil;                                { Clear old item }
     End;
     If (Action = DoSelect) OR ((Action = DoNothing)
     AND AutoSelect) Then                             { Item is selecting }
       If (Current <> Nil) Then With Current Do      { Current item valid }
         If (Name <> '') Then                        { Item has a name }
           If (Command = 0) Then Begin                { Has no command }
             If (E.What AND (evMouseDown+evMouseMove) <> 0)
               Then PutEvent(E);                      { Put event on queue }
             GetItemRectX(Current, R);                 { Get area of item }
             R.A.X := R.A.X + Origin.X; { Left start point }
             R.A.Y := R.B.Y + Origin.Y;{ Top start point }
             R.B.X := TView(Owner).Size.X;                  { X screen area left }
             R.B.Y := TView(Owner).Size.Y;                  { Y screen area left }
             Target := TopMenu.NewSubView(R, SubMenu,
               Self);                                { Create drop menu }
             Res := TGroup(Owner).ExecView(Target);          { Execute dropped view }
             freeandnil(Target);                   { Dispose drop view }
           End Else If Action = DoSelect Then
             Res := Command;                          { Return result }
     If (Res <> 0) AND CommandEnabled(Res)            { Check command }
     Then Begin
       Action := DoReturn;                            { Return command }
       ClearEvent(E);                                 { Clear the event }
     End Else Res := 0;                               { Clear result }
   Until (Action = DoReturn);
   If (E.What <> evNothing) Then
     If (ParentMenu <> Nil) OR (E.What = evCommand)   { Check event type }
       Then PutEvent(E);                              { Put event on queue }
   If (Current <> Nil) Then Begin
     Menu.Default := Current;                        { Set new default }
     Current := Nil;                                  { Clear current }
     DrawView;                                        { Redraw the view }
   End;
   Execute := Res;                                    { Return result }
END;

{--TMenuView----------------------------------------------------------------}
{  GetHelpCtx -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 08May98 LdB        }
{---------------------------------------------------------------------------}
function TMenuView.GetHelpCtx: Word;
VAR C: TMenuView;
BEGIN
   C := Self;                                        { Start at self }
   While (C <> Nil) AND ((C.Current = Nil) OR
   (C.Current.HelpCtx = hcNoContext) OR             { Has no context }
   (C.Current.caption = '')) Do C := C.ParentMenu;   { Parent menu context }
   If (C<>Nil) Then GetHelpCtx := C.Current.HelpCtx { Current context }
     Else GetHelpCtx := hcNoContext;                  { No help context }
END;

{--TMenuView----------------------------------------------------------------}
{  GetPalette -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 15May98 LdB        }
{---------------------------------------------------------------------------}
function TMenuView.GetPalette: PPalette;
{$IFDEF PPC_DELPHI3}                                  { DELPHI3+ COMPILER }
CONST P: String = CMenuView;                          { Possible huge string }
{$ELSE}                                               { OTHER COMPILERS }
CONST P: String[Length(CMenuView)] = CMenuView;       { Always normal string }
{$ENDIF}
BEGIN
   GetPalette := PPalette(@P);                        { Return palette }
END;

{--TMenuView----------------------------------------------------------------}
{  FindItem -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 11May98 LdB          }
{---------------------------------------------------------------------------}
function TMenuView.FindItem(Ch: Char): TMenuItem;
VAR I: Integer; P: TMenuItem;
BEGIN
   Ch := UpCase(Ch);                                  { Upper case of char }
   for Tcomponent(P) in Menu do                                  { First menu item }
   Begin                                             { While item valid }
     If (P.caption <> '') AND (NOT P.Disabled)        { Valid enabled cmd }
     Then Begin
       I := Pos('~', P.caption);                       { Scan for highlight }
       If (I <> 0) AND (Ch = UpCase(P.caption[I+1]))   { Hotkey char found }
       Then Begin
         FindItem := P;                               { Return item }
         Exit;                                        { Now exit }
       End;
     End;
   End;
   FindItem := Nil;                                   { No item found }
END;

{--TMenuView----------------------------------------------------------------}
{  HotKey -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 11May98 LdB            }
{---------------------------------------------------------------------------}
function TMenuView.HotKey(KeyCode: Word): TMenuItem;

   FUNCTION FindHotKey (M: TMenu): TMenuItem;
   VAR P,T: TMenuItem;
   BEGIN
     for TComponent(P) in M do
       Begin                        { While item valid }
       If (P.caption <> '') Then                       { If valid name }
         If (P.Command = 0) Then Begin               { Valid command }
           T := FindHotKey(P.SubMenu);        { Search for hot key }
           If (T <> Nil) Then Begin
             Result := T;                         { Return hotkey }
             Exit;                                    { Now exit }
           End;
         End Else If NOT P.Disabled AND              { Hotkey is enabled }
         (P.KeyCode <> kbNoKey) AND                  { Valid keycode }
         (P.KeyCode = KeyCode) Then Begin            { Key matches request }
           Result := P;                           { Return hotkey code }
           Exit;                                      { Exit }
         End;
     End;
     Result := Nil;                               { No item found }
   END;

BEGIN
   HotKey := FindHotKey(Menu);                 { Hot key function }
END;

{--TMenuView----------------------------------------------------------------}
{  NewSubView -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 11May98 LdB        }
{---------------------------------------------------------------------------}
function TMenuView.NewSubView(var Bounds: TRect; AMenu: TMenu;
  AParentMenu: TMenuView): TMenuView;
BEGIN
   NewSubView := TMenuBox.Init(tgroup(self.owner),Bounds, AMenu,
     AParentMenu);                                   { Create a menu box }
END;

{--TMenuView----------------------------------------------------------------}
{  Store -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 11May98 LdB             }
{---------------------------------------------------------------------------}
procedure TMenuView.Store(var S: TStream);

   PROCEDURE DoStoreMenu (AMenu: TMenu);
   VAR Item: TMenuItem; Tok: Byte;
   BEGIN
     Tok := $FF;                                      { Preset max count }
     for TComponent(Item) in AMenu Do Begin
       With Item Do Begin
         S.Write(Tok, SizeOf(Tok));                      { Write tok value }
         S.WriteAnsiString(Name);                            { Write item name }
         S.Write(Command, SizeOf(Command));           { Menu item command }
         S.Write(Disabled, SizeOf(Disabled));         { Menu item state }
         S.Write(KeyCode, SizeOf(KeyCode));           { Menu item keycode }
         S.Write(HelpCtx, SizeOf(HelpCtx));           { Menu item help ctx }
         If (Name <> '') Then
           If Command = 0 Then DoStoreMenu(SubMenu)
           Else S.WriteAnsiString(Param);                    { Write parameter }
       End;
     End;
     Tok := 0;                                        { Clear tok count }
     S.Write(Tok, SizeOf(Tok));                       { Write tok value }
   END;

BEGIN
   inherited Store(S);                                    { TView.Store called }
   DoStoreMenu(Menu);                                 { Store menu items }
END;

{--TMenuView----------------------------------------------------------------}
{  HandleEvent -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 08May98 LdB       }
{---------------------------------------------------------------------------}
procedure TMenuView.HandleEvent(var Event: TEvent);
VAR CallDraw: Boolean; P: TMenuItem;

   PROCEDURE UpdateMenu (AMenu: TMenu);
   VAR P: TMenuItem; CommandState: Boolean;
   BEGIN
     for TComponent(P) in AMenu Do Begin
       If (P.caption <> '') Then                       { Valid name }
       If (P.Command = 0) Then UpdateMenu(P.SubMenu){ Update menu }
       Else Begin
         CommandState := CommandEnabled(P.Command);  { Menu item state }
         If (P.Disabled = CommandState) Then Begin
           P.Disabled := NOT CommandState;           { Disable item }
           CallDraw := True;                          { Must draw }
         End;
       End;
     End;
   END;

   PROCEDURE DoSelect;
   BEGIN
     PutEvent(Event);                                 { Put event on queue }
     Event.Command := TGroup(Owner).ExecView(Self);         { Execute view }
     If (Event.Command <> 0) AND
     CommandEnabled(Event.Command) Then Begin
       Event.What := evCommand;                       { Command event }
       Event.InfoPtr := Nil;                          { Clear info ptr }
       PutEvent(Event);                               { Put event on queue }
     End;
     ClearEvent(Event);                               { Clear the event }
   END;

BEGIN
   If (Menu <> Nil) Then
     Case Event.What Of
       evMouseDown: DoSelect;                         { Select menu item }
       evKeyDown:
         If (FindItem(GetAltChar(Event.KeyCode)) <> Nil)
         Then DoSelect Else Begin                     { Select menu item }
           P := HotKey(Event.KeyCode);                { Check for hotkey }
           If (P <> Nil) AND
           (CommandEnabled(P.Command)) Then Begin
             Event.What := evCommand;                 { Command event }
             Event.Command := P.Command;             { Set command event }
             Event.InfoPtr := Nil;                    { Clear info ptr }
             PutEvent(Event);                         { Put event on queue }
             ClearEvent(Event);                       { Clear the event }
           End;
         End;
       evCommand:
         If Event.Command = cmMenu Then DoSelect;     { Select menu item }
       evBroadcast:
         If (Event.Command = cmCommandSetChanged)     { Commands changed }
         Then Begin
           CallDraw := False;                         { Preset no redraw }
           UpdateMenu(Menu);                          { Update menu }
           If CallDraw Then DrawView;                 { Redraw if needed }
         End;
     End;
END;

{--TMenuView----------------------------------------------------------------}
{  GetItemRectX -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 08May98 LdB       }
{---------------------------------------------------------------------------}
procedure TMenuView.GetItemRectX(Item: TMenuItem; out R: TRect);
BEGIN                                                 { Abstract method }
END;

{--TMenuView----------------------------------------------------------------}
{  GetItemRect -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 08May98 LdB       }
{---------------------------------------------------------------------------}
procedure TMenuView.GetItemRect(Item: TMenuItem; out R: TRect);
BEGIN
  GetItemRectX(Item,R);
END;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                        TMenuBar OBJECT METHODS                            }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TMenuBar-----------------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 08May98 LdB              }
{---------------------------------------------------------------------------}
constructor TMenuBar.Create(aOwner: Tgroup; var Bounds: TRect; AMenu: TMenu);
BEGIN
   Inherited Init(aOwner,Bounds);                            { Call ancestor }
   GrowMode := gfGrowHiX;                             { Set grow mode }
   Menu := AMenu;                                     { Hold menu item }
   Options := Options OR ofPreProcess;                { Preprocessing view }
END;

{--TMenuBar-----------------------------------------------------------------}
{  Done -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 08May98 LdB              }
{---------------------------------------------------------------------------}
destructor TMenuBar.Destroy;
BEGIN
   If (Menu <> Nil) Then DisposeMenu(Menu);           { Dispose menu items }
   Inherited ;                                    { Call ancestor }
END;

{--TMenuBar-----------------------------------------------------------------}
{  DrawBackGround -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 08May98 LdB    }
{---------------------------------------------------------------------------}
procedure TMenuBar.Draw;
VAR I, J, CNormal, CSelect, CNormDisabled, CSelDisabled, Color: Word;
    P: TMenuItem; B: TDrawBuffer;
BEGIN
   CNormal := GetColor($0301);                        { Normal colour }
   CSelect := GetColor($0604);                        { Select colour }
   CNormDisabled := GetColor($0202);                  { Disabled colour }
   CSelDisabled := GetColor($0505);                   { Select disabled }
   MoveChar(B, ' ', Byte(CNormal), Size.X);           { Empty bar }
   If (Menu <> Nil) Then Begin                        { Valid menu }
     I := 0;                                          { Set start position }
     for TComponent(P) in Menu Do Begin
       If (P.caption <> '') Then Begin                 { Name valid }
         If P.Disabled Then Begin
           If (P = Current) Then Color := CSelDisabled{ Select disabled }
             Else Color := CNormDisabled              { Normal disabled }
         End Else Begin
           If (P = Current) Then Color := CSelect     { Select colour }
             Else Color := CNormal;                   { Normal colour }
         End;
         J := CStrLen(P.caption);                      { Length of string }
         MoveChar(B[I], ' ', Byte(Color), 1);
         MoveCStr(B[I+1], P.caption, Color);           { Name to buffer }
         MoveChar(B[I+1+J], ' ', Byte(Color), 1);
         Inc(I, J+2);                                 { Advance position }
       End;
     End;
   End;
  WriteBuf(0, 0, Size.X, 1, B);                       { Write the string }
END;

{--TMenuBar-----------------------------------------------------------------}
{  GetItemRectX -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 08May98 LdB      }
{---------------------------------------------------------------------------}
procedure TMenuBar.GetItemRectX(Item: TMenuItem; out R: TRect);
VAR I: Integer; P: TMenuItem;
BEGIN
   I := 0;                                            { Preset to zero }
   R.Assign(0, 0, 0, 1);                     { Initial rect size }
   for Tcomponent(P) in Menu do Begin                          { While valid item }
     R.A.X := I;                            { Move area along }
     If (P.caption <> '') Then Begin                   { Valid name }
       R.B.X := R.A.X+CTextWidth(' ' + P.caption + ' ');{ Add text width  }
       I := I + CStrLen(P.caption) + 2;                { Add item length }
     End Else R.B.X := R.A.X;
     If (P = Item) Then break;                        { Requested item found }
   End;
END;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                          TMenuBox OBJECT METHODS                          }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TMenuBox-----------------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 11May98 LdB              }
{---------------------------------------------------------------------------}
constructor TMenuBox.Init(aOwner: TGroup; var Bounds: TRect; AMenu: TMenu;
  AParentMenu: TMenuView);
VAR W, H, L: Integer; S: String; P: TMenuItem; R: TRect;
BEGIN
   W := 0;                                            { Clear initial width }
   H := 2;                                            { Set initial height }
   If (AMenu <> Nil) Then Begin                       { Valid menu }
     for TComponent(P) in AMenu Do Begin                        { If item valid }
       If (P.caption <> '') Then Begin                 { Check for name }
         S := ' ' + P.caption + ' ';                   { Transfer string }
         If (P.Command <> 0) AND (P.Param <> '')
           Then S := S + ' - ' + P.Param;           { Add any parameter }
       End;
       L := CTextWidth(S);                             { Width of string }
       If (L > W) Then W := L;                        { Hold maximum }
       Inc(H);                                        { Inc count of items }
     End;
   End;
   W := 5 + W;                        { Longest text width }
   R.Copy(Bounds);                                    { Copy the bounds }
   If (R.A.X + W < R.B.X) Then R.B.X := R.A.X + W     { Shorten if possible }
     Else R.A.X := R.B.X - W;                         { Insufficent space }
   R.B.X := R.A.X + W;
   If (R.A.Y + H < R.B.Y) Then R.B.Y := R.A.Y + H     { Shorten if possible }
     Else R.A.Y := R.B.Y - H;                         { Insufficent height }
   Inherited Init(aOwner,R);                                 { Call ancestor }
   State := State OR sfShadow;                        { Set shadow state }
   Options := Options OR ofFramed or ofPreProcess;                { View pre processes }
   Menu := AMenu;                                     { Hold menu }
   ParentMenu := AParentMenu;                         { Hold parent }
END;

{--TMenuBox-----------------------------------------------------------------}
{  Draw -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 11May98 LdB              }
{---------------------------------------------------------------------------}
procedure TMenuBox.Draw;
VAR CNormal, CSelect, CSelectDisabled, CDisabled, Color: Word; Index, Y: Integer;
    S: String; P: TMenuItem; B: TDrawBuffer;
Type
   FrameLineType = (UpperLine,NormalLine,SeparationLine,LowerLine);
   FrameLineChars = Array[0..2] of char;
Const
   FrameLines : Array[FrameLineType] of FrameLineChars =
     ('ÚÄ¿','³ ³','ÃÄ´','ÀÄÙ');
  Procedure CreateBorder(LineType : FrameLineType);
  Begin
    MoveChar(B, ' ', CNormal, 1);
    MoveChar(B[1], FrameLines[LineType][0], CNormal, 1);
    MoveChar(B[2], FrameLines[LineType][1], Color, Size.X-4);
    MoveChar(B[Size.X-2], FrameLines[LineType][2], CNormal, 1);
    MoveChar(B[Size.X-1], ' ', CNormal, 1);
  End;


BEGIN
   CNormal := GetColor($0301);                        { Normal colour }
   CSelect := GetColor($0604);                        { Selected colour }
   CDisabled := GetColor($0202);                      { Disabled colour }
   CSelectDisabled := GetColor($0505);                { Selected, but disabled }
   Color := CNormal;                              { Normal colour }
   CreateBorder(UpperLine);
   WriteBuf(0, 0, Size.X, 1, B);                  { Write the line }
   Y := 1;
   If (Menu <> Nil) Then Begin                        { We have a menu }
     for TComponent(P) in Menu Do Begin                        { Valid menu item }
       Color := CNormal;                              { Normal colour }
       If (P.caption <> '') Then Begin                 { Item has text }
         If P.Disabled Then
           begin
             if (P = Current) then
               Color := CSelectDisabled
             else
               Color := CDisabled; { Is item disabled }
           end
         else
           If (P = Current) Then Color := CSelect;    { Select colour }
         CreateBorder(NormalLine);
         Index:=2;
         S := ' ' + P.caption + ' ';                   { Menu string }
         MoveCStr(B[Index], S, Color);                { Transfer string }
        if P.Command = 0 then
          MoveChar(B[Size.X - 4],SubMenuChar[LowAscii],
            Byte(Color), 1) else
         If (P.Command <> 0) AND(P.Param <> '') Then
         Begin
            MoveCStr(B[Size.X - 3 - Length(P.Param)], P.Param, Color);  { Add param chars }
            S := S + ' - ' + P.Param;                { Add to string }
         End;
         If (OldItem = Nil) OR (OldItem = P) OR
            (Current = P) Then
           Begin                     { We need to fix draw }
             WriteBuf(0, Y, Size.X, 1, B);             { Write the whole line }
         End;
       End Else Begin { no text NewLine }
         Color := CNormal;                              { Normal colour }
         CreateBorder(SeparationLine);
         WriteBuf(0, Y, Size.X, 1, B);                { Write the line }
       End;
       Inc(Y);                                        { Next line down }
     End;
   End;
   Color := CNormal;                              { Normal colour }
   CreateBorder(LowerLine);
   WriteBuf(0, Size.Y-1, Size.X, 1, B);                  { Write the line }
END;


{--TMenuBox-----------------------------------------------------------------}
{  GetItemRectX -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 11May98 LdB      }
{---------------------------------------------------------------------------}
procedure TMenuBox.GetItemRectX(Item: TMenuItem; out R: TRect);
VAR X, Y: Integer; P: TMenuItem;
BEGIN
   Y := 1;                                   { Initial y position }
   for TComponent(P) in Menu Do Begin                         { Valid item }
     Inc(Y);                              { Inc position }
   End;
   X := 2;                                { Left/Right margin }
   R.Assign(X, Y, Size.X - X, Y + 1);     { Assign area }
END;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                        TMenuPopUp OBJECT METHODS                          }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TMenuPopUp---------------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 15May98 LdB              }
{---------------------------------------------------------------------------}
constructor TMenuPopup.Init(aOwner: TGroup; var Bounds: TRect; AMenu: TMenu);
BEGIN
   Inherited Init(aowner, Bounds, AMenu, Nil);                { Call ancestor }
END;

{--TMenuPopUp---------------------------------------------------------------}
{  Done -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 15May98 LdB              }
{---------------------------------------------------------------------------}
destructor TMenuPopup.destroy;
BEGIN
   If (Menu <> Nil) Then DisposeMenu(Menu);           { Dispose menu items }
   Inherited Destroy;                                    { Call ancestor }
END;

{--TMenuPopUp---------------------------------------------------------------}
{  HandleEvent -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 15May98 LdB       }
{---------------------------------------------------------------------------}
procedure TMenuPopup.HandleEvent(var Event: TEvent);
VAR P: TMenuItem;
BEGIN
   Case Event.What Of
     evKeyDown: Begin
         P := FindItem(GetCtrlChar(Event.KeyCode));   { Find the item }
         If (P = Nil) Then P := HotKey(Event.KeyCode);{ Try hot key }
         If (P <> Nil) AND (CommandEnabled(P.Command))
         Then Begin                                   { Command valid }
           Event.What := evCommand;                   { Command event }
           Event.Command := P.Command;               { Set command value }
           Event.InfoPtr := Nil;                      { Clear info ptr }
           PutEvent(Event);                           { Put event on queue }
           ClearEvent(Event);                         { Clear the event }
         End Else If (GetAltChar(Event.KeyCode) <> #0)
           Then ClearEvent(Event);                    { Clear the event }
       End;
   End;
   Inherited HandleEvent(Event);                      { Call ancestor }
END;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                        TStatusLine OBJECT METHODS                         }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TStatusLine--------------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 11May98 LdB              }
{---------------------------------------------------------------------------}
constructor TStatusLine.Create(aOwner: TGroup; var Bounds: TRect;
  ADefs: PStatusDef);
BEGIN
   Inherited create(aOwner,Bounds);                            { Call ancestor }
   Options := Options OR ofPreProcess;                { Pre processing view }
   EventMask := EventMask OR evBroadcast;             { See broadcasts }
   GrowMode := gfGrowLoY + gfGrowHiX + gfGrowHiY;     { Set grow modes }
   Defs := ADefs;                                     { Set default items }
   FindItems;                                         { Find the items }
END;

{--TStatusLine--------------------------------------------------------------}
{  Load -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 11May98 LdB              }
{---------------------------------------------------------------------------}
constructor TStatusLine.Load(aOwner: TComponent; var S: TStream);

   FUNCTION DoLoadStatusItems: PStatusItem;
   VAR Count: Integer; Cur, First: PStatusItem; Last: ^PStatusItem;
   BEGIN
     Cur := Nil;                                      { Preset nil }
     Last := @First;                                  { Start on first item }
     S.Read(Count, SizeOf(Count));                    { Read count }
     While (Count > 0) Do Begin
       New(Cur);                                      { New status item }
       Last^ := Cur;                                  { First chain part }
       If (Cur <> Nil) Then Begin                     { Check pointer valid }
         Last := @Cur^.Next;                          { Chain complete }
         Cur^.Text := S.ReadAnsiString;                      { Read item text }
         S.Read(Cur^.KeyCode, SizeOf(Cur^.KeyCode));  { Keycode of item }
         S.Read(Cur^.Command, SizeOf(Cur^.Command));  { Command of item }
       End;
       Dec(Count);                                    { One item loaded }
     End;
     Last^ := Nil;                                    { Now chain end }
     DoLoadStatusItems := First;                      { Return the list }
   END;

   FUNCTION DoLoadStatusDefs: PStatusDef;
   VAR Count: Integer; Cur, First: PStatusDef; Last: ^PStatusDef;
   BEGIN
     Last := @First;                                  { Start on first }
     S.Read(Count, SizeOf(Count));                    { Read item count }
     While (Count > 0) Do Begin
       New(Cur);                                      { New status def }
       Last^ := Cur;                                  { First part of chain }
       If (Cur <> Nil) Then Begin                     { Check pointer valid }
         Last := @Cur^.Next;                          { Chain complete }
         S.Read(Cur^.Min, SizeOf(Cur^.Min));          { Read min data }
         S.Read(Cur^.Max, SizeOf(Cur^.Max));          { Read max data }
         Cur^.Items := DoLoadStatusItems;             { Set pointer }
       End;
       Dec(Count);                                    { One item loaded }
     End;
     Last^ := Nil;                                    { Now chain ends }
     DoLoadStatusDefs := First;                       { Return item list }
   END;

BEGIN
   Inherited Load(aOwner,S);                                 { Call ancestor }
   Defs := DoLoadStatusDefs;                          { Retreive items }
   FindItems;                                         { Find the items }
END;

{--TStatusLine--------------------------------------------------------------}
{  Done -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 11May98 LdB              }
{---------------------------------------------------------------------------}
destructor TStatusLine.Done;
VAR T: PStatusDef;

   PROCEDURE DisposeItems (Item: PStatusItem);
   VAR T: PStatusItem;
   BEGIN
     While (Item <> Nil) Do Begin                     { Item to dispose }
       T := Item;                                     { Hold pointer }
       Item := Item^.Next;                            { Move down chain }
 //      DisposeStr(T.Text);                           { Dispose string }
       Dispose(T);                                    { Dispose item }
     End;
   END;

BEGIN
   While (Defs <> Nil) Do Begin
     T := Defs;                                       { Hold pointer }
     Defs := Defs^.Next;                              { Move down chain }
     DisposeItems(T^.Items);                          { Dispose the item }
     Dispose(T);                                      { Dispose status item }
   End;
   Inherited ;                                    { Call ancestor }
END;


{--TStatusLine--------------------------------------------------------------}
{  GetPalette -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 11May98 LdB        }
{---------------------------------------------------------------------------}
function TStatusLine.GetPalette: PPalette;
{$IFDEF PPC_DELPHI3}                                  { DELPHI3+ COMPILER }
CONST P: String = CStatusLine;                        { Possible huge string }
{$ELSE}                                               { OTHER COMPILERS }
CONST P: String[Length(CStatusLine)] = CStatusLine;   { Always normal string }
{$ENDIF}
BEGIN
   GetPalette := PPalette(@P);                        { Return palette }
END;

{--TStatusLine--------------------------------------------------------------}
{  Hint -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 11May98 LdB              }
{---------------------------------------------------------------------------}
function TStatusLine.Hint(AHelpCtx: Word): String;
BEGIN
   Hint := '';                                        { Return nothing }
END;

{--TStatusLine--------------------------------------------------------------}
{  Draw -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 11May98 LdB              }
{---------------------------------------------------------------------------}
procedure TStatusLine.Draw;
BEGIN
   DrawSelect(Nil);                                   { Call draw select }
END;

{--TStatusLine--------------------------------------------------------------}
{  Update -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 15May98 LdB            }
{---------------------------------------------------------------------------}
procedure TStatusLine.Update;
VAR H: Word; P: TView;
BEGIN
   P := TopView;                                      { Get topmost view }
   If (P <> Nil) Then H := P.GetHelpCtx Else         { Top views context }
     H := hcNoContext;                                { No context }
   If (HelpCtx <> H) Then Begin                       { Differs from last }
     HelpCtx := H;                                    { Hold new context }
     FindItems;                                       { Find the item }
     DrawView;                                        { Redraw the view }
   End;
END;

{--TStatusLine--------------------------------------------------------------}
{  Store -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 11May98 LdB             }
{---------------------------------------------------------------------------}
procedure TStatusLine.Store(var S: TStream);

   PROCEDURE DoStoreStatusItems (Cur: PStatusItem);
   VAR Count: Integer; T: PStatusItem;
   BEGIN
     Count := 0;                                      { Clear count }
     T := Cur;                                        { Start on current }
     While (T <> Nil) Do Begin
       Inc(Count);                                    { Count items }
       T := T^.Next;                                  { Next item }
     End;
     S.Write(Count, SizeOf(Count));                   { Write item count }
     While (Cur <> Nil) Do Begin
       S.WriteAnsiString(Cur^.Text);                         { Store item text }
       S.Write(Cur^.KeyCode, SizeOf(Cur^.KeyCode));   { Keycode of item }
       S.Write(Cur^.Command, SizeOf(Cur^.Command));   { Command of item }
       Cur := Cur^.Next;                              { Move to next item }
     End;
   END;

   PROCEDURE DoStoreStatusDefs (Cur: PStatusDef);
   VAR Count: Integer; T: PStatusDef;
   BEGIN
     Count := 0;                                      { Clear count }
     T := Cur;                                        { Current status item }
     While (T <> Nil) Do Begin
       Inc(Count);                                    { Count items }
       T := T^.Next                                   { Next item }
     End;
     S.Write(Count, 2);                               { Write item count }
     While (Cur <> Nil) Do Begin
       With Cur^ Do Begin
         S.Write(Cur^.Min, 2);                        { Write min data }
         S.Write(Cur^.Max, 2);                        { Write max data }
         DoStoreStatusItems(Items);                   { Store the items }
       End;
       Cur := Cur^.Next;                              { Next status item }
     End;
   END;

BEGIN
   Inherited Store(S);                                    { TView.Store called }
   DoStoreStatusDefs(Defs);                           { Store status items }
END;

{--TStatusLine--------------------------------------------------------------}
{  HandleEvent -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 11May98 LdB       }
{---------------------------------------------------------------------------}
procedure TStatusLine.HandleEvent(var Event: TEvent);
VAR Mouse: TPoint; T, Tt: PStatusItem;

   FUNCTION ItemMouseIsIn: PStatusItem;
   VAR X, Xi: Word; T: PStatusItem;
   BEGIN
     ItemMouseIsIn := Nil;                            { Preset fail }
     If (Mouse.Y < 0) OR (Mouse.Y > 1)       { Outside view height }
       Then Exit;                                     { Not in view exit }
     X := 0;                                          { Zero x position }
     T := Items;                                      { Start at first item }
     While (T <> Nil) Do Begin                        { While item valid }
       If (T^.Text <> '') Then Begin                 { Check valid text }
         Xi := X;                                     { Hold initial x value }
         X := Xi + CTextWidth(' ' + T^.Text + ' ');   { Add text width }
         If (Mouse.X >= Xi) AND (Mouse.X < X)
         Then Begin
           ItemMouseIsIn := T;                        { Selected item }
           Exit;                                      { Now exit }
         End;
       End;
       T := T^.Next;                                  { Next item }
     End;
   END;

BEGIN
   Inherited HandleEvent(Event);                      { Call ancestor }
   Case Event.What Of
     evMouseDown: Begin
         T := Nil;                                    { Preset ptr to nil }
         Repeat
           Mouse.X := Event.Where.X - Origin.X;    { Local x position }
           Mouse.Y := Event.Where.Y - Origin.Y;    { Local y position }
           Tt := ItemMouseIsIn;                       { Find selected item }
           If (T <> Tt) Then                          { Item has changed }
             DrawSelect(Tt);                          { Draw new item }
           T := Tt                                    { Transfer item }
         Until NOT MouseEvent(Event, evMouseMove);    { Mouse stopped moving }
         If (T <> Nil) AND CommandEnabled(T^.Command) { Check cmd enabled }
         Then Begin
           Event.What := evCommand;                   { Command event }
           Event.Command := T^.Command;               { Set command value }
           Event.InfoPtr := Nil;                      { No info ptr }
           PutEvent(Event);                           { Put event on queue }
         End;
         ClearEvent(Event);                           { Clear the event }
         DrawSelect(Nil);                             { Clear the highlight }
       End;
     evKeyDown: Begin                                 { Key down event }
         T := Items;                                  { Start on first item }
         While (T <> Nil) Do Begin                    { For each valid item }
           If (Event.KeyCode = T^.KeyCode) AND        { Check for hot key }
           CommandEnabled(T^.Command) Then Begin      { Check cmd enabled }
             Event.What := evCommand;                 { Change to command }
             Event.Command := T^.Command;             { Set command value }
             Event.InfoPtr := Nil;                    { Clear info ptr }
             PutEvent(Event);                           { Put event on queue }
             ClearEvent(Event);                         { Clear the event }
             Exit;             Exit;                                    { Now exit }
           End;
           T := T^.Next;                              { Next item }
         End;
       End;
     evBroadcast:
       If (Event.Command = cmCommandSetChanged) Then  { Command set change }
         DrawView;                                    { Redraw view }
   End;
END;

{***************************************************************************}
{                    TStatusLine OBJECT PRIVATE METHODS                     }
{***************************************************************************}

{--TStatusLine--------------------------------------------------------------}
{  FindItems -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 11May98 LdB         }
{---------------------------------------------------------------------------}
procedure TStatusLine.FindItems;
VAR P: PStatusDef;
BEGIN
   P := Defs;                                         { First status item }
   While (P <> Nil) AND ((HelpCtx < P^.Min) OR
   (HelpCtx > P^.Max)) Do P := P^.Next;               { Find status item }
   If (P = Nil) Then Items := Nil Else
     Items := P^.Items;                               { Return found item }
END;

{--TStatusLine--------------------------------------------------------------}
{  DrawSelect -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 11May98 LdB        }
{---------------------------------------------------------------------------}
procedure TStatusLine.DrawSelect(Selected: PStatusItem);
VAR I, L: Integer; Color, CSelect, CNormal, CSelDisabled, CNormDisabled: Word;
    HintBuf: String; B: TDrawBuffer; T: PStatusItem;
BEGIN
   CNormal := GetColor($0301);                        { Normal colour }
   CSelect := GetColor($0604);                        { Select colour }
   CNormDisabled := GetColor($0202);                  { Disabled colour }
   CSelDisabled := GetColor($0505);                   { Select disabled }
   MoveChar(B, ' ', Byte(CNormal), Size.X);      { Clear the buffer }
   T := Items;                                        { First item }
   I := 0;                                            { Clear the count }
   L := 0;
   While (T <> Nil) Do Begin                          { While valid item }
     If (T^.Text <> '') Then Begin                   { While valid text }
       L := CStrLen(' '+T^.Text+' ');                { Text length }
       If CommandEnabled(T^.Command) Then Begin       { Command enabled }
         If T = Selected Then Color := CSelect        { Selected colour }
           Else Color := CNormal                      { Normal colour }
       End Else
         If T = Selected Then Color := CSelDisabled   { Selected disabled }
           Else Color := CNormDisabled;               { Disabled colour }
       MoveCStr(B[I], ' '+T^.Text+' ', Color);       { Move text to buf }
       Inc(I, L);                                     { Advance position }
     End;
     T := T^.Next;                                    { Next item }
   End;
   HintBuf := Hint(HelpCtx);                          { Get hint string }
   If (HintBuf <> '') Then Begin                      { Hint present }
     {$IFNDEF OS_WINDOWS}
     MoveChar(B[I], #179, Byte(CNormal), 1);          { '|' char to buffer }
     {$ELSE}
     MoveChar(B[I], #124, Byte(CNormal), 1);          { '|' char to buffer }
     {$ENDIF}
     Inc(I, 2);                                       { Move along }
     MoveStr(B[I], HintBuf, Byte(CNormal));           { Move hint to buffer }
     I := I + Length(HintBuf);                        { Hint length }
   End;
   WriteLine(0, 0, Size.X, 1, B);                          { Write the buffer }
END;

{***************************************************************************}
{                            INTERFACE ROUTINES                             }
{***************************************************************************}

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                           MENU INTERFACE ROUTINES                         }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{---------------------------------------------------------------------------}
{  NewMenu -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 14May98 LdB           }
{---------------------------------------------------------------------------}
function NewMenu(aOwner:TGroup;Items:TMenuItem): TMenu;
VAR P: TMenu;
  r: TRect;
  I: TMenuItem;
BEGIN
   P:= TMenu.create(aOwner,r);                                            { Create new menu }
   I:= Items;
   while i <> nil  do
     begin
     if not assigned(i.Owner) then
       if assigned(Aowner) then
         aOwner.InsertComponent(i)
       else
         p.InsertComponent(i);
     if not assigned(i.parent) or (i.parent <> P) then
     P.Insert(I);
     i := TMenuItem(i.Next{%H-});
     end;
   result := P;                                      { Return menu }
END;

{---------------------------------------------------------------------------}
{  DisposeMenu -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 14May98 LdB       }
{---------------------------------------------------------------------------}
procedure DisposeMenu(var Menu: TMenu);

BEGIN
   If (Menu <> Nil) Then Begin                        { Valid menu item }
     freeandnil(Menu);
   End;
END;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                             MENU ITEM ROUTINES                            }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{---------------------------------------------------------------------------}
{  NewLine -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 14May98 LdB           }
{---------------------------------------------------------------------------}
function NewLine(Next: TMenuItem): TMenuItem;
VAR P: TMenuItem;
  r: TRect;
BEGIN
   P := TMenuItem.create(nil,r);                                            { Allocate memory }
   If (P <> Nil)  Then
   Begin                           { Check valid pointer }
     P.Next := Next;                                 { Hold next menu item }
   End;
   Result := P;                                      { Return new line }
END;

{---------------------------------------------------------------------------}
{  NewItem -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 14May98 LdB           }
{---------------------------------------------------------------------------}
function NewItem(Name, Param: TMenuStr; KeyCode: Word; Command: Word;
  AHelpCtx: Word; Next: TMenuItem): TMenuItem;
VAR P: TMenuItem; R: TRect;
BEGIN
   If (Name <> '') AND (Command <> 0) Then Begin
     P := TMenuItem.create(nil,r);                                            { Allocate memory }
     If (P <> Nil) Then Begin                         { Check valid pointer }
       P.Next := Next;                               { Hold next item }
       P.caption := Name;                       { Hold item name }
       P.Command := Command;                         { Hold item command }
       R.Assign(1, 1, 10, 10);                        { Random assignment }
       P.KeyCode := KeyCode;                         { Hold item keycode }
       P.HelpCtx := AHelpCtx;                        { Hold help context }
       P.Param := Param;                     { Hold parameter }
     End;
     NewItem := P;                                    { Return item }
   End Else NewItem := Next;                          { Move forward }
END;

{---------------------------------------------------------------------------}
{  NewSubMenu -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 14May98 LdB        }
{---------------------------------------------------------------------------}
function NewSubMenu(Name: TMenuStr; AHelpCtx: Word; SubMenu: TMenu;
  Next: TMenuItem): TMenuItem;
VAR P: TMenuItem;
  r: TRect;
BEGIN
   If (Name <> '') AND (SubMenu <> Nil) Then Begin
     P := TMenuItem.create(nil,r);                                            { Allocate memory }
     If (P <> Nil) Then Begin                         { Check valid pointer }
       P.Next := Next;                               { Hold next item }
       P.caption := Name;                       { Hold submenu name }
       P.HelpCtx := AHelpCtx;                        { Set help context }
       P.SubMenu := SubMenu;                         { Hold next submenu }
     End;
     NewSubMenu := P;                                 { Return submenu }
   End Else NewSubMenu := Next;                       { Return next item }
END;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                          STATUS INTERFACE ROUTINES                        }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{---------------------------------------------------------------------------}
{  NewStatusDef -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 15May98 LdB      }
{---------------------------------------------------------------------------}
function NewStatusDef(AMin, AMax: Word; AItems: PStatusItem; ANext: PStatusDef
  ): PStatusDef;
VAR T: PStatusDef;
BEGIN
   New(T);                                            { Allocate memory }
   If (T <> Nil) Then Begin                           { Check valid pointer }
     T^.Next := ANext;                                { Set next item }
     T^.Min := AMin;                                  { Hold min value }
     T^.Max := AMax;                                  { Hold max value }
     T^.Items := AItems;                              { Hold item list }
   End;
   NewStatusDef := T;                                 { Return status }
END;

{---------------------------------------------------------------------------}
{  NewStatusKey -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 15May98 LdB      }
{---------------------------------------------------------------------------}
function NewStatusKey(AText: String; AKeyCode: Word; ACommand: Word;
  ANext: PStatusItem): PStatusItem;
VAR T: PStatusItem;
BEGIN
   New(T);                                            { Allocate memory }
   If (T <> Nil) Then Begin                           { Check valid pointer }
     T^.Text := AText;                        { Hold text string }
     T^.KeyCode := AKeyCode;                          { Hold keycode }
     T^.Command := ACommand;                          { Hold command }
     T^.Next := ANext;                                { Pointer to next }
   End;
   NewStatusKey := T;                                 { Return status item }
END;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                           OBJECT REGISTER ROUTINES                        }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{---------------------------------------------------------------------------}
{  RegisterMenus -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 15May98 LdB     }
{---------------------------------------------------------------------------}
procedure RegisterMenus;
BEGIN
   //RegisterType(RMenuBar);                            { Register bar menu }
   //RegisterType(RMenuBox);                            { Register menu box }
   //RegisterType(RStatusLine);                         { Register status line }
   //RegisterType(RMenuPopup);                          { Register popup menu }
END;

END.
